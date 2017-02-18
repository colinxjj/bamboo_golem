
local task = {}

--------------------------------------------------------------------------------
-- Get player's current location
--[[----------------------------------------------------------------------------
Params:
none
----------------------------------------------------------------------------]]--

task.class = 'locate'

function task:_resume()
  local location = map.get_current_location()

  -- complete this taswk if got unique result
  if location and #location == 1 then
    message.debug('locate 任务：目前位于：' .. location[ 1 ].id )
    self:complete()
    return
  end

  self:listen{ event = 'located', func = self.resume, id = 'task.locate' }

  -- get room desc
  local room = map.get_current_room()
  if not room or not room.desc or not location then self:send{ 'l' }; return end

  -- get place info
  if not self.place then
    self.place = true
    self:send{ 'place' }
    return
  end

  -- complete this task if got multiple results
  if #location > 1 then
    message.debug('locate 任务：当前位置有 ' .. #location .. ' 种可能' )
    self:complete()
    return
  end

  -- otherwise, walk to adjacent room
  for dir in pairs( map.get_current_room().exit ) do self:send{ dir }; return end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
