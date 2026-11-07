-- SPDX-License-Identifier: AGPL-3.0-or-later
-- Spelling practice visual layer. Keeps original PDF pixels untouched.
local Blitbuffer = require('ffi/blitbuffer')
local Device = require('device')
local Font = require('ui/font')
local TextWidget = require('ui/widget/textwidget')
local Screen = Device.screen

local Overlay = {}
Overlay.__index = Overlay

local BLACK, WHITE = Blitbuffer.COLOR_BLACK, Blitbuffer.COLOR_WHITE
local GRAY = Blitbuffer.COLOR_DARK_GRAY

local function rect(bb, x, y, w, h, color)
    bb:paintRect(math.floor(x), math.floor(y), math.max(1,math.floor(w)), math.max(1,math.floor(h)), color)
end

-- E-ink-friendly outline with 3px clipped corners (rounded-square appearance).
local function roundedOutline(bb, x, y, w, h, color)
    local r = math.min(4, math.floor(w / 7))
    local t = 2
    rect(bb,x+r,y,w-2*r,t,color)
    rect(bb,x+r,y+h-t,w-2*r,t,color)
    rect(bb,x,y+r,t,h-2*r,color)
    rect(bb,x+w-t,y+r,t,h-2*r,color)
    rect(bb,x+1,y+2,r,2,color)
    rect(bb,x+w-r-1,y+2,r,2,color)
    rect(bb,x+1,y+h-4,r,2,color)
    rect(bb,x+w-r-1,y+h-4,r,2,color)
end

local function text(bb, label, sz, x, y, center, color)
    local widget = TextWidget:new{
        text = tostring(label),
        face = Font:getFace('cfont', sz),
        fgcolor = color or BLACK,
        padding = 0,
    }
    local size = widget:getSize()
    widget:paintTo(bb, math.floor(center and x-size.w/2 or x), math.floor(y))
    widget:free()
end

function Overlay:new(plugin)
    return setmetatable({plugin = plugin}, Overlay)
end

function Overlay:resetLayout() end

function Overlay:paintTo(bb, x, y)
    local p = self.plugin
    if not p or not p.spelling_active or not p:isSupported() then return end
    if p:readerPage() ~= p.spelling_word * 2 then return end
    local answer = p.spelling_answer
    if not answer or #answer == 0 then return end

    local w = (self.view and self.view.dimen and self.view.dimen.w) or Screen:getWidth()
    local h = (self.view and self.view.dimen and self.view.dimen.h) or Screen:getHeight()
    local xx = function(n) return x+math.floor(w*n) end
    local yy = function(n) return y+math.floor(h*n) end

    -- Mask answer title and pronunciation ONLY in the live reader layer.
    -- Example sentence and derivation can disclose the word: hide both too.
    -- Coordinates fit WordScreen PET portrait PDFs (758x1024 native page).
    rect(bb, xx(.045), yy(.075), w*.91, h*.141, WHITE)
    rect(bb, xx(.08), yy(.523), w*.84, h*.056, WHITE)
    rect(bb, xx(.06), yy(.848), w*.88, h*.069, WHITE)

    local count = p:wordCount()
    text(bb, string.format('SPELL %d / %d', p.spelling_word, count), 19, xx(.5), yy(.080), true, BLACK)

    local letters = {}
    local normalized = answer:gsub('[^A-Za-z]', '')
    local guessed = (p.spelling_guess or ''):gsub('[^A-Za-z]',''):upper()
    local given = normalized:sub(1,1):upper()
    for i=1,#normalized do
        letters[#letters+1] = (i == 1 and given) or guessed:sub(i-1,i-1)
    end
    -- Long words wrap instead of producing impossibly narrow touch boxes.
    local n = #letters
    local cols = n > 14 and math.ceil(n/2) or n
    local cell = math.min(47, math.floor(w*.79/math.max(cols,1))-4)
    cell = math.max(20,cell)
    local gap = math.min(6,math.floor(cell*.13))
    local rows = n > 14 and 2 or 1
    local start_y = rows == 1 and yy(.121) or yy(.113)
    for row=1,rows do
        local first = (row-1)*cols+1
        local last = math.min(row*cols,n)
        local num = last-first+1
        local width = num*cell + (num-1)*gap
        local left = xx(.5) - width/2
        local top = start_y + (row-1)*(cell+3)
        for idx=first,last do
            local bx = math.floor(left+(idx-first)*(cell+gap))
            local by = math.floor(top)
            if idx == 1 then
                rect(bb, bx+2,by+2,cell-4,cell-4,Blitbuffer.COLOR_LIGHT_GRAY)
            end
            roundedOutline(bb,bx,by,cell,cell,BLACK)
            if letters[idx] and letters[idx] ~= '' then
                text(bb, letters[idx], math.min(26,cell-8), bx+cell/2, by+math.floor(cell*.13), true, BLACK)
            end
        end
    end
    local label_y = rows == 1 and .177 or .209
    if p.spelling_locked then
        text(bb, 'Swipe to continue', 15, xx(.5), yy(label_y), true,GRAY)
    end

    -- Spacious status field is BELOW the Chinese meaning, not over the image.
    local status = p.spelling_status or ''
    local ix, iy = xx(.14), yy(.635)
    local iw, ih = math.floor(w*.72), math.floor(h*.064)
    rect(bb,ix,iy,iw,ih,WHITE)
    roundedOutline(bb,ix,iy,iw,ih,BLACK)
    if status ~= '' then
        text(bb,status,15,xx(.5),yy(.651),true,BLACK)
    end
end
return Overlay