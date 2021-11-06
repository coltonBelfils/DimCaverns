--local cellType = require("CellType")

local Cell = {}
local CellProto = {}

function Cell:new(cellType, pos)
    -- Private
    local _cellType = cellType -- TODO Cell and CellType need to be merged
    local _pos = pos

    -- Public
    local nCell = {}

    function nCell:getCellType()
        return _cellType
    end

    function nCell:setCellType(cellType)
        _cellType = cellType
    end

    function nCell:getPos()
        return _pos
    end

    setmetatable(nCell, CellProto)

    return nCell
end

CellProto.__index = CellProto
function CellProto:__tostring()
    return tostring(self:getPos() .. " - " .. self:getCellType())
end

return Cell
