local cellType = require("cellType")
local mapGen = require("mapGen")
local pos = require("pos")
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

local playerAnimationOffset = animationOffset:new() -- do this for map too and then put it in the key press and draw functions
local mapAnimationOffset = animationOffset:new()

local rope

function love.load()
    print("Seed: " .. seed)

    love.graphics.setLineStyle("rough")
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setBackgroundColor(black)
    love.graphics.setColor(white)

    rope = ropeItem:new(gameState().bigMap)
    printMap()

    if gameState():getBigMap()[2][2] == cellType.PATH then
        centerLocation = pos:new(2, 2)
        -- playerLocation = pos:new(2, 2)
    elseif gameState():getBigMap()[3][2] == cellType.PATH then
        centerLocation = pos:new(3, 2)
        -- playerLocation = pos:new(3, 2)
    elseif gameState():getBigMap()[2][3] == cellType.PATH then
        centerLocation = pos:new(2, 3)
        -- playerLocation = pos:new(2, 3)
    else
        error("starting player location didn't work")
    end

    playerLocation = pos:new(3, 3)

    smallMap = gameState():getSmallMap()
    -- rope:equip(smallToBigPos(playerLocation, centerLocation))
end

function printMap()
    local str = ""
    local size = settings().mapSize
    for y = size, 1, -1 do
        for x = 1, size, 1 do
            str = str .. tostring(gameState():getBigMap()[x][y].print)
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
            local type = smallMap[x][y]
            love.graphics.setColor(type.color or black)
            love.graphics.rectangle("fill", (((x - 1) * 48) + 80) - (mapAnimationOffset.x * 48), ((((y * -1) + 6) - 1) * 48) + (mapAnimationOffset.y * 48), 48, 48) -- The (y * -1) + 6) part is because the y axis needs to be inverted. The drawing canvas has (0,0) in the upper left, but the maps have it in the lower left.
        end
    end

    love.graphics.setColor({1, 0, 0})

    -- local smallPlayerLocation = bigToSmallPos(playerLocation, centerLocation)
    love.graphics.rectangle("line", (((gameState():getPlayerPos():getX() - 1) * 48) + 80) + (playerAnimationOffset.x * 48), ((((gameState():getPlayerPos():getY() * -1) + 6) - 1) * 48) - (playerAnimationOffset.y * 48), 48, 48) -- The (y * -1) + 6) part is because the y axis needs to be inverted. The drawing canvas has (0,0) in the upper left, but the maps have it in the lower left.

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
            newPlayerLocation = pos:new(playerLocation:getX(), playerLocation:getY() + 1)
            if newPlayerLocation:getY() > 4 then
                newCenterLocation = pos:new(centerLocation:getX(), centerLocation:getY() + 1)
                newPlayerLocation = pos:new(playerLocation:getX(), 4)
            end
        elseif key == 'd' then
            newPlayerLocation = pos:new(playerLocation:getX() + 1, playerLocation:getY())
            if newPlayerLocation:getX() > 4 then
                newCenterLocation = pos:new(centerLocation:getX() + 1, centerLocation:getY())
                newPlayerLocation = pos:new(4, newPlayerLocation:getY())
            end
        elseif key == 's' then
            newPlayerLocation = pos:new(playerLocation:getX(), playerLocation:getY() - 1)
            if newPlayerLocation:getY() < 2 then
                newCenterLocation = pos:new(centerLocation:getX(), centerLocation:getY() - 1)
                newPlayerLocation = pos:new(playerLocation:getX(), 2)
            end
        elseif key == 'a' then
            newPlayerLocation = pos:new(playerLocation:getX() - 1, playerLocation:getY())
            if newPlayerLocation:getX() < 2 then
                newCenterLocation = pos:new(centerLocation:getX() - 1, centerLocation:getY())
                newPlayerLocation = pos:new(2, newPlayerLocation:getY())
            end
        elseif key == 'e' then
            local bigPlayerPos = smallToBigPos(playerLocation, centerLocation)
            if rope.equiped then
                rope:unequip(bigPlayerPos)
            else
                rope:equip(bigPlayerPos)
            end
        end

        local bigPlayerPos = smallToBigPos(newPlayerLocation, newCenterLocation)
        if (playerLocation ~= newPlayerLocation or centerLocation ~= newCenterLocation) and gameState():getBigMap()[bigPlayerPos:getX()][bigPlayerPos:getY()].canMoveTo then
            -- animationManager:addTask(animationTask:new(centerLocation, newCenterLocation, .08, mapAnimationOffset), MAP_ANIMATION_ID)
            -- animationManager:addTask(animationTask:new(playerLocation, newPlayerLocation, .08, playerAnimationOffset), PLAYER_ANIMATION_ID)

            centerLocation = newCenterLocation
            playerLocation = newPlayerLocation
            rope:movedTo(bigPlayerPos)
        end
        smallMap = gameState():getSmallMap()
    end
end

function smallToBigPos(smallPos, bigPosAnchor)
    return pos:new(bigPosAnchor:getX() + (smallPos:getX() - 3), bigPosAnchor:getY() + (smallPos:getY() - 3))
end

function bigToSmallPos(bigPos, bigPosAnchor)
    return pos:new(bigPos:getX() - bigPosAnchor:getX() + 3, bigPos:getY() - bigPosAnchor:getY() + 3)
end
