local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag

local awful = require("awful")
local lain = require("lain")

local utils = require("modes.utils")
local taghelper = utils.taghelper

local tag_commands = {
    {
        description = "focus tag by direction",
        pattern = {'%d*', '[ghl]'},
        handler = function(_, count, movement)
            count = count == '' and 1 or tonumber(count)

            if movement == 'g' then
                local screen = awful.screen.focused()
                local tag = screen.tags[count]
                if tag then
                    tag:view_only()
                end
            elseif movement == 'l' then
                awful.tag.viewidx(count)
            elseif movement == 'h' then
                awful.tag.viewidx(-count)
            end
        end
    },
    {
        description = "focus active tag by direction",
        pattern = {'%d*', '[.,]'},
        handler = function(_, count, movement)
            count = count == '' and 1 or tonumber(count)

            if movement == '.' then
                lain.util.tag_view_nonempty(count)
            elseif movement == ',' then
                lain.util.tag_view_nonempty(-count)
            end
        end
    },
    {
        description = "move tag in a given direction",
        pattern = { '%d*', '[HL]' },
        handler = function(_, count, movement)
            count = count == '' and 1 or tonumber(count)
            local s = awful.screen.focused()
            local t = s.selected_tag
            local dir = movement == 'H' and -1 or 1

            if t then
                local nxt = (t.index + dir * count) % 5
                nxt = nxt == 0 and 5 or nxt

                t.index = nxt
            end
        end
    },
    {
        description = utils.accent("T") .. "oggle Tag",
        pattern = { 't', '%d*', '[ghl]' },
        handler = function(_, _, count, movement)
            taghelper(awful.tag.viewtoggle, count, movement)
        end
    },
    {
        description = utils.accent("M") .. "ove focused client to tag",
        pattern = {'m', '%d*', '[ghl]'},
        handler = function(_, _, count, movement)
            taghelper(function(tag)
                local c = client.focus
                if c then
                    c:move_to_tag(tag)
                end
            end, count, movement)
        end
    },
    {
        description = "toggle focused " .. utils.accent("C") .. "lient on tag",
        pattern = { 'c', '%d*', '[ghl]' },
        handler = function(_, _, count, movement)
            taghelper(function(tag)
                local c = client.focus
                if c then
                    c:toggle_tag(tag)
                end
            end, count, movement)
        end
    },
    {
        description = utils.accent("M") .. "ove to " .. utils.accent("M") .. "aster",
        pattern = {'m', 'm'},
        handler = function()
            local c, m = client.focus, awful.client.getmaster()
            if c and m then
                c:swap(m)
            end
        end
    }
}

return tag_commands
