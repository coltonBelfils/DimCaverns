local cellType = require("cellType")
local mapper = require("mapper")
local pos = require("pos")
local animationManager = require("animationManager")
local animationTask = require("animationTask")
local animationOffset = require("animationOffset")

local black = {0, 0, 0}
local white = {1, 1, 1}

local seed = os.time()
seed = 456789
math.randomseed(seed)

local mapSize = 70
local maxRoomSize = 7

local bigMap
local smallMap = {} -- a 2D array ints/cellTypes. 7 by 7 array, only 5 by 5 cells are shown at a time and then there's one buffer cell per side for animation.
local centerLocation -- the pos of the center of the small map on the big map
local playerLocation

local PLAYER_ANIMATION_ID = "PLAYER_ANIMATION_ID"
local MAP_ANIMATION_ID = "MAP_ANIMATION_ID"

local playerAnimationOffset = animationOffset:new() -- do this for map too and then put it in the key press and draw functions
local mapAnimationOffset = animationOffset:new()

function love.load()
    print("Seed: " .. seed)

    love.graphics.setLineStyle("rough")
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setBackgroundColor(black)
    love.graphics.setColor(white)

    bigMap = mapper:new(mapSize, maxRoomSize)
    printMap()

    if bigMap.map[2][2] == cellType.PATH then
        centerLocation = pos:new(2, 2)
        --playerLocation = pos:new(2, 2)
    elseif bigMap.map[3][2] == cellType.PATH then
        centerLocation = pos:new(3, 2)
        --playerLocation = pos:new(3, 2)
    elseif bigMap.map[2][3] == cellType.PATH then
        centerLocation = pos:new(2, 3)
        --playerLocation = pos:new(2, 3)
    else
        error("starting player location didn't work")
    end

    playerLocation = pos:new(3, 3)

    smallMap = getSmallMap(centerLocation, bigMap)
end

function printMap()
    local str = ""
    for y = mapSize, 1, -1 do
        for x = 1, mapSize, 1 do
            str = str .. tostring(bigMap.map[x][y])
        end
        str = str .. "\n"
    end
    print(str)
end

function love.update(dt)
    --animationManager:updateTasks(dt)
    --smallMap = getSmallMap(centerLocation, bigMap)
end

function love.draw()
    for x = 0, 6, 1 do
        for y = 0, 6, 1 do
            local type = smallMap[x][y]
            if type == cellType.PATH then
                love.graphics.setColor(white)
            else
                love.graphics.setColor(black)
            end
            love.graphics.rectangle("fill", (((x - 1) * 48) + 80) - (mapAnimationOffset.x * 48),
                ((((y * -1) + 6) - 1) * 48) + (mapAnimationOffset.y * 48), 48, 48) -- The (y * -1) + 6) part is because the y axis needs to be inverted. The drawing canvas has (0,0) in the upper left, but the maps have it in the lower left.
        end
    end

    love.graphics.setColor({1, 0, 0})

    --local smallPlayerLocation = bigToSmallPos(playerLocation, centerLocation)
    love.graphics.rectangle("fill", (((playerLocation.x - 1) * 48) + 80) + (playerAnimationOffset.x * 48),
        ((((playerLocation.y * -1) + 6) - 1) * 48) - (playerAnimationOffset.y * 48), 48, 48) -- The (y * -1) + 6) part is because the y axis needs to be inverted. The drawing canvas has (0,0) in the upper left, but the maps have it in the lower left.

    love.graphics.setColor({.5, .5, .5})
    love.graphics.rectangle("fill", 0, 0, 80, 240)
    love.graphics.rectangle("fill", 320, 0, 80, 240)
end

function love.keypressed(key, scancode, isrepeat) -- something's not right with the up and down movement. I think the small map may be upside-down somehow or something like that.
    if not isrepeat then
        local newPlayerLocation = playerLocation
        --local smallPlayerLocation = bigToSmallPos(playerLocation, centerLocation)
        local newCenterLocation = centerLocation
        if key == 'w' then
            newPlayerLocation = pos:new(playerLocation.x, playerLocation.y + 1)
            if newPlayerLocation.y > 4 then
                newCenterLocation = pos:new(centerLocation.x, centerLocation.y + 1)
                newPlayerLocation = pos:new(playerLocation.x, 4)
            end
        elseif key == 'd' then
            newPlayerLocation = pos:new(playerLocation.x + 1, playerLocation.y)
            if newPlayerLocation.x > 4 then
                newCenterLocation = pos:new(centerLocation.x + 1, centerLocation.y)
                newPlayerLocation = pos:new(4, newPlayerLocation.y)
            end
        elseif key == 's' then
            newPlayerLocation = pos:new(playerLocation.x, playerLocation.y - 1)
            if newPlayerLocation.y < 2 then
                newCenterLocation = pos:new(centerLocation.x, centerLocation.y - 1)
                newPlayerLocation = pos:new(playerLocation.x, 2)
            end
        elseif key == 'a' then
            newPlayerLocation = pos:new(playerLocation.x - 1, playerLocation.y)
            if newPlayerLocation.x < 2 then
                newCenterLocation = pos:new(centerLocation.x - 1, centerLocation.y)
                newPlayerLocation = pos:new(2, newPlayerLocation.y)
            end
        end

        local bigPlayerPos = smallToBigPos(newPlayerLocation, newCenterLocation)
        if bigMap.map[bigPlayerPos.x][bigPlayerPos.y] == cellType.PATH then
            --animationManager:addTask(animationTask:new(centerLocation, newCenterLocation, .08, mapAnimationOffset), MAP_ANIMATION_ID)
            --animationManager:addTask(animationTask:new(playerLocation, newPlayerLocation, .08, playerAnimationOffset), PLAYER_ANIMATION_ID)

            centerLocation = newCenterLocation
            playerLocation = newPlayerLocation
            smallMap = getSmallMap(centerLocation, bigMap)
        end
    end
end

function getSmallMap(center, bigMap)
    local newSmallMap = {}
    for xMod = -3, 3, 1 do
        newSmallMap[xMod + 3] = {}
        for yMod = -3, 3, 1 do
            local newPos = pos:new(center.x + xMod, center.y + yMod)
            if newPos.x > 0 and newPos.x <= mapSize and newPos.y > 0 and newPos.y <= mapSize then
                newSmallMap[xMod + 3][yMod + 3] = bigMap.map[newPos.x][newPos.y]
            else
                newSmallMap[xMod + 3][yMod + 3] = cellType.LEVEL_BOARDER
            end
        end
    end
    return newSmallMap
end

function smallToBigPos(smallPos, bigPosAnchor)
    return pos:new(bigPosAnchor.x + (smallPos.x - 3), bigPosAnchor.y + (smallPos.y - 3))
end

function bigToSmallPos(bigPos, bigPosAnchor)
    return pos:new(bigPos.x - bigPosAnchor.x + 3, bigPos.y - bigPosAnchor.y + 3)
end
