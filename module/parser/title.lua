--------------------------------------------------------------------------------
-- This module parses title info
--------------------------------------------------------------------------------

local function parse_title( _, t )
  player.title = remove_space( t[ 2 ] )
  player.title2 = t[ 3 ]
  player.name = extract_name( t[ 5 ] )
  player.id = string.lower( t[ 6 ] )
  event.new 'title'
end

trigger.new{ name = 'title', match = '^(> )*¡¾(.+)¡¿(\\S+)( |¡¸)(\\S+)\\((\\w+)\\)$', func = parse_title, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
