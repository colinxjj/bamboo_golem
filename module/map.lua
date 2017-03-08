
local map = {}

--------------------------------------------------------------------------------
-- This module handles map related stuff
--------------------------------------------------------------------------------

-- load the full map index
local index = require 'data.map'

-- load all exit conditions from map index as functions
local cond_checker = {}
for id, room in pairs( index ) do
  if room.use_cond and not cond_checker[ room.use_cond ] then
    cond_checker[ room.use_cond ] = loadstring( 'return ' .. room.use_cond )
  end
  for dir, exit in pairs( room.exit ) do
    if exit.cond and not cond_checker[ exit.cond ] then
      cond_checker[ exit.cond ] = loadstring( 'return ' .. exit.cond )
      if not cond_checker[ exit.cond ] then error( 'error compiling function for exit.cond: ' .. exit.cond ) end
    end
  end
end

-- generate room name indices
local name_index, longname_index = {}, {}
-- index by room name like 北大街
do
  local name
  for _, room in pairs( index ) do
    name = room.name
    name_index[ name ] = name_index[ name ] or {}
    table.insert( name_index[ name ], room )
  end
end
-- index by long room names like 长安城北大街
do
  local longname
  for _, room in pairs( index ) do
    longname = room.area .. room.name
    longname_index[ longname ] = longname_index[ longname ] or {}
    table.insert( longname_index[ longname ], room )
  end
end

--------------------------------------------------------------------------------
-- get rooms

function map.get_room_by_name( name )
  return name_index[ name ]
end

function map.get_room_by_longname( name )
  return longname_index[ name ]
end

function map.get_room_by_id( id )
  return index[ id ]
end

--------------------------------------------------------------------------------
-- path generation / evaluation

-- return a function to check if reached dest by directly comparing tables of rooms
local function is_dest_by_room( dest )
  return function( room )
    return room == dest
  end
end

-- get path from one room to another. the 2nd param is a func to decide whether we've reached the/a dest
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
      ( not exit.blocked_by_task or not map.is_block_valid( exit ) ) and
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

  --[[
  local s = 'MAP 模块分析了 ' .. #list .. ' 个房间，成功找到路径，共 ' .. #path .. ' 步：'
  for _, room in pairs( path ) do
    s = s .. room.id .. ' > '
  end
  s = s:gsub( ' > $', '' )
  message.debug( s )
  --]]

  return path, max_cost
end

-- get the path between two rooms
-- params can be ids or tables of the rooms, the 'to' param can also be a function for is_dest check
function map.getpath( from, to )
  from = type( from ) == 'string' and index[ from ] or from
  to = type( to ) == 'string' and index[ to ] or to
  assert( from and from.id, 'map.getpath - invalid "from" param' )
  assert( type( to ) == 'table' and to.id or type( to ) == 'function', 'map.getpath - invalid "to" param' )

  to = type( to ) == 'table' and is_dest_by_room( to ) or to
  return genpath( from, to )
end

function map.getcost( from, to )
  local _, cost = map.getpath( from, to )
  return cost
end

-- check if a room can be found within X range from the starting room
-- both room params must be the tables of the rooms
function map.is_room_within_range( start_room, room_to_find, range )
  local list, list_pos, distance, new_distance, from, to, is_found = { start_room }, 1, { [ start_room ] = 0 }
  while list[ list_pos ] do
    from = list[ list_pos ]
    if from == room_to_find then is_found = true; break end
    for _, exit in pairs( from.exit ) do
      to = index[ exit.to ]
      new_distance = distance[ from ] + 1
      if to and new_distance <= range and not distance[ to ] then -- add new node
        distance[ to ] = new_distance
        list[ #list + 1 ] = to
      end
    end
    list_pos = list_pos + 1 -- move to next node
  end

  return is_found
end

-- return a list of rooms within the range from the base location
-- the loc param can be the long name, id, or table of a room
function map.expand_loc( loc, range )
  -- get a list of rooms matching the loc
  local base_list = longname_index[ loc ] or { map.get_room_by_id( loc ) } or { loc }
  assert( next( base_list ), 'map.expand_loc - invalid base room list' )

  local result = {}
  for _, start_room in pairs( base_list ) do
    local list, list_pos, distance, new_distance, from, to = { start_room }, 1, { [ start_room ] = 0 }
    while list[ list_pos ] do
      from = list[ list_pos ]
      result[ from ] = true
      for _, exit in pairs( from.exit ) do
        to = index[ exit.to ]
        new_distance = distance[ from ] + 1
        if to and not exit.no_wander and not exit.ignore
        and ( not exit.blocked_by_task or not map.is_block_valid( exit ) )
        and ( exit.cond and cond_checker[ exit.cond ]() or not exit.cond )
        and new_distance <= range and not distance[ to ] then -- add new node
          distance[ to ] = new_distance
          list[ #list + 1 ] = to
          result[ to ] = true -- add the room to result list
        end
      end
      list_pos = list_pos + 1 -- move to next node
    end
  end
  return result
end

local function find_room( from, is_dest, prefer_furthest )
  local list, list_pos, cost, max_cost, to, dest, new_cost = { from }, 1, { [ from ] = 0 }
  local cost_ok = function( new_cost, max_cost )
    if not max_cost then return true end
    if prefer_furthest then
      return new_cost > max_cost
    else
      return new_cost < max_cost
    end
  end
  while list[ list_pos ] do
    from = list[ list_pos ]
    if is_dest( from ) and cost_ok( cost[ from ], max_cost ) then -- set dest
      max_cost, dest = cost[ from ], from
    end
    for _, exit in pairs( from.exit ) do
      to = index[ exit.to ]
      new_cost = cost[ from ] + ( exit.cost or 1 )
      if to and from ~= to and not exit.ignore and
      ( not exit.blocked_by_task or not map.is_block_valid( exit ) ) and
      ( exit.cond and cond_checker[ exit.cond ]() or not exit.cond ) and
      ( prefer_furthest or cost_ok( new_cost, max_cost ) ) and
      ( not cost[ to ] or new_cost < cost[ to ] ) then -- add new node
        cost[ to ] =  new_cost
        list[ #list + 1 ] = to
      end
    end
    list_pos = list_pos + 1 -- move to next node
  end

  return dest
end

-- find the nearest room that meets the criteria
-- the 1st param must be the id/table of a room, the 2nd a function to check if a room is one that we want
function map.find_nearest( from, is_dest )
  from = type( from ) == 'string' and index[ from ] or from
  assert( from and from.id, 'map.find_nearest - invalid "from" param' )

  local room = find_room( from, is_dest )
  return room
end

-- find the furthest room that meets the criteria
-- the 1st param must be the id/table of a room, the 2nd a function to check if a room is one that we want
function map.find_furthest( from, is_dest )
  from = type( from ) == 'string' and index[ from ] or from
  assert( from and from.id, 'map.find_furthest - invalid "from" param' )

  local room = find_room( from, is_dest, true )
  return room
end

function map.get_step_cmd( from, to )
  for dir, exit in pairs( from.exit ) do
    if exit.to == to.id and not exit.ignore then
      local cmd = exit.cmd or ( not string.find( dir, 'hidden' ) and dir )
      return cmd, exit.door, exit.handler
    end
  end
end

-- block the exit from a room to another with a task, the exit will be ignored until the task is dead
-- the two room params are the id/table of a room
function map.block_exit( from, to, task )
  from = type( from ) == 'string' and index[ from ] or from
  to = type( to ) == 'string' and index[ to ] or to
  assert( from and from.id, 'map.block_exit - invalid "from" param' )
  assert( to and to.id, 'map.block_exit - invalid "to" param' )
  assert( type( task ) == 'table' and task.status, 'map.block_exit - invalid "task" param' )

  for _, exit in pairs( from.exit ) do
    if exit.to == to.id and not exit.ignore and
    -- exit cond will be checked so only exits that the player can use otherwise are blocked
    ( exit.cond and cond_checker[ exit.cond ]() or not exit.cond ) then
      exit.blocked_by_task = task
    end
  end
end

-- checks if a block is still valid or not, if not, the block will be lifted
function map.is_block_valid( exit )
  local task = exit.blocked_by_task
  if task.status == 'dead' then
    exit.blocked_by_task = nil
    return false
  else
    return true
  end
end

-- generate the list of items / flags needed to complete the path
function map.get_path_req( path )
  local list, from, to, entry = {}
  for i = 1, #path - 1 do
    from, to = path[ i ], path[ i + 1 ]
    for _, exit in pairs( from.exit ) do
      if exit.req and exit.to == to.id and not exit.ignore
      -- check the exit cond because there can be multiple exits from a room to another and we need to get the requirement for the right exit
      and ( exit.cond and cond_checker[ exit.cond ]() or not exit.cond ) then
        for k, v in pairs( exit.req ) do
          list[ k ] = list[ k ] or {}
          entry = list[ k ]
          if type( v ) == 'number' then -- a numeric value means that it's an item req
            entry.item = k
            entry.count = entry.count and entry.count + v or v -- this might result in preparing more than what we actually need but for now it should be OK
          else -- otherwise it's flag req
            entry.flag = k
          end
          entry[ #entry + 1 ]  = { from = from, to = to } -- add the from/to pair to the array part so that all exits that require this thing can be properly blocked until we've got the items / flags
          list[ #list + 1 ] = entry -- also add the entry to the array part of the list for easy access
        end
      end
    end
  end
  return list
end

--------------------------------------------------------------------------------
-- location history

-- player location history
local lochistory, startpos, endpos = {}, 0, 0

-- add an entry to location history
function map.add_to_loc_history( entry )
  endpos = endpos + 1
  lochistory[ endpos ] = entry

  if endpos - startpos > 100 then -- store 100 history entries
    lochistory[ startpos ] = nil
    startpos = startpos + 1
  end

  return entry
end

function map.get_last_location()
  return lochistory[ endpos - 1 ]
end

-- get current location
function map.get_current_location()
  return lochistory[ endpos ]
end

-- check if a room is the current location or one of the possible current locations
function map.is_current_location( room )
  if type( room ) == 'string' then room = map.get_room_by_id( room ) end
  if not room then return end
  for _, loc in pairs( map.get_current_location() ) do
    if loc == room then return true end
  end
end

--------------------------------------------------------------------------------
-- locating / comparing current room with map rooms

function map.is_area_match( this_room, map_room )
  return this_room.area == map_room.area
end

-- compare if two rooms match based their exits
function map.is_exit_match( this_room, map_room )
  local is_diff
  for dir, exit in pairs( this_room.exit ) do
    local e, dir2, dir3, dir4 = map_room.exit, dir .. '2', dir .. '3', dir .. '4'
    if not e[ dir ] or -- check for exit room name as well if available
    ( exit ~= true and ( exit ~= index[ e[ dir ].to ].name
    and ( e[ dir2 ] and exit ~= index[ e[ dir2 ].to ].name or not e[ dir2 ] )
    and ( e[ dir3 ] and exit ~= index[ e[ dir3 ].to ].name or not e[ dir3 ] )
    and ( e[ dir4 ] and exit ~= index[ e[ dir4 ].to ].name or not e[ dir4 ] ) ) ) then
      is_diff = true
      break
    end
  end
  if is_diff then return false end
  for dir, exit in pairs( map_room.exit ) do
    if not this_room.exit[ dir ] and
    not string.find( dir, 'hidden' ) and
    not string.find( dir, '%d' ) and -- e.g. ignore out2, e4
    not exit.unstable and not exit.door then
      is_diff = true
      break
    end
  end
  return not is_diff
end

-- compare if two rooms match based their description
function map.is_desc_match( this_room, map_room )
  local is_same
  if type( map_room.desc ) == 'table' then
    for _, desc in pairs( map_room.desc ) do
      if desc == this_room.desc then is_same = true; break end
    end
  else
    if map_room.desc == this_room.desc then is_same = true end
  end
  return is_same
end

-- check if a map room is within X range from player's previous location
function map.is_adjacent_to_prev_location( map_room, range )
  local prev_loc, is_found = map.get_current_location()
  if not prev_loc then return end
  for _, loc in pairs( prev_loc ) do
    is_found = map.is_room_within_range( loc, map_room, range )
    if is_found then break end
  end
  return is_found
end

-- check if a room can be reached from another room with specified cmd
local function is_room_reachable( from, cmd, to )
  for dir, exit in pairs( from.exit ) do
    dir = string.gsub( dir, '_', '' ) -- convert dirs like out_ to out
    if ( dir == cmd or exit.cmd == cmd or exit.handler ) and exit.to == to.id then -- if  exit has a handler and links to the target room, then consider it as reachable with the cmd
      -- message.debug( string.format( '可从“%s”的 %s 出口到达“%s”', from.id, dir, to.id ) )
      return true
    end
  end
  -- message.debug( string.format( '不可从“%s”到达“%s”', from.id, to.id ) )
end

-- check if a room can be reached from player's previous location with specified cmd
function map.is_reachable_from_prev_location_with_cmd( map_room, cmd )
  local prev_loc, is_reachable = map.get_current_location()
  if not prev_loc then return end
  for _, loc in pairs( prev_loc ) do
    is_reachable = is_room_reachable( loc, cmd, map_room )
    if is_reachable then break end
  end
  return is_reachable
end

--------------------------------------------------------------------------------
-- helper functions

-- list all map areas
function map.list_all_area()
  local result = {}
  for id, room in pairs( index ) do
    local a = room.area or string.gsub( id, room.name .. '#?[%w-]*$', '' )
    result[ a ] = true
  end
  -- tprint( result )
  return result
end

-- list all rooms that could have no exit (like 渡船)
function map.list_all_potentially_no_exit()
  local result = {}
  for id, room in pairs( index ) do
    local exit_count = 0
    for dir, exit in pairs( room.exit ) do
      if not exit.unstable and
         not exit.door and
       ( not string.find( dir, 'hidden' ) ) then
        exit_count = exit_count + 1 or exit_count
      end
    end
    if exit_count == 0 then
      result[ room.name ] = id
    end
  end
  return result
end

-- list all duplicate room ids
function map.list_duplicate_room_id()
  local t, result = {}, {}
  for id in pairs( index ) do
    if t[ id ] == nil then
      t[ id ] = true
    else
      result[ id ] = true
    end
  end
  if #result > 0 then
    tprint( result )
  else
    print '没有任何重复的房间 ID！'
  end
end

-- list all dead end exits
function map.list_all_deadend()
  local result = {}
  for _, room in pairs( index ) do
    for _, exit in pairs( room.exit ) do
      if index[ exit.to ] == nil then
        result[ exit.to ] = true
      end
    end
  end
  tprint( result )
end

-- list all rooms with multiple description
function map.list_all_multi_desc()
  local result = {}
  for id, room in pairs( index ) do
    if type( room.desc ) == 'table' then
      table.insert( result, id )
    end
  end
  tprint( result )
end

-- list all labels used in room exits, like no_wander, unstable
function map.list_all_exit_labels()
  local result = {}
  for _, room in pairs( index ) do
    for _, exit in pairs( room.exit ) do
      for k in pairs( exit ) do
        result[ k ] = true
      end
    end
  end
  tprint( result )
end

-- list all labels used in rooms, like name, desc
function map.list_all_room_labels()
  local result = {}
  for _, room in pairs( index ) do
    for k in pairs( room ) do
      result[ k ] = true
    end
  end
  tprint( result )
end

-- list all rooms with non standard exits
function map.list_all_nonst_exit_room()
  local temp, result = {}, {}
  for id, room in pairs( index ) do
    for dir, exit in pairs( room.exit ) do
      if not DIR_REVERSE[ dir ] then
        temp[ id ] = true
      end
    end
  end
  for id in pairs( temp ) do
    table.insert( result, id )
  end
  tprint( result )
  print( '共 ' .. #result .. ' 个房间有非标准出口')
end

-- list all non standard exit labels
function map.list_all_nonst_exit_labels()
  local result = {}
  for _, room in pairs( index ) do
    for dir in pairs( room.exit ) do
      if not DIR_REVERSE[ dir ] then
        result[ dir ] = true
      end
    end
  end
  tprint( result )
end

-- index rooms within each area
function map.generate_area_index()
  local area_list, result = map.list_all_area( index ), {}
  for area in pairs( area_list ) do
    result[ area ] = {}
    for id, room in pairs( index ) do
      if room.area == area then
        table.insert( result[ area ], id )
      end
    end
  end
  -- tprint( result )
  return result
end

-- how many rooms are there in the map?
function map.get_room_count()
  local result = 0
  for _ in pairs( index ) do
    result = result + 1
  end
  print( '地图数据中共 ' .. result .. ' 个房间' )
end

-- list rooms that couldn't be located with full current room info (name, desc, exits, area.) It's not a complete list since it doesn't handle directions like out2
function map.list_hard_to_locate_room()
  for longname, list in pairs( longname_index ) do
    local desc_index, same_desc_list = {}, {}
    for _, room in pairs( list ) do
      if type( room.desc ) == 'string' then -- rooms with multiple descriptions are always uniquely identifiable
        desc_index[ room.desc ] = desc_index[ room.desc ] or {}
        table.insert( desc_index[ room.desc ], room )
      end
    end
    for _, same_desc_room in pairs( desc_index ) do
      if #same_desc_room > 1 then table.insert( same_desc_list, same_desc_room ) end
    end
    local same_exit_list = {}
    for _, list in pairs( same_desc_list ) do
      local exit_index = {}
      for _, room in pairs( list ) do
        local fingerprint = ''
        for _, dir in ipairs( DIR_ALL ) do -- generate exit fingerprint for a room
          fingerprint = fingerprint .. ( room.exit[ dir ] and 'x' or '_' )
        end
        exit_index[ fingerprint ] = exit_index[ fingerprint ] or {}
        table.insert( exit_index[ fingerprint ], room )
      end
      for _, same_exit_room in pairs( exit_index ) do
        if #same_exit_room > 1 then table.insert( same_exit_list, same_exit_room ) end
      end
    end
    local same_exit_to_list = {}
    for _, list in pairs( same_exit_list ) do
      local exit_to_index = {}
      for _, room in pairs( list ) do
        local fingerprint = ''
        for _, dir in ipairs( DIR_ALL ) do -- generate exit to fingerprint for a room
          if room.exit[ dir ] then fingerprint = fingerprint .. index[ room.exit[ dir ].to ].name .. '-' end
        end
        exit_to_index[ fingerprint ] = exit_to_index[ fingerprint ] or {}
        table.insert( exit_to_index[ fingerprint ], room.id )
      end
      for _, same_exit_to_room in pairs( exit_to_index ) do
        if #same_exit_to_room > 1 then table.insert( same_exit_to_list, same_exit_to_room ) end
      end
    end
    tprint( same_exit_to_list )
  end
end

local exit_labels = {
  'to',
  'cost',
  'cmd',
  'door',
  'unstable',
  'ignore',
  'cond',
  'handler',
  'no_wander',
}

function map.serialize_room( room )
  room.area = room.area or ''
  room.id = room.area .. room.name
  local result = string.format( [=[
['%s'] = {
  id = '%s',
  area = '%s',
  name = '%s',
  desc = [[%s]],
  exit = {
]=], room.id, room.id, room.area, room.name, room.desc )
  for dir, exit in pairs( room.exit ) do
    result = result .. string.format( [[
    %s = { to = '%s', },
]], dir, room.area .. ( exit ~= true and exit or 'XXX' ) )
  end
  result = result .. [[
  },
},

]]
  return result
end

function map.serialize_map_room( room )
  local result = string.format( [[
['%s'] = {
  id = '%s',
  area = '%s',
  name = '%s',
  use_cond = '%s',
  desc = ]], room.id, room.id, room.area, room.name, room.use_cond or '' ) ..
  ( type( room.desc ) == 'string' and
  string.format( [=[ [[%s]],]=], room.desc ) or
  string.format( [=[{ [[%s]], [[%s]] },]=], room.desc[ 1 ], room.desc[ 2 ] ) ) ..
  [[

  exit = {
]]
  for dir, exit in pairs( room.exit ) do
    result = result .. string.format( [[
    %s = { ]], dir )
    for _, label in pairs( exit_labels ) do
      if type( exit[ label ] ) == 'string' then
        result = result .. string.format( [[%s = '%s', ]], label, exit[ label ] )
      elseif exit[ label ] then
        result = result .. string.format( [[%s = %s, ]], label, tostring( exit[ label ] ) )
      end
    end
    result = result .. [[},
]]
  end
  result = result .. [[
  },
},

]]
  return result
end

function map.serialize_all( filename )
  local count = 0
  local file = io.open( CWD .. 'userdata/' .. filename, 'w' )
  local area_index = map.generate_area_index()
  file:write [[
local map = {

]]
  for area, list in pairs( area_index ) do
    for _, id in pairs( list ) do
      count = count + 1
      file:write( map.serialize_map_room( index[ id ] ) )
    end
  end
  file:write [[
}

return map
]]
  file:flush()
  file:close()
  print( '共序列化 ' .. count .. ' 个房间，已保存到“' .. CWD .. 'userdata/' .. filename .. '”文件中。' )
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return map
