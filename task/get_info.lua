
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
  for _, info in pairs( info_type ) do
    if self[ info ] ~= nil then string = string .. info .. ', ' end
  end
  string = string.gsub( string, ', $', '' )
  return string
end

function task:get_id()
  return 'get info: ' .. get_info_type_string( self )
end

local function look_dir( self, dir, cmd_list )
  cmd_list[ #cmd_list + 1 ] = dir == 'here' and 'l' or ( 'l ' .. ( DIR_FULL[ dir ] or dir ) )
  self.dir_list[ #self.dir_list + 1 ] = dir
end

local function setup_listener( self )
  self:listen{ event = 'room', func = self.parse_look_result, id = 'task.get_info', sequence = 99, keep_eval = self.dir_list[ 1 ] == 'here' and true or false }
end

function task:get_room_info( cmd_list )
  self.dir_list = {}
  local target = self.room
  -- look current room
  if target == 'all' or target == true then
    look_dir( self, 'here', cmd_list )
  end
  -- look surrounding rooms
  if target == 'all' or target == 'surrounding' then
    for dir in pairs( room.get().exit ) do
      look_dir( self, dir, cmd_list )
    end
  elseif target ~= true then
    look_dir( self, target, cmd_list )
  end
  self.room = 'sent'
  setup_listener( self )
end

function task:parse_look_result( evt )
  self.room = 'received'
  local dir = table.remove( self.dir_list, 1 )
  self.result = self.result or {}
  self.result[ dir ] = evt.data
  if next( self.dir_list ) then setup_listener( self ) end
end

function task:_resume( evt )
  if not self.start_time then
    self.start_time = os.clock() * 1000
  end
  local cmd_list = { no_echo = true, complete_func = self.resume }
  for _, info in pairs( info_type ) do
    local target = self[ info ]
    if target and target ~= 'received' then
      if info == 'room' then
        self:get_room_info( cmd_list )
      else
        self[ info ] = 'sent'
        self:listen{ event = info, func = self.parse_event, id = 'task.get_info' }
        gag.once( info )
        cmd_list[ #cmd_list + 1 ] = info
      end
    end
  end
  if #cmd_list > 0 then
    self:send( cmd_list )
  else
    self:complete()
  end
end

function task:parse_event( evt )
  self[ evt.event ] = 'received'
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
