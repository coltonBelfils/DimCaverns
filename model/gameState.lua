local mapGen = require("mapGen")
local set = require("model.settings")
local pos = require("Point2D")
local cellType = require("cellType")

--[[local gameStateProto = {}

local instance = nil

local function getGameState() -- editing and retrieving any of the members of this table need to be thread safe.
    if instance then
        return instance
    end

    -- Check for settings file here
    local s = settings()

    -- Check for save file here

    -- Private
    local bigMap = mapGen:generate(s.mapSize, s.maxRoomSize)
    local playerPos = pos:new(3, 3)
    local smallMapCenterPos = pos:new(2, 2)

    -- Public
    local nState = {}

    function nState:getBigMap()
        return bigMap
    end
    
    function nState:getPlayerPos()
        return playerPos
    end
    
    function nState:getSmallMapCenter()
        return smallMapCenterPos
    end
    
    function nState:getSmallMap()
        local s = settings()
        local newSmallMap = {}
        for xMod = -3, 3, 1 do
            newSmallMap[xMod + 3] = {}
            for yMod = -3, 3, 1 do
                local newPos = pos:new(smallMapCenterPos:getX() + xMod, smallMapCenterPos:getY() + yMod)
                if newPos:getX() > 0 and newPos:getX() <= s.mapSize and newPos:getY() > 0 and newPos:getY() <=
                    s.mapSize then
                    newSmallMap[xMod + 3][yMod + 3] = bigMap[newPos:getX()][newPos:getY()]
                else
                    newSmallMap[xMod + 3][yMod + 3] = cellType.LEVEL_BOARDER
                end
            end
        end
        return newSmallMap
    end

    setmetatable(nState, gameStateProto)

    instance = nState

    return instance
end

gameStateProto.__index = gameStateProto

getGameState() -- This probably shouldn't be here in the end and should instead should lazily init the singleton, but until GameState:get() is thread safe this is here.

return getGameState]]


-- Check for save file here

local GameState = {
    bigMap = mapGen.generate(set.mapSize, set.maxRoomSize),
    playerPos = pos(3, 3),
    smallMapCenterPos = pos(2, 2),
}

setmetatable(GameState, {
    __metatable = "GameState",
})

function GameState.getSmallMap()
    local newSmallMap = {}
    for xMod = -3, 3, 1 do
        newSmallMap[xMod + 3] = {}
        for yMod = -3, 3, 1 do
            local newPos = pos(GameState.smallMapCenterPos.x + xMod, GameState.smallMapCenterPos.y + yMod)
            if newPos.x > 0 and newPos.x <= set.mapSize and newPos.y > 0 and newPos.y <= set.mapSize then
                newSmallMap[xMod + 3][yMod + 3] = GameState.bigMap[newPos.x][newPos.y]
            else
                newSmallMap[xMod + 3][yMod + 3] = cellType.LEVEL_BOARDER
            end
        end
    end
    return newSmallMap
end

return GameState