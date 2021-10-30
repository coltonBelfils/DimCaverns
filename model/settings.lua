local gds = require("model.defaultSettings")

local instance = nil

local function getSettings()
    if instance then
        return instance
    end

    -- Check for save file

    instance = gds()

    return instance
end

getSettings()

return getSettings
