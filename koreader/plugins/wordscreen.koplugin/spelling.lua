-- SPDX-License-Identifier: AGPL-3.0-or-later
-- Offline KOReader PDF B-page spelling mode, sharing WordScreen's open PDF.
local InputDialog = require('ui/widget/inputdialog')
local UIManager = require('ui/uimanager')
local Overlay = require('spellingoverlay')

local S = {}

local function normalize(s)
    return tostring(s or ''):lower():gsub('[^a-z]', '')
end

local function bookErrors(p)
    local all = p.settings:readSetting('spelling_mistakes',{}) or {}
    return all, all[p.current_file or ''] or {}
end

local function saveErrors(p, all, book)
    all[p.current_file or ''] = book
    p.settings:saveSetting('spelling_mistakes',all)
    p.settings:flush()  -- wrong answers must persist, even after a forced restart
end

function S.init(p)
    if p.spelling_overlay_registered or not p.ui or not p.ui.view then return end
    p.spelling_overlay = Overlay:new(p)
    p.ui.view:registerViewModule('wordscreen_spelling',p.spelling_overlay)
    p.spelling_overlay_registered = true
end

-- KOReader/MuPDF extracts the B-page answer directly from PDF text.
-- The WordScreen PET PDF puts its large title at ~9-15% of page height.
-- Nothing is read from image OCR; fail closed if the title can't be verified.
function S.readAnswer(p, word)
    p.spelling_cache = p.spelling_cache or {}
    if p.spelling_cache[word] then return p.spelling_cache[word] end
    local doc = p.ui and p.ui.document
    if not doc or not doc.getPageText then return nil end
    local pageno = word * 2
    local ok, lines = pcall(function() return doc:getPageText(pageno) end)
    if not ok or type(lines) ~= 'table' then return nil end
    local page_height = 1024
    if doc.getPageDimensions then
        local okdim, dim = pcall(function() return doc:getPageDimensions(pageno,1,0) end)
        if okdim and dim and tonumber(dim.h) then page_height = tonumber(dim.h) end
    end
    local best, bestScore
    for _, line in ipairs(lines) do
        if line.y0 and line.y0 > page_height*.077 and line.y0 < page_height*.165 then
            local words = {}
            for _, item in ipairs(line) do
                if type(item.word) == 'string' then words[#words+1] = item.word end
            end
            local phrase = table.concat(words,' '):gsub('^%s+',''):gsub('%s+$','')
            if phrase:match('^[A-Za-z][A-Za-z%s%-']*$') and #normalize(phrase) >= 2 and #normalize(phrase) <= 35 then
                local score = math.abs(line.y0 / page_height - .11)
                if not best or score < bestScore then
                    best,bestScore = phrase,score
                end
            end
        end
    end
    if best then p.spelling_cache[word] = best end
    return best
end

-- Close the modal keyboard host so ReaderUI can receive swipe gestures.
-- KOReader's InputDialog is modal even when its own paintTo() is suppressed;
-- leaving it open after a wrong answer prevents the reader touch zones from
-- seeing the user's left/right swipe.
function S.closeKeyboard(p)
    local dialog = p.spelling_input
    if dialog then
        p.spelling_input = nil
        UIManager:close(dialog)
    end
end

function S.endSession(p)
    p.spelling_active = false
    p.spelling_transitioning = false
    p.spelling_advance_token = (p.spelling_advance_token or 0) + 1
    p.spelling_status = ''
    p.spelling_guess = ''
    S.closeKeyboard(p)
    p:refreshHeart()
end

local function loadWord(p, word)
    local answer = S.readAnswer(p, word)
    if not answer then
        p:notice('Cannot extract the title from PDF page '..(word*2)..'. Use original PET PDF, full-page mode.')
        return false
    end
    p.spelling_word = word
    p.spelling_answer = answer
    p.spelling_guess = ''
    p.spelling_status = ''
    p.spelling_locked = false
    if p.spelling_input and p.spelling_input.setInputText then
        p.spelling_input:setInputText('')
    end
    p.current_word = word
    p:gotoPage(word*2)
    p:refreshHeart()
    return true
end

function S.start(p, word, review)
    if not p:isSupported() then return p:notice('Open a WordScreen two-page PET PDF first.') end
    -- No autoplay task is allowed in this mode.
    p:stop(true)
    S.endSession(p)
    p.spelling_cache = p.spelling_cache or {}
    local review_list
    if review then
        local _,errors = bookErrors(p)
        review_list = {}
        for i=1,p:wordCount() do
            local item = errors[tostring(i)]
            if item and item.active then review_list[#review_list+1]=i end
        end
        if #review_list==0 then return p:notice('No pending spelling mistakes.') end
        word = review_list[1]
    end
    p.spelling_active = true
    p.spelling_transitioning = false
    p.spelling_advance_token = (p.spelling_advance_token or 0) + 1
    -- Stop any player timer again after spelling takes ownership. WordScreen
    -- also guards tick()/turnWord(), covering callbacks already in the queue.
    if p.task then UIManager:unschedule(p.task) end
    if p.start_task then UIManager:unschedule(p.start_task) end
    p.playing = false
    p.mode = nil
    p.spelling_review = review or false
    p.spelling_review_list = review_list
    local starting = tonumber(word) or p:currentWordFromReader()
    if not loadWord(p,math.max(1,math.min(p:wordCount(),math.floor(starting)))) then
        S.endSession(p)
        return
    end
    -- Bring up the KOReader keyboard immediately; the tiny input host is visually hidden.
    S.showKeyboard(p)
end

function S.step(p, direction)
    if not p.spelling_active then return end
    -- A swipe can be reported by more than one overlapping KOReader zone.
    -- Lock navigation until the target page has settled and the keyboard opens.
    if p.spelling_transitioning then return end
    p.spelling_transitioning = true
    p.spelling_advance_token = (p.spelling_advance_token or 0) + 1

    local current = p.spelling_word
    local new
    if p.spelling_review then
        local _,errors = bookErrors(p)
        local list = {}
        for i=1,p:wordCount() do
            if errors[tostring(i)] and errors[tostring(i)].active then list[#list+1]=i end
        end
        if #list == 0 then
            p.spelling_transitioning = false
            p.spelling_status = 'Mistakes cleared!'
            p:refreshHeart()
            p:notice('All pending mistakes cleared. Great work!')
            return
        end
        local pos
        for i,v in ipairs(list) do if v==current then pos=i break end end
        if not pos then
            for i,v in ipairs(list) do if v > current then pos = i-1 break end end
            pos = pos or #list
        end
        new = list[(pos-1+direction)%#list+1]
    else
        new = (current-1+direction)%p:wordCount()+1
    end

    if not loadWord(p,new) then
        p.spelling_transitioning = false
        return
    end

    if not p.spelling_input then
        -- Let ReaderUI finish the current swipe/GotoPage event before opening
        -- the keyboard. Re-check the target so an obsolete callback cannot
        -- reopen the keyboard for a stale word.
        UIManager:scheduleIn(0.20,function()
            if p.spelling_active and p.spelling_word == new and not p.spelling_input then
                p.spelling_transitioning = false
                S.showKeyboard(p)
            else
                p.spelling_transitioning = false
            end
        end)
    else
        p.spelling_transitioning = false
    end
end

local function updateMistakeStreak(p, key, correct)
    local all,errors = bookErrors(p)
    local item = errors[key]
    if correct then
        if item and item.active then
            item.streak = (item.streak or 0)+1
            if item.streak >= 3 then item.active = false end
            item.last_correct = os.time()
            errors[key] = item
            saveErrors(p,all,errors)
        end
    else
        item = item or {count=0,streak=0,active=true}
        item.count = (item.count or 0)+1
        item.streak = 0
        item.active = true
        item.last_wrong = os.time()
        errors[key] = item
        saveErrors(p,all,errors)
    end
end

function S.submit(p, typed)
    if not p.spelling_active or p.spelling_locked then return end
    local actual = normalize(typed)
    local answer = normalize(p.spelling_answer)
    local expected = answer:sub(2)
    -- Allow the learner to type the whole word too.
    if actual == answer then actual = expected end
    if actual == '' then return end
    p.spelling_guess = actual
    local key = tostring(p.spelling_word)
    if actual == expected then
        p.spelling_locked = true
        p.spelling_status = 'Correct!'
        updateMistakeStreak(p,key,true)
        p:refreshHeart()
        -- Advance automatically after a short visual confirmation.
        p.spelling_advance_token = (p.spelling_advance_token or 0) + 1
        local token = p.spelling_advance_token
        UIManager:scheduleIn(0.45,function()
            if p.spelling_active and p.spelling_word == tonumber(key)
                and p.spelling_advance_token == token then
                S.step(p,1)
            end
        end)
    else
        p.spelling_locked = true
        -- Reveal every missing letter in the boxes and persist the mistake.
        p.spelling_guess = expected
        p.spelling_status = 'Wrong - saved to mistakes. Swipe next.'
        updateMistakeStreak(p,key,false)
        -- The answer is now revealed on the page. Dismiss the modal input host
        -- so the next left/right swipe reaches WordScreen's reader touch zone.
        S.closeKeyboard(p)
        p:refreshHeart()
    end
end

function S.showKeyboard(p)
    if not p.spelling_active or p.spelling_input then return end
    local dialog
    dialog = InputDialog:new{
        -- InputDialog is retained only as KOReader's native keyboard input host.
        -- Its own panel is not painted; only the separate virtual keyboard is visible.
        title = '',
        input = '',
        input_hint = '',
        input_face = require('ui/font'):getFace('cfont', 1),
        text_height = 1,
        border_size = 0,
        input_padding = 0,
        input_margin = 0,
        button_padding = 0,
        bottom_v_padding = 0,
        condensed = true,
        is_movable = false,
        deny_keyboard_hiding = true,
        allow_newline = false,
        buttons = {},
        edited_callback = function()
            -- KOReader's InputText:initTextBox() invokes edit_callback once
            -- during InputDialog:new(), before the assignment to `dialog`
            -- has completed.  Ignore that constructor-time notification.
            if not dialog then return end
            if not p.spelling_active or p.spelling_locked or p.spelling_input ~= dialog then return end
            local given = normalize(dialog:getInputText())
            p.spelling_guess = given
            p.spelling_status = ''
            p:refreshHeart()
            local expected = normalize(p.spelling_answer):sub(2)
            if #given >= #expected then
                S.submit(p,given)
            end
        end,
        enter_callback = function()
            if dialog and p.spelling_active and not p.spelling_locked then
                S.submit(p,dialog:getInputText())
            end
        end,
    }
    -- Suppress the modal dialog surface completely: typed text is rendered by
    -- WordScreen's letter-box overlay, while KOReader paints its native keyboard.
    dialog.paintTo = function() end
    p.spelling_input = dialog
    UIManager:show(dialog)
    dialog:onShowKeyboard()
end

function S.showAnswer(p)
    if not p.spelling_active then return end
    p.spelling_guess=normalize(p.spelling_answer):sub(2)
    p.spelling_locked = true
    p.spelling_status = 'Answer shown. Swipe to continue.'
    S.closeKeyboard(p)
    p:refreshHeart()
end

function S.pendingCount(p)
    if not p:isSupported() then return 0 end
    local _,errors = bookErrors(p)
    local count=0
    for i=1,p:wordCount() do
        if errors[tostring(i)] and errors[tostring(i)].active then count=count+1 end
    end
    return count
end

return S