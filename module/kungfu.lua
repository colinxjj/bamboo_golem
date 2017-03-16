
local kungfu = {}

--------------------------------------------------------------------------
-- This module handles kungfu related stuff
--------------------------------------------------------------------------

local index = require 'data.kungfu'

-- initialize based on player's current skills
function kungfu.initialize()
  player.skill_set = kungfu.get_best_skill_set( player.skill )
end

local function get_possible_skill_set( tbl )
  local set_list = {}
  for fname, force in pairs( tbl.force ) do
    for dname, dodge in pairs( tbl.dodge ) do
      if kungfu.is_compatible( force, dodge ) then
        for nname, attack in pairs( tbl.attack ) do
          if kungfu.is_compatible( force, attack ) and kungfu.is_compatible( dodge, attack ) then
            set_list[ #set_list + 1 ] = { force = fname, dodge = dname, attack = nname, parry = nname }
            for pname, parry in pairs( tbl.parry ) do
              if kungfu.is_compatible( attack, parry ) then
                set_list[ #set_list + 1 ] = { force = fname, dodge = dname, attack = nname, parry = pname }
              end
            end
          end
        end
      end
    end
  end
  return set_list
end

-- generate a skill set to use based a list of current skills
function kungfu.get_best_skill_set( list )
  local power, skill_set, category = {}, { force = {}, parry = {}, dodge = {}, attack = {} }
  for name, skill in pairs( list ) do
    if skill.class == '特殊' then
      power[ name ] = kungfu.get_skill_power( skill )
      category = kungfu.get_skill_category( skill.name )
      if category then skill_set[ category ][ name ] = skill end
    end
  end
  skill_set = get_possible_skill_set( skill_set )
  for _, set in pairs( skill_set ) do
    set.power = power[ set.force ] + power[ set.dodge ] + power[ set.attack ] + power[ set.parry ]
  end
  table.sort( skill_set, function( a, b ) return a.power > b.power end )
  for i = 1, 3 do
    if skill_set[ i ] then
      message.debug( ( '第 %d 最佳武功组合为：内功“%s”，轻功“%s”，外功“%s”，招架“%s”，评估得分：%.1f' ):format( i, skill_set[ i ].force, skill_set[ i ].dodge, skill_set[ i ].attack, skill_set[ i ].parry, skill_set[ i ].power ) )
      skill_set[ i ].power = nil
    end
  end
  return skill_set[ 1 ]
end

-- get the power value of a skill / function
local function get_power( lvl, tbl )
  for _, p in pairs( tbl or {} ) do
    if lvl >= p.from and lvl <= p.to then return p.power end
  end
  return 1
end

function kungfu.get_skill_power( skill )
  local iskill = index[ skill.name ]
  if not iskill or skill.class ~= '特殊' then return end -- only evaluate special skills with data
  -- evaluate base skill power
  local sk_power = get_power( skill.level, iskill.power )
  --print( '技能“' .. skill.name .. '”的基础强度为 ' .. sk_power )
  -- evalute skill function power
  local fn_power, fn_power_max
  for id, fn in pairs( iskill.fn or {} ) do
    if kungfu.is_function_usable( fn ) then
      -- evalute function's power
      fn_power = get_power( skill.level, fn.power )
      --print( '├─ 特殊功能“' .. fn.name .. '”可用，强度为 ' .. ( fn_power or 0 ) )
      if fn.type == 'powerup' then
        sk_power = sk_power + fn_power -- directly add powerup function's power to skill power
      else
        fn_power_max = ( not fn_power_max or fn_power > fn_power_max ) and fn_power or fn_power_max
      end
    end
  end
  -- add function's power to skill power
  sk_power = sk_power + ( fn_power_max or 0 )
  --print( '├综合强度为 ' .. sk_power )
  -- scale skill power based its level (and its base skill's level) compared to player level
  local base_skill = kungfu.get_player_skill_by_id( iskill.type )
  local base_level = base_skill and base_skill.level or 0
  sk_power = math.modf( sk_power * 5 * ( skill.level + base_level ) / player.level ) / 10
  --print( '└调整后强度为 ' .. sk_power )
  return sk_power
end

function kungfu.get_skill_category( name )
  assert( type( name ) == 'string', 'kungfu.get_skill_category - param must be a string' )
  local iskill = index[ name ]
  if not iskill then return end -- only evaluate skills with data
  local category = iskill.type ~= 'force' and iskill.type ~= 'dodge' and iskill.type ~= 'parry' and 'attack' or iskill.type
  --print( '技能“' .. name .. '”的类别为 ' .. category .. '\n' )
  return category
end

function kungfu.get_skill_type( name )
  assert( type( name ) == 'string', 'kungfu.get_skill_type - param must be a string' )
  local iskill = index[ name ]
  return iskill and iskill.type or nil
end

-- check if a skill function is usable
function kungfu.is_function_usable( fn )
  local is_usable
  -- evalute function's skill level, neili, and jingli requirements
  if player.neili_max >= ( fn.req.neili_max or 1 )
  and player.jingli_max >= ( fn.req.jingli or 1 ) then
    is_usable = true
    -- evalute function's addtional skill requirements
    for rname, rlevel in pairs( fn.req.skill or {} ) do
      if not player.skill[ rname ] or player.skill[ rname ].level < rlevel then is_usable = false break end
    end
    -- evalute function's player stats requirements
    for rstat, rvalue in pairs( fn.req.stat or {} ) do
      if player[ rstat ] < rvalue then is_usable = false break end
    end
  end
  return is_usable == true
end

function kungfu.get_player_skill_by_id( id )
  for _, skill in pairs( player.skill ) do
    if skill.id == id then return skill end
  end
end

-- check if two skills are compatible wit each other (can be used at the same time and doesn't block each other's function)
function kungfu.is_compatible( a, b )
  a, b = index[ a ] or index[ a.name ], index[ b ] or index[ b.name ]
  if not a or not b then return end
  local i = 1
  repeat
    local cpt_count, incpt_count = 0, 0
    for _, fn in pairs( a.fn or {} ) do
      local is_cpt = true
      for enable_type, enable_name in pairs( fn.req.enable or {} ) do
        local b_type = kungfu.get_skill_type( b.name )
        if enable_type == b_type and enable_name ~= b.name then is_cpt = false end
      end
      --print( a.name, '的', fn.name, '与', b.name, ( is_cpt and '' or '不' ) .. '兼容' )
      if is_cpt then
        cpt_count = cpt_count + 1
      else
        incpt_count = incpt_count + 1
      end
    end
    if cpt_count == 0 and incpt_count > 0 then return false end
    i = i + 1
    a, b = b, a
  until i > 2
  return true
end

function kungfu.get_dazuo_rate()
  local f, fl = player.enable.force.level, math.floor
  local rate = fl( 1 + fl( f / 15 ) * ( 1 + fl( f / 60 ) ) )
  rate = player.age < 20 and fl( rate + rate * ( 20 - player.age ) / 10 ) or rate
  rate = fl( rate * 1.5 )
  return rate
end

function kungfu.get_tuna_rate()
  local f, f2, fl = player.enable.force.level, ( player.skill['基本内功'] and player.skill['基本内功'].level or 0 ), math.floor
  local rate = fl( 1 + fl( f2 / 10 ) * ( 1 + fl( f / 100 ) ) )
  rate = player.age < 20 and fl( rate + rate * ( 20 - player.age ) / 10 ) or rate
  rate = fl( rate * 1.5 )
  return rate
end

--------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------

return kungfu
