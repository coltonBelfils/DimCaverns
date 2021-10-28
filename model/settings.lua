local defaultSettings = require("model.defaultSettings")

local Settings = {
    instance = nil -- Find a way to make private.
}

function Settings:get()
    if self.instance then return self.instance end

    -- Check for save file
    self.instance = defaultSettings

    return self.instance
end

return Settings