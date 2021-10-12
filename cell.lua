local cellType = require("CellType")

local Cell = {
    new = function(self, cellType, pos)
        local nCell = {}

        nCell.cellType = cellType
        nCell.pos = pos

        setmetatable(nCell, self)

        return nCell
    end
}

Cell.__index = Cell
Cell.__tostring = function(self)
    return tostring(self.cellType)
end

return Cell
