
local task = {}

--------------------------------------------------------------------------------
-- Get various temp player flags
--[[----------------------------------------------------------------------------
Params:
flag = 'ask �ֹ�': the flag to get (required)
----------------------------------------------------------------------------]]--

task.class = 'get_flag'

local flag_getter = require 'task.helper.flag_getter'

function task:get_id()
  return 'get flag: ' .. self.flag
end

function task:_resume()
  if player.temp_flag[ self.flag ] then self:complete() return end
  self:enable_trigger_group( 'flag_getter.' .. self.flag )
  flag_getter[ self.flag ]( self )
end

function task:_complete()
  message.debug( '�ɹ�ȡ�ñ�ǣ�' .. self.flag )
end

function task:_fail()
  message.debug( 'δ��ȡ�ñ�ǣ�' .. self.flag )
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
