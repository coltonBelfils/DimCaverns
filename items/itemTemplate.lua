local ItemTemplate = {}

function ItemTemplate:new(map) 
    local nItem = {}

    nItem.map = map

    setmetatable(nItem, self)
    return nItem
end

function ItemTemplate:grab(playerAt) -- are the gdes functions here in the item class inin the manager class?
    
end

function ItemTemplate:drop(playerAt)
    
end

function ItemTemplate:equip(playerAt)
    
end

function ItemTemplate:stow(playerAt)
    
end

function ItemTemplate:use(playerAt)
    
end

function ItemTemplate:movedTo(playerAt)

end

ItemTemplate.__index = ItemTemplate
function ItemTemplate:__tostring()
    return ""
end

return ItemTemplate
