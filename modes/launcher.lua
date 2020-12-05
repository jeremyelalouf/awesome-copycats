local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local awful = require("awful")
local wibox = require("wibox")
local menubar = require("menubar")
local naughty       = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

local launcher_commands = {
    {
        description = "lua execute prompt",
        pattern = {'x'},
        handler = function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
    },
    {
        description = "run prompt",
        pattern = {'s'},
        handler = function(mode)
            awful.screen.focused().mypromptbox:run()
            mode.stop()
        end
    },
    {
        description = "open a terminal",
        pattern = {'%d*', 't'},
        handler = function(mode, count)
            count = count == '' and 1 or tonumber(count)

            while count ~= 0 do
                awful.spawn(awful.util.terminal)
                count = count - 1
            end
            mode.stop()
        end
    },
    {
        description = "lock screen",
        pattern = { 'l' },
        handler = function() -- naughty.notify({ text = awful.util.lock }) 
            awful.spawn(awful.util.locker)
        end
    },
    {
        description = "open Menu",
        pattern = {'m'},
        handler = function() awful.util.mymainmenu:show() end
    },
}

return launcher_commands
