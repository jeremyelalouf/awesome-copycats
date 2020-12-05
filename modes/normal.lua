local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag

local awful         = require("awful")
local beautiful     = require("beautiful")
local lain          = require("lain")
local wibox         = require("wibox")
local hotkeys_popup = require("awful.hotkeys_popup")

local utils = require("modes.utils")
local taghelper = utils.taghelper
local directions = utils.directions

local normal_commands = {
    -- Tag Handling
    {
        description = "focus tag by direction or globally",
        pattern = {'%d*', '[gHL]'},
        handler = function(_, count, movement)
            count = count == '' and 1 or tonumber(count)

            if movement == 'g' then
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
        description = "Tag: Undo history",
        pattern = { 't', '%d*', 'u' },
        handler = function(_, _, count)
            count = count == '' and "previous" or tonumber(count)
            awful.tag.history.restore(awful.screen.focused(), count)
        end
    },
    {
        description = "Toggle Tag",
        pattern = { 't', 't?', '%d*', '[ghl]' },
        handler = function(_, _, _, count, movement)
            taghelper(awful.tag.viewtoggle, count, movement)
        end
    },
    {
        description = "Tag: New",
        pattern = { 't', 'n' },
        handler = function() lain.util.add_tag() end,
    },
    {
        description = "Tag: Rename",
        pattern = { 't', 'r' },
        handler = function() lain.util.rename_tag() end,
    },
    {
        description = "Tag: eXecute in new tag",
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
        description = "Delete tag",
        pattern = { 'd', 't' },
        handler = function () lain.util.delete_tag() end
    },

    -- Client handling
    {
        description = "close focused client",
        pattern = {'d', '[dc]'},
        handler = function()
            local c = client.focus
            if c then
                c:kill()
            end
        end
    },
    {
        description = "Client toggle floaTing",
        pattern = { 'c', 't' },
        handler = function()
            local c = client.focus
            if c then
                c.floating = not c.floating
            end
        end
    },
    {
        description = "Client toggle Keep on top",
        pattern = { 'c', 'k' },
        handler = function()
            local c = client.focus
            if c then
                c.ontop = not c.ontop
            end
        end
    },
    {
        description = "Client toggle Sticky",
        pattern = { 'c', 's' },
        handler = function()
            local c = client.focus
            if c then
                c.sticky = not c.sticky
            end
        end
    },
    {
        description = "Client toggle Fullscreen",
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
        description = "Client toggle Maximize",
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
        description = "Client toggle Magnify",
        pattern = { 'c', 'M' },
        handler = function()
            lain.util.magnify_client(client.focus)
        end
    },
    {
        description = "Client miNimize",
        pattern = { 'c', 'n' },
        handler = function()
            local c = client.focus
            if c then
                c.minimized = true
            end
        end
    },
    {
        description = "Client Restore",
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
        description = "Client Jump to urgent",
        pattern = { 'c', 'j' },
        handler = function(mode)
            awful.client.urgent.jumpto()
            mode.stop()
        end
    },
    {
        description = "Client Undo history",
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
        description = "Toggle focused Client on tag",
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
        description = "Move focused client to tag",
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
        description = "Move focused client to Screen by direction",
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
        description = "focus Screen by direction or globally",
        pattern = { 's', '%d*', '[ghjkl]' },
        handler = function (_, _, count, movement)
            count = count == '' and 1 or tonumber(count)

            if movement == 'g' then
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
        description = "Yank a Screen (take a screenshot)",
        pattern = { 'y', 's' },
        handler = function() os.execute("screenshot") end
    },
    -- Misc
    {
        description = "Wibox Toggle",
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
        description = "Widget show Calendar",
        pattern = { 'w', 'c' },
        handler = function ()
            if beautiful.cal then beautiful.cal.show(7) end
        end
    },
    {
        description= "Widget show Filesystem",
        pattern = { 'w', 's' },
        handler = function()
            if beautiful.fs then beautiful.fs.show(7) end
        end
    },
    {
        description= "Widget show weather",
        pattern = { 'w', 'w' },
        handler = function()
            if beautiful.weather then beautiful.weather.show(7) end
        end
    }
}

return normal_commands
