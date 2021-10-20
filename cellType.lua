local CellData = {}
function CellData:new(print, color)
    local nData = {}

    nData.print = print
    nData.color = color

    setmetatable(nData, self)

    return nData
end

local CellType = {-- symbols to make the cli dev map easier to read
    PATH = CellData:new('*', {1,1,1}),
    ROPE_PATH = CellData:new('+', {1, .5, .5}),
    WALL = CellData:new('#', {0, 0, 0}),
    LEVEL_BOARDER = CellData:new('@', {0, 0, 0}),
    PIT = CellData:new('', {}), -- from here down aren't used yet
    DOOR = CellData:new('', {}),
    BOSS_DOOR = CellData:new('', {}),
    ITEM = CellData:new('', {}),
    KEY = CellData:new('', {}),
    BOSS_KEY = CellData:new('', {}),
}

function CellType:__tostring()
    return self.print
end

return CellType-- Make a cell data table/class that has things like sprite info, color, animations, ... for all the cell types and then have cellType hold the key to that table.