
local task = {}

--------------------------------------------------------------------------------
-- Kill time
--[[----------------------------------------------------------------------------
Params:
duration = 10: length of time to kill in seconds (optional, default: 10)
can_move = true: player can move during the period (optional, default: false) -- TODO not yet implemented
idle_only = true: do nothing during the period (optional, default: false)
no_raise = true: if set, won't raise max neili or jingli (optional, default: false)
----------------------------------------------------------------------------]]--

task.class = 'kill_time'

function task:get_id()
  return 'kill_time for ' .. ( self.duration or 10 ) .. ' sec'
end

local function is_exert_needed( self )
  if player.neili < 20 or not player.enable.force or not map.is_at_dazuo_tuna_loc() then return false end
  if player.qi < player.qi_max * 0.9 and player.enable.force.level >= 120 then return true end
  if player.jing < player.jing_max * 0.7 and player.enable.force.level >= 100 then return true end
end

local function is_dazuo_ok( self )
  -- don't dazuo if can't even finish a 10 point dazuo in 10 seconds
  if kungfu.get_dazuo_rate() < 2 then return false end
  if not player.enable.force or not map.is_at_dazuo_tuna_loc() or player.neili >= player.neili_max * 2 or player.jing / player.jing_max < 0.7 or player.qi < kungfu.get_min_dazuo_value() then return false end
  if self.no_raise and player.neili + kungfu.get_min_dazuo_value() >= player.neili_max * 2 then return false end
  return true
end

local function is_tuna_ok( self )
  -- don't tuna if can't even finish a 10 point tuna in 10 seconds
  if kungfu.get_tuna_rate() < 2 then return false end
  if not player.enable.force or not map.is_at_dazuo_tuna_loc() or player.jingli >= player.jingli_max * 2 or player.qi < player.qi_max * 0.7 or player.jing < 10 then return false end
  if self.no_raise and player.jingli + 10 >= player.jingli_max * 2 then return end
  return true
end

local function is_heal_ok( self )
  -- don't heal if can't
  if player.qi_perc >= 100 or player.neili < 50 or player.neili_max < 200 or player.qi_perc <= 33 or not player.enable.force or player.enable.force.level < 50 or not player.skill[ '本草术理' ] or player.skill[ '本草术理' ].level < 30 then return false end
  return true
end

function task:_resume()
  self.duration = self.duration or 10 -- default to 10 seconds

  if not self.start_time then message.debug( 'kill_time 任务：开始度过 ' .. self.duration .. ' 秒时间' ) end

  self.start_time = self.start_time or os.time()
  self.end_time = self.end_time or os.time() + self.duration
  self.remaining = self.end_time - os.time()

  if self.remaining <= 0 then self:complete() return end

  if self.idle_only or self.remaining <= 2 then self:idle() return end

  -- update hp as needed
  if not self.has_updated_hp then
    self.has_updated_hp = true
    self:newsub{ class = 'get_info', hp = true }
    return
  end

  if is_exert_needed( self ) then
    self:exert()
  elseif is_dazuo_ok( self ) then
    self:dazuo()
  elseif is_tuna_ok( self ) then
    self:tuna()
  elseif is_heal_ok( self ) then
    self:heal()
  else
    self:idle()
  end
end

function task:_complete()
  message.debug( 'kill_time 任务：已度过 ' .. self.duration .. ' 秒时间' )
end

function task:idle()
  message.debug( 'kill_time 任务：开始发呆 ' .. self.remaining .. ' 秒' )
  self:timer{ id = 'kill_time', duration = self.remaining + 0.1, func = self.resume }
end

function task:exert()
  self.has_updated_hp = false
  local c = { complete_func = self.resume }
  if player.jing < player.jing_max * 0.7 then c[ 1 ] = 'yun jing' end
  if player.qi < player.qi_max * 0.9 and player.enable.force.level >= 120 then c[ #c + 1 ] = 'yun qi' end
  self:send( c )
end

function task:dazuo()
  local target = player.neili + kungfu.get_dazuo_rate() * self.remaining * 0.5
  target = self.no_raise and target >= player.neili_max * 2 and ( player.neili_max * 2 - 1 ) or target
  local val = kungfu.get_best_dazuo_value( target )
  self:listen{ event = 'dazuo_end', func = self.resume, id = 'task.kill_time' }
  self.has_updated_hp = false
  self:send{ 'dazuo ' .. val }
end

function task:tuna()
  local target = player.jingli + kungfu.get_tuna_rate() * self.remaining * 0.5
  target = self.no_raise and target >= player.jingli_max * 2 and ( player.jingli_max * 2 - 1 ) or target
  local val = kungfu.get_best_tuna_value( target )
  self:listen{ event = 'tuna_end', func = self.resume, id = 'task.kill_time' }
  self.has_updated_hp = false
  self:send{ 'tuna ' .. val }
end

function task:heal()
  self:listen{ event = 'heal_end', func = self.resume, id = 'task.recover' }
  self.has_updated_hp = false
  if player.lasting_action ~= 'heal' then self:send{ 'yun heal' } end
  self:timer{ id = 'kill_time', duration = self.remaining + 0.1, func = self.resume } -- a timer to complete the task no matter if heal has ended or not
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
