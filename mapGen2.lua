local Cell = require("Cell")
local CellType = require("cellType")
local P2d = require("Point2D")
local Tree = require("tree")
local LL = require("linkedList")
local P2dL = require("Point2DLink")

 -- A glorified version of Kruskal's Algorithm the cells in the maze aren't all uniform squares.

local function generaateMap(mapSize, maxRoomSize)
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

    -- Rewriting the function here and breaaking it out into mulitiple functions. This function is the main one and it will call other functions inside of it.
end

return generaateMap
