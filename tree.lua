local linkedList = require("linkedList")

local Tree = {}
local TreeProto = {}

function Tree:new(value)
    -- Private
    local value = value
    local children = linkedList:new()
    local childArray = {}
    local childArrayChanged = false
    local parent = nil

    -- Public
    local nTree = {}

    function nTree:getValue()
        return value
    end

    function nTree:setValue(value)
        value = value
    end

    function nTree:getParent()
        return parent
    end

    function nTree:getChildren()
        if not childArrayChanged then return childArray end
        childArray = {}
        for i = 1, children:getSize(), 1 do
            table.insert(childArray, children:get(i))
        end
        return childArray
    end

    function nTree:graft(childTree)
        local newChild = childTree:getTopParent()
        newChild.parent = self
        children:addLast(newChild)
    end

    function TreeProto:removeBranch()
        assert(parent ~= nil, "tree.removeBranch(): Tree does not have a parent to detach from.")
        for i = 1, parent.children:getSize(), 1 do
            if parent.children:get(i) == self then
                parent.children:removeIndex(i)
                break
            end
        end
        parent = nil
    end

    function TreeProto:removeNode()
        if parent ~= nil then
            while children:getSize() > 0 do
                local move = children:removeFirst()
                move.parent = parent
                parent.children:addLast(move)
            end
        elseif children:getSize() > 0 then
            local newParent = children:removeFirst()
            while children:getSize() > 0 do
                local move = children:removeFirst()
                move.parent = newParent
                newParent.children:addLast(move)
            end
        end
    end

    setmetatable(nTree, TreeProto)

    return nTree
end

TreeProto.__index = TreeProto
function TreeProto:__tostring()
    return "Value: " .. tostring(self.value) .. ", Parent: [ " .. tostring(self.parent) .. " ] "
end

function TreeProto:getParentValue()
    return self:getParent():getValue()
end

function TreeProto:getTopParent()
    assert(self ~= nil, "self is nil")
    local top = self
    while top:getParent() ~= nil do
        top = top:getParent()
    end
    return top
end

--[[function TreeProto:getChildValues()
    local childArray = {}
    for i = 1, self.children:getSize(), 1 do
        table.insert(childArray, self.children:get(i).value)
    end
    return childArray
end]] -- This doesn't seem to be used, and is kinda redundant, so I took it out, but it's here if necessary

function TreeProto:printTree() -- prints layers of the tree not connections
    self:getTopParent():printTreeHelp(1)
end

function TreeProto:printTreeHelp(layerNum)
    if #self:getChildren() > 0 then
        print(tostring(self:getValue():getPos()) .. " -> " .. "(" .. layerNum .. "){")
        for i = 1, #self:getChildren(), 1 do
            self:getChildren()[i]:printTreeHelp(layerNum + 1)
        end
        print("}(" .. layerNum .. ")\n")
    else
        print(tostring(self:getValue():getPos()) .. " -> " .. "botttom of tree\n")
    end
end

return Tree
