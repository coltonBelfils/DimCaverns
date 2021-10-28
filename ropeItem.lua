local cellType = require("cellType")
local linkedList = require("linkedList")

local RopeItem = {}

function RopeItem:new(map) -- the rope class works more now but is still bad. I think this item is getting killed :/
    local nRope = {}

    nRope.map = map
    nRope.ropeStack = linkedList:new()
    nRope.crossPathHistory = {} -- this is partially done but not finished.

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
    print("equiped: " .. tostring(playerAt) .. " size: " .. tostring(self.ropeStack:getSize()))
end

function RopeItem:unequip(playerAt)
    print("unequiped:" .. tostring(playerAt) .. " size: " .. tostring(self.ropeStack:getSize()))
    self.equiped = false
end

function RopeItem:movedTo(playerAt)
    if not self.equiped then
        return
    end

    if self.ropeStack:getSize() > 1 and self.ropeStack:peek(1):id() == playerAt:id() then
        local top = self.ropeStack:pop()
        self.crossPathHistory[top] = self.crossPathHistory[top] - 1
        if not self.crossPathHistory[top] then -- if the Pos I'm moving away from is not in the histroy anymore (self.crossPathHistory[top] == 0) make it a path
            self.map[top.x][top.y] = cellType.PATH
        end
    else
        self.map[playerAt.x][playerAt.y] = cellType.ROPE_PATH
        self.ropeStack:push(playerAt)
        self.crossPathHistory[playerAt] = self.crossPathHistory[playerAt] + 1
    end
    local pre = self.ropeStack:peek(1)
    self.map[playerAt.x][playerAt.y] = cellType.ROPE_PATH_PREVIOUS
    print("moved to:" .. tostring(playerAt) .. " size: " .. tostring(self.ropeStack:getSize()))
end

RopeItem.__index = RopeItem
function RopeItem:__tostring()
    return "Item: Rope. Length: " .. self.length
end

return RopeItem
