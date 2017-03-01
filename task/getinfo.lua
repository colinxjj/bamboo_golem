
local task = {}

--------------------------------------------------------------------------------
-- Get player or world information
--[[----------------------------------------------------------------------------
Params:
one or more of the info types (see info_type below) set to non-false values
hp/time/etc. = 'forced': force an update of the corresponding info type
room = true: get info for current room
     = 'e': get info for room in that direction to the current room
     = 'surrounding': get info for all rooms surrounding the current room
     = 'all': get info for all rooms including the current room and the surrounding rooms
----------------------------------------------------------------------------]]--

task.class = 'getinfo'

info_type = { 'hp', 'inventory', 'skills', 'score', 'enable', 'room', 'time' }

local function get_info_type_string( self )
  string = ''
  for _, type in pairs( info_type ) do
    if self[ type ] ~= nil then string = string .. type .. ', ' end
  end
  string = string.gsub( string, ', $', '' )
  return string
end

function task:get_id()
  return 'get info: ' .. get_info_type_string( self )
end

function task:get_room_info( evt )
  self.looked, self.result = self.looked or {}, self.result or {} -- this assumes that the task only need to return room info to its parent
  if evt then self.result[ self.last_look ] = evt.data end -- put data from last look in to results
  local target = self.room
  -- look current room
  if ( target == 'all' or target == true or not map.get_current_room() ) and not self.looked.here then self:look_dir 'here'; return end
  -- look surrounding rooms
  if target == 'all' or target == 'surrounding' then
    local exit = self.result.here and self.result.here.exit or map.get_current_room().exit
    for dir in pairs( exit ) do
      if not self.looked[ dir ] then self:look_dir( dir ); return end
    end
  elseif not self.looked[ target ] and target ~= true then self:look_dir( target ); return end
  self.room = false -- mark room part as done
  self:resume()
end

function task:look_dir( dir )
  if dir == 'here' then
    self:listen{ event = 'room', func = self.get_room_info, id = 'task.getinfo' }
    self:send{ 'l' }
  else
    self:listen{ event = 'room', func = self.get_room_info, id = 'task.getinfo', sequence = 99, keep_eval = false }
    self:send{ 'l ' .. ( DIR_FULL[ dir ] or dir ) }
  end
  self.last_look, self.looked[ dir ] = dir, true
end

function task:_resume( evt )
  for _, type in pairs( info_type ) do
    if self[ type ] then
      if type == 'room' then
        self:get_room_info()
        return
      elseif self[ type ] == 'forced' -- if update is forced, then always do
          or ( type == 'inventory' and ( not player.inventory_update_time or os.time() - player.inventory_update_time > 180 ) ) -- update inventory info at most once every 3 min
          or ( type == 'hp' and ( not player.hp_update_time or os.time() - player.hp_update_time > 180 ) )  -- update hp info at most once every 3 min
          or not player[ type .. '_update_time' ] then -- get score, skills, enable, and time info only once
        self[ type ] = false -- to avoid repetition
        gag.once( type )
        self:listen{ event = type, func = self.resume, id = 'task.getinfo' }
        self:send{ type, no_echo = true }
        return
      end
    end
  end
  self:complete()
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
