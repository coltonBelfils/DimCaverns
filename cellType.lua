local CellData = {} -- This needs to implement the duplicate metatable function and when members of the table are changed it needs to check if it is equal to one of the cellTypes and if so point to that table instead to save on memory.

setmetatable(CellData, {
    __call = function(self, print, color, canMoveTo)
        local nData = {}

        nData.print = print
        nData.color = color
        nData.canMoveTo = canMoveTo or false

        setmetatable(nData, {
            __tostring = function(self)
                return self.print
            end,
            __metatable = "CellData",
        })

        return nData
    end,
})

local CellType =
    { -- These should represent the elemental cellTypes like path, wall, door, …. Things about the cell that are not elemental like if it has a key or a rope on it are not distint cellTypes but custom fields in the cellData table. When a cell needs custom stuff it should duplicate its cellData so that the field isn't applied to the rest of the cells that use that cellData. If a cell that has duplicated its cellData once again becomes identical to its starting cellType it should revert to using that cellType not the duplicate that was made to cut down on memory usage.
        PATH = CellData('*', {1, 1, 1}, true),
        ROPE_PATH = CellData('+', {1, .5, .5}, true),
        ROPE_PATH_PREVIOUS = CellData('x', {1, .4, .4}, true),
        WALL = CellData('#', {0, 0, 0}, false),
        LEVEL_BOARDER = CellData('@', {0, 0, 0}, false),
        PIT = CellData('', {}, true), -- from here down aren't used yet
        DOOR = CellData('', {}, false),
        BOSS_DOOR = CellData('', {}, false),
        ITEM = CellData('', {}, true),
        KEY = CellData('', {}, true),
        BOSS_KEY = CellData('', {}, true),
    }

return CellType -- Make a cell data table/class that has things like sprite info, color, animations, ... for all the cell types and then have cellType hold the key to that table.
