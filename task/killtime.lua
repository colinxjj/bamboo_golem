
local task = {}

--------------------------------------------------------------------------------
-- Kill time
--[[----------------------------------------------------------------------------
Params:
duration = 10: length of time to kill in seconds (optional, default: 10)
can_move = true: player can move during the period (optional, default: false) -- TODO undefined yet
----------------------------------------------------------------------------]]--

task.class = 'killtime'

function task:get_id()
  return 'killtime for ' .. ( self.duration or 10 ) .. ' sec'
end

function task:_resume()
  self.duration = self.duration or 10 -- default to 10 seconds

  self.start_time = self.start_time or os.time()
  self.end_time = self.end_time or os.time() + self.duration

  -- task complete if end time is passed
  if self.timer_set then
    if os.time() - self.end_time >= -1 then self:complete(); return end
  end

  -- TODO for now just use a timer to idle
  self.timer_set = true
  self:timer{ id = 'killtime_timer', duration = self.duration, func = self.resume }
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
