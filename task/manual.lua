
local task = {}

--------------------------------------------------------------------------------
-- The manual task, an agency for all of user's manual actions
--[[----------------------------------------------------------------------------
Params:
none
----------------------------------------------------------------------------]]--

task.class = 'manual'
task.priority = 2 -- manual task has second highest priority

-- a catcher for subtask failure to avoid this task being killed as a result the subtask's failure
function task:fail_catcher()
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
