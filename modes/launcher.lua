local string, os, table, tostring, tonumber, type = string, os, table, tostring, tonumber, type

local awful = require("awful")
local utils = require("modes.utils")

local launcher_commands = {
    {
        description = "lua e" .. utils.accent("X") .. "ecute prompt",
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
        description = "open a " .. utils.accent("T") .. "erminal",
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
        description = utils.accent("L") .. "ock screen",
        pattern = { 'l' },
        handler = function(mode)
            awful.spawn(awful.util.locker)
            mode.start("normal")
        end
    },
    {
        description = "open " .. utils.accent("M") .. "enu",
        pattern = {'m'},
        handler = function() awful.util.mymainmenu:show() end
    },
}

return launcher_commands
