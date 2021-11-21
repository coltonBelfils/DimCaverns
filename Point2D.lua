--[[local Pos = {}
local PosProto = {}

function Pos:new(x, y)
    -- Private
    local _x = x
    local _y = y

    -- Public
    local nPos = {}

    function nPos:getX()
        return _x
    end

    function nPos:setX(value)
        _x = value
    end

    function nPos:getY()
        return _y
    end

    function nPos:setY(value)
        _y = value
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

return Pos]] 

local Point2D = {} -- (I think) This is what all the datatypes should look like. Point2D() (or the __call() Point2D metamethod) has only what it truely needs to be that type. All other functions live in the Point2D table. There is no, or very little encapsulation.

function Point2D.equal(p1, p2)
    return p1.x == p2.x and p1.y == p2.y
end

function Point2D.id(point)
    return point.x .. "-" .. point.y
end

setmetatable(Point2D, {
    __call = function(self, x, y)
        local nPoint2D = {
            x = x or 0,
            y = y or 0,
        }

        setmetatable(nPoint2D, {
            __tostring = function(self)
                return "(" .. self.x .. "," .. self.y .. ")"
            end,
            __eq = Point2D.equal,
            __metatable = "Point2D",
        })

        return nPoint2D
    end,
})

return Point2D
