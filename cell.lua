--local cellType = require("CellType")

local Cell = {}

function Cell:new(cellType, pos)
    local nCell = {}

    nCell.cellType = cellType -- TODO Cell and CellType need to be merged
    nCell.pos = pos

    setmetatable(nCell, self)

    return nCell
end

Cell.__index = Cell
function Cell:__tostring()
    return tostring(self.cellType)
end

return Cell
