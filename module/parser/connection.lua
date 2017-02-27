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

trigger.new{ name = 'login', match = '^「书剑」共有\\S+位玩家在\\S+处站点连线中。$', func = parse_login, group = 'connection' }
trigger.new{ name = 'connect', match = '^您目前的权限是：', func = parse_connect, group = 'connection' }
trigger.new{ name = 'reconnect', match = '^重新连线完毕。$', func = parse_reconnect, group = 'connection' }
trigger.new{ name = 'disconnect', match = '^〖书剑〗：您本次总共在线', func = parse_disconnect, enabled = true }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
