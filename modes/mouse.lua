local awful = require("awful")


local is_up = { true, true, true, true, true }

local mouse_util = {
    trigger_click = function (button)
        if (type(button) == "number" and (button >= 1 and button <= 5)) then
            awful.spawn.easy_async("xdotool getwindowfocus click " .. tostring(button), function () is_up[button] = true end)
        end
    end,
    toggle_button = function (button)
        if (type(button) == "number" and (button >= 1 and button <= 5)) then
            local action = "mouse"

            if (is_up[button] == false) then
                action = action .. "up"
            else
                action = action .. "down"
            end

            is_up[button] = not is_up[button]

            awful.spawn("xdotool getwindowfocus " .. action .. " " .. tostring(button))
        end
    end
}

local mouse_commands = {
    {
        description = "move mouse left",
        pattern = {'h'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- -10 0") end,
    },
    {
        description = "move mouse down",
        pattern = {'j'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 0 10") end,
    },
    {
        description = "move mouse up",
        pattern = {'k'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 0 -10") end,
    },

    {
        description = "move mouse right",
        pattern = {'l'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 10 0") end,
    },

    {
        description = "move mouse UL",
        pattern = {{"Control", 'h'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- -10 -10") end,
    },
    {
        description = "move mouse UR",
        pattern = {{"Control", 'k'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 10 -10") end,
    },
    {
        description = "move mouse DL",
        pattern = {{"Control", 'j'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- -10 10") end,
    },
    {
        description = "move mouse DR",
        pattern = {{"Control", 'l'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 10 10") end,
    },

    -- Fast Mode
    {
        description = "move mouse left",
        pattern = {'H'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- -50 0") end,
    },
    {
        description = "move mouse down",
        pattern = {'J'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 0 50") end,
    },
    {
        description = "move mouse up",
        pattern = {'K'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 0 -50") end,
    },
    {
        description = "move mouse right",
        pattern = {'L'},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 50 0") end,
    },

    {
        description = "move mouse UL",
        pattern = {{"Control", "Shift", 'h'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- -50 -50") end,
    },
    {
        description = "move mouse UR",
        pattern = {{"Control", "Shift", 'k'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 50 -50") end,
    },
    {
        description = "move mouse DL",
        pattern = {{"Control", "Shift", 'j'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- -50 50") end,
    },
    {
        description = "move mouse DR",
        pattern = {{"Control", "Shift", 'l'}},
        handler = function () awful.spawn.spawn("xdotool mousemove_relative -- 50 50") end,
    },

    -- Click
    {
        description = "Left click",
        pattern = {"a"},
        handler = function (_)
            mouse_util.trigger_click(1)
        end,
    },
    {
        description = "Left click toggle",
        pattern = {"q"},
        handler = function (_)
            mouse_util.toggle_button(1)
        end,
    },
    {
        description = "Middle click",
        pattern = {"w"},
        handler = function (_)
            mouse_util.trigger_click(2)
        end,
    },
    {
        description = "Middle click toggle",
        pattern = {"e"},
        handler = function (_)
            mouse_util.toggle_button(2)
        end,
    },
    {
        description = "Right click",
        pattern = {"f"},
        handler = function (_)
            mouse_util.trigger_click(3)
        end,
    },
    {
        description = "Right click toggle",
        pattern = {"r"},
        handler = function (_)
            mouse_util.toggle_button(3)
        end,
    },
    {
        description = "wheel up",
        pattern = {"s"},
        handler = function (_)
            mouse_util.trigger_click(4)
        end,
    },
    {
        description = "wheel down",
        pattern = {"d"},
        handler = function (_)
            mouse_util.trigger_click(5)
        end,
    },
    {
        description = "toggle button",
        pattern = {'t', '[afw]'},
        handler = function (_, _, key)
            local mapping = { a=1, w=2, f=3, s=4, d=5 }

            mouse_util.toggle_button(mapping[key])
        end
    }
}

return mouse_commands
