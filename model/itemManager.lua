local ItemManager = {}

function ItemManager:new(map) 
    local nItemManager = {}

    nItemManager.map = map

    setmetatable(nItemManager, self)
    return nItemManager
end

ItemManager.__index = ItemManager
function ItemManager:__tostring()
    return ""
end

return ItemManager
