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

local function parse_sleep_start()
  player.lasting_action = 'sleep'
  event.new 'sleep_start'
end

local function parse_sleep_end()
  player.lasting_action = false
  event.new 'sleep_end'
end


trigger.new{ name = 'dazuo_start', match = '^(> )*��(��ϥ����|��ϥ����|��������|������ϥ����|ϯ�ض�������������|�������£�˫��ƽ��|�������һ�����������۾���������Ů�ľ�|���������޼��񹦣����۵���|�������죬�ų�һ������|���󽣾�����������������|����������ϥ����|�����������Ŀ����|����һվ��˫�ֻ���̧������һ����|���˵�������ڶ��������Ƴ�|��Ϣ��������������|�����������ù�)', func = parse_dazuo_start, enabled = true }
trigger.new{ name = 'dazuo_end', match = '^(> )*(����Ƭ�̣�)?��(����Ϣ���˸�С����|����Ϣ������һ��С����|�����뵤�������ת����|�������������뵤��|��������Ϣ��ͨ����|�����������һ��Ԫ|�ֿ�˫�֣�������������|����������������֮�ư�����һ��|˫��΢�գ���������ؾ���֮����������|����Ϣ����������ʮ������|ֻ����Ԫ��һ|�е��Լ��������Ϊһ��|һ�������н�����|������������������������һȦ|����������������һ������|�о�����ԽתԽ��|����Ϣ����һ������|�о��Լ��Ѿ��������޼������۵���|�˹���ϣ�վ������)', func = parse_dazuo_end, enabled = true }
trigger.new{ name = 'dazuo_halt', match = '^(> )*��(����һ����������Ϣ�������˻�ȥ|��ɫһ����Ѹ������|��Ϣһת��Ѹ������|�Ҵҽ���Ϣ���˻�ȥ|����΢΢��������������|˫�ۻ����պϣ�Ƭ���͵�����|˫��һ��|���������е�����ǿ��ѹ�ص���|΢һ��ü������Ϣѹ�ص���|�е��������ͣ�ֻ��и����Ϣ|�е��������ң�ȫ�����ȣ�ֻ���չ�|�͵�����˫�ۣ�˫��Ѹ�ٻظ����|üͷһ�壬�������������ַ�������|˫��һ�֣�������ȭ|˫��һ�֣�ƽ̯����|����һ��������Ϣѹ�ص���)', func = parse_dazuo_halt, enabled = true }

trigger.new{ name = 'tuna_start', match = '^(> )*������۾���ʼ���ɡ�', func = parse_tuna_start, enabled = true }
trigger.new{ name = 'tuna_end', match = '^(> )*��������ϣ�����˫�ۣ�վ��������', func = parse_tuna_end, enabled = true }
trigger.new{ name = 'tuna_halt', match = '^(> )*���������ڴ�����վ��������', func = parse_tuna_halt, enabled = true }

trigger.new{ name = 'sleep_start', match = '^(> )*����(����|���½���)һ�ɣ���ʼ˯����', func = parse_sleep_start, enabled = true }
trigger.new{ name = 'sleep_end', match = '^(> )*��һ������', func = parse_sleep_end, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
