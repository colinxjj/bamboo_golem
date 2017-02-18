
local helper = {}

--------------------------------------------------------------------------------
-- This module contains helper functions to manipulate / verify map data
--------------------------------------------------------------------------------

-- list all map areas
function helper.list_all_area( index )
  local result = {}
  for id, room in pairs( index ) do
    local a = room.area or string.gsub( id, room.name .. '#?[%w-]*$', '' )
    result[ a ] = true
  end
  -- tprint( result )
  return result
end

-- list all rooms that could have no exit (like 渡船)
function helper.list_all_potentially_no_exit( index )
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
function helper.list_duplicate_room_id( index )
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
function helper.list_all_deadend( index )
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
function helper.list_all_multi_desc( index )
  local result = {}
  for id, room in pairs( index ) do
    if type( room.desc ) == 'table' then
      table.insert( result, id )
    end
  end
  tprint( result )
end

-- list all labels used in room exits, like no_wander, unstable
function helper.list_all_exit_labels( index )
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
function helper.list_all_room_labels( index )
  local result = {}
  for _, room in pairs( index ) do
    for k in pairs( room ) do
      result[ k ] = true
    end
  end
  tprint( result )
end

-- list all rooms with non standard exits
function helper.list_all_nonst_exit_room( index )
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
function helper.list_all_nonst_exit_labels( index )
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
function helper.generate_area_index( index )
  local area_list, result = helper.list_all_area( index ), {}
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
function helper.get_room_count( index )
  local result = 0
  for _ in pairs( index ) do
    result = result + 1
  end
  print( '地图数据中共 ' .. result .. ' 个房间' )
end

-- list rooms that couldn't be located with full current room info (name, desc, exits, area.) It's not a complete list since it doesn't handle directions like out2
function helper.list_hard_to_locate_room( index )
  local longname_index = helper.generate_longname_index( index )
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

function helper.serialize_room( room )
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

function helper.serialize_map_room( room )
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

function helper.serialize_all( index, filename )
  local count = 0
  local file = io.open( CWD .. 'userdata/' .. filename, 'w' )
  local area_index = helper.generate_area_index( index )
  file:write [[
local map = {

]]
  for area, list in pairs( area_index ) do
    for _, id in pairs( list ) do
      count = count + 1
      file:write( helper.serialize_map_room( index[ id ] ) )
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

function helper.generate_name_index( index )
  local result, name = {}
  for _, room in pairs( index ) do
    name = room.name
    result[ name ] = result[ name ] or {}
    table.insert( result[ name ], room )
  end
  return result
end

function helper.generate_longname_index( index )
  local result, longname = {}
  for _, room in pairs( index ) do
    longname = room.area .. room.name
    result[ longname ] = result[ longname ] or {}
    table.insert( result[ longname ], room )
  end
  return result
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return helper
