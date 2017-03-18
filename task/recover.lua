
local task = {}

--------------------------------------------------------------------------------
-- Recover
--[[----------------------------------------------------------------------------
Params:
all, neili, jingli, jing, qi = 'double', 'full', 'half', 'a_little', 900 -- one or more of these params set to one of the valid recover levels or a exact number. 'all' covers all four attributes, but its value will be overridden by individual values if any is set. Only neili and jingli support the 'double' recover level (required)
stay_here = true -- should player stay where he/she is during the recover process? (optional, default: false)
----------------------------------------------------------------------------]]--

task.class = 'recover'

local valid_param = { all = true, jing = true, jingli = true, qi = true, neili = true }

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

local all_attr = { 'jing', 'jingli', 'qi', 'neili' }
local convertable_attr = { 'jing', 'jingli', 'qi' }

local function validate_recover_param( self )
  for _, attr in pairs( all_attr ) do
    local tgt, max = self[ attr ], player[ attr .. '_max' ]
    -- convert 'all' param to individual params
    if self.all and not tgt then self[ attr ] = self.all end
    if ( attr == 'qi' or attr == 'jing' ) and tgt == 'double' then self[ attr ] = 'full' end -- qi and jing doesn't support 'double' recover level
    -- raise error and adjust targets if numeric targets exceed what is achievable
    if type( tgt ) == 'number' and ( tgt >= max * 2 or ( ( attr == 'qi' or attr == 'jing' ) and tgt > max ) ) then
      local new_tgt = ( attr == 'qi' or attr == 'jing' ) and max or max * 2 - 1
      message.warning( 'RECOVER 任务：' .. attr .. ' 恢复目标 ' .. tgt .. ' 超出了能达到的上限，调整为 ' .. new_tgt )
      self[ attr ] = new_tgt
    end
  end
end

local function has_reached_target( self, attr )
  local tgt, val, max = self[ attr ], player[ attr ], player[ attr .. '_max' ]
  local pct = val / max
  return not tgt
      or ( tgt == 'double' and pct > 1.9 )
      or ( tgt == 'full' and pct > 0.9 )
      or ( tgt == 'half' and pct > 0.4 )
      or ( tgt == 'a_little' and pct > 0.1 )
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
  return val / max > 0.95
end

local function is_heal_needed( self )
  return player.qi_perc < 100
end

local function has_sufficient_qi_for_dazuo()
  if player.qi_max > 1000 then
    return player.qi / player.qi_max >= 0.2
  else
    return player.qi >= 10
  end
end

local function is_sleep_needed( self )
  local has_recently_slept = os.time() - 180 < ( player.last_sleep_time or 0 )
  -- don't sleep if last sleep is less than 3 minutes ago
  if has_recently_slept then return false end
  -- don't sleep if stay_here is set and we can't sleep at the current room
  local is_in_sleep_room = room.get().label and room.get().label.sleep
  if self.stay_here and player.party ~= '丐帮' and not is_in_sleep_room then return false end
  -- if not enough jing to dazuo and no neili to recover it
  if player.neili < 20 and player.jing / player.jing_max < 0.7 then return true end
  -- if qi is depleted and no neili, or no positive loop dazuo, go to sleep
  if not has_sufficient_qi_for_dazuo() and ( not player.enable.force or player.enable.force.level < 120 or player.neili < 20 ) then return true end
end

local function is_exert_needed( self )
  for _, attr in pairs( convertable_attr ) do
    if self[ attr ] and not has_reached_target( self, attr ) and not is_full( attr ) and player.neili >= 20 then return true end
  end
end

local function is_dazuo_needed( self )
  if not has_reached_target( self, 'neili' ) then return true end
  for _, attr in pairs( convertable_attr ) do
    if self[ attr ] and not has_reached_target( self, attr ) and not is_full( attr ) and player.neili < 20 then return true end
  end
end

local function is_tuna_needed( self )
  if not has_reached_target( self, 'jingli' ) then return true end
end

function task:_resume()
  -- update hp as needed
  if not self.has_updated_hp then
    self.has_updated_hp = true
    -- check if param values are valid and convert the "all" param
    validate_recover_param( self )
    if not player.set[ '积蓄' ] then cmd.new{ 'set 积蓄' } end -- use cmd.new to make sure the cmd will be sent even when the task is not active
    self:newsub{ class = 'get_info', hp = 'forced' }
    return
  end
  -- if all targets have been reached then complete
  if has_reached_all_target( self ) then self:complete() return end
  -- if player needs to sleep, go to sleep
  if is_heal_needed( self ) then self:heal() return end
  -- if player needs to sleep, go to sleep
  if is_sleep_needed( self ) then self:go_to_sleep() return end
  -- try to recover jing, qi, jingli with neili
  if is_exert_needed( self ) then self:exert() return end
  -- try to recover neili through dazuo
  if is_dazuo_needed( self ) then self:dazuo() return end
  -- try to recover jingli through tuna
  if is_tuna_needed( self ) then self:tuna() return end
  -- otherwise, wait
  self:newsub{ class = 'killtime', duration = 20, idle_only = true }
end

function task:_complete()
  cmd.new{ 'unset 积蓄' }
  message.verbose( '完成恢复任务：' .. get_param_string( self ) )
end

function task:heal()

end

function task:exert()
  local c = {}
  for _, attr in pairs( convertable_attr ) do
    if self[ attr ] and not has_reached_target( self, attr ) and not is_full( attr ) then
      c[ #c + 1 ] = 'yun ' .. attr
    end
  end
  c.complete_func = self.resume
  self.has_updated_hp = false
  self:send( c )
end

local function is_valid_sleep_room( room )
  if room.label and room.label.sleep then
    return not room.use_cond or map.check_cond( room.use_cond )
  end
end

function task:go_to_sleep()
  if map.is_at_sleep_loc() then
    self:listen{ event = 'sleep_end', func = self.resume, id = 'task.recover' }
    self.has_updated_hp = false
    self:send{ 'sleep' }
  else
    local loc = map.get_current_location()[ 1 ]
    local dest = map.find_nearest( loc, is_valid_sleep_room )
    self:newsub{ class = 'go', to = dest }
  end
end

local function convert_tgt_to_num( self, attr )
  local tgt, max = self[ attr ], player[ attr .. '_max' ]
  return ( type( tgt ) == 'number' and tgt )
      or ( tgt == 'double' and max * 2 - 1 )
      or ( tgt == 'full' and max )
      or ( tgt == 'half' and max * 0.5 )
      or ( tgt == 'a_little' and max * 0.1 )
end

local function get_best_dazuo_value( min, tgt )
  local tick, best_val = kungfu.get_dazuo_rate()
  for i = 1, math.ceil( tgt / tick ) do
    local val = tick * i
    if val >= min and val <= player.qi then best_val = val end
  end
  local alt_val = tgt <= player.qi - 10 and tgt or player.qi - 10
  alt_val = alt_val >= min and alt_val or min
  return best_val or alt_val
end

local function is_valid_dazuo_room( room )
  return not room.label or ( not room.label.sleep and not room.label.no_fight )
end

function task:dazuo()
  if map.is_at_dazuo_loc() then
    local tgt = self.neili and convert_tgt_to_num( self, 'neili' ) or player.neili_max
    local until_tgt = tgt - player.neili
    local min = player.qi_max > 1000 and math.floor( player.qi_max / 5 ) or 10
    local val = get_best_dazuo_value( min, until_tgt )
    self:listen{ event = 'dazuo_end', func = self.resume, id = 'task.recover' }
    self.has_updated_hp = false
    self:send{ 'dazuo ' .. val }
  else
    local loc = map.get_current_location()[ 1 ]
    local dest = map.find_nearest( loc, is_valid_dazuo_room )
    self:newsub{ class = 'go', to = dest }
  end
end

function task:tuna()

end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
