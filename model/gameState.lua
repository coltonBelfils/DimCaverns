local mapper = require("mapper")
local settings = require("model.settings")
local pos = require("pos")

local GameState = {
    instance = nil -- Find a way to make private
}

function GameState:get() -- editing and retrieving any of the members of this table need to be thread safe.
    if self.instance then return self.instance end

     -- Check for settings file here
     local s = settings:get()

     -- Check for save file here

    local nState = {
        bigMap = mapper:generate(s.mapSize, s.maxRoomSize),
        smallMap = nil, -- How do I seemlessly keep this up to date? I could make it a function and not a var and essenchaly call the getSmallMap function that is currently in main every time OR have it be a var that is updated every time smallMapCenterPos or bigMap are changed but knowing if any of the cells in bigMap have changed could be expensive. 
        playerPos = pos:new(3, 3), -- Need to decide if this will be reletive to bigMap or smallMap. Currently it's small map.
        smallMapCenterPos = pos:new(2, 2), -- The center of the small map on the bigMap. Needs a better name.
    }

    self.instance = nState

    return nState
end

GameState:get() -- This probably shouldn't be here in the end and should instead should lazily init the singleton, but until GameState:get() is thread safe this is here.

return GameState