
local task = {}

--------------------------------------------------------------------------------
-- Recover
--[[----------------------------------------------------------------------------
Params:
all, neili, jingli, jing, qi = 'double', 'full', 'half', 'a_little' -- one or more of these params set to one of the valid values. 'All' covers all four stats, but its value will be overridden by individual values if any is set (required)
----------------------------------------------------------------------------]]--

task.class = 'recover'

local valid_param = { all, jing = true, jingli = true, qi = true, neili = true }

function task:get_id()
  local s = 'recover: '
  for param in pairs( valid_param ) do
    if self[ param ] then s = s .. param .. ' ' .. self[ param ] .. ', ' end
  end
  s = string.gsub( s, ', $', '' )
  return s
end

function task:_resume()
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
