local Pos = {}

function Pos:new(x, y)
    local nPos = {}

    nPos.x = x
    nPos.y = y

    setmetatable(nPos, self)

    return nPos
end

function Pos:id()
    return "" .. self.x .. "-" .. self.y
end
Pos.__index = Pos
function Pos:__tostring()
    return "(" .. self.x .. "," .. self.y .. ")"
end

return Pos