local Pos = {}
local PosProto = {}

function Pos:new(x, y)
    -- Private
    local x = x
    local y = y

    -- Public
    local nPos = {}

    function nPos:getX()
        return x
    end

    function nPos:setX(value)
        x = value
    end

    function nPos:getY()
        return y
    end

    function nPos:setY(value)
        y = value
    end

    setmetatable(nPos, PosProto)

    return nPos
end

PosProto.__index = PosProto

function PosProto:id()
    return "" .. self:getX() .. "-" .. self:getY()
end

function PosProto:__tostring()
    return "(" .. self:getX() .. "," .. self:getY() .. ")"
end

function PosProto.__eq(p1, p2)
    return p1:getX() == p2:getX() and p1:getY() == p2:getY()
end

return Pos
