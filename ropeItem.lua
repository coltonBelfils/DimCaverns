local cellType = require("cellType")
local linkedList = require("linkedList")

local RopeItem = {}

function RopeItem:new(map)
    local nRope = {}

    nRope.map = map
    nRope.ropeStack = linkedList:new()

    setmetatable(nRope, self)
    return nRope
end

function RopeItem:equip(playerAt)
    if self.ropeStack:getSize() == 0 then
        self.ropeStack:push(playerAt)
        self.map[playerAt.x][playerAt.y] = cellType.ROPE_PATH
    elseif self.ropeStack:peek():id() ~= playerAt:id() then
        return
    end
    self.equiped = true
end

function RopeItem:unequip(playerAt)
    self.equiped = false
end

function RopeItem:movedTo(playerAt) -- the rope class works more now but is still bad.
    if not self.equiped then
        return
    end

    if self.ropeStack:getSize() > 1 and self.ropeStack:peek(1):id() == playerAt:id() then
        local top = self.ropeStack:pop()
        self.map[top.x][top.y] = cellType.PATH
    else
        self.map[playerAt.x][playerAt.y] = cellType.ROPE_PATH
        self.ropeStack:push(playerAt)
    end
end

RopeItem.__index = RopeItem
function RopeItem:__tostring()
    return "Item: Rope. Length: " .. self.length
end

return RopeItem
