--local cellType = require("CellType")

local Cell = {}
local CellProto = {}

function Cell:new(cellType, pos)
    -- Private
    local cellType = cellType -- TODO Cell and CellType need to be merged
    local pos = pos

    -- Public
    local nCell = {}

    function nCell:getCellType()
        return cellType
    end

    function nCell:setCellType(cellType)
        cellType = cellType
    end

    function nCell:getPos()
        return pos
    end

    setmetatable(nCell, CellProto)

    return nCell
end

CellProto.__index = CellProto
function CellProto:__tostring()
    return tostring(self:getPos() .. " - " .. self:getCellType())
end

return Cell
