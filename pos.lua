local Pos = {}
local PosPrototype = {}

function Pos:new(x, y)
    local private = {
        x = x,
        y = y
    }

    local public = {}

    function public:getX()
        return private.x
    end

    function public:setX(value)
        private.x = value
    end

    function public:getY()
        return private.y
    end

    function public:setY(value)
        private.y = value
    end

    setmetatable(public, PosPrototype)

    return public
end

PosPrototype.__index = PosPrototype

function PosPrototype:id()
    return "" .. self:getX() .. "-" .. self:getY()
end

function PosPrototype:__tostring()
    return "(" .. self:getX() .. "," .. self:getY() .. ")"
end

function PosPrototype.__eq(p1, p2)
    return p1:getX() == p2:getX() and p1:getY() == p2:getY()
end

return Pos
