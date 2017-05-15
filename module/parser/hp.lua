--------------------------------------------------------------------------------
-- This module parses hp info
--------------------------------------------------------------------------------

local function parse_line_1( _, t )
  player.jing = tonumber( t[ 1 ] )
  player.jing_perc = tonumber( t[ 3 ] )
  player.jing_max = math.ceil( tonumber( t[ 2 ] ) / player.jing_perc * 100 )
  player.jingli = tonumber( t[ 4 ] )
  player.jingli_max = tonumber( t[ 5 ] )
  player.jingli_limit = tonumber( t[ 6 ] )
  trigger.enable_group 'hp'
end

local function parse_line_2( _, t )
  player.qi = tonumber( t[ 1 ] )
  player.qi_perc = tonumber( t[ 3 ] )
  player.qi_max = math.ceil( tonumber( t[ 2 ] ) / player.qi_perc * 100 )
  player.neili = tonumber( t[ 4 ] )
  player.neili_max = tonumber( t[ 5 ] )
  player.jiali = tonumber( t[ 6 ] )
end

local function parse_line_3( _, t )
  player.shen = tonumber( ( t[ 1 ] == '戾' and '-' or '' ) .. ( string.gsub( t[ 2 ], ',', '' ) ) )
  player.neili_limit = tonumber( t[ 3 ] )
  player.neili_limit2 = tonumber( t[ 4 ] )
end

local function parse_line_4( _, t )
  player.food = tonumber( t[ 1 ] )
  player.pot = tonumber( t[ 2 ] )
  player.pot_max = tonumber( t[ 3 ] )
  player.level = player.pot_max - 100
end

local function parse_line_5( _, t )
  player.water = tonumber( t[ 1 ] )
  player.exp = tonumber( ( string.gsub( t[ 2 ], ',', '' ) ) )
  player.exp_perc = tonumber( t[ 3 ] )
  player.hp_update_time = os.time()
  trigger.disable_group 'hp'
  event.new 'hp'
end

trigger.new{ name = 'hp1', match = '^·精血·\\s*(\\d+)\\s*/\\s*(\\d+)\\s*\\(\\s*(\\d+)%\\)\\s*·精力·\\s*(\\d+)\\s*/\\s*(\\d+)\\s*\\((\\d+)\\)$', func = parse_line_1, enabled = true }
trigger.new{ name = 'hp2', match = '^·气血·\\s*(\\d+)\\s*/\\s*(\\d+)\\s*\\(\\s*(\\d+)%\\)\\s*·内力·\\s*(\\d+)\\s*/\\s*(\\d+)\\s*\\(\\+(\\d+)\\)$', func = parse_line_2, group = 'hp' }
trigger.new{ name = 'hp3', match = '^·(正|戾)气·\\s*(\\S+)\\s*·内力上限·\\s*(\\d+)\\s*/\\s*(\\d+)$', func = parse_line_3, group = 'hp' }
trigger.new{ name = 'hp4', match = '^·食物·\\s+(\\d+)\\.\\d+%\\s+·潜能·\\s*(\\d+)\\s*/\\s*(\\d+)$', func = parse_line_4, group = 'hp' }
trigger.new{ name = 'hp5', match = '^·饮水·\\s+(\\d+)\\.\\d+%\\s+·经验·\\s*(\\S+)\\s*\\((\\d+)\\.\\d+%\\)$', func = parse_line_5, group = 'hp' }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
