local common = require("modes.common")

local modes = {
    normal    = require("modes.normal"),
    tag       = require("modes.tag"),
    visual    = require("modes.visual"),
    launcher  = require("modes.launcher")
}

local ignores = {
    tag       = 'T',
    visual    = 'v',
    launcher  = 'r'
}

for mode, desc in pairs(modes) do
    for _, v in ipairs(common) do
        if table.concat(v.pattern) ~= ignores[mode] then
            table.insert(desc, v)
        end
    end
end

return modes
