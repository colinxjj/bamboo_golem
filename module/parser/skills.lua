--------------------------------------------------------------------------------
-- This module parses skills info
--------------------------------------------------------------------------------

-- only moves data to player.skill when info is fully parsed.
local cache

local end_patt = any_but( lpeg.S '┌│├' )

local function parse_end()
  player.skill, cache = cache, nil -- move cache data to player.skill and clear cache
  player.skills_update_time = os.time()
  trigger.disable 'skills2'
  event.new 'skills'
end

local function parse_header( _, t )
  cache = {}
  player.skill_count = cntonumber( t[ 2 ] )
  trigger.enable 'skills2'
  trigger.new{ name = 'parser.skills_end', match = end_patt, func = parse_end, one_shot = true }
end

local sp = lpeg.P ' '^0
local cntext = lpeg.C( ( 1 - ( lpeg.S ' (' + lpeg.R 'az' + lpeg.R '09') )^1 )
local id = lpeg.C( ( lpeg.R 'az' + '-' )^1 )
local num = lpeg.C( lpeg.R '09'^1 )
local patt_skill = lpeg.Ct( sp * cntext * sp * '(' * id * ')' * sp * '→' * sp * cntext * sp * num * sp * '/' * sp * num )^1
local patt_type = sp * '『' * lpeg.C( 4 ) * '技能' * sp * cntext * sp * '种』'
local class

local function parse_content( _, t )
  local c = patt_type:match( t[ 1 ] )
  if c then
    class = c
  else
    c = { patt_skill:match( t[ 1 ] ) }
    for _, v in pairs( c ) do
      local is_enabled
      if string.sub( v[ 1 ], 1, 2 ) == '□' then
        v[ 1 ] = string.sub( v[ 1 ], 3 )
        is_enabled = true
      end
      cache[ v[ 1 ] ] = {
        name = v[ 1 ],
        id = v[ 2 ],
        knowledge_level = ( class == '杂项' or class == '职业' ) and KNOWLEDGE_LEVEL[ v[ 3 ] ] or nil,
        power_level = ( class == '基本' or class == '特殊' ) and POWER_LEVEL[ v[ 3 ] ] or nil,
        level = tonumber( v[ 4 ] ),
        exp = tonumber( v[ 5 ] ),
        class = class,
        is_enabled = is_enabled
      }
    end
  end
end

local function parse_empty()
  cache = {}
  player.skill_count = 0
  player.skills_update_time = os.time()
  player.skill, cache = cache, false -- move cache data to player.skill and clear cache
  event.new 'skills'
end

local function parse_levelup( _, t )
  local sk = player.skill[ t[ 2 ] ]
  if not sk then
    sk = {}
    sk.name, sk.level = t[ 2 ], 0
    player.skill[ t[ 2 ] ] = sk
  end
  sk.level = sk.level + 1
  sk.exp  = 0
end

trigger.new{ name = 'skills1', match = '^(> )*【你的技能表】：总共(\\S+)项技能', func = parse_header, enabled = true }
trigger.new{ name = 'skills2', match = '^│(.+)$', func = parse_content }

trigger.new{ name = 'skills0', match = '^(> )*你目前并没有学会任何技能。', func = parse_empty, enabled = true }

trigger.new{ name = 'skillsu', match = '^(> )*你的「(\\S+)」进步了！', func = parse_levelup, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
