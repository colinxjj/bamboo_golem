--------------------------------------------------------------------------------
-- This module parses connection status changes
--------------------------------------------------------------------------------

local function parse_login()
  event.new 'ready_to_login'
end

local function parse_connect()
  trigger.disable_group 'connection'
  event.new 'connected'
end

local function parse_reconnect()
  trigger.disable_group 'connection'
  event.new 'reconnected'
end

local function parse_disconnect()
  event.new 'disconnected'
end

trigger.new{ name = 'login', match = '^���齣������\\S+λ�����\\S+��վ�������С�$', func = parse_login, group = 'connection' }
trigger.new{ name = 'connect', match = '^��Ŀǰ��Ȩ���ǣ�', func = parse_connect, group = 'connection' }
trigger.new{ name = 'reconnect', match = '^����������ϡ�$', func = parse_reconnect, group = 'connection' }
trigger.new{ name = 'disconnect', match = '^���齣�����������ܹ�����', func = parse_disconnect, enabled = true }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
