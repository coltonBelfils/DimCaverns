--[[local LinkedList = {}
local LinkedListProto = {}

function LinkedList:new()
    -- Private
    local size = 0
    local onHand = {} -- holds nodes that the user may need for soon to save time. May need to make this less agressive in saving nodes if memory is a concern, idk.
    local head = {}
    local tail = {
        prev = head
    }
    head.next = tail

    -- Public
    local nLL = {}

    function nLL:getSize()
        if head.next == tail then
            size = 0
        end
        return size
    end

    function nLL:addFirst(value)
        local first = head.next
        head.next = {
            value = value,
            next = first,
            prev = head
        }
        first.prev = head.next
        onHand = {}
        size = size + 1
    end

    function nLL:addLast(value)
        local last = tail.prev
        tail.prev = {
            value = value,
            next = tail,
            prev = last
        }
        last.next = tail.prev
        size = size + 1
    end

    function nLL:addIndex(value, index) -- inserts after the spesified index. Index 0 is addFirst. Index size is addLast
        assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
        assert(index >= 0 and index <= size, "Invalid Linked List index: " .. index)
        local cur = head
        for i = 0, index, 1 do
            cur = cur.next
        end
        local prev = cur.prev
        local next = cur
        prev.next = {
            value = value,
            next = next,
            prev = prev
        }
        next.prev = prev.next
        onHand = {}
        size = size + 1
    end

    function nLL:removeFirst()
        assert(size > 0, "No Linked List items to remove")
        local value = head.next.value
        head.next = head.next.next
        head.next.prev = head
        onHand = {}
        size = size - 1
        return value
    end

    function nLL:removeLast()
        assert(size > 0, "No Linked List items to remove")
        local value = tail.prev.value
        tail.prev = tail.prev.prev
        tail.prev.next = tail
        onHand[size] = nil
        size = size - 1
        return value
    end

    function nLL:removeIndex(index)
        assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
        assert(index > 0 and index <= size, "Invalid Linked List index: " .. index)
        local cur = head -- check on-hand table before going through the for loop
        for i = 1, index, 1 do
            cur = cur.next
        end
        cur.prev.next = cur.next
        cur.next.prev = cur.prev
        size = size - 1
        return cur.value
    end

    function nLL:get(index)
        assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
        assert(index > 0 and index <= size, "Invalid Linked List index: " .. index)
        -- check on-hand table before traversing to that index
        if onHand[index] ~= nil then
            if index > 1 then
                onHand[index - 1] = onHand[index].prev
            end
            if index < size then
                onHand[index + 1] = onHand[index].next
            end
            return onHand[index].value
        else
            local cur = head
            for i = 1, index, 1 do -- TODO should treverse backwards if the number is greater than half of the size
                cur = cur.next
                onHand[i] = cur
                if i > 1 then
                    onHand[i - 1] = cur.prev
                end
                if i < size then
                    onHand[i + 1] = cur.next
                end
            end
            return cur.value
        end
    end

    nLL.push = nLL.addFirst
    nLL.enqueue = nLL.addFirst
    nLL.pop = nLL.removeFirst
    nLL.dequeue = nLL.removeLast

    setmetatable(nLL, LinkedListProto)

    return nLL
end

LinkedListProto.__index = LinkedListProto
function LinkedListProto:__tostring()
    return "toString not currently supported"
end

function LinkedListProto:printList()
    for i = 1, self:getSize(), 1 do
        print(tostring(self:get(i)))
    end
end

function LinkedListProto:peek(depth)
    local index = (depth or 0) + 1
    return self:get(index)
end

return LinkedList]] 

local LinkedList = {}

function LinkedList.addFirst(list, value)
    local first = list.head.next
    list.head.next = {
        value = value,
        next = first,
        prev = list.head,
    }
    first.prev = list.head.next
    list.onHand = {}
    list.size = list.size + 1
end

function LinkedList.addLast(list, value)
    local last = list.tail.prev
    list.tail.prev = {
        value = value,
        next = list.tail,
        prev = last,
    }
    last.next = list.tail.prev
    list.onHand[#list] = list.tail.prev
    list.size = list.size + 1
end

function LinkedList.addIndex(list, value, index) -- inserts after the specified index. Index 0 is addFirst. Index size is addLast
    assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
    assert(index >= 0 and index <= #list, "Invalid Linked List index: " .. index)
    local cur = list.head
    for i = 0, index, 1 do
        cur = cur.next
    end
    local prev = cur.prev
    local next = cur
    prev.next = {
        value = value,
        next = next,
        prev = prev,
    }
    next.prev = prev.next
    list.onHand = {}
    list.size = list.size + 1
end

function LinkedList.removeFirst(list)
    assert(#list > 0, "No Linked List items to remove")
    local value = list.head.next.value
    list.head.next = list.head.next.next
    list.head.next.prev = list.head
    list.onHand = {}
    list.size = list.size - 1
    return value
end

function LinkedList.removeLast(list)
    assert(#list > 0, "No Linked List items to remove")
    local value = list.tail.prev.value
    list.tail.prev = list.tail.prev.prev
    list.tail.prev.next = list.tail
    list.onHand[#list] = nil
    list.size = list.size - 1
    return value
end

function LinkedList.removeIndex(list, index)
    assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
    assert(index > 0 and index <= #list, "Invalid Linked List index: " .. index)
    local cur = list.head -- check on-hand table before going through the for loop
    for i = 1, index, 1 do
        cur = cur.next
    end
    cur.prev.next = cur.next
    cur.next.prev = cur.prev
    list.onHand = {}
    list.size = list.size - 1
    return cur.value
end

function LinkedList.get(list, index)
    assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
    assert(index > 0 and index <= #list, "Invalid Linked List index: " .. index)
    if list.onHand[index] ~= nil then -- check on-hand table before traversing to that index
        if index > 1 then
            list.onHand[index - 1] = list.onHand[index].prev
        end
        if index < #list then
            list.onHand[index + 1] = list.onHand[index].next
        end
        return list.onHand[index].value
    else
        local cur = list.head
        for i = 1, index, 1 do -- TODO should traverse backwards if the number is greater than half of the size
            cur = cur.next
            list.onHand[i] = cur
            if i > 1 then
                list.onHand[i - 1] = cur.prev
            end
            if i < #list then
                list.onHand[i + 1] = cur.next
            end
        end
        return cur.value
    end
end

function LinkedList.printList(list)
    for i = 1, #list, 1 do
        print(tostring(LinkedList.get(list, i)))
    end
end

function LinkedList.peek(list, depth)
    local index = (depth or 0) + 1
    return LinkedList.get(list, index)
end

LinkedList.push = LinkedList.addFirst
LinkedList.enqueue = LinkedList.addFirst
LinkedList.pop = LinkedList.removeFirst
LinkedList.dequeue = LinkedList.removeLast

setmetatable(LinkedList, {
    __call = function(self)
        local nLL = {
            onHand = {},
            size = 0,
            head = {},
        }
        nLL.tail = {
            prev = nLL.head,
        }
        nLL.head.next = nLL.tail

        setmetatable(nLL, {
            __tostring = function(self)
                return "tostring not currently supported for Linkedlist"
            end,
            __len = function(self)
                return nLL.size
            end,
            __metatable = "LinkedList",
        })

        return  nLL
    end,
})

return LinkedList
