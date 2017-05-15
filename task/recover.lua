
local task = {}

--------------------------------------------------------------------------------
-- Recover
--[[----------------------------------------------------------------------------
Params:
all, neili, jingli, jing, qi = 'double', 'full', 'half', 'a_little', 'best_effort' (neili only), 900 -- one or more of these params set to one of the valid recover levels or a exact number. 'all' covers all four attributes, but its value will be overridden by individual values if any is set. Only neili and jingli support the 'double' recover level (required)
food = 'full', 'half', 'a_little', -- 'all' doesn't cover this and it needs to be set explicitly (optional)
water = 'double', 'full', 'half', 'a_little', 'all' doesn't cover this and it needs to be set explicitly (optional)
stay_here = true -- should player stay where he/she is during the recover process? (optional, default: false)
maximize_organic_recovery = true -- keep attributes from being full whenever possbile, to maximize organic recovery (optional, default: false)
target_updater = a_func -- a function to dynamically update the target parameters whenever the task is resumed (optional)
----------------------------------------------------------------------------]]--

task.class = 'recover'

local valid_param = { all = true, jing = true, jingli = true, qi = true, neili = true, food = true, water = true }

local function get_param_string( self )
  local s = ''
  for param in pairs( valid_param ) do
    if self[ param ] then s = s .. param .. ' ' .. self[ param ] .. ', ' end
  end
  s = string.gsub( s, ', $', '' )
  return s
end

function task:get_id()
  return 'recover: ' .. get_param_string( self )
end

local all_attr = { 'jing', 'qi', 'jingli', 'neili', 'food', 'water' }
local convertable_attr = { 'jing', 'qi', 'jingli' }

local function validate_recover_param( self )
  for _, attr in pairs( all_attr ) do
    local tgt, max = self[ attr ], player[ attr .. '_max' ] or 100
    -- convert 'all' param to individual params
    if self.all and not tgt and attr ~= 'food' and attr ~= 'water' then self[ attr ] = self.all end
    -- incompatible best_effort option?
    if tgt == 'best_effort' and attr ~= 'neili' then
      message.warning( '属性 ' .. attr .. ' 不支持 ' .. tgt .. ' 恢复目标' )
      self:fail()
    -- task fails if targets exceed what is achievable
    elseif ( ( attr == 'qi' or attr == 'jing' or attr == 'food' ) and tgt == 'double' ) or ( type( tgt ) == 'number' and ( tgt > max * 2 or ( ( attr == 'qi' or attr == 'jing' or attr == 'food' ) and tgt > max ) ) ) then
      message.warning( '恢复任务失败：' .. attr .. ' 恢复目标 ' .. tgt .. ' 超出了能达到的上限' )
      self:fail()
    end
  end
end

local function has_reached_target( self, attr )
  local tgt, val, max = self[ attr ], player[ attr ], player[ attr .. '_max' ] or 100
  if max == 0 then return true end
  local pct = val / max
  return not tgt
      or ( tgt == 'best_effort' and player.qi < kungfu.get_min_dazuo_value() )
      or ( ( tgt == 'double' or tgt == 'best_effort' ) and pct >= 1.8 )
      or ( tgt == 'full' and pct >= 0.9 )
      or ( tgt == 'half' and pct >= 0.4 )
      or ( tgt == 'a_little' and pct >= 0.1 )
      or ( type( tgt ) == 'number' and val >= tgt )
end

local function has_reached_all_target( self )
  for _, attr in pairs( all_attr ) do
    if not has_reached_target( self, attr ) then return false end
  end
  return true
end

local function is_full( attr )
  local val, max = player[ attr ], player[ attr .. '_max' ]
  return val / max > 0.95 or max - val < 10
end

local function is_eat_needed( self )
  return ( player.food < 90 and self.food == 'full' )
      or ( player.food < 40 and self.food == 'half' )
      or ( player.food < 10 and self.food == 'a_little' )
end

local function is_drink_needed( self )
  return ( player.water < 180 and self.water == 'double' )
      or ( player.water < 90 and self.water == 'full' )
      or ( player.water < 40 and self.water == 'half' )
      or ( player.water < 10 and self.water == 'a_little' )
end

local function is_heal_needed( self )
  return player.qi_perc < 100
end

local function is_sleep_needed( self )
  -- sleep if pending_sleep is set (to avoid aborted sleep attempt after arriving at the sleep room because of updated hp info in the process of going to the sleep room)
  if self.pending_sleep then return true end
  -- don't sleep if last sleep is less than 3 minutes ago
  if has_recently_slept() then return false end
  -- don't sleep if stay_here is set and we can't sleep at the current room
  local is_in_sleep_room = room.get().label and room.get().label.sleep
  if self.stay_here and player.party ~= '丐帮' and not is_in_sleep_room then return false end
  -- if not enough jing to dazuo and no neili to recover it
  if player.neili < 20 and player.jing / player.jing_max < 0.7 then return true end
  -- if qi is depleted and no neili, or no positive loop dazuo, go to sleep
  if not kungfu.has_enough_qi_for_dazuo() and ( not kungfu.is_dazuo_positive_loop() or player.neili < 20 ) then return true end
end

local function is_exert_needed( self )
  if player.neili < 20 then return false end
  for _, attr in pairs( convertable_attr ) do
    if not has_reached_target( self, attr ) and not is_full( attr ) then return true end
    if attr == 'qi' and not is_full 'qi' and kungfu.is_dazuo_positive_loop() and not has_reached_target( self, 'neili' ) then return true end
    if attr == 'jing' then
      if not has_reached_target( self, 'jingli' ) then
        if not is_full 'jing' and is_full 'jingli' then return true end
        if player.jing < player.jing_max * 0.7 and player.qi >= kungfu.get_min_dazuo_value() then return true end
      end
      if not has_reached_target( self, 'neili' ) and player.jing < player.jing_max * 0.7 then return true end
    end
  end
end

local function is_tuna_needed( self )
  -- if not enough qi or jing, don't tuna
  if player.qi / player.qi_max < 0.7 or player.jing < 10 then return false end
  -- if there won't be enough jing to dazuo even after yun jing, don't tuna
  if not kungfu.is_tuna_value_safe_for_subsequent_dazuo( 10 ) then return false end
  -- tuna when maxmized organic recovery is wanted and conditions are met
  if self.maximize_organic_recovery and not self.jing and self.jingli and player.jing - kungfu.get_tuna_rate() >= player.jing_max * 0.7 then return true end
  -- tuna only if jingli is full or force level is so low that yun jingli is inefficient (otherwise yun jingli with neili is more efficient)
  if not has_reached_target( self, 'jingli' ) and ( is_full 'jingli' or player.enable.force.level < 100 ) then return true end
end

local function is_dazuo_needed( self )
  -- if not enough qi or jing, don't dazuo
  if player.jing / player.jing_max < 0.7 or player.qi < kungfu.get_min_dazuo_value() then return false end
  if not has_reached_target( self, 'neili' ) then return true end
  for _, attr in pairs( convertable_attr ) do
    if self[ attr ] and not has_reached_target( self, attr ) and not is_full( attr ) and player.neili < 20 then return true end
  end
end

function task:_resume()
  -- update target parameters if an updater is provided
  if self.target_updater then self:target_updater() end
  -- check if param values are valid and convert the "all" param
  if not self.is_param_validated then
    validate_recover_param( self )
    self.is_param_validated = true
  end
  -- update hp as needed
  if not self.has_updated_hp then
    self.has_updated_hp = true
    self:newsub{ class = 'get_info', hp = true }
    return
  end
  -- if all targets have been reached then complete
  if has_reached_all_target( self ) then self:complete() return end
  -- evaluate each type of action in order
  local is_action_skipped = true
  if is_eat_needed( self ) or is_drink_needed( self ) then
    is_action_skipped = self:eat_drink()
  elseif is_heal_needed( self ) then
    is_action_skipped = self:heal()
  elseif is_sleep_needed( self ) then
    is_action_skipped = self:go_to_sleep()
  elseif player.enable.force and is_exert_needed( self ) then
    is_action_skipped = self:exert()
  elseif player.enable.force and is_tuna_needed( self ) then
    is_action_skipped = self:tuna()
  elseif player.enable.force and is_dazuo_needed( self ) then
    is_action_skipped = self:dazuo()
  end
  -- if no action is possbile at the moment, wait
  if is_action_skipped then
    self.has_updated_hp = false
    self:newsub{ class = 'kill_time', duration = 20, idle_only = true }
  end
end

function task:_complete()
  if player.set[ '积蓄' ] then cmd.new{ 'unset 积蓄' } end
  message.debug( '完成恢复任务：' .. get_param_string( self ) )
end

local function food_source_evaluator( source )
  local it = item.get( source.item )
  local food_supply = ( it.consume_count or 1 ) * it.food_supply * 0.5
  local gap = 100 - player.food
  -- demote food with excessive supply
  if food_supply > gap then
    -- demote more for shop food and less for others
    if source.type == 'shop' then
      return ( gap - food_supply ) * 0.5
    else
      return ( gap - food_supply ) * 0.3
    end
  end
end

local function drink_source_evaluator( source )
  if source.item == '乳酪' then
    -- if food and water levels are both low, 乳酪 is a more attractive choice
    if player.food < 50 and player.water < 50 then return 20 end
    -- if food or water level is above 100, then completely ignore 乳酪
    if player.food >= 100 or player.water >= 100 then return -1000000 end
  end
end

function task:eat_drink()
  local choice
  if is_eat_needed( self ) and not is_drink_needed( self ) then
    choice = 'food'
  elseif is_drink_needed( self ) and not is_eat_needed( self ) then
    choice = 'drink'
  else
    local curr_loc = map.get_current_location()[ 1 ].id
    local best_food_source = item.get_best_source{ item = 'food', source_evaluator = food_source_evaluator, is_quality_ignored = true }
    local best_drink_source = item.get_best_source{ item = 'drink', source_evaluator = drink_source_evaluator, is_quality_ignored = true }
    -- if no source available, task fails
    if not best_food_source or not best_drink_source then self:fail() end
    choice = ( best_food_source.location == curr_loc and 'food' )
          or ( best_drink_source.location == curr_loc and 'drink' )
          or ( best_food_source.score > best_drink_source.score and 'food' )
          or 'drink'
  end
  self:newsub{ class = 'get_item', item = ( choice == 'drink' and self.water == 'double' and '双倍清水' or choice ), source_evaluator = ( choice == 'food' and food_source_evaluator or drink_source_evaluator ), is_quality_ignored = true, complete_func = task.consume }
end

function task:consume( name )
  self.has_updated_hp = false
  if name == '清水' or name == '双倍清水' then
    self:resume()
  else
    self:newsub{ class = 'manage_inventory', action = 'consume', item = name }
  end
end

local function is_self_heal_best_choice()
  -- if can't self heal, return false
  if player.neili_max < 200 or player.qi_perc <= 33 or not player.enable.force or player.enable.force.level < 50 or not player.skill[ '本草术理' ] or player.skill[ '本草术理' ].level < 30 then return false end
  -- if qi percentage is lower than config threshold, return false
  --if player.qi_perc < config.get 'self_heal_threshold' then return false end
  return true
end

local function convert_tgt_to_num( self, attr )
  local tgt, max = self[ attr ], player[ attr .. '_max' ]
  return ( not tgt and 0 )
      or ( type( tgt ) == 'number' and tgt )
      or ( ( tgt == 'double' or tgt == 'best_effort' ) and max * 2 )
      or ( tgt == 'full' and max )
      or ( tgt == 'half' and max * 0.5 )
      or ( tgt == 'a_little' and max * 0.1 )
end

function task:heal()
  if is_self_heal_best_choice() then -- yun heal
    -- if no neili, then recover neili first
    if player.neili < 50 then
      self.neili = convert_tgt_to_num( self, 'neili' ) < 50 and 'half' or self.neili
      return true
    end
    self:listen{ event = 'heal_end', func = self.resume, id = 'task.recover' }
    self.has_updated_hp = false
    self:send{ 'yun heal' }
  else
    -- TODO other ways to heal
  end
end

function task:exert()
  local c = {}
  for _, attr in pairs( convertable_attr ) do
    if ( self[ attr ] and not has_reached_target( self, attr ) and not is_full( attr ) )
    or ( attr == 'qi' and not is_full 'qi' and kungfu.is_dazuo_positive_loop() and not has_reached_target( self, 'neili' ) )
    or ( attr == 'jing' and not has_reached_target( self, 'jingli' ) and not is_full 'jing' and is_full 'jingli' )
    or ( attr == 'jing' and not has_reached_target( self, 'jingli' ) and player.jing < player.jing_max * 0.7 and player.qi >= kungfu.get_min_dazuo_value() )
    or ( attr == 'jing' and not has_reached_target( self, 'neili' ) and player.jing < player.jing_max * 0.7 ) then
      c[ #c + 1 ] = 'yun ' .. attr
    end
  end
  c.complete_func = self.resume
  self.has_updated_hp = false
  self:send( c )
end

local function is_valid_sleep_room( room )
  if room.label and room.label.sleep then
    return room.label.sleep == true or room.label.sleep == player.party
  end
end

function task:go_to_sleep()
  if map.is_at_sleep_loc() then
    self:listen{ event = 'sleep_end', func = self.resume, id = 'task.recover' }
    self.has_updated_hp, self.pending_sleep = false, false
    self:send{ 'sleep' }
  else
    local loc = map.get_current_location()[ 1 ]
    local dest = map.find_nearest( loc, is_valid_sleep_room )
    self.pending_sleep = dest
    if not dest then return true end -- to skip action
    self:newsub{ class = 'go', to = dest, fail_func = self.go_to_sleep }
  end
end

local function is_valid_dazuo_tuna_room( room )
  return not room.label or ( not room.label.sleep and not room.label.no_fight )
end

local function go_to_dazuo_tuna_room( self )
  local loc = map.get_current_location()[ 1 ]
  local dest = map.find_nearest( loc, is_valid_dazuo_tuna_room )
  self:newsub{ class = 'go', to = dest }
end

function task:dazuo()
  if map.is_at_dazuo_tuna_loc() then
    local tgt = self.neili and convert_tgt_to_num( self, 'neili' ) or player.neili_max

    local val = kungfu.get_best_dazuo_value( tgt )
    if not val then return true end -- skip action if got no dazuo value

    self:listen{ event = 'dazuo_end', func = self.resume, id = 'task.recover' }
    self.has_updated_hp = false
    if tgt > player.neili_max * 1.8 and not player.set[ '积蓄' ] then self:send{ 'set 积蓄' } end
    self:send{ 'dazuo ' .. val }
  else
    go_to_dazuo_tuna_room( self )
  end
end

function task:tuna()
  if map.is_at_dazuo_tuna_loc() then
    local tgt, lower_only
    -- exploit available jing to tuna when conditions are met
    if self.maximize_organic_recovery and not self.jing and self.jingli and has_reached_target( self, 'jingli' ) then
      tgt = player.jingli + player.jing - player.jing_max * 0.7
      lower_only = true -- to avoid lowering jing to less than 70% of max
    else
      tgt = convert_tgt_to_num( self, 'jingli' )
    end

    local val = kungfu.get_best_tuna_value( tgt, lower_only )
    if not val then return true end -- skip action if got no tuna value

    self:listen{ event = 'tuna_end', func = self.resume, id = 'task.recover' }
    self.has_updated_hp = false
    if tgt > player.jingli_max * 1.8 and not player.set[ '积蓄' ] then self:send{ 'set 积蓄' } end
    self:send{ 'tuna ' .. val }
  else
    go_to_dazuo_tuna_room( self )
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
