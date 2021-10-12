local AnimationOffset = {
    new = function(self)
        local nOffset = {}

        nOffset.x = 0
        nOffset.y = 0

        setmetatable(nOffset, self)

        return nOffset
    end,
}

AnimationOffset.__index = AnimationOffset
AnimationOffset.__tostring = function(self)
    return "x:" .. self.x .. "-y:" .. self.y
end

return AnimationOffset