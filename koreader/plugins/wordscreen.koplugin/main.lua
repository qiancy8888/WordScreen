-- SPDX-License-Identifier: AGPL-3.0-or-later
-- Copyright (C) 2026 qiancy8888
-- WordScreen for KOReader v0.4.3 (player + manual spelling mode)
-- PDF format: odd page A/question, even page B/answer.
-- Designed for a PDF opened directly by KOReader (e.g. KPVBooklet home-library entry).
-- Does not modify system launchers or require launching KUAL.
local Event = require("ui/event")
local DataStorage = require("datastorage")
local InfoMessage = require("ui/widget/infomessage")
local LuaSettings = require("luasettings")
local UIManager = require("ui/uimanager")
local HeartOverlay = require("heartoverlay")
local Spelling = require("spelling")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")

local WordScreen = WidgetContainer:extend{
    name = "wordscreen",
    is_doc_only = true,
    playing = false,
    mode = nil,
    current_word = 1,
    face = "A",
    delay_a = 4,
    delay_b = 4,
    task = nil,
    start_task = nil,
    current_file = nil,
    favorites_list = nil,
    resume_after_suspend = false,
    suspend_resume_mode = nil,
    suspend_resume_page = nil,
    touch_registered = false,
    heart_overlay_registered = false,
    auto_start_scheduled = false,
    spelling_active = false,
    spelling_overlay_registered = false,
}

local function wordForPage(page)
    return math.floor((page + 1) / 2)
end

local function pageForWord(word, face)
    return word * 2 - (face == "A" and 1 or 0)
end

function WordScreen:notice(msg)
    UIManager:show(InfoMessage:new{ text = msg, timeout = 3 })
end

function WordScreen:pageCount()
    return self.ui.document and self.ui.document.info
        and self.ui.document.info.number_of_pages or 0
end

function WordScreen:isSupported()
    local file = self.ui.document and self.ui.document.file
    local count = self:pageCount()
    return type(file) == "string" and file:lower():match("%.pdf$") ~= nil
        and count >= 2 and count % 2 == 0
end

function WordScreen:wordCount()
    return math.floor(self:pageCount() / 2)
end

function WordScreen:readerPage()
    local page = (self.ui.paging and self.ui.paging:getTopPage()) or 1
    page = tonumber(page) or 1
    return math.max(1, math.min(self:pageCount(), math.floor(page)))
end

function WordScreen:currentWordFromReader()
    return math.max(1, math.min(self:wordCount(), wordForPage(self:readerPage())))
end

function WordScreen:getDisplayedWord()
    if self.playing then return self.current_word end
    return self:currentWordFromReader()
end

function WordScreen:bookFavorites()
    local all = self.settings:readSetting("favorites", {}) or {}
    return all[self.current_file or ""] or {}
end

function WordScreen:isFavorite(word)
    return word and self:bookFavorites()[tostring(word)] == true
end

function WordScreen:getFavoriteList()
    local result, favs = {}, self:bookFavorites()
    for i = 1, self:wordCount() do
        if favs[tostring(i)] then result[#result + 1] = i end
    end
    return result
end

function WordScreen:refreshHeart()
    if self.ui then
        UIManager:setDirty(self.ui, "ui")
    end
end

function WordScreen:registerHeartOverlay()
    if self.heart_overlay_registered or not self.ui or not self.ui.view then return end
    self.heart_overlay = HeartOverlay:new(self)
    self.ui.view:registerViewModule("wordscreen_heart", self.heart_overlay)
    self.heart_overlay_registered = true
    self:refreshHeart()
end

-- Persist no more often than each 10 words during playback, plus on stop/close.
-- Do NOT write to flash on every 4-second page transition.
function WordScreen:saveProgress()
    if not self:isSupported() then return end
    local page = self.playing and pageForWord(self.current_word, self.face) or self:readerPage()
    self.settings:saveSetting("resume_file", self.current_file)
    self.settings:saveSetting("resume_page", page)
    if self.mode then self.settings:saveSetting("resume_mode", self.mode) end
    self.settings:flush()
end

function WordScreen:configureQuickResume(enabled)
    if not self:isSupported() then
        return self:notice("Open a two-page PDF first.")
    end
    self.settings:saveSetting("quick_pdf", self.current_file)
    self.settings:saveSetting("quick_resume_enabled", enabled)
    self:saveProgress()
    self:notice(enabled and "Quick resume ENABLED for this PDF." or "Quick resume DISABLED.")
end

-- Notify KOReader's activity hooks when a timed page transition occurs.
-- This refreshes AutoSuspend.last_action_time, allowing Kindle's T1 timer
-- to keep resetting normally without disabling AutoSuspend or powerd.
function WordScreen:markActivity()
    local hook = UIManager.event_hook
    if hook and hook.execute then
        hook:execute("InputEvent")
    end
end

function WordScreen:arm(seconds)
    UIManager:unschedule(self.task)
    if self.playing then UIManager:scheduleIn(seconds, self.task) end
end

function WordScreen:gotoPage(page)
    if page < 1 or page > self:pageCount() then return false end
    self.ui:handleEvent(Event:new("GotoPage", page))
    return true
end

function WordScreen:drawCurrent()
    self:gotoPage(pageForWord(self.current_word, self.face))
    self:refreshHeart()
end

function WordScreen:turnWord(step)
    if not self:isSupported() then return end
    local count = self:wordCount()
    local current = self.playing and self.current_word or self:currentWordFromReader()
    if self.mode == "favorites" and self.favorites_list and #self.favorites_list > 0 then
        local where = 1
        for index, word in ipairs(self.favorites_list) do
            if word == current then where = index break end
        end
        self.current_word = self.favorites_list[(where - 1 + step) % #self.favorites_list + 1]
    else
        self.current_word = (current - 1 + step) % count + 1
    end
    self.face = "A"
    self:drawCurrent()
    if self.playing then
        self:arm(self.delay_a)
        if self.current_word % 10 == 0 then self:saveProgress() end
    end
end

function WordScreen:tick()
    if not self.playing then return end
    local top = UIManager:getTopmostVisibleWidget()
    if not top or top.name ~= "ReaderUI" then
        self:arm(1)
        return
    end
    -- A timed page flip is ongoing activity even though it is not a touch event.
    -- Keep KOReader's normal AutoSuspend/T1 bookkeeping in sync with playback.
    self:markActivity()
    if self.face == "A" then
        self.face = "B"
        self:drawCurrent()
        self:arm(self.delay_b)
    else
        self:turnWord(1)
    end
end

function WordScreen:stop(silent, preserve_suspend_resume)
    if self.task then UIManager:unschedule(self.task) end
    if self.start_task then UIManager:unschedule(self.start_task) end
    local was_playing = self.playing
    self.playing = false
    self.mode = nil
    self.favorites_list = nil
    if not preserve_suspend_resume then
        self.resume_after_suspend = false
        self.suspend_resume_mode = nil
        self.suspend_resume_page = nil
    end
    if was_playing and not silent then
        self:notice("WordScreen paused. Your position was saved.")
    end
end

function WordScreen:stopFromMenu()
    if self.playing then self:saveProgress() end
    self:stop(false)
end

-- Optional resume_page preserves A/B face exactly (e.g. page 326 = word 163 B).
function WordScreen:start(mode, resume_page)
    if self.spelling_active then Spelling.endSession(self) end
    if not self:isSupported() then
        self:notice("Requires an even-page PDF: two pages per word.")
        return
    end
    if self.ui.autoturn and self.ui.autoturn.enabled then
        self:notice("Disable built-in KOReader AutoTurn first.")
        return
    end
    self:stop(true)
    local page = tonumber(resume_page)
    page = page and math.max(1, math.min(self:pageCount(), math.floor(page))) or 1
    local word = wordForPage(page)

    if mode == "favorites" then
        self.favorites_list = self:getFavoriteList()
        if #self.favorites_list == 0 then
            self:notice("No favorites in this PDF yet.")
            return
        end
        local matched = false
        for _, favorite in ipairs(self.favorites_list) do
            if favorite == word then matched = true break end
        end
        if not matched then
            word = self.favorites_list[1]
            page = pageForWord(word, "A")
        end
    else
        mode = "all"
    end

    self.mode = mode
    self.current_word = word
    self.face = (page % 2 == 0) and "B" or "A"
    self.playing = true

    -- Do not pause AutoSuspend or disable Kindle's screensaver.
    -- markActivity() refreshes the normal activity/T1 timers during playback.

    -- The first explicit playback selects this as the one-tap WordScreen PDF.
    self.settings:saveSetting("quick_pdf", self.current_file)
    self.settings:saveSetting("quick_resume_enabled", true)
    self:saveProgress()
    -- Wait for KOReader document transition/menus to finish before drawing.
    UIManager:scheduleIn(1, self.start_task)
end

function WordScreen:resumeFromSavedPosition()
    if not self:isSupported() then return end
    local saved_file = self.settings:readSetting("resume_file")
    local saved_page
    if saved_file == self.current_file then
        saved_page = self.settings:readSetting("resume_page")
    end
    -- KOReader's saved last-page location remains the fallback.
    local page = tonumber(saved_page) or self:readerPage()
    local mode = self.settings:readSetting("resume_mode", "all")
    self:start(mode, page)
end

function WordScreen:toggleFavorite()
    if not self:isSupported() then return self:notice("Open a two-page PDF first.") end
    local word = self:getDisplayedWord()
    local all = self.settings:readSetting("favorites", {}) or {}
    local key = self.current_file or ""
    local favs = all[key] or {}
    local id = tostring(word)
    if favs[id] then
        favs[id] = nil
        self:notice("Word " .. word .. " removed from favorites")
    else
        favs[id] = true
        self:notice("Word " .. word .. " added to favorites")
    end
    all[key] = favs
    self.settings:saveSetting("favorites", all)
    self.settings:flush()
    if self.mode == "favorites" then
        self.favorites_list = self:getFavoriteList()
        if #self.favorites_list == 0 then
            self:stopFromMenu()
        else
            local exists = false
            for _, fav in ipairs(self.favorites_list) do
                if fav == self.current_word then exists = true break end
            end
            if not exists then
                self.current_word = self.favorites_list[1]
                self.face = "A"
                self:drawCurrent()
                if self.playing then self:arm(self.delay_a) end
            end
        end
    end
    self:refreshHeart()
end

function WordScreen:init()
    self.settings = LuaSettings:open(DataStorage:getSettingsDir() .. "/wordscreen_koreader.lua")
    self.delay_a = self.settings:readSetting("delay_a", 4)
    self.delay_b = self.settings:readSetting("delay_b", 4)
    self.current_file = self.ui.document and self.ui.document.file or nil
    self.task = function() self:tick() end
    self.start_task = function()
        if self.playing then
            self:drawCurrent()
            self:arm(self.face == "B" and self.delay_b or self.delay_a)
        end
    end
    self.ui.menu:registerToMainMenu(self)
end

function WordScreen:onReaderReady()
    if not self:isSupported() then return end
    self:registerHeartOverlay()
    Spelling.init(self)

    if not self.touch_registered and self.ui.registerTouchZones then
        self.touch_registered = true
        self.ui:registerTouchZones({
            {
                id = "wordscreen_favorite_tap",
                ges = "tap",
                screen_zone = HeartOverlay.HIT_ZONE,
                overrides = {
                    "tap_link", "readerhighlight_tap", "readerfooter_tap",
                    "readermenu_tap", "readermenu_ext_tap",
                    "tap_forward", "tap_backward", "tap_top_left_corner",
                    "tap_top_right_corner", "tap_left_bottom_corner", "tap_right_bottom_corner",
                },
                handler = function()
                    if self.spelling_active then
                        Spelling.showKeyboard(self)
                    else
                        self:toggleFavorite()
                    end
                    return true
                end,
            },
            {
                id = "wordscreen_spelling_tap",
                ges = "tap",
                screen_zone = {ratio_x=.08,ratio_y=.075,ratio_w=.76,ratio_h=.15},
                overrides = {"tap_link","readerhighlight_tap","readermenu_tap","tap_forward","tap_backward"},
                handler = function()
                    if not self.spelling_active then return false end
                    Spelling.showKeyboard(self)
                    return true
                end,
            },
            {
                id = "wordscreen_spelling_input_tap",
                ges = "tap",
                screen_zone = {ratio_x=.14,ratio_y=.63,ratio_w=.72,ratio_h=.075},
                overrides = {"tap_forward","tap_backward","readermenu_tap","readerhighlight_tap"},
                handler = function()
                    if not self.spelling_active then return false end
                    Spelling.showKeyboard(self)
                    return true
                end,
            },
            {
                id = "wordscreen_spelling_prevent_paging",
                ges = "tap",
                screen_zone = {ratio_x=0,ratio_y=.22,ratio_w=1,ratio_h=.78},
                overrides = {"tap_forward","tap_backward"},
                handler = function()
                    return self.spelling_active == true
                end,
            },
            {
                id = "wordscreen_swipe",
                ges = "swipe",
                screen_zone = { ratio_x = 0.02, ratio_y = 0.15, ratio_w = 0.96, ratio_h = 0.70 },
                overrides = { "paging_swipe", "rolling_swipe", "swipe_link" },
                handler = function(ges)
                    if self.spelling_active then
                        if ges.direction == "west" then Spelling.step(self,1); return true end
                        if ges.direction == "east" then Spelling.step(self,-1); return true end
                        return false
                    end
                    if not self.playing then return false end
                    if ges.direction == "west" then
                        self:turnWord(1)
                        return true
                    elseif ges.direction == "east" then
                        self:turnWord(-1)
                        return true
                    end
                    return false
                end,
            },
        })
    end

    -- One-tap native-home shortcut: KPVBooklet opens the PDF directly in KOReader.
    -- Only the explicitly chosen PDF autoplays. Other PDFs remain normal reading.
    local allowed = self.settings:readSetting("quick_resume_enabled", false)
    local selected = self.settings:readSetting("quick_pdf")
    if allowed and selected == self.current_file and not self.auto_start_scheduled then
        self.auto_start_scheduled = true
        UIManager:scheduleIn(0.5, function()
            if self.ui and self.ui.document and not self.playing and not self.spelling_active then
                self:resumeFromSavedPosition()
            end
        end)
    end
end

-- Normal exit stores the exact currently displayed PDF page once, not each turn.
function WordScreen:onCloseDocument()
    self.resume_after_suspend = false
    self.suspend_resume_mode = nil
    self.suspend_resume_page = nil
    self:saveProgress()
    if self.spelling_active then Spelling.endSession(self) end
    self:stop(true)
end

function WordScreen:onCloseWidget()
    self.resume_after_suspend = false
    self.suspend_resume_mode = nil
    self.suspend_resume_page = nil
    if self.playing then self:saveProgress() end
    if self.spelling_active then Spelling.endSession(self) end
    self:stop(true)
end

function WordScreen:onSuspend()
    if self.spelling_input then
        UIManager:close(self.spelling_input)
        self.spelling_input = nil
    end
    if self.playing then
        self.suspend_resume_mode = self.mode or "all"
        self.suspend_resume_page = pageForWord(self.current_word, self.face)
        self:saveProgress()
        self.resume_after_suspend = true
        -- Stop the playback timer while suspended, but retain a one-shot resume request.
        self:stop(true, true)
    end
end

function WordScreen:onResume()
    if not self.resume_after_suspend then return end

    local mode = self.suspend_resume_mode or "all"
    local page = self.suspend_resume_page or self.settings:readSetting("resume_page", 1)
    self.resume_after_suspend = false
    self.suspend_resume_mode = nil
    self.suspend_resume_page = nil

    -- Let KOReader finish restoring the reader view before restarting playback.
    UIManager:scheduleIn(1, function()
        if self.ui and self.ui.document and self:isSupported() then
            self:start(mode, page)
        end
    end)
end

function WordScreen:addToMainMenu(menu_items)
    menu_items.wordscreen_pdf = {
        text = "WordScreen - Play / Spelling",
        sorting_hint = "more_tools",
        sub_item_table = {
            { text = "SPELLING: practice current word (B page only)", callback = function()
                Spelling.start(self,self:currentWordFromReader(),false)
            end },
            { text = "SPELLING: start from first word", callback = function()
                Spelling.start(self,1,false)
            end },
            { text_func = function() return "SPELLING: review mistakes ("..Spelling.pendingCount(self)..")" end,
              callback = function() Spelling.start(self,1,true) end },
            { text = "SPELLING: type remaining letters", callback = function() Spelling.showKeyboard(self) end },
            { text = "SPELLING: show correct answer", callback = function() Spelling.showAnswer(self) end },
            { text = "SPELLING: next word (manual)", callback = function() Spelling.step(self,1) end },
            { text = "SPELLING: previous word (manual)", callback = function() Spelling.step(self,-1) end },
            { text = "SPELLING: exit practice", callback = function() Spelling.endSession(self) end, separator = true },
            { text = "Resume HERE + enable home shortcut", callback = function()
                self:start("all", self:readerPage())
            end },
            { text = "Start ALL from FIRST word", callback = function() self:start("all", 1) end },
            { text = "Start FAVORITES - endless loop", callback = function()
                self:start("favorites", self:readerPage())
            end },
            { text = "STOP WordScreen (save position)", callback = function() self:stopFromMenu() end,
              separator = true },
            { text = "Next word (jump to A page)", callback = function() self:turnWord(1) end },
            { text = "Previous word (jump to A page)", callback = function() self:turnWord(-1) end },
            { text_func = function()
                  if not self:isSupported() then return "Favorite word [PDF only]" end
                  local word = self:getDisplayedWord()
                  return (self:isFavorite(word) and "Unfavorite word " or "Favorite word ") .. word
              end,
              callback = function() self:toggleFavorite() end,
              separator = true },
            { text_func = function()
                  return "Favorites in this PDF: " .. #self:getFavoriteList()
              end,
              callback = function() self:notice("Favorites: " .. #self:getFavoriteList()) end },
            { text_func = function()
                  local enabled = self.settings:readSetting("quick_resume_enabled", false)
                  local selected = self.settings:readSetting("quick_pdf")
                  return (enabled and selected == self.current_file)
                         and "Disable quick auto-resume" or "Enable auto-resume for THIS PDF"
              end,
              callback = function()
                  local enabled = self.settings:readSetting("quick_resume_enabled", false)
                  local selected = self.settings:readSetting("quick_pdf")
                  self:configureQuickResume(not (enabled and selected == self.current_file))
              end,
              separator = true },
            { text = "Help: quick shortcut and resume",
              callback = function()
                  self:notice("Tap this PDF in Kindle home (KPVBooklet). Playback resumes at last saved A/B page.")
              end },
        },
    }
end

return WordScreen