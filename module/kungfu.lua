
local kungfu = {}

--------------------------------------------------------------------------------
-- This module handles kungfu related stuff
--------------------------------------------------------------------------------

local index = require 'data.kungfu'

-- compile source cond to functions
do
  local cond_checker = {} -- for memoization
  for _, skill in pairs( index ) do
    if skill.source then
      for _, source in pairs( skill.source ) do
        if source.cond then
          local f = cond_checker[ source.cond ] or loadstring( 'return ' .. source.cond )
	        if not f then error( 'error compiling function for skill source cond: ' .. source.cond ) end
	        cond_checker[ source.cond ], source.cond = f, f
        end
      end
    end
  end
end

-- add skill sources based on item data (books only), and compile their cond to functions
do
  local list = item.get_all 'book'
  local cond_checker = {} -- for memoization
  for _, it in pairs( list ) do
    if it.skill then
      local cond = ( 'return %splayer.exp >= %d and player.int >= %d' ):format( it.cond and ( it.cond .. ' and ' ) or '', it.read.exp_required or 0, it.read.difficulty or 0 )
      local f = cond_checker[ cond ] or loadstring( cond )
      if not f then error( 'error compiling function for skill source cond: ' .. cond ) end
      cond_checker[ cond ] = f
      local source = { item = it.iname, min = it.skill.min, max = it.skill.max, cost = it.read.cost, cmd = it.read.cmd, cond = f }
      local skill = index[ it.skill.name ]
      skill.source = skill.source or {}
      table.insert( skill.source, source )
    end
  end
end

--------------------------------------------------------------------------------

local force_trigger_list = { 'dazuo_start', 'dazuo_end', 'dazuo_halt', 'heal_start', 'heal_halt' }

local function setup_force_trigger( enabled )
  local skill = index[ enabled.force and enabled.force.skill or '' ] or {}
  local default = index.default_force
  for _, trigger_name in pairs( force_trigger_list ) do
    local msg_name = trigger_name .. '_msg'
    local match = '^(> )*' .. ( skill[ msg_name ] or default[ msg_name ] )
    --print( trigger_name .. ': ' .. match )
    trigger.update{ name = trigger_name, match = match }
  end
  local match = ( '^(> )*(%s|%s)' ):format( skill.heal_finish_msg or default.heal_finish_msg, skill.heal_unfinish_msg or default.heal_unfinish_msg )
  --print( 'heal_end: ' .. match )
  trigger.update{ name = 'heal_end', match = match }
end

-- initialize based on player's current skills
function kungfu.initialize()
  player.best_skill_set = kungfu.get_best_skill_set( player.skill )
  setup_force_trigger( player.enable )
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
      --message.debug( ( '第 %d 最佳武功组合为：内功“%s”，轻功“%s”，外功“%s”，招架“%s”，评估得分：%.1f' ):format( i, skill_set[ i ].force, skill_set[ i ].dodge, skill_set[ i ].attack, skill_set[ i ].parry, skill_set[ i ].power ) )
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

--------------------------------------------------------------------------------

function kungfu.get_dazuo_rate()
  if not player.enable.force then return 0 end
  local f, fl = player.enable.force.level, math.floor
  local rate = fl( 1 + fl( f / 15 ) * ( 1 + fl( f / 60 ) ) )
  rate = player.age < 20 and fl( rate + rate * ( 20 - player.age ) / 10 ) or rate
  rate = fl( rate * 1.5 )
  return rate
end

function kungfu.get_tuna_rate()
  if not player.enable.force then return 0 end
  local f, f2, fl = player.enable.force.level, ( player.skill['基本内功'] and player.skill['基本内功'].level or 0 ), math.floor
  local rate = fl( 1 + fl( f2 / 10 ) * ( 1 + fl( f / 100 ) ) )
  rate = player.age < 20 and fl( rate + rate * ( 20 - player.age ) / 10 ) or rate
  rate = fl( rate * 1.5 )
  return rate
end

function kungfu.get_min_dazuo_value()
  return player.qi_max > 1000 and math.floor( player.qi_max / 5 ) or 10
end

local function get_best_multiple( base, lower, upper )
  lower, upper = lower or -math.huge, upper or math.huge
  local multiple
  for i = 1, math.huge do
    multiple = base * i
    if multiple >= lower and multiple <= upper then return multiple end
  end
end

function kungfu.get_best_dazuo_value( target, lower_only )
  local gap = target - player.neili
  assert( gap > 0, 'kungfu.get_best_dazuo_value - dazuo neili target must be greater than current neili' )
  local min, max = kungfu.get_min_dazuo_value(), player.qi - 10 -- always leave at least 10 qi to avoid death by illness
  local tick, best_val = kungfu.get_dazuo_rate()
  -- calculate best value
  local count = math.ceil( gap / tick ) - ( lower_only and 1 or 0 )
  for i = 1, count do
    local val = tick * i
    if val >= min and val <= max then best_val = val end
  end
  -- calculate alt value
  local alt_val = get_best_multiple( tick, gap )
  alt_val = alt_val <= max and alt_val or max
  alt_val = alt_val >= min and alt_val or get_best_multiple( tick, min, max ) or min

  return best_val or alt_val
end

function kungfu.get_current_total_converted_jing()
  local lvl = player.enable.force and player.enable.force.level or 0
  local total_jing = math.floor( player.neili * ( lvl / 100 ) + player.jing )
  return total_jing
end

-- if tuna X value, will player (with yun jing) be able to dazuo after tuna?
function kungfu.is_tuna_value_safe_for_subsequent_dazuo( val )
  local total_jing = kungfu.get_current_total_converted_jing()
  return total_jing - val >= player.jing_max * 0.7
end

function kungfu.get_best_tuna_value( target, lower_only )
  local gap = target - player.jingli
  assert( gap > 0, 'kungfu.get_best_tuna_value - tuna jingli target must be greater than current jingli' )
  local min, max = 10, player.jing - 10 -- always leave at least 10 jing to avoid death by illness
  local tick, best_val = kungfu.get_tuna_rate()
  -- calculate best value
  local count = math.ceil( gap / tick ) - ( lower_only and 1 or 0 )
  for i = 1, count do
    local val = tick * i
    if val >= min and val <= max then best_val = val end
  end
  -- calculate alt value
  local alt_val = get_best_multiple( tick, gap )
  alt_val = alt_val <= max and alt_val or max
  alt_val = alt_val >= min and alt_val or get_best_multiple( tick, min, max ) or min

  -- if there won't be enough jing to dazuo after tuna, then adjust tuna value
  if not kungfu.is_tuna_value_safe_for_subsequent_dazuo( best_val or alt_val ) then
    best_val = math.floor( kungfu.get_current_total_converted_jing() - player.jing_max * 0.7 )
    if best_val < min or best_val > max then best_val, alt_val = nil end
  end

  return best_val or alt_val
end

function kungfu.has_enough_qi_for_dazuo()
  if player.qi_max > 1000 then
    return player.qi / player.qi_max >= 0.2
  else
    return player.qi >= 10
  end
end

function kungfu.is_dazuo_positive_loop()
  return player.enable.force and player.enable.force.level >= 150
end

--------------------------------------------------------------------------------

function kungfu.get_all_source( skill )
  return index[ skill ] and index[ skill ].source
end

local function calculate_source_score( source )
	local score = 0
  --print( '\n' .. source.location )

  -- efficiency score, based on attr, gain, and cost
  local efficiency = ( source.attr and player[ source.attr ] or 20 ) * 10
  local total_cost = 0
  for attr, cost in pairs( source.cost ) do total_cost = total_cost + cost end
  efficiency = efficiency / total_cost * ( source.gain or 1 )
  score = score + efficiency
  --print( 'efficiency score: ' .. efficiency )

  -- distance score
  if source.location then
    local loc = map.get_current_location()[ 1 ]
    local path_cost = map.get_cost( loc, source.location )
    -- give inaccessible sources a very low score
  	if not path_cost then return -1000000 end
    score = score - path_cost * 0.01
    --print( 'distance score: -' .. path_cost * 0.01 )
  end

  -- capacity score, i.e. the ratio of cost / attribute_max
  local capacity, max, count = math.huge
  for attr, cost in pairs( source.cost ) do
    max = player[ attr .. '_max' ]
    max = max > 0 and max or 1
    count = max / cost
    capacity = count < capacity and count or capacity
  end
  score = score + capacity * 0.01
  --print( 'capacity score: ' .. capacity * 0.01 )

  --print( 'total score: ', score )
  return score
end

local function sort_by_score( a, b )
	return a.score > b.score
end

function kungfu.get_best_source( skill )
  -- filtering sources by skill level
  local lvl = player.skill[ skill ] and player.skill[ skill ].level or 0
  local slist = {}
  for _, source in pairs( index[ skill ].source ) do
    if source.min <= lvl and lvl <= source.max then
      source.score = calculate_source_score( source ) -- calculate source scores
      if source.score > -1000 and ( not source.cond or source.cond() ) then slist[ #slist + 1 ] = source end
    end
  end

  -- sorting sources by scores
  table.sort( slist, sort_by_score )

  --tprint( slist )
  return slist[ 1 ]
end

function kungfu.is_valid_source( skill, source )
  local lvl = player.skill[ skill ] and player.skill[ skill ].level or 0
  return source.min <= lvl and lvl <= source.max
end

--------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------

return kungfu
