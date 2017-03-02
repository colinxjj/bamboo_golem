--------------------------------------------------------------------------------
-- This module parses uptime info
--------------------------------------------------------------------------------

local function parse_uptime ( _, t )
  time.uptime = cn_timelen_to_sec( t[ 1 ] )
  time.uptime_timestamp = os.time()
  event.new 'uptime'
end

trigger.new{ name = 'uptime', match = '^���齣������վ�Ѿ�����ִ����(\\S+)��', func = parse_uptime, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
