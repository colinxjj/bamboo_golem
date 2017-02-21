
local task = {}

--------------------------------------------------------------------------------
-- Find an object / a person in the world
--[[----------------------------------------------------------------------------
Params:
object = '胡斐': name of the object/person to find (required)
at = '黄河领域墓地': long name or id of the location of the object, if not specified, predefined npc/item data will be used to locate it (optional)
range = 2: the range of steps in number that the object might wander off the specified / predefined location (optional, default: 0)
is_unique = true: if true, if the object is seen anywhere (even outside the range), it will be deemed as found (optional, default: false)
test_action = some_func: a function to run to test if we've found the right object or not ( e.g. to find the correct npc to deliver a letter ) (optional)
----------------------------------------------------------------------------]]--

task.class = 'find'

function task:get_id()
  local id = 'find ' .. self.object
  id = self.at and ( id .. ' at ' .. self.at ) or id
  id = self.range and ( id .. ' within range of ' .. self.range ) or id
  return id
end

function task:_resume()
  if not self.at then
    local char = npc[ object ] or item[ object ]
    -- TODO handle objects with predefined locations
  end

  self:listen{ event = 'room_object', id = 'task.find', func = task.check }

  self:newweaksub{ class = 'traverse', loc = self.at, range = self.range }
end

function task:_complete()
  message.verbose( '顺利找到' .. self.object )
end

function task:check( obj )
  if obj.name ~= self.object then return end
  if self.is_unique == true then self:complete() end

  for _, loc in pairs( map.get_current_location() ) do
    if string.find( loc.id, self.at ) then
      if self.test_action then
        self.test_action( obj ) -- TODO how does the test_action func pass back the result to determine if we should continue to find the object or complete this task?
      else
        self:complete()
      end
      break
    end
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
