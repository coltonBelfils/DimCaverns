local PosLink = {}
local PosLinkProto = {}

function PosLink:new(pos, otherPos, linkPos)
    assert(pos and otherPos and linkPos, "PosLink:new(), paramiters must be not nil")

    -- Private
    local posOne
    local posTwo
    if pos:getX() > otherPos:getX() then
        assert(pos:getX() - 2 == otherPos:getX() and pos:getX() - 1 == linkPos:getX(), "Invalid Link")
        posOne = pos
        posTwo = otherPos
    elseif pos:getX() == otherPos:getX() and pos:getY() > otherPos:getY() then
        assert(pos:getY() - 2 == otherPos:getY() and pos:getY() - 1 == linkPos:getY(), "Invalid Link")
        posOne = pos
        posTwo = otherPos
    else
        assert((pos:getX() + 2 == otherPos:getX() and pos:getX() + 1 == linkPos:getX()) or (pos:getY() + 2 == otherPos:getY() and pos:getY() + 1 == linkPos:getY()), "Invalid Link")
        posOne = otherPos
        posTwo = pos
    end
    local _linkPos = linkPos

    -- Public
    local nLink = {}

    function nLink:getPosOne()
        return posOne
    end

    function nLink:getPosTwo()
        return posTwo
    end

    function nLink:getLinkPos()
        return _linkPos
    end

    setmetatable(nLink, PosLinkProto)

    return nLink
end

PosLinkProto.__index = PosLinkProto
function PosLinkProto:__tostring()
    return ">" .. tostring(self:getPosOne()) .. "-" .. tostring(self:getLinkPos()) .. "-" .. tostring(self:getPosTwo()) .. "<"
end

function PosLinkProto:id()
    return "1:" .. self:getPosOne():getX() .. self:getPosOne():getY() .. "-link:" .. self:getLinkPos():getX() .. self:getLinkPos():getY() .. "-2:" .. self:getPosTwo():getX() .. self:getPosTwo():getY()
end

return PosLink
