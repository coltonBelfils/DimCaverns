local AnimationOffset = {}

function AnimationOffset:new()
    local nOffset = {}

    nOffset.x = 0
    nOffset.y = 0

    setmetatable(nOffset, self)

    return nOffset
end

AnimationOffset.__index = AnimationOffset
function AnimationOffset:__tostring()
    return "x:" .. self.x .. "-y:" .. self.y
end

return AnimationOffset