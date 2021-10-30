local cell = require("cell")
local cellType = require("cellType")
local pos = require("pos")
local tree = require("tree")
local linkedList = require("linkedList")
local posLink = require("posLink")

local Mapper = {}-- A glorified version of Kruskal's Algorithm the cells in the maze aren't all uniform squares.

function Mapper:generate(mapSize, maxRoomSize)
    local constructionMap = {} -- a 2D array of trees. The tree values are cells.
    local exportMap = {} -- a 2D array of cellTypes.

    local pointsAssigned = {}
    local points = linkedList:new() -- a LL of all points that is flattened instead of in a 2D map
    local borders = linkedList:new() -- LL which contains the border cells of all possible borders
    local bordersAlready = {} -- Hashtable that keeps track of which borders have already been added so you don't have to treverse the borders LL to find out

    for x = 1, mapSize, 1 do -- (0,0) is the bottom left
        constructionMap[x] = {}
        exportMap[x] = {}
        for y = 1, mapSize, 1 do
            if x == 1 or x == mapSize or y == 1 or y == mapSize then
                local newCell = cell:new(cellType.LEVEL_BOARDER, pos:new(x, y))
                constructionMap[x][y] = tree:new(newCell)
                exportMap[x][y] = cellType.LEVEL_BOARDER
                pointsAssigned[newCell:getPos():id()] = constructionMap[x][y]
            else
                local newCell = cell:new(cellType.PATH, pos:new(x, y))
                constructionMap[x][y] = tree:new(newCell)
                exportMap[x][y] = cellType.PATH
                points:addLast(constructionMap[x][y])
            end
        end
    end
    
    -- This while loop is what creates all the rooms. 
    while points:getSize() > 0 do -- This while loop could probably be optimized a little (a lot).
        local index = math.random(points:getSize())
        local cellTree = points:removeIndex(index) -- get the starting point for the room
        local cellPoint = cellTree:getValue()
        if pointsAssigned[cellPoint:getPos():id()] == nil then -- check if that point is available
            pointsAssigned[cellPoint:getPos():id()] = cellPoint -- make that point unavailable for the future
            local xDist = math.random(3, maxRoomSize)
            local yDist = math.random(3, maxRoomSize)
            local rect = {
                top = cellPoint:getPos():getY(),
                bottom = cellPoint:getPos():getY(),
                left = cellPoint:getPos():getX(),
                right = cellPoint:getPos():getX(),
            }
            local xPacked = false
            local yPacked = false
            while xPacked == false and xDist > 0 do -- expand in the x direction up to xDist if possible
                if pointsAssigned[pos:new(rect.right + 1, rect.top):id()] == nil then
                    rect.right = rect.right + 1
                    local newPoint = constructionMap[rect.right][rect.top]
                    pointsAssigned[newPoint:getValue():getPos():id()] = newPoint
                    cellTree:graft(newPoint)
                    xDist = xDist - 1
                elseif pointsAssigned[pos:new(rect.left - 1, rect.top):id()] == nil then
                    rect.left = rect.left - 1
                    local newPoint = constructionMap[rect.left][rect.top]
                    pointsAssigned[newPoint:getValue():getPos():id()] = newPoint
                    cellTree:graft(newPoint)
                    xDist = xDist - 1
                else
                    xPacked = true
                end
            end
            while yPacked == false and yDist > 0 do -- expand in the y direction up to ydist if possible
                local topCellsClear = true
                for i = rect.left, rect.right, 1 do
                    if pointsAssigned[pos:new(i, rect.top + 1):id()] ~= nil then
                        topCellsClear = false
                    end
                end
                if topCellsClear then
                    rect.top = rect.top + 1
                    for i = rect.left, rect.right, 1 do
                        local newPoint = constructionMap[i][rect.top]
                        pointsAssigned[newPoint:getValue():getPos():id()] = newPoint
                        cellTree:graft(newPoint)
                    end
                    yDist = yDist - 1
                else
                    local bottomCellsClear = true
                    for i = rect.left, rect.right, 1 do
                        if pointsAssigned[pos:new(i, rect.bottom - 1):id()] ~= nil then
                            bottomCellsClear = false
                        end
                    end
                    if bottomCellsClear then
                        rect.bottom = rect.bottom - 1
                        for i = rect.left, rect.right, 1 do
                            local newPoint = constructionMap[i][rect.bottom]
                            pointsAssigned[newPoint:getValue():getPos():id()] = newPoint
                            cellTree:graft(newPoint)
                        end
                        yDist = yDist - 1
                    else
                        yPacked = true
                    end
                end
            end

            for x = rect.left, rect.right, 1 do
                for y = rect.bottom, rect.top, 1 do
                    if x == rect.right then
                        if constructionMap[rect.right + 1][y]:getValue():getCellType() == cellType.PATH then constructionMap[rect.right][y]:removeNode()
                            local wallPoint = constructionMap[rect.right][y]:getValue()
                            wallPoint:setCellType(cellType.WALL)
                            exportMap[rect.right][y] = cellType.WALL
                            pointsAssigned[wallPoint:getPos():id()] = wallPoint
                            local newLink = posLink:new(constructionMap[rect.right - 1][y]:getValue():getPos(), constructionMap[rect.right + 1][y]:getValue():getPos(), constructionMap[rect.right][y]:getValue():getPos())
                            if not bordersAlready[newLink:id()] then
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        elseif constructionMap[rect.right + 1][y]:getValue():getCellType() ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(constructionMap[rect.right][y]:getValue():getPos(), constructionMap[rect.right + 2][y]:getValue():getPos(), constructionMap[rect.right + 1][y]:getValue():getPos()):id()] then
                            local newLink = posLink:new(constructionMap[rect.right][y]:getValue():getPos(), constructionMap[rect.right + 2][y]:getValue():getPos(), constructionMap[rect.right + 1][y]:getValue():getPos())
                            bordersAlready[newLink:id()] = true
                            borders:addFirst(newLink)
                        end
                    elseif x == rect.left then
                        if constructionMap[rect.left - 1][y]:getValue():getCellType() == cellType.PATH then constructionMap[rect.left][y]:removeNode()
                            local wallPoint = constructionMap[rect.left][y]:getValue()
                            wallPoint:setCellType(cellType.WALL)
                            exportMap[rect.left][y] = cellType.WALL
                            pointsAssigned[wallPoint:getPos():id()] = wallPoint
                            local newLink = posLink:new(constructionMap[rect.left + 1][y]:getValue():getPos(), constructionMap[rect.left - 1][y]:getValue():getPos(), constructionMap[rect.left][y]:getValue():getPos())
                            if not bordersAlready[newLink:id()] then
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        elseif constructionMap[rect.left - 1][y]:getValue():getCellType() ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(constructionMap[rect.left][y]:getValue():getPos(), constructionMap[rect.left - 2][y]:getValue():getPos(), constructionMap[rect.left - 1][y]:getValue():getPos()):id()] then
                            local newLink = posLink:new(constructionMap[rect.left][y]:getValue():getPos(), constructionMap[rect.left - 2][y]:getValue():getPos(), constructionMap[rect.left - 1][y]:getValue():getPos())
                            bordersAlready[newLink:id()] = true
                            borders:addFirst(newLink)
                        end
                    end
                    if y == rect.top then
                        if constructionMap[x][rect.top + 1]:getValue():getCellType() == cellType.PATH then constructionMap[x][rect.top]:removeNode()
                            local wallPoint = constructionMap[x][rect.top]:getValue()
                            wallPoint:setCellType(cellType.WALL)
                            exportMap[x][rect.top] = cellType.WALL
                            pointsAssigned[wallPoint:getPos():id()] = wallPoint
                            local newLink = posLink:new(constructionMap[x][rect.top - 1]:getValue():getPos(), constructionMap[x][rect.top + 1]:getValue():getPos(), constructionMap[x][rect.top]:getValue():getPos())
                            if not bordersAlready[newLink:id()] then
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        elseif constructionMap[x][rect.top + 1]:getValue():getCellType() ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(constructionMap[x][rect.top]:getValue():getPos(), constructionMap[x][rect.top + 2]:getValue():getPos(), constructionMap[x][rect.top + 1]:getValue():getPos()):id()] then
                            local newLink = posLink:new(constructionMap[x][rect.top]:getValue():getPos(), constructionMap[x][rect.top + 2]:getValue():getPos(), constructionMap[x][rect.top + 1]:getValue():getPos())
                            bordersAlready[newLink:id()] = true
                            borders:addFirst(newLink)
                        end
                    elseif y == rect.bottom then
                        if constructionMap[x][rect.bottom - 1]:getValue():getCellType() == cellType.PATH then constructionMap[x][rect.bottom]:removeNode()
                            local wallPoint = constructionMap[x][rect.bottom]:getValue()
                            wallPoint:setCellType(cellType.WALL)
                            exportMap[x][rect.bottom] = cellType.WALL
                            pointsAssigned[wallPoint:getPos():id()] = wallPoint
                            local newLink = posLink:new(constructionMap[x][rect.bottom + 1]:getValue():getPos(), constructionMap[x][rect.bottom - 1]:getValue():getPos(), constructionMap[x][rect.bottom]:getValue():getPos())
                            if not bordersAlready[newLink:id()] then
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        elseif constructionMap[x][rect.bottom - 1]:getValue():getCellType() ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(constructionMap[x][rect.bottom]:getValue():getPos(), constructionMap[x][rect.bottom - 2]:getValue():getPos(), constructionMap[x][rect.bottom - 1]:getValue():getPos()):id()] then
                            local newLink = posLink:new(constructionMap[x][rect.bottom]:getValue():getPos(), constructionMap[x][rect.bottom - 2]:getValue():getPos(), constructionMap[x][rect.bottom - 1]:getValue():getPos())
                            bordersAlready[newLink:id()] = true
                            borders:addFirst(newLink)
                        end
                    end
                end
            end
        end
    end

    -- This while loop connects all the rooms so there is only one path from one room to another
    while borders:getSize() > 0 do
        local index = math.random(borders:getSize())
        local borderLink = borders:removeIndex(index)
        local borderOne = constructionMap[borderLink:getPosOne():getX()][borderLink:getPosOne():getY()]
        local borderTwo = constructionMap[borderLink:getPosTwo():getX()][borderLink:getPosTwo():getY()]
        if borderOne:getValue():getCellType() == cellType.PATH and borderTwo:getValue():getCellType() == cellType.PATH and borderOne:getTopParent() ~= borderTwo:getTopParent() then
            constructionMap[borderLink:getLinkPos():getX()][borderLink:getLinkPos():getY()]:getValue():setCellType(cellType.PATH)
            exportMap[borderLink:getLinkPos():getX()][borderLink:getLinkPos():getY()] = cellType.PATH
            borderOne:graft(borderTwo)
        end
    end

    local mapReturn = {
        
    }

    return exportMap
end

Mapper.__index = Mapper

return Mapper
