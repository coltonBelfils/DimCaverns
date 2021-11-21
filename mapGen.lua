local Cell = require("Cell")
local CellType = require("cellType")
local P2d = require("Point2D")
local Tree = require("tree")
local LL = require("linkedList")
local P2dL = require("Point2DLink")

local Mapper = {} -- A glorified version of Kruskal's Algorithm the cells in the maze aren't all uniform squares.

function Mapper.generate(mapSize, maxRoomSize)
    local constructionMap = {} -- a 2D array of trees. The tree values are cells.
    local exportMap = {} -- a 2D array of cellTypes.

    local pointsAssigned = {}
    local points = LL() -- a LL of all points that is flattened instead of in a 2D map
    local borders = LL() -- LL which contains the border cells of all p2dsible borders
    local bordersAlready = {} -- Hashtable that keeps track of which borders have already been added so you don't have to treverse the borders LL to find out

    for x = 1, mapSize, 1 do -- (0,0) is the bottom left
        constructionMap[x] = {}
        exportMap[x] = {}
        for y = 1, mapSize, 1 do
            if x == 1 or x == mapSize or y == 1 or y == mapSize then
                local newCell = Cell(CellType.LEVEL_BOARDER, P2d(x, y))
                constructionMap[x][y] = Tree(newCell)
                exportMap[x][y] = CellType.LEVEL_BOARDER
                pointsAssigned[P2d.id(newCell.point)] = constructionMap[x][y]
            else
                local newCell = Cell(CellType.PATH, P2d(x, y))
                constructionMap[x][y] = Tree(newCell)
                exportMap[x][y] = CellType.PATH
                LL.addLast(points, constructionMap[x][y])
            end
        end
    end
    print(points.size)

    -- This while loop is what creates all the rooms. 
    while points.size > 0 do -- This while loop could probably be optimized a little (a lot).
        local index = math.random(points.size)
        local cellTree = LL.removeIndex(points, index) -- get the starting point for the room
        local cellPoint = cellTree.value.point
        if pointsAssigned[P2d.id(cellPoint)] == nil then -- check if that point is available
            pointsAssigned[P2d.id(cellPoint)] = cellPoint -- make that point unavailable for the future
            local xDist = math.random(3, maxRoomSize)
            local yDist = math.random(3, maxRoomSize)
            local rect = {
                top = cellPoint.y,
                bottom = cellPoint.y,
                left = cellPoint.x,
                right = cellPoint.x,
            }
            local xPacked = false
            local yPacked = false
            while xPacked == false and xDist > 0 do -- expand in the x direction up to xDist if posible
                if pointsAssigned[P2d.id(P2d(rect.right + 1, rect.top))] == nil then
                    rect.right = rect.right + 1
                    local newPoint = constructionMap[rect.right][rect.top]
                    pointsAssigned[P2d.id(newPoint.value.point)] = newPoint
                    Tree.graft(cellTree, newPoint)
                    xDist = xDist - 1
                elseif pointsAssigned[P2d.id(P2d(rect.left - 1, rect.top))] == nil then
                    rect.left = rect.left - 1
                    local newPoint = constructionMap[rect.left][rect.top]
                    pointsAssigned[P2d.id(newPoint.value.point)] = newPoint
                    Tree.graft(cellTree, newPoint)
                    xDist = xDist - 1
                else
                    xPacked = true
                end
            end
            while yPacked == false and yDist > 0 do -- expand in the y direction up to ydist if posible
                local topCellsClear = true
                for i = rect.left, rect.right, 1 do
                    if pointsAssigned[P2d.id(P2d(i, rect.top + 1))] ~= nil then
                        topCellsClear = false
                    end
                end
                if topCellsClear then
                    rect.top = rect.top + 1
                    for i = rect.left, rect.right, 1 do
                        local newPoint = constructionMap[i][rect.top]
                        pointsAssigned[P2d.id(newPoint.value.point)] = newPoint
                        Tree.graft(cellTree, newPoint)
                    end
                    yDist = yDist - 1
                else
                    local bottomCellsClear = true
                    for i = rect.left, rect.right, 1 do
                        if pointsAssigned[P2d.id(P2d(i, rect.bottom - 1))] ~= nil then
                            bottomCellsClear = false
                        end
                    end
                    if bottomCellsClear then
                        rect.bottom = rect.bottom - 1
                        for i = rect.left, rect.right, 1 do
                            local newPoint = constructionMap[i][rect.bottom]
                            pointsAssigned[P2d.id(newPoint.value.point)] = newPoint
                            Tree.graft(cellTree, newPoint)
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
                        if constructionMap[rect.right + 1][y].value.cellType == CellType.PATH then
                            Tree.removeNode(constructionMap[rect.right][y])
                            local wallPoint = constructionMap[rect.right][y].value
                            wallPoint.cellType = CellType.WALL
                            exportMap[rect.right][y] = CellType.WALL
                            pointsAssigned[P2d.id(wallPoint.point)] = wallPoint
                            local newLink = P2dL(constructionMap[rect.right - 1][y].value.point, constructionMap[rect.right + 1][y].value.point, constructionMap[rect.right][y].value.point)
                            if not bordersAlready[P2dL.id(newLink)] then
                                bordersAlready[P2dL.id(newLink)] = true
                                LL.addFirst(borders, newLink)
                            end
                        elseif constructionMap[rect.right + 1][y].value.cellType ~= CellType.LEVEL_BOARDER and not bordersAlready[P2dL.id(P2dL(constructionMap[rect.right][y].value.point, constructionMap[rect.right + 2][y].value.point, constructionMap[rect.right + 1][y].value.point))] then
                            local newLink = P2dL(constructionMap[rect.right][y].value.point, constructionMap[rect.right + 2][y].value.point, constructionMap[rect.right + 1][y].value.point)
                            bordersAlready[P2dL.id(newLink)] = true
                            LL.addFirst(borders, newLink)
                        end
                    elseif x == rect.left then
                        if constructionMap[rect.left - 1][y].value.cellType == CellType.PATH then
                            Tree.removeNode(constructionMap[rect.left][y])
                            local wallPoint = constructionMap[rect.left][y].value
                            wallPoint.cellType = CellType.WALL
                            exportMap[rect.left][y] = CellType.WALL
                            pointsAssigned[P2d.id(wallPoint.point)] = wallPoint
                            local newLink = P2dL(constructionMap[rect.left + 1][y].value.point, constructionMap[rect.left - 1][y].value.point, constructionMap[rect.left][y].value.point)
                            if not bordersAlready[P2dL.id(newLink)] then
                                bordersAlready[P2dL.id(newLink)] = true
                                LL.addFirst(borders, newLink)
                            end
                        elseif constructionMap[rect.left - 1][y].value.cellType ~= CellType.LEVEL_BOARDER and not bordersAlready[P2dL.id(P2dL(constructionMap[rect.left][y].value.point, constructionMap[rect.left - 2][y].value.point, constructionMap[rect.left - 1][y].value.point))] then
                            local newLink = P2dL(constructionMap[rect.left][y].value.point, constructionMap[rect.left - 2][y].value.point, constructionMap[rect.left - 1][y].value.point)
                            bordersAlready[P2dL.id(newLink)] = true
                            LL.addFirst(borders, newLink)
                        end
                    end
                    if y == rect.top then
                        if constructionMap[x][rect.top + 1].value.cellType == CellType.PATH then
                            Tree.removeNode(constructionMap[x][rect.top])
                            local wallPoint = constructionMap[x][rect.top].value
                            wallPoint.cellType = CellType.WALL
                            exportMap[x][rect.top] = CellType.WALL
                            pointsAssigned[P2d.id(wallPoint.point)] = wallPoint
                            local newLink = P2dL(constructionMap[x][rect.top - 1].value.point, constructionMap[x][rect.top + 1].value.point, constructionMap[x][rect.top].value.point)
                            if not bordersAlready[P2dL.id(newLink)] then
                                bordersAlready[P2dL.id(newLink)] = true
                                LL.addFirst(borders, newLink)
                            end
                        elseif constructionMap[x][rect.top + 1].value.cellType ~= CellType.LEVEL_BOARDER and not bordersAlready[P2dL.id(P2dL(constructionMap[x][rect.top].value.point, constructionMap[x][rect.top + 2].value.point, constructionMap[x][rect.top + 1].value.point))] then
                            local newLink = P2dL(constructionMap[x][rect.top].value.point, constructionMap[x][rect.top + 2].value.point, constructionMap[x][rect.top + 1].value.point)
                            bordersAlready[P2dL.id(newLink)] = true
                            LL.addFirst(borders, newLink)
                        end
                    elseif y == rect.bottom then
                        if constructionMap[x][rect.bottom - 1].value.cellType == CellType.PATH then
                            Tree.removeNode(constructionMap[x][rect.bottom])
                            local wallPoint = constructionMap[x][rect.bottom].value
                            wallPoint.cellType = CellType.WALL
                            exportMap[x][rect.bottom] = CellType.WALL
                            pointsAssigned[P2d.id(wallPoint.point)] = wallPoint
                            local newLink = P2dL(constructionMap[x][rect.bottom + 1].value.point, constructionMap[x][rect.bottom - 1].value.point, constructionMap[x][rect.bottom].value.point)
                            if not bordersAlready[P2dL.id(newLink)] then
                                bordersAlready[P2dL.id(newLink)] = true
                                LL.addFirst(borders, newLink)
                            end
                        elseif constructionMap[x][rect.bottom - 1].value.cellType ~= CellType.LEVEL_BOARDER and not bordersAlready[P2dL.id(P2dL(constructionMap[x][rect.bottom].value.point, constructionMap[x][rect.bottom - 2].value.point, constructionMap[x][rect.bottom - 1].value.point))] then
                            local newLink = P2dL(constructionMap[x][rect.bottom].value.point, constructionMap[x][rect.bottom - 2].value.point, constructionMap[x][rect.bottom - 1].value.point)
                            bordersAlready[P2dL.id(newLink)] = true
                            LL.addFirst(borders, newLink)
                        end
                    end
                end
            end
        end
    end

    -- This while loop connects all the rooms so there is only one path from one room to another
    while borders.size > 0 do
        local index = math.random(borders.size)
        local borderLink = LL.removeIndex(borders, index)
        local borderOne = constructionMap[borderLink.pointOne.x][borderLink.pointOne.y]
        local borderTwo = constructionMap[borderLink.pointTwo.x][borderLink.pointTwo.y]
        if borderOne.value.cellType == CellType.PATH and borderTwo.value.cellType == CellType.PATH and Tree.getTopParent(borderOne) ~= Tree.getTopParent(borderTwo) then
            constructionMap[borderLink.linkPoint.x][borderLink.linkPoint.y].value.cellType = CellType.PATH
            exportMap[borderLink.linkPoint.x][borderLink.linkPoint.y] = CellType.PATH
            Tree.graft(borderOne, borderTwo)
        end
    end

    return exportMap -- This file is a mess, enjoy cleaning it up :| Make the mapper type more functional instead of just table with one function in it type thing.
end

Mapper.__index = Mapper

return Mapper
