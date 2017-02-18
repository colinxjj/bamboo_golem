
local map = {}

--------------------------------------------------------------------------------
-- This module handles map related stuff
--------------------------------------------------------------------------------

-- load the full map index
local index = require 'data.map'

-- load submodules
local history = require 'module.map.history'
local helper = require 'module.map.helper'
local locator = require 'module.map.locator'
local step_handler = require 'module.map.step_handler'

-- load all exit conditions from map index as functions
local cond_checker = {}
for id, room in pairs( index ) do
  if room.use_cond and not cond_checker[ room.use_cond ] then
    cond_checker[ room.use_cond ] = loadstring( 'return ' .. room.use_cond )
  end
  for dir, exit in pairs( room.exit ) do
    if exit.cond and not cond_checker[ exit.cond ] then
      cond_checker[ exit.cond ] = loadstring( 'return ' .. exit.cond )
    end
  end
end


-- helper redirector
function map.serialize_room( room )
  return helper.serialize_room( room )
end
function map.list_all_potentially_no_exit()
  return helper.list_all_potentially_no_exit( index )
end


-- index by room name like 北大街
local name_index = helper.generate_name_index( index )
-- index by long room names like 长安城北大街
local longname_index = helper.generate_longname_index( index )

-- current room data, not the calculated current location
local current_room

function map.get_room_by_name( name )
  return name_index[ name ]
end

function map.get_room_by_longname( name )
  return longname_index[ name ]
end

function map.get_room_by_id( id )
  return index[ id ]
end

-- a function to check if reached dest by directly comparing rooms (tables)
local function is_dest_by_room( dest )
  return function( room )
    return room == dest
  end
end

-- get path from one room to another. the 2nd param is a func to decide whether we've reached the / a dest
local function genpath( from, is_dest )
  local list, list_pos, cost, prev, path, rev_path, max_cost, to, dest, new_cost = { from }, 1, { [ from ] = 0 }, {}, {}, {}
  while list[ list_pos ] do
    from = list[ list_pos ]
    if is_dest( from ) and
    ( max_cost and cost[ from ] < max_cost or not max_cost ) then -- set dest
      max_cost, dest = cost[ from ], from
    end
    for _, exit in pairs( from.exit ) do
      to = index[ exit.to ]
      new_cost = cost[ from ] + ( exit.cost or 1 )
      if to and from ~= to and not exit.ignore and
      ( exit.cond and cond_checker[ exit.cond ]() or not exit.cond ) and
      ( max_cost and new_cost < max_cost or not max_cost ) and
      ( not cost[ to ] or new_cost < cost[ to ] ) then -- add new node
        cost[ to ], prev[ to ] =  new_cost, from
        list[ #list + 1 ] = to
      end
    end
    list_pos = list_pos + 1 -- move to next node
  end

  if not dest then return end -- no dest found

  while dest do -- generate path
    rev_path[ #rev_path + 1 ] = dest
    dest = prev[ dest ]
  end
  for i = #rev_path, 1, -1 do
    path[ #path + 1 ] = rev_path[ i ]
  end

  --[[]]
  local s = 'MAP 模块分析了 ' .. #list .. ' 个房间，成功找到路径，共 ' .. #path .. ' 步：'
  for _, room in pairs( path ) do
    s = s .. room.id .. ' > '
  end
  s = s:gsub( ' > $', '' )
  message.debug( s )
  --]]

  return path
end

-- get the path between two rooms, accepts room id's and room tables as arguments
function map.getpath( from, to )
  from = type( from ) == 'string' and index[ from ] or from
  to = type( to ) == 'string' and index[ to ] or to
  assert( from and from.id, 'map.getpath - can\'t parse the from param' )
  assert( to and to.id, 'map.getpath - can\'t parse the to param' )

  return genpath( from, is_dest_by_room( to ) )
end

-- check if a room can be found within X range from the starting room
function map.find_room_within_range( start_room, room_to_find, range )
  local list, list_pos, distance, new_distance, from, to, found = { start_room }, 1, { [ start_room ] = 0 }
  while list[ list_pos ] do
    from = list[ list_pos ]
    if from == room_to_find then found = true; break end
    for _, exit in pairs( from.exit ) do
      to = index[ exit.to ]
      new_distance = distance[ from ] + 1
      if to and new_distance <= range and not distance[ to ] then -- add new node
        distance[ to ] =  new_distance
        list[ #list + 1 ] = to
      end
    end
    list_pos = list_pos + 1 -- move to next node
  end

  return found
end

function map.get_step_cmd( from, to )
  for dir, exit in pairs( from.exit ) do
    if exit.to == to.id and not exit.ignore then
      local cmd = exit.cmd or ( not string.find( dir, 'hidden' ) and dir )
      local handler = exit.handler and step_handler[ exit.handler ]
      local handler_tg = exit.handler and 'step_handler.' .. exit.handler
      return cmd, exit.door, handler, handler_tg
    end
  end
end

function map.get_last_location()
  return history.query_last()
end

-- get current room data
function map.get_current_room()
  return current_room
end

-- get current location
function map.get_current_location()
  return history.query_current()
end

-- check if a room is the current location or one of the possible current locations
function map.is_current_location( room )
  for _, loc in pairs( map.get_current_location() ) do
    if loc == room then return true end
  end
end

function map.ignore_room()
  mesage.debug 'MAP 模块：忽略了一个房间'
end

function map.ignore_next_room()
  mesage.debug 'MAP 模块：收到忽略下一个房间的请求'
  event.listen{ event = 'room', func = map.ignore_room, id = 'map.ignore_room', sequence = 90, keep_eval = false }
end

-- locate the player based on the current room data
function map.locate( room )
  local same_name_list = name_index[ room.name ] or {}

  if #same_name_list <= 1 then return same_name_list end

  local same_area_list
  if room.area then
    same_area_list = {}
    for _, map_room in pairs( same_name_list ) do -- check area
      if locator.is_area_same( room, map_room ) then table.insert( same_area_list, map_room ) end
    end
  else
    same_area_list = same_name_list
  end

  if #same_area_list <= 1 then return same_area_list end

  local same_exit_list = {}
  for _, map_room in pairs( same_area_list ) do -- check exit
    if locator.is_exit_match( room, map_room, index ) then table.insert( same_exit_list, map_room ) end
  end

  if #same_exit_list <= 1 then return same_exit_list end

  local same_desc_list
  if room.desc then
    same_desc_list = {}
    for _, map_room in pairs( same_exit_list ) do -- check desc
      if locator.is_desc_same( room, map_room ) then table.insert( same_desc_list, map_room ) end
    end
  else
    same_desc_list = same_exit_list
  end

  if #same_desc_list <= 1 then return same_desc_list end

  local adjacent_list = {}
  if history.query_current() then
    for _, map_room in pairs( same_desc_list ) do -- check adjacency
      if locator.is_adjacent_to_prev_location( map_room, 1 ) then table.insert( adjacent_list, map_room ) end
    end
  end

  if #adjacent_list > 1 and cmd.get_last() then -- narrow down the scope based on last command sent
    local i, map_room = 1
    while i <= #adjacent_list do
      map_room = adjacent_list[ i ]
      -- message.debug( '检查是否可从之前的位置以 ' .. cmd.get_last() .. ' 命令到达' .. map_room.id )
      if not locator.is_reachable_from_prev_location_with_cmd( map_room, cmd.get_last() ) then
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

function map.auto_locate( evt )
  current_room = evt.data
  local result = map.locate( current_room )
  if #result ~= 1 then
    local s = '自动定位：' .. #result .. ' 个可能结果'
    if #result > 0 then
      s = s .. '：'
      for _, loc in pairs( result ) do
        s = s .. loc.id .. '、'
      end
      s = string.gsub( s, '、$', '' )
    end
    message.debug( s )
  end
  history.insert( result )
  event.new 'located'
end

event.listen{ event = 'room', func = map.auto_locate, persistent = true, id = 'map.locate' }
event.listen{ event = 'place', func = map.auto_locate, persistent = true, id = 'map.locate' }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return map
