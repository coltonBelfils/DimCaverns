--local cellType = require("CellType")

local Cell = {
    --[[T_PATH = "PATH", -- These are keys for the cellType table which holds things like the sprites, animations, cli character, ... for the type.
    T_WALL = "WALL",
    T_LEVEL_BOARDER = "LEVEL_BOARDER",
    T_PIT = "PIT", -- from here down aren't used yet
    T_DOOR = "DOOR",
    T_BOSS_DOOR = "BOSS_DOOR",
    T_ITEM = "ITEM",
    T_KEY = "KEY",
    T_BOSS_KEY = "BOSS_KEY"]]
}

function Cell:new(cellType, pos)
    local nCell = {}

    nCell.cellType = cellType
    nCell.pos = pos

    setmetatable(nCell, self)

    return nCell
end

Cell.__index = Cell
function Cell:__tostring()
    return tostring(self.cellType)
end

return Cell
