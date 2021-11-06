local LinkedList = {}
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

return LinkedList
