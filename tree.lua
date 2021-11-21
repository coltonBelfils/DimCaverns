local ll = require("LinkedList")

--[[local Tree = {}
local TreeProto = {}

function Tree:new(value)
    -- Private
    local _value = value
    local _children = linkedList:new()
    local _childArray = {}
    local _childArrayChanged = false
    local _parent = nil

    -- Public
    local nTree = {}

    function nTree:getValue()
        return _value
    end

    function nTree:setValue(value)
        _value = value
    end

    function nTree:getParent()
        return _parent
    end

    function nTree:getChildren()
        if not _childArrayChanged then
            return _childArray
        end
        _childArray = {}
        for i = 1, _children:getSize(), 1 do
            table.insert(_childArray, _children:get(i))
        end
        return _childArray
    end

    function nTree:graft(childTree)
        local newChild = childTree:getTopParent()
        newChild.parent = self
        _children:addLast(newChild)
    end

    function TreeProto:removeBranch()
        assert(_parent ~= nil, "tree.removeBranch(): Tree does not have a parent to detach from.")
        for i = 1, _parent.children:getSize(), 1 do
            if _parent.children:get(i) == self then
                _parent.children:removeIndex(i)
                break
            end
        end
        _parent = nil
    end

    function TreeProto:removeNode()
        if _parent ~= nil then
            while _children:getSize() > 0 do
                local move = _children:removeFirst()
                move.parent = _parent
                _parent.children:addLast(move)
            end
        elseif _children:getSize() > 0 then
            local newParent = _children:removeFirst()
            while _children:getSize() > 0 do
                local move = _children:removeFirst()
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

function TreeProto:getChildValues()
    local childArray = {}
    for i = 1, self.children:getSize(), 1 do
        table.insert(childArray, self.children:get(i).value)
    end
    return childArray
end -- This doesn't seem to be used, and is kinda redundant, so I took it out, but it's here if necessary

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

return Tree]]

local Tree = {}

function Tree.graft(tree, childTree)
    local newChild = Tree.getTopParent(childTree)
    newChild.parent = tree
    ll.addLast(tree.children, newChild)
end

function Tree.removeBranch(tree)
    assert(tree.parent ~= nil, "tree.removeBranch(): Tree does not have a parent to detach from.")
    for i = 1, tree.parent.children.size, 1 do
        if ll.get(tree.parent.children, i) == tree then
            ll.removeIndex(tree.parent.children, i)
            break
        end
    end
    tree.parent = nil
end

function Tree.removeNode(tree)
    if tree.parent ~= nil then
        while tree.children.size > 0 do
            local move = ll.removeFirst(tree.children)
            move.parent = tree.parent
            ll.addLast(tree.parent.children, move)
        end
    elseif tree.children.size > 0 then
        local newParent = ll.removeFirst(tree.children)
        while tree.children.size > 0 do
            local move = ll.removeFirst(tree.children)
            move.parent = newParent
            ll.addLast(newParent.children, move)
        end
    end
end

function Tree.getTopParent(tree)
    assert(tree ~= nil, "self is nil")
    local top = tree
    while top.parent ~= nil do
        top = top.parent
    end
    return top
end

function Tree.printTree(tree) -- prints layers of the tree not connections
    tree.getTopParent(tree).printTreeHelp(1)
end

local function printTreeHelp(tree, layerNum)
    if tree.children.size > 0 then
        print(tostring(tree.value) .. " -> " .. "(" .. layerNum .. "){")
        for i = 1, tree.children.size, 1 do
            printTreeHelp(ll.get(tree.children,i), layerNum + 1)
        end
        print("}(" .. layerNum .. ")\n")
    else
        print(tostring(tree.value) .. " -> " .. "botttom of tree\n")
    end
end

setmetatable(Tree, {
    __call = function(self, value)
        local nTree = {
            value = value,
            children = ll(),
            childArray = {},
            childArrayChanged = false,
            parent = nil,
        }

        setmetatable(nTree, {
            __tostring = function(self)
                return "Value: " .. tostring(self.value) .. ", Parent: [ " .. tostring(self.parent) .. " ] "
            end,
            __metatable = "Tree",
        })

        return nTree
    end,
})

return Tree