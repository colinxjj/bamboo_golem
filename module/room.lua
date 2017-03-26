
local room = {}

--------------------------------------------------------------------------------
-- This module handles current room related stuff
--------------------------------------------------------------------------------

local current_room

-- get current room data
function room.get()
  return current_room
end

function room.reset()
  current_room = nil
end

-- check if a person / an object is present in the current room
function room.has_object( object )
	object = type( object ) == 'table' and object or get_npc( object ) or item.get( object ) or { name = object }
  if type( object.name ) == 'table' then -- for object with multiple names
    local room_object
    for _, name in pairs( object.name ) do
      room_object = current_room.object[ name ]
    	if room_object and ( not object.id or object.id == room_object.id ) then return true end
    end
  elseif object.name then -- for object with a single name
  	local room_object = current_room.object[ object.name ]
  	return room_object and ( not object.id or object.id == room_object.id ) and true or false
  elseif object.id then -- for object with id but without names (e.g. 杂役喇嘛#XS, it's impossbile to handle them by name since their name combinations are numerous)
    for _, room_object in pairs( current_room.object ) do
      if room_object.id == object.id then return true end
    end
  end
end

-- add a new object to the current room
function room.add_object( object )
	object = type( object ) == 'string' and { name = object } or object
	current_room.object[ object.name ] = object
end

function room.remove_object( name )
  assert( type( name ) == 'string', 'room.remove_object - param must be a string' )
	current_room.object[ name ] = nil
end

function room.get_object( name )
  assert( type( name ) == 'string', 'room.get_object - param must be a string' )
  local it = get_npc( name ) or item.get( name )
  if not it then -- for object without index data
    return current_room.object[ name ]
  elseif type( it.name ) == 'string' then -- for object with a single name
    return current_room.object[ it.name ]
  elseif it.name then -- for object with multiple names
    for _, possible_name in pairs( it.name ) do
      if current_room.object[ possible_name ] then return current_room.object[ possible_name ] end
    end
  elseif it.id then -- for object with id but without names
    for _, room_object in pairs( current_room.object ) do
      if room_object.id == it.id then return room_object end
    end
  end
end

function room.get_object_count( name )
  local it = room.get_object( name )
  return it and it.count or 0
end

-- locate the player based on the current room data
local function locate( room )
  local same_name_list = map.get_room_by_name( room.name ) or {}

  if #same_name_list <= 1 then return same_name_list end

  local same_area_list
  if room.area then
    same_area_list = {}
    for _, map_room in pairs( same_name_list ) do -- check area
      if map.is_area_match( room, map_room ) then table.insert( same_area_list, map_room ) end
    end
  else
    same_area_list = same_name_list
  end

  if #same_area_list <= 1 then return same_area_list end

  local same_exit_list = {}
  for _, map_room in pairs( same_area_list ) do -- check exit
    if map.is_exit_match( room, map_room, index ) then table.insert( same_exit_list, map_room ) end
  end

  if #same_exit_list <= 1 then return same_exit_list end

  local same_desc_list
  if room.desc then
    same_desc_list = {}
    for _, map_room in pairs( same_exit_list ) do -- check desc
      if map.is_desc_match( room, map_room ) then table.insert( same_desc_list, map_room ) end
    end
  else
    same_desc_list = same_exit_list
  end

  if #same_desc_list <= 1 then return same_desc_list end

  local adjacent_list = {}
  if map.get_current_location() then
    for _, map_room in pairs( same_desc_list ) do -- check adjacency
      if map.is_adjacent_to_prev_location( map_room, 1 ) then table.insert( adjacent_list, map_room ) end
    end
  end

  local c = cmd.get_last()
  if #adjacent_list > 1 and c and c.type ~= 'batch' then -- narrow down the scope based on last non-batch command sent
    local i, map_room = 1
    while i <= #adjacent_list do
      map_room = adjacent_list[ i ]
      -- message.debug( '检查是否可从之前的位置以 ' .. c.cmd .. ' 命令到达' .. map_room.id )
      if not map.is_reachable_from_prev_location_with_cmd( map_room, c.cmd ) then
        table.remove( adjacent_list, i )
      else
        i = i + 1
      end
    end
  end

  if #adjacent_list == 1 then return adjacent_list end

  -- adjacency locating should be auxiliary only so if it ruled out all options, revert to the result from previous step
  if #adjacent_list == 0 then adjacent_list = same_desc_list end

  return adjacent_list -- set current location to a list of possbile locations
end

local function auto_locate( evt )
  current_room = evt.data
  local result = locate( current_room )
  if #result == 0 then message.warning '自动定位失败' end
  --[[
  if #result > 1 then
    local s = '自动定位：' .. #result .. ' 个可能结果'
    s = s .. '：'
    for _, loc in pairs( result ) do
      s = s .. loc.id .. '、'
    end
    s = string.gsub( s, '、$', '' )
    message.debug( s )
  end
  --]]

  map.add_to_loc_history( result )
  event.new{ event = 'located', location = result }
end

event.listen{ event = 'room', func = auto_locate, persistent = true, id = 'room.auto_locate' }
event.listen{ event = 'place', func = auto_locate, persistent = true, id = 'room.auto_locate' }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return room
