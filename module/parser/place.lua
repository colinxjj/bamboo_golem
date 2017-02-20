--------------------------------------------------------------------------------
-- This module parses place info
--------------------------------------------------------------------------------

local room

local function parse_header( _, t )
  room = map.get_current_room()
  room = ( not room or room.name ~= t[ 1 ] ) and { name = t[ 1 ], exit = {} } or room
  trigger.enable_group 'place'
end

local roomname = lpeg.C( any_but( ' ', '(' )^1 )
local dir = ( lpeg.R'AZ' + lpeg.R'az' )^1 / string.lower
local part = ( roomname * '(' * dir * ')' )^1
local patt = ( any_but( part )^0 * part )^1

local function parse_content( _, t )
  t = { patt:match( t[ 0 ] ) }
  for i = 1, #t / 2 do
    room.exit[ t[ i * 2 ] ] = string.gsub( t[ i * 2 - 1 ], '..�棺' , '' )
  end
end

local function parse_footer()
  trigger.disable_group 'place'
  event.new{ event = 'place', data = room }
  room = nil
end

trigger.new{ name = 'place1', match = '^������(\\S+)������\\S+�����ڣ��ֱ�ͨ����', func = parse_header, enabled = true }
trigger.new{ name = 'place2', match = '^.+$', func = parse_content, group = 'place' }
trigger.new{ name = 'place3', match = '^���������������������������������������������������� SJ ����$', func = parse_footer, group = 'place', sequence = 99 }

trigger.new{ name = 'place0', match = '^(> )*����û���κ����Եĳ�·��$', func = parse_footer, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
