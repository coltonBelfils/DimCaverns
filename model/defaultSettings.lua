local time = os.time()

local mapSize = 70
local maxRoomSize = 7
local seed = time

local function getDefaultSettings()
    return {
        mapSize = mapSize,
        maxRoomSize = maxRoomSize,
        seed = seed
    }
end

return getDefaultSettings
