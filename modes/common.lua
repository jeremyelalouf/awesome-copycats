local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag

local awful         = require("awful")
local lain          = require("lain")
local wibox         = require("wibox")
local hotkeys_popup = require("awful.hotkeys_popup")

local utils = require("modes.utils")
local taghelper = utils.taghelper
local directions = utils.directions

local awesome_ctl = {
    quit = awesome.quit,
    restart = awesome.restart,
    help = hotkeys_popup.show_help,
    lock = function() awful.spawn(awful.util.locker) end
}

local common_commands = {
    merge=true,
    {
        description = "Run command or control awesome",
        pattern = {':'},
        handler = function()
            awful.prompt.run {
                prompt  = ":",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = function(name)
                    if (awesome_ctl[name] ~= nil) then
                        awesome_ctl[name]()
                    else
                        awful.spawn(name)
                    end
                end,
                history_path = awful.util.get_cache_dir() .. "/history_prompt",
                completion_callback = awful.completion.shell

            }
        end
    },
    {
        description = "show help popup",
        pattern = { '?' },
        handler = function() hotkeys_popup.show_help() end
    },

    -- Modes switching
    {
        description = "enter " .. utils.accent("I") .. "nsert mode",
        pattern = {'i'},
        handler = function(mode) mode.stop() end
    },
    {
        description = "enter launche".. utils.accent("R") .. " mode",
        pattern = {'r'},
        handler = function(mode) mode.start("launcher") end
    },
    {
        description = "enter " .. utils.accent("V") .. "isual mode",
        pattern = {'v'},
        handler = function(mode) mode.start("visual") end
    },
    {
        description = "enter " .. utils.accent("T") .. "ag mode",
        pattern = {'T'},
        handler = function(mode) mode.start("tag") end
    },
    {
        description = "enter " .. utils.accent("M") .. "ouse mode",
        pattern = {'M'},
        handler = function(mode) mode.start("mouse") end
    }
}

return common_commands
