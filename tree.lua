local linkedList = require("linkedList")

local Tree = {
    new = function(self, value)
        local nTree = {}

        nTree.value = value
        nTree.children = linkedList:new()
        nTree.parent = nil

        setmetatable(nTree, self)

        return nTree
    end
}

Tree.__index = Tree
Tree.__tostring = function(self)
    return "Value: " .. tostring(self.value) .. ", Parent: [ " .. tostring(self.parent) .. " ] "
end

Tree.getValue = function(self)
    return self.value
end

Tree.getParent = function(self)
    return self.parent
end

Tree.getParentValue = function(self)
    return self.parent.value
end

Tree.getTopParent = function(self)
    assert(self ~= nil, "self is nil")
    local top = self
    while top.parent ~= nil do
        top = top.parent
    end
    return top
end

Tree.getChildren = function(self)
    local childArray = {}
    for i = 1, self.children:getSize(), 1 do
        table.insert(childArray, self.children:get(i))
    end
    return childArray
end

Tree.getChildValues = function(self)
    local childArray = {}
    for i = 1, self.children:getSize(), 1 do
        table.insert(childArray, self.children:get(i).value)
    end
    return childArray
end

Tree.graft = function(self, childTree)
    local newChild = childTree:getTopParent()
    newChild.parent = self
    self.children:addLast(newChild)
end

Tree.removeBranch = function(self)
    assert(self.parent ~= nil, "tree.detach(): Tree does not have a parent to detach from.")
    for i = 1, self.parent.children:getSize(), 1 do
        if self.parent.children:get(i) == self then
            self.parent.children:removeIndex(i)
            break
        end
    end
    self.parent = nil
end

Tree.removeNode = function(self)
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

Tree.printTree = function(self) -- prints layers of the tree not connections
    self:getTopParent():printTreeHelp(1)
end

Tree.printTreeHelp = function(self, layerNum)
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
