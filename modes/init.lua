local modes = {
    normal    = require("modes.normal"),
    tag       = require("modes.tag"),
    visual    = require("modes.visual"),
    launcher  = require("modes.launcher"),
    common    = require("modes.common")
}

local ignores = {
    tag       = 'T',
    visual    = 'v',
    launcher  = 'r'
}

return modes
