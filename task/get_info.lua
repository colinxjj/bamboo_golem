
local task = {}

--------------------------------------------------------------------------------
-- Get player or world information
--[[----------------------------------------------------------------------------
Params:
one or more of the info types (see info_type below) set to non-false values
room = true: get info for current room
     = 'e': get info for room in that direction to the current room
     = 'surrounding': get info for all rooms surrounding the current room
     = 'all': get info for all rooms including the current room and the surrounding rooms
----------------------------------------------------------------------------]]--

task.class = 'get_info'

info_type = { 'hp', 'inventory', 'skills', 'score', 'enable', 'room', 'time', 'uptime', 'set', 'title' }

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
  if ( target == 'all' or target == true or not room.get() ) and not self.looked.here then self:look_dir 'here'; return end
  -- look surrounding rooms
  if target == 'all' or target == 'surrounding' then
    local exit = self.result.here and self.result.here.exit or room.get().exit
    for dir in pairs( exit ) do
      if not self.looked[ dir ] then self:look_dir( dir ); return end
    end
  elseif not self.looked[ target ] and target ~= true then self:look_dir( target ); return end
  self.room = false -- mark room part as done
  self:resume()
end

function task:look_dir( dir )
  if dir == 'here' then
    self:listen{ event = 'room', func = self.get_room_info, id = 'task.get_info' }
    self:send{ 'l' }
  else
    self:listen{ event = 'room', func = self.get_room_info, id = 'task.get_info', sequence = 99, keep_eval = false }
    self:send{ 'l ' .. ( DIR_FULL[ dir ] or dir ) }
  end
  self.last_look, self.looked[ dir ] = dir, true
end

local pending_type, received_event

function task:_resume( evt )
  -- if command was sent but the related event didn't fire, try again
  if pending_type and not received_event then
    self[ pending_type ] = pending_type_value
    pending_type, pending_type_value, received_event = nil
  end
  for _, type in pairs( info_type ) do
    if self[ type ] then
      if type == 'room' then
        self:get_room_info()
        return
      else
        pending_type, pending_type_value, received_event = type, self[ type ], false
        self[ type ] = false -- to avoid repetition
        gag.once( type )
        self:listen{ event = type, func = self.parse_event, id = 'task.get_info' }
        self:send{ type; no_echo = true, complete_func = self.resume }
        return
      end
    end
  end
  self:complete()
end

function task:parse_event()
  received_event = true
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
