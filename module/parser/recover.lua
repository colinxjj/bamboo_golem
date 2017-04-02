--------------------------------------------------------------------------------
-- This module parses force related messages
--------------------------------------------------------------------------------

local function parse_dazuo_start()
  player.lasting_action = 'dazuo'
  event.new 'dazuo_start'
end

local function parse_dazuo_end()
  player.lasting_action = false
  event.new 'dazuo_end'
end

local function parse_dazuo_halt()
  player.lasting_action = false
  event.new 'dazuo_halt'
end

local function parse_tuna_start()
  player.lasting_action = 'tuna'
  event.new 'tuna_start'
end

local function parse_tuna_end()
  player.lasting_action = false
  event.new 'tuna_end'
end

local function parse_tuna_halt()
  player.lasting_action = false
  event.new 'tuna_halt'
end

local function parse_heal_start()
  player.lasting_action = 'heal'
  event.new 'heal_start'
end

local function parse_heal_end()
  player.lasting_action = false
  event.new 'heal_end'
end

local function parse_heal_halt()
  player.lasting_action = false
  event.new 'heal_halt'
end

local function parse_sleep_start()
  player.is_asleep = true
  event.new 'sleep_start'
end

local function parse_sleep_end()
  player.is_asleep = false
  player.last_sleep_time = os.time()
  event.new 'sleep_end'
end

trigger.new{ name = 'dazuo_start', match = 'XXXXXYZ', func = parse_dazuo_start, enabled = true }
trigger.new{ name = 'dazuo_end', match = 'XXXXXYZ', func = parse_dazuo_end, enabled = true }
trigger.new{ name = 'dazuo_halt', match = 'XXXXXYZ', func = parse_dazuo_halt, enabled = true }

trigger.new{ name = 'tuna_start', match = '^(> )*������۾���ʼ���ɡ�', func = parse_tuna_start, enabled = true }
trigger.new{ name = 'tuna_end', match = '^(> )*��������ϣ�����˫�ۣ�վ��������', func = parse_tuna_end, enabled = true }
trigger.new{ name = 'tuna_halt', match = '^(> )*���������ڴ�����վ��������', func = parse_tuna_halt, enabled = true }

trigger.new{ name = 'heal_start', match = 'XXXXXYZ', func = parse_heal_start, enabled = true }
trigger.new{ name = 'heal_end', match = 'XXXXXYZ', func = parse_heal_end, enabled = true }
trigger.new{ name = 'heal_halt', match = 'XXXXXYZ', func = parse_heal_halt, enabled = true }

trigger.new{ name = 'sleep_start', match = '^(> )*����(����|���½���)һ�ɣ���ʼ˯����', func = parse_sleep_start, enabled = true }
trigger.new{ name = 'sleep_start2', match = '^(> )*��һ�������ڴ��ϣ���һ����������������������硣', func = parse_sleep_start, enabled = true }
trigger.new{ name = 'sleep_end', match = '^(> )*��һ������', func = parse_sleep_end, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
