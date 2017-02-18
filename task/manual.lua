
local task = {}

--------------------------------------------------------------------------------
-- The manual task, an agency for all of user's manual actions
--[[----------------------------------------------------------------------------
Params:
none
----------------------------------------------------------------------------]]--

task.class = 'manual'
task.priority = 1 -- manual task has highest priority

function task:complete()
  -- this task never completes
end

function task:fail()
  -- this task never fails
end

function task:kill()
  -- this task will never be killed
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
