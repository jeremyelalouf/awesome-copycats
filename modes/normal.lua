local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag

local awful         = require("awful")
local beautiful     = require("beautiful")
local lain          = require("lain")

local utils = require("modes.utils")
local taghelper = utils.taghelper
local directions = utils.directions

local normal_commands = {
    -- Tag Handling
    {
        description = "focus tag by direction or globally",
        pattern = {'%d*', '[gHL]'},
        handler = function(_, count, movement)
            local nomvt = count == ''
            count = count == '' and 1 or tonumber(count)

            if movement == 'g' and not nomvt then
                local s= awful.screen.focused()
                local t= s.tags[count]
                if t then
                    t:view_only()
                end
            elseif movement == 'L' then
                awful.tag.viewidx(count)
            elseif movement == 'H' then
                awful.tag.viewidx(-count)
            end
        end
    },
    {
        description = utils.accent("T") .. "ag: " .. utils.accent("U") .. "ndo history",
        pattern = { 't', '%d*', 'u' },
        handler = function(_, _, count)
            count = count == '' and "previous" or tonumber(count)
            awful.tag.history.restore(awful.screen.focused(), count)
        end
    },
    {
        description = utils.accent("T") .. "oggle " .. utils.accent("T") ..  "ag",
        pattern = { 't', 't?', '%d*', '[ghl]' },
        handler = function(_, _, _, count, movement)
            taghelper(awful.tag.viewtoggle, count, movement)
        end
    },
    {
        description = utils.accent("T") .. "ag: " .. utils.accent("N") .. "ew",
        pattern = { 't', 'n' },
        handler = function() lain.util.add_tag() end,
    },
    {
        description = utils.accent("T") .. "ag: " .. utils.accent("R") .. "ename",
        pattern = { 't', 'r' },
        handler = function() lain.util.rename_tag() end,
    },
    {
        description = utils.accent("T") .. "ag: e" .. utils.accent("X") .. "ecute in new tag",
        pattern = { 't', 'x' },
        handler = function()
            awful.prompt.run {
                prompt       = "Run in new tag: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = function (name)
                    if not name or #name == 0 then return end
                    awful.tag.add(name, { screen = awful.screen.focused(), layout = awful.layout.suit.tile, volatile = true }):view_only()
                    awful.spawn(name)
                end,
                history_path = awful.util.get_cache_dir() .. "/history_new_tag",
                completion_callback = awful.completion.shell
            }
        end
    },
    {
        description = utils.accent("D") .. "elete " .. utils.accent("T") .. "ag",
        pattern = { 'd', 't' },
        handler = function () lain.util.delete_tag() end
    },

    -- Client handling
    {
        description = utils.accent("D") .. "elete (close) focused " .. utils.accent("C") .. "lient",
        pattern = {'d', '[dc]'},
        handler = function()
            local c = client.focus
            if c then
                c:kill()
            end
        end
    },
    {
        description = utils.accent("C") .. "lient toggle floa" .. utils.accent("T") .. "ing",
        pattern = { 'c', 't' },
        handler = function()
            local c = client.focus
            if c then
                c.floating = not c.floating
            end
        end
    },
    {
        description = utils.accent("C") .. "lient toggle " .. utils.accent("K") .. "eep on top",
        pattern = { 'c', 'k' },
        handler = function()
            local c = client.focus
            if c then
                c.ontop = not c.ontop
            end
        end
    },
    {
        description = utils.accent("C") .. "lient toggle " .. utils.accent("S") .. "ticky",
        pattern = { 'c', 's' },
        handler = function()
            local c = client.focus
            if c then
                c.sticky = not c.sticky
            end
        end
    },
    {
        description = utils.accent("C") .. "lient toggle " .. utils.accent("F") .. "ullscreen",
        pattern = { 'c', 'f' },
        handler = function()
            local c = client.focus
            if c then
                c.fullscreen = not c.fullscreen
                c:raise()
            end
        end
    },
    {
        description = utils.accent("C") .. "lient toggle " .. utils.accent("M") .. "aximize",
        pattern = { 'c', 'm' },
        handler = function()
            local c = client.focus
            if c then
                c.maximized = not c.maximized
                c:raise()
            end
        end
    },
    {
        description = utils.accent("C") .. "lient toggle " .. utils.accent("M") .. "agnify",
        pattern = { 'c', 'M' },
        handler = function()
            lain.util.magnify_client(client.focus)
        end
    },
    {
        description = utils.accent("C") .. "lient mi" .. utils.accent("N") .. "imize",
        pattern = { 'c', 'n' },
        handler = function()
            local c = client.focus
            if c then
                c.minimized = true
            end
        end
    },
    {
        description = utils.accent("C") .. "lient " .. utils.accent("R") .. "estore",
        pattern = { 'c', 'r' },
        handler = function()
            local c = awful.client.restore()
            if c then
                client.focus = c
                c:raise()
            end
        end
    },
    {
        description = utils.accent("C") .. "lient " .. utils.accent("J") .. "ump to urgent",
        pattern = { 'c', 'j' },
        handler = function(mode)
            awful.client.urgent.jumpto()
            mode.stop()
        end
    },
    {
        description = utils.accent("C") .. "lient " .. utils.accent("U") .. "ndo history",
        pattern = { 'c', '%d*' ,'u' },
        handler = function (_, _, count)
            count = count == '' and 1 or tonumber(count)

            local c = awful.client.focus.history.get(awful.screen.focused(), count)
            if c then
                client.focus = c
                c:raise()
            end
        end
    },
    {
        description = "focus client by direction",
        pattern = {'%d*', '[hjkl]'},
        handler = function(_, count, movement)
            count = count == '' and 1 or tonumber(count)

            for _ = 1, count do
                awful.client.focus.bydirection(directions[movement])
            end
        end
    },
    {
        description = utils.accent("T") .. "oggle focused " .. utils.accent("C") .. "lient on tag",
        pattern = { 't', 'c', '%d*', '[ghl]' },
        handler = function(_, _, _, count, movement)
            taghelper(function(tag)
                local c = client.focus
                if c then
                    c:toggle_tag(tag)
                end
            end, count, movement)
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
        description = utils.accent("M") .. "ove focused client to " .. utils.accent("S") .. "creen",
        pattern = {'m', 's', '%d*', '[ghjkl]'},
        handler = function(_, _, _, count, movement)
            local c = client.focus
            count = count == '' and 1 or tonumber(count)

            if c then
                if movement == g then
                    c:move_to_screen(count)
                else
                    while count ~= 0 do
                        local new_scr = c.screen:get_next_in_direction(directions[movement])
                        c:move_to_screen(new_scr)
                        count = count - 1
                    end
                end
            end
        end
    },

    -- Screen handling
    {
        description = "focus " .. utils.accent("S") .. "creen by direction or globally",
        pattern = { 's', '%d*', '[ghjkl]' },
        handler = function (_, _, count, movement)
            local nomvt = count == ''
            count = count == '' and 1 or tonumber(count)

            if movement == 'g' and not nomvt then
                awful.screen.focus(count)
            else
                while count ~= 0 do
                    awful.screen.focus_bydirection(directions[movement])
                    count = count - 1
                end
            end
        end
    },
    {
        -- https://github.com/lcpz/dots/blob/master/bin/screenshot
        description = utils.accent("Y") .. "ank a " .. utils.accent("S") .. "creen (take a screenshot)",
        pattern = { 'y', 's' },
        handler = function() os.execute("screenshot") end
    },
    -- Misc
    {
        description = utils.accent("W") .. "ibox " .. utils.accent("T") .. "oggle",
        pattern = { 'W', 't' },
        handler = function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end
    },
    {
        description = utils.accent("W") .. "idget show " .. utils.accent("C") .. "alendar",
        pattern = { 'w', 'c' },
        handler = function ()
            if beautiful.cal then beautiful.cal.show(7) end
        end
    },
    {
        description= utils.accent("W") .. "idget show " .. utils.accent("F") .. "ilesystem",
        pattern = { 'w', 's' },
        handler = function()
            if beautiful.fs then beautiful.fs.show(7) end
        end
    },
    {
        description= utils.accent("W") .. "idget show " .. utils.accent("W") .. "eather",
        pattern = { 'w', 'w' },
        handler = function()
            if beautiful.weather then beautiful.weather.show(7) end
        end
    }
}

return normal_commands
