--------------------------------------------------------------------------------
-- This module parses skills info
--------------------------------------------------------------------------------

-- only moves data to player.skill when info is fully parsed.
local cache

local end_patt = any_but( lpeg.S '������' )

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
local patt_skill = lpeg.Ct( sp * cntext * sp * '(' * id * ')' * sp * '��' * sp * cntext * sp * num * sp * '/' * sp * num )^1
local patt_type = sp * '��' * lpeg.C( 4 ) * '����' * sp * cntext * sp * '�֡�'
local class

local function parse_content( _, t )
  local c = patt_type:match( t[ 1 ] )
  if c then
    class = c
  else
    c = { patt_skill:match( t[ 1 ] ) }
    for _, v in pairs( c ) do
      local is_enabled
      if string.sub( v[ 1 ], 1, 2 ) == '��' then
        v[ 1 ] = string.sub( v[ 1 ], 3 )
        is_enabled = true
      end
      cache[ v[ 1 ] ] = {
        name = v[ 1 ],
        id = v[ 2 ],
        knowledge_level = ( class == '����' or class == 'ְҵ' ) and KNOWLEDGE_LEVEL[ v[ 3 ] ] or nil,
        power_level = ( class == '����' or class == '����' ) and POWER_LEVEL[ v[ 3 ] ] or nil,
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

local attr_tbl = { [ '�����ڹ�' ] = 'con', [ '�����Ṧ' ] = 'dex', [ '����д��' ] = 'int' }
local str_tbl = { [ '�����Ʒ�' ] = true, [ '�����ȷ�' ] = true, [ '�����ַ�' ] = true, [ '����צ��' ] = true, [ '����ȭ��' ] = true, [ '����ָ��' ] = true }

local function update_attr ( skill )
  if attr_tbl[ skill ] then
    local attr = attr_tbl[ skill ]
    player[ attr ] = player[ attr ] + 1
  elseif str_tbl[ skill ] then
    local highest = 0
    for sk_name in pairs( str_tbl ) do
      local level = player.skill[ sk_name ] and player.skill[ sk_name ].level or 0
      if level > highest then highest = level end
    end
    player.str = player.str_innate + math.floor( highest / 10 )
  end
end

local function parse_levelup( _, t )
  local name = t[ 2 ]
  player.skill[ name ] = player.skill[ name ] or { name = name, level = 0 }
  local skill = player.skill[ name ]
  skill.level = skill.level + 1
  skill.exp  = 0
  -- update player attributes when certain skills reach ??0 level
  if skill.level % 10 == 0 then update_attr( name ) end
end

trigger.new{ name = 'skills1', match = '^(> )*����ļ��ܱ����ܹ�(\\S+)���', func = parse_header, enabled = true }
trigger.new{ name = 'skills2', match = '^��(.+)$', func = parse_content }

trigger.new{ name = 'skills0', match = '^(> )*��Ŀǰ��û��ѧ���κμ��ܡ�', func = parse_empty, enabled = true }

trigger.new{ name = 'skillsu', match = '^(> )*��ġ�(\\S+)�������ˣ�', func = parse_levelup, enabled = true }
-- TODO ������˻����Ṧ��

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
