local PosLink = {
    new = function(self, pos, otherPos, linkPos)
        local nLink = {}

        if pos.x > otherPos.x then
            assert(pos.x - 2 == otherPos.x and pos.x - 1 == linkPos.x, "Invalid Link")
            nLink.posOne = pos
            nLink.posTwo = otherPos
        elseif pos.x == otherPos.x and pos.y > otherPos.y then
            assert(pos.y - 2 == otherPos.y and pos.y- 1 == linkPos.y, "Invalid Link")
            nLink.posOne = pos
            nLink.posTwo = otherPos
        else
            assert((pos.x + 2 == otherPos.x and pos.x + 1 == linkPos.x) or (pos.y + 2 == otherPos.y and pos.y + 1 == linkPos.y), "Invalid Link")
            nLink.posOne = otherPos
            nLink.posTwo = pos
        end

        nLink.linkPos = linkPos

        setmetatable(nLink, self)

        return nLink
    end
}

PosLink.__index = PosLink
PosLink.__tostring = function(self)
    return ">" .. tostring(self.posOne) .. "-" .. tostring(self.linkPos) .. "-" .. tostring(self.posTwo) .. "<"
end

PosLink.id = function(self)
    return "1:" .. self.posOne.x .. self.posOne.y .. "-link:" .. self.linkPos.x .. self.linkPos.y .. "-2:" .. self.posTwo.x .. self.posTwo.y
end

return PosLink
