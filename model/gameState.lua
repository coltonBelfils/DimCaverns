local mapGen = require("mapGen")
local settings = require("model.settings")
local pos = require("pos")
local cellType = require("cellType")

local instance = {} -- This class/singleton and the settings class/singleton need some work still.

local bigMap
local function getSmallMap()
    local newSmallMap = {}
    for xMod = -3, 3, 1 do
        newSmallMap[xMod + 3] = {}
        for yMod = -3, 3, 1 do
            local newPos = pos:new(self.center:getX() + xMod, self.center:getY() + yMod)
            if newPos:getX() > 0 and newPos:getX() <= settings().mapSize and newPos:getY() > 0 and newPos:getY() <= settings().mapSize then
                newSmallMap[xMod + 3][yMod + 3] = bigMap[newPos:getX()][newPos:getY()]
            else
                newSmallMap[xMod + 3][yMod + 3] = cellType.LEVEL_BOARDER
            end
        end
    end
    return newSmallMap
end
local playerPos
local smallMapCenterPos

local function getGameState() -- editing and retrieving any of the members of this table need to be thread safe.
    if instance then
        return instance
    end

    -- Check for settings file here
    local s = settings()

    -- Check for save file here

    local nState = {
        bigMap = mapGen:generate(s.mapSize, s.maxRoomSize),
        smallMap = self.getSmallMap,
        playerPos = pos:new(3, 3), -- Need to decide if this will be reletive to bigMap or smallMap. Currently it's small map.
        smallMapCenterPos = pos:new(2, 2) -- The center of the small map on the bigMap. Needs a better name.
    }

    instance = nState

    return nState
end

getGameState() -- This probably shouldn't be here in the end and should instead should lazily init the singleton, but until GameState:get() is thread safe this is here.

return getGameState
