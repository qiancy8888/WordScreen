-- SPDX-License-Identifier: AGPL-3.0-or-later
-- Copyright (C) 2026 qiancy8888
-- WordScreen heart overlay for KOReader ReaderView.
-- Draws a tiny pixel heart next to the PDF word title (no font dependency).
local Blitbuffer = require("ffi/blitbuffer")
local Device = require("device")

local Screen = Device.screen

local HeartOverlay = {}
HeartOverlay.__index = HeartOverlay

-- Screen-relative title-row anchor; does not depend on PDF text extraction.
HeartOverlay.HEART_CENTER_X = 0.91
HeartOverlay.HEART_CENTER_Y = 0.125
-- Enlarged hit target around the small visual heart. Keep it below the header.
HeartOverlay.HIT_ZONE = { ratio_x = 0.845, ratio_y = 0.085, ratio_w = 0.145, ratio_h = 0.09 }

local OUTLINE = {
    "01100110",
    "10011001",
    "10000001",
    "01000010",
    "00100100",
    "00011000",
}

local FILLED = {
    "01100110",
    "11111111",
    "11111111",
    "01111110",
    "00111100",
    "00011000",
}

function HeartOverlay:new(plugin)
    return setmetatable({ plugin = plugin }, self)
end

function HeartOverlay:paintTo(bb, x, y)
    local plugin = self.plugin
    if not plugin or not plugin:isSupported() or plugin.spelling_active then return end

    local word = plugin:getDisplayedWord()
    if not word then return end

    local pattern = plugin:isFavorite(word) and FILLED or OUTLINE
    local cell = math.max(2, Screen:scaleBySize(4))
    local heart_w = 8 * cell
    local heart_h = #pattern * cell

    local view_width = (self.view and self.view.dimen and self.view.dimen.w) or Screen:getWidth()
    local view_height = (self.view and self.view.dimen and self.view.dimen.h) or Screen:getHeight()

    -- Keep the heart beside the large word title in the upper right.
    -- Fixed screen-relative positioning is stable across words of different lengths.
    -- In the standard 758x1024 PET PDFs this is approximately (690, 128).
    local center_x = HeartOverlay.HEART_CENTER_X
    local center_y = HeartOverlay.HEART_CENTER_Y
    local left = x + math.floor(view_width * center_x - heart_w / 2)
    local top = y + math.floor(view_height * center_y - heart_h / 2)

    for row = 1, #pattern do
        local line = pattern[row]
        for col = 1, #line do
            if line:sub(col, col) == "1" then
                bb:paintRect(
                    left + (col - 1) * cell,
                    top + (row - 1) * cell,
                    cell,
                    cell,
                    Blitbuffer.COLOR_BLACK
                )
            end
        end
    end
end

function HeartOverlay:resetLayout()
    -- Coordinates are computed from the current ReaderView dimensions on each paint.
end

return HeartOverlay