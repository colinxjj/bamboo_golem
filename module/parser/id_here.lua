--------------------------------------------------------------------------------
-- This module parses id here info
--------------------------------------------------------------------------------

-- FIXME this parser doesn't really work

local function parse_prompt()
  trigger.disable 'id_here2'
  event.new 'id here'
end

local function parse_header()
  cache = {}
  trigger.enable 'id_here2'
  event.listen{ event = 'prompt', func = parse_prompt, id = 'parser.id_here' }
end

local idchar = lpeg.R 'az' + lpeg.S ' _-\''
local seperator = lpeg.P ', ' + -1
local patt = ( lpeg.C( idchar^1 ) * seperator )^1

local function parse_content( _, t )
  local name, ids = t[ 1 ], { patt:match( t[ 2 ] ) }
  cache[ name ] = cache[ name ] or {}
  local item = cache[ name ]
  item.count = item.count and item.count + 1 or 1
  item.sequence = tonumber( t[ 1 ] )
  item.id = item.id or ids[ 1 ]
  item.alternate_id = ids
end

trigger.new{ name = 'id_here1', match = '^(> )*在这个房间中, 生物及物品的\\(英文\\)名称如下：$', func = parse_header, enabled = true }
trigger.new{ name = 'id_here2', match = '^(\\S+) = ([\\w\\s\',-]+)$', func = parse_content }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
