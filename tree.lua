local linkedList = require("linkedList")

local Tree = {}

function Tree:new(value)
    local nTree = {}

    nTree.value = value
    nTree.children = linkedList:new()
    nTree.parent = nil

    setmetatable(nTree, self)

    return nTree
end

Tree.__index = Tree
function Tree:__tostring()
    return "Value: " .. tostring(self.value) .. ", Parent: [ " .. tostring(self.parent) .. " ] "
end

function Tree:getValue()
    return self.value
end

function Tree:getParent()
    return self.parent
end

function Tree:getParentValue()
    return self.parent.value
end

function Tree.getTopParent()
    assert(self ~= nil, "self is nil")
    local top = self
    while top.parent ~= nil do
        top = top.parent
    end
    return top
end

function Tree.getChildren()
    local childArray = {}
    for i = 1, self.children:getSize(), 1 do
        table.insert(childArray, self.children:get(i))
    end
    return childArray
end

function Tree.getChildValues()
    local childArray = {}
    for i = 1, self.children:getSize(), 1 do
        table.insert(childArray, self.children:get(i).value)
    end
    return childArray
end

function Tree.graft(childTree)
    local newChild = childTree:getTopParent()
    newChild.parent = self
    self.children:addLast(newChild)
end

function Tree.removeBranch()
    assert(self.parent ~= nil, "tree.detach(): Tree does not have a parent to detach from.")
    for i = 1, self.parent.children:getSize(), 1 do
        if self.parent.children:get(i) == self then
            self.parent.children:removeIndex(i)
            break
        end
    end
    self.parent = nil
end

function Tree.removeNode()
    if self.parent ~= nil then
        while self.children:getSize() > 0 do
            local move = self.children:removeFirst()
            move.parent = self.parent
            self.parent.children:addLast(move)
        end
    elseif self.children:getSize() > 0 then
        local newParent = self.children:removeFirst()
        while self.children:getSize() > 0 do
            local move = self.children:removeFirst()
            move.parent = newParent
            newParent.children:addLast(move)
        end
    end
end

function Tree.printTree() -- prints layers of the tree not connections
    self:getTopParent():printTreeHelp(1)
end

function Tree.printTreeHelp(layerNum)
    if self.children:getSize() > 0 then
        print(tostring(self.value.pos) .. " -> " .. "(" .. layerNum .. "){")
        for i = 1, self.children:getSize(), 1 do
            self.children:get(i):printTreeHelp(layerNum + 1)
        end
        print("}(" .. layerNum .. ")\n")
    else
        print(tostring(self.value.pos) .. " -> " .. "botttom of tree\n")
    end
end

return Tree
