local LinkedList = {}

function LinkedList:new()
    local nLL = {}

    nLL.size = 0
    nLL.onHand = {} -- holds nodes that the user may need for soon to save time. May need to make this less agressive in saving nodes if memory is a concern, idk.
    nLL.head = {}
    nLL.tail = {
        prev = nLL.head
    }
    nLL.head.next = nLL.tail

    setmetatable(nLL, self)

    return nLL
end

LinkedList.__index = LinkedList
function LinkedList:__tostring()
    return ""
end

function LinkedList:getSize()
    if self.head.next == self.tail then
        self.size = 0
    end
    return self.size
end

function LinkedList:addFirst(value)
    local first = self.head.next
    self.head.next = {
        value = value,
        next = first,
        prev = self.head
    }
    first.prev = self.head.next
    self.onHand = {}
    self.size = self.size + 1
end

LinkedList.push = LinkedList.addFirst
LinkedList.enqueue = LinkedList.addFirst

function LinkedList:addLast(value)
    local last = self.tail.prev
    self.tail.prev = {
        value = value,
        next = self.tail,
        prev = last
    }
    last.next = self.tail.prev
    self.size = self.size + 1
end

function LinkedList:addIndex(value, index) -- inserts after the spesified index. Index 0 is addFirst. Index size is addLast
    assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
    assert(index >= 0 and index <= self.size, "Invalid Linked List index: " .. index)
    local cur = self.head
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
    self.onHand = {}
    self.size = self.size + 1
end

function LinkedList:removeFirst()
    assert(self.size > 0, "No Linked List items to remove")
    local value = self.head.next.value
    self.head.next = self.head.next.next
    self.head.next.prev = self.head
    self.onHand = {}
    self.size = self.size - 1
    return value
end

LinkedList.pop = LinkedList.removeFirst

function LinkedList:removeLast()
    assert(self.size > 0, "No Linked List items to remove")
    local value = self.tail.prev.value
    self.tail.prev = self.tail.prev.prev
    self.tail.prev.next = self.tail
    self.onHand[self.size] = nil
    self.size = self.size - 1
    return value
end

LinkedList.dequeue = LinkedList.removeLast

function LinkedList:removeIndex(index)
    assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
    assert(index > 0 and index <= self.size, "Invalid Linked List index: " .. index)
    local cur = self.head -- check on-hand table before going through the for loop
    for i = 1, index, 1 do
        cur = cur.next
    end
    cur.prev.next = cur.next
    cur.next.prev = cur.prev
    self.size = self.size - 1
    return cur.value
end

function LinkedList:get(index)
    assert(type(index) == "number") -- this needs to turn into function decorators and the checks lib
    assert(index > 0 and index <= self.size, "Invalid Linked List index: " .. index)
    -- check on-hand table before traversing to that index
    if self.onHand[index] ~= nil then
        if index > 1 then
            self.onHand[index - 1] = self.onHand[index].prev
        end
        if index < self.size then
            self.onHand[index + 1] = self.onHand[index].next
        end
        return self.onHand[index].value
    else
        local cur = self.head
        for i = 1, index, 1 do -- TODO should treverse backwards if the number is greater than half of the size
            cur = cur.next
            self.onHand[i] = cur
            if i > 1 then
                self.onHand[i - 1] = cur.prev
            end
            if i < self.size then
                self.onHand[i + 1] = cur.next
            end
        end
        return cur.value
    end
end

function LinkedList:peek(depth)
    local index = (depth or 0) + 1
    return self:get(index)
end

function LinkedList:printList()
    local cur = self.head
    for i = 1, self.size, 1 do
        cur = cur.next
        print(tostring(cur.value))
    end
end

return LinkedList
