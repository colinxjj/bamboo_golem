--------------------------------------------------------------------------------
-- This module parses set info
--------------------------------------------------------------------------------

local cache

local function parse_prompt()
  player.set, cache = cache, nil -- move cache data to player.set and clear cache
  trigger.disable 'set2'
  event.new 'set'
end

local function parse_header ( _, t )
  cache = {}
  trigger.enable 'set2'
  event.listen{ event = 'prompt', func = parse_prompt, id ='parser.set' }
end

local function parse_content( _, t )
  cache[ t[ 1 ] ] = t[ 2 ]
end

local function parse_set( _, t )
  player.set[ t[ 2 ] ] = t[ 3 ]
  event.new 'set'
end

local unset_patt = lpeg.P 'unset ' * lpeg.C( lpeg.P( 1 )^1 )

local function parse_unset( _, t )
  local c = cmd.get_last()
  if not c then return end
  c = unset_patt:match( c.cmd )
  if not c then return end
  player.set[ c ] = nil
  event.new 'set'
end

trigger.new{ name = 'set1', match = '^(> )*你目前设定的环境变量有：$', func = parse_header, enabled = true }
trigger.new{ name = 'set2', match = '^(\\S+)\\s*"?([^"]*)"?$', func = parse_content }

trigger.new{ name = 'set', match = '^(> )*设定环境变量：(\\S+) = "?([^"]*)"?$', func = parse_set, enabled = true }
trigger.new{ name = 'unset', match = '^(> )*Ok\\.$', func = parse_unset, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
