local Pos = {
    new = function(self, x, y)
        local nPos = {}

        nPos.x = x
        nPos.y = y

        setmetatable(nPos, self)

        return nPos
    end,
}

Pos.id = function(self)
    return "" .. self.x .. "-" .. self.y
end
Pos.__index = Pos
Pos.__tostring = function(self)
    return "(" .. self.x .. "," .. self.y .. ")"
end

return Pos