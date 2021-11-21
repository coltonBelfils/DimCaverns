local cellType = require("cellType")
local mapGen = require("mapGen")
local P2D = require("Point2D")
local animationManager = require("animationManager")
local animationTask = require("animationTask")
local animationOffset = require("animationOffset")
local ropeItem = require("ropeItem")
local gameState = require("model.gameState")
local settings = require("model.settings")

local black = {0, 0, 0}
local white = {1, 1, 1}

local seed = os.time()
seed = 456789
math.randomseed(seed)

local smallMap = {} -- a 2D array ints/cellTypes. 7 by 7 array, only 5 by 5 cells are shown at a time and then there's one buffer cell per side for animation.
local centerLocation -- the pos of the center of the small map on the big map
local playerLocation

local PLAYER_ANIMATION_ID = "PLAYER_ANIMATION_ID"
local MAP_ANIMATION_ID = "MAP_ANIMATION_ID"

local playerAnimationOffset = P2D() -- do this for map too and then put it in the key press and draw functions
local mapAnimationOffset = P2D()

local rope

function love.load()
    print("Seed: " .. seed)

    love.graphics.setLineStyle("rough")
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setBackgroundColor(black)
    love.graphics.setColor(white)

    --rope = ropeItem(gameState.bigMap)
    printMap()

    if gameState.bigMap[2][2] == cellType.PATH then
        centerLocation = P2D(2, 2)
        -- playerLocation = pos(2, 2)
    elseif gameState.bigMap[3][2] == cellType.PATH then
        centerLocation = P2D(3, 2)
        -- playerLocation = pos(3, 2)
    elseif gameState.bigMap[2][3] == cellType.PATH then
        centerLocation = P2D(2, 3)
        -- playerLocation = pos(2, 3)
    else
        error("starting player location didn't work")
    end

    playerLocation = P2D(3, 3)

    smallMap = gameState:getSmallMap()
    -- rope:equip(smallToBigPos(playerLocation, centerLocation))
end

function printMap()
    local str = ""
    local size = settings.mapSize
    for y = size, 1, -1 do
        for x = 1, size, 1 do
            str = str .. tostring(gameState.bigMap[x][y].print)
        end
        str = str .. "\n"
    end
    print(str)
end

function love.update(dt)
    -- animationManager:updateTasks(dt)
    -- smallMap = getSmallMap(centerLocation, bigMap)
end

function love.draw()
    for x = 0, 6, 1 do
        for y = 0, 6, 1 do
            local type = gameState.getSmallMap()[x][y]
            love.graphics.setColor(type.color or black)
            love.graphics.rectangle("fill", (((x - 1) * 48) + 80) - (mapAnimationOffset.x * 48), ((((y * -1) + 6) - 1) * 48) + (mapAnimationOffset.y * 48), 48, 48) -- The (y * -1) + 6) part is because the y axis needs to be inverted. The drawing canvas has (0,0) in the upper left, but the maps have it in the lower left.
        end
    end

    love.graphics.setColor({1, 0, 0})

    -- local smallPlayerLocation = bigToSmallPos(playerLocation, centerLocation)
    love.graphics.rectangle("line", (((gameState.playerPos.x - 1) * 48) + 80) + (playerAnimationOffset.x * 48), ((((gameState.playerPos.y * -1) + 6) - 1) * 48) - (playerAnimationOffset.y * 48), 48, 48) -- The (y * -1) + 6) part is because the y axis needs to be inverted. The drawing canvas has (0,0) in the upper left, but the maps have it in the lower left.

    love.graphics.setColor({.5, .5, .5})
    love.graphics.rectangle("fill", 0, 0, 80, 240)
    love.graphics.rectangle("fill", 320, 0, 80, 240)
end

function love.keypressed(key, scancode, isrepeat) -- something's not right with the up and down movement. I think the small map may be upside-down somehow or something like that.
    if not isrepeat then
        local newPlayerLocation = playerLocation
        -- local smallPlayerLocation = bigToSmallPos(playerLocation, centerLocation)
        local newCenterLocation = centerLocation
        if key == 'w' then
            newPlayerLocation = P2D(playerLocation.x, playerLocation.y + 1)
            if newPlayerLocation.y > 4 then
                newCenterLocation = P2D(centerLocation.x, centerLocation.y + 1)
                newPlayerLocation = P2D(playerLocation.x, 4)
            end
        elseif key == 'd' then
            newPlayerLocation = P2D(playerLocation.x + 1, playerLocation.y)
            if newPlayerLocation.x > 4 then
                newCenterLocation = P2D(centerLocation.x + 1, centerLocation.y)
                newPlayerLocation = P2D(4, newPlayerLocation.y)
            end
        elseif key == 's' then
            newPlayerLocation = P2D(playerLocation.x, playerLocation.y - 1)
            if newPlayerLocation.y < 2 then
                newCenterLocation = P2D(centerLocation.x, centerLocation.y - 1)
                newPlayerLocation = P2D(playerLocation.x, 2)
            end
        elseif key == 'a' then
            newPlayerLocation = P2D(playerLocation.x - 1, playerLocation.y)
            if newPlayerLocation.x < 2 then
                newCenterLocation = P2D(centerLocation.x - 1, centerLocation.y)
                newPlayerLocation = P2D(2, newPlayerLocation.y)
            end
        elseif key == 'e' then
            --[[local bigPlayerPos = smallToBigPos(playerLocation, centerLocation)
            if rope.equiped then
                rope:unequip(bigPlayerPos)
            else
                rope:equip(bigPlayerPos)
            end]]
        end

        local bigPlayerPos = smallToBigPos(newPlayerLocation, newCenterLocation)
        if (playerLocation ~= newPlayerLocation or centerLocation ~= newCenterLocation) and gameState.bigMap[bigPlayerPos.x][bigPlayerPos.y].canMoveTo then
            -- animationManager:addTask(animationTask(centerLocation, newCenterLocation, .08, mapAnimationOffset), MAP_ANIMATION_ID)
            -- animationManager:addTask(animationTask(playerLocation, newPlayerLocation, .08, playerAnimationOffset), PLAYER_ANIMATION_ID)

            centerLocation = newCenterLocation
            playerLocation = newPlayerLocation
            --rope:movedTo(bigPlayerPos)
        end
        smallMap = gameState.getSmallMap()
    end
end

function smallToBigPos(smallPos, bigPosAnchor)
    return P2D(bigPosAnchor.x + (smallPos.x - 3), bigPosAnchor.y + (smallPos.y - 3))
end

function bigToSmallPos(bigPos, bigPosAnchor)
    return P2D(bigPos.x - bigPosAnchor.x + 3, bigPos.y - bigPosAnchor.y + 3)
end
