
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
    message.verbose('定位结果：目前位于“' .. location[ 1 ].id .. '”' )
    self:complete()
    return
  end

  self:listen{ event = 'located', func = self.resume, id = 'task.locate' }

  -- get room desc
  local room = room.get()
  if not room or not room.desc or not location then self:send{ 'l' }; return end

  -- get place info
  if not self.place then
    self.place = true
    self:send{ 'place' }
    return
  end

  -- complete this task if got multiple results
  if #location > 1 then
    local s = '定位结果：当前位置有 ' .. #location .. ' 种可能：'
    for _, loc in pairs( location ) do
      s = s .. loc.id .. ' '
    end
    message.verbose( s )
    self:complete()
    return
  end

  -- otherwise, walk to adjacent room
  for dir in pairs( room.get().exit ) do self:send{ dir }; return end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
