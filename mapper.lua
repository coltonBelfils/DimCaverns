local cell = require("cell")
local cellType = require("cellType")
local pos = require("pos")
local tree = require("tree")
local linkedList = require("linkedList")
local posLink = require("posLink")

local Mapper = {-- A glorified version of Kruskal's Algorithm the cells in the maze aren't all uniform squares.
    new = function(self, mapSize, maxRoomSize)
        local map = {} -- a 2D array of trees. The tree values are cells.
        local exportMap = {} -- a 2D array of cellTypes.

        local pointsAssigned = {}
        local points = linkedList:new() -- a LL of all points that is flattened instead of in a 2D map
        local borders = linkedList:new() -- LL which contains the border cells of all possible borders
        local bordersAlready = {} -- Hashtable that keeps track of which borders have already been added so you don't have to treverse the borders LL to find out

        for x = 1, mapSize, 1 do -- (0,0) is the bottom left
            map[x] = {}
            exportMap[x] = {}
            for y = 1, mapSize, 1 do
                if x == 1 or x == mapSize or y == 1 or y == mapSize then
                    local newCell = cell:new(cellType.LEVEL_BOARDER, pos:new(x, y))
                    map[x][y] = tree:new(newCell)
                    exportMap[x][y] = cellType.LEVEL_BOARDER
                    pointsAssigned[newCell.pos:id()] = map[x][y]
                else
                    local newCell = cell:new(cellType.PATH, pos:new(x, y))
                    map[x][y] = tree:new(newCell)
                    exportMap[x][y] = cellType.PATH
                    points:addLast(map[x][y])
                end
            end
        end
        
        -- This while loop is what creates all the rooms. 
        while points:getSize() > 0 do -- This while loop could probably be optimized a little (a lot).
            local index = math.random(points:getSize())
            local cellTree = points:removeIndex(index) -- get the starting point for the room
            local cellPoint = cellTree:getValue()
            if pointsAssigned[cellPoint.pos:id()] == nil then -- check if that point is available
                pointsAssigned[cellPoint.pos:id()] = cellPoint -- make that point unavailable for the future
                local xDist = math.random(3, maxRoomSize)
                local yDist = math.random(3, maxRoomSize)
                local rect = {
                    top = cellPoint.pos.y,
                    bottom = cellPoint.pos.y,
                    left = cellPoint.pos.x,
                    right = cellPoint.pos.x
                }
                local xPacked = false
                local yPacked = false
                while xPacked == false and xDist > 0 do -- expand in the x direction up to xDist if possible
                    if pointsAssigned[pos:new(rect.right + 1, rect.top):id()] == nil then
                        rect.right = rect.right + 1
                        local newPoint = map[rect.right][rect.top]
                        pointsAssigned[newPoint:getValue().pos:id()] = newPoint
                        cellTree:graft(newPoint)
                        xDist = xDist - 1
                    elseif pointsAssigned[pos:new(rect.left - 1, rect.top):id()] == nil then
                        rect.left = rect.left - 1
                        local newPoint = map[rect.left][rect.top]
                        pointsAssigned[newPoint:getValue().pos:id()] = newPoint
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
                            local newPoint = map[i][rect.top]
                            pointsAssigned[newPoint:getValue().pos:id()] = newPoint
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
                                local newPoint = map[i][rect.bottom]
                                pointsAssigned[newPoint:getValue().pos:id()] = newPoint
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
                            if map[rect.right + 1][y]:getValue().cellType == cellType.PATH then map[rect.right][y]:removeNode()
                                local wallPoint = map[rect.right][y]:getValue()
                                wallPoint.cellType = cellType.WALL
                                exportMap[rect.right][y] = cellType.WALL
                                pointsAssigned[wallPoint.pos:id()] = wallPoint
                                local newLink = posLink:new(map[rect.right - 1][y].value.pos, map[rect.right + 1][y].value.pos, map[rect.right][y].value.pos)
                                if not bordersAlready[newLink:id()] then
                                    bordersAlready[newLink:id()] = true
                                    borders:addFirst(newLink)
                                end
                            elseif map[rect.right + 1][y]:getValue().cellType ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(map[rect.right][y].value.pos, map[rect.right + 2][y].value.pos, map[rect.right + 1][y].value.pos):id()] then
                                local newLink = posLink:new(map[rect.right][y].value.pos, map[rect.right + 2][y].value.pos, map[rect.right + 1][y].value.pos)
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        elseif x == rect.left then
                            if map[rect.left - 1][y]:getValue().cellType == cellType.PATH then map[rect.left][y]:removeNode()
                                local wallPoint = map[rect.left][y]:getValue()
                                wallPoint.cellType = cellType.WALL
                                exportMap[rect.left][y] = cellType.WALL
                                pointsAssigned[wallPoint.pos:id()] = wallPoint
                                local newLink = posLink:new(map[rect.left + 1][y].value.pos, map[rect.left - 1][y].value.pos, map[rect.left][y].value.pos)
                                if not bordersAlready[newLink:id()] then
                                    bordersAlready[newLink:id()] = true
                                    borders:addFirst(newLink)
                                end
                            elseif map[rect.left - 1][y]:getValue().cellType ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(map[rect.left][y].value.pos, map[rect.left - 2][y].value.pos, map[rect.left - 1][y].value.pos):id()] then
                                local newLink = posLink:new(map[rect.left][y].value.pos, map[rect.left - 2][y].value.pos, map[rect.left - 1][y].value.pos)
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        end
                        if y == rect.top then
                            if map[x][rect.top + 1]:getValue().cellType == cellType.PATH then map[x][rect.top]:removeNode()
                                local wallPoint = map[x][rect.top]:getValue()
                                wallPoint.cellType = cellType.WALL
                                exportMap[x][rect.top] = cellType.WALL
                                pointsAssigned[wallPoint.pos:id()] = wallPoint
                                local newLink = posLink:new(map[x][rect.top - 1].value.pos, map[x][rect.top + 1].value.pos, map[x][rect.top].value.pos)
                                if not bordersAlready[newLink:id()] then
                                    bordersAlready[newLink:id()] = true
                                    borders:addFirst(newLink)
                                end
                            elseif map[x][rect.top + 1]:getValue().cellType ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(map[x][rect.top].value.pos, map[x][rect.top + 2].value.pos, map[x][rect.top + 1].value.pos):id()] then
                                local newLink = posLink:new(map[x][rect.top].value.pos, map[x][rect.top + 2].value.pos, map[x][rect.top + 1].value.pos)
                                bordersAlready[newLink:id()] = true
                                borders:addFirst(newLink)
                            end
                        elseif y == rect.bottom then
                            if map[x][rect.bottom - 1]:getValue().cellType == cellType.PATH then map[x][rect.bottom]:removeNode()
                                local wallPoint = map[x][rect.bottom]:getValue()
                                wallPoint.cellType = cellType.WALL
                                exportMap[x][rect.bottom] = cellType.WALL
                                pointsAssigned[wallPoint.pos:id()] = wallPoint
                                local newLink = posLink:new(map[x][rect.bottom + 1].value.pos, map[x][rect.bottom - 1].value.pos, map[x][rect.bottom].value.pos)
                                if not bordersAlready[newLink:id()] then
                                    bordersAlready[newLink:id()] = true
                                    borders:addFirst(newLink)
                                end
                            elseif map[x][rect.bottom - 1]:getValue().cellType ~= cellType.LEVEL_BOARDER and not bordersAlready[posLink:new(map[x][rect.bottom].value.pos, map[x][rect.bottom - 2].value.pos, map[x][rect.bottom - 1].value.pos):id()] then
                                local newLink = posLink:new(map[x][rect.bottom].value.pos, map[x][rect.bottom - 2].value.pos, map[x][rect.bottom - 1].value.pos)
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
            local borderOne = map[borderLink.posOne.x][borderLink.posOne.y]
            local borderTwo = map[borderLink.posTwo.x][borderLink.posTwo.y]
            if borderOne.value.cellType == cellType.PATH and borderTwo.value.cellType == cellType.PATH and borderOne:getTopParent() ~= borderTwo:getTopParent() then
                map[borderLink.linkPos.x][borderLink.linkPos.y].value.cellType = cellType.PATH
                exportMap[borderLink.linkPos.x][borderLink.linkPos.y] = cellType.PATH
                borderOne:graft(borderTwo)
            end
        end

        local nMapper = {
            map = exportMap
        }

        setmetatable(nMapper, self)

        return nMapper
    end

}

Mapper.__index = Mapper

return Mapper
