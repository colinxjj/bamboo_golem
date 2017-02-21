
local task = {}

--------------------------------------------------------------------------------
-- Traverse all rooms within a range from the base location
--[[----------------------------------------------------------------------------
Params:
loc = '扬州城北大街': long name or id of the location (required)
range = 2: traverse all roms with this range from the base location (optional, default: 0)
----------------------------------------------------------------------------]]--

task.class = 'traverse'

function task:get_id()
  local dest = type( self.to ) == 'table' and self.to.id or self.to
  return 'go to ' .. dest
end

function task:_resume()
  -- get a list of rooms with range from the base location
  self.room_list = self.room_list or map.expand_loc( self.loc, self.range )

  -- create a closure to be used with map.find_nearest to let it know if it's found a valid dest or not
  self.is_dest = self.is_dest or function( dest )
    for _, room in pairs( self.room_list ) do
      if room == dest then return true end
    end
  end

  -- first we need to go to the traverse area
  if not self.ready_to_start then
    -- get current location
    local from = map.get_current_location()
    if not from then self:newsub{ class = 'locate' }; return end
    from = from[ 1 ]

    -- find the nearest room in the list
    local dest = map.find_nearest( from, is_dest )

    -- go to that room, then start traversing
    self.ready_to_start = true
    self:newsub{ class = 'go', to = dest }
  end

  -- traverse the rooms
  -- TODO
end

function task:_complete()
end

-- start traversing
function task:start()
  -- body...
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
