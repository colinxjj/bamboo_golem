
local locator = {}

--------------------------------------------------------------------------------
-- This module contains helper funcs for locating player
--------------------------------------------------------------------------------

function locator.is_area_same( this_room, map_room )
  return this_room.area == map_room.area
end

-- compare if two rooms match based their exits
function locator.is_exit_match( this_room, map_room, index )
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
function locator.is_desc_same( this_room, map_room )
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
function locator.is_adjacent_to_prev_location( map_room, range )
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
    if ( dir == cmd or exit.cmd == cmd ) and exit.to == to.id then
      -- message.debug( string.format( '可从“%s”的 %s 出口到达“%s”', from.id, dir, to.id ) )
      return true
    end
  end
  -- message.debug( string.format( '不可从“%s”到达“%s”', from.id, to.id ) )
end

-- check if a room can be reached from player's previous location with specified cmd
function locator.is_reachable_from_prev_location_with_cmd( map_room, cmd )
  local prev_loc, is_reachable = map.get_current_location()
  if not prev_loc then return end
  for _, loc in pairs( prev_loc ) do
    is_reachable = is_room_reachable( loc, cmd, map_room )
    if is_reachable then break end
  end
  return is_reachable
end


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return locator
