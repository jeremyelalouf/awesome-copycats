local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local awful         = require("awful")
local beautiful     = require("beautiful")

local directions = {h = 'left', j = 'down', k = 'up', l = 'right'}

local function taghelper(func, count, movement)
    local s, index = awful.screen.focused()
    count = count == '' and 1 or tonumber(count)
    movement = string.lower(movement)

    if movement == 'g' then
      index = count
    elseif movement == 'l' then
      index = ((s.selected_tag.index - 1 + count) % #s.tags) + 1
    elseif movement == 'h' then
      index = ((s.selected_tag.index - 1 - count) % #s.tags) + 1
    end

    if s.tags[index] then
      func(s.tags[index])
    end
end

local function accent_str(str, color)
    color = color or beautiful.get().fg_focus
    return string.format("<span foreground=\"%s\"><b>%s</b></span>", color, str)
end

local module = {
    taghelper = taghelper,
    directions = directions,
    accent = accent_str
}

return module
