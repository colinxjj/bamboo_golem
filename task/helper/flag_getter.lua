
local getter = {}

--------------------------------------------------------------------------------
-- Flag getters for acquiring various temp player flags
--------------------------------------------------------------------------------

getter.data = {}

-- ask ��ǧ�� about �ֹ�
function getter:tz_ghost()
	self:newsub{ class = 'find', object = '��ǧ��', action = 'ask %id about �ֹ�' }
end
function getter:tz_ghost_succeed()
  self:disable_trigger_group 'flag_getter.tz_ghost'
  player.temp_flag.tz_ghost = true
end
trigger.new{ name = 'tz_ghost_succeed', group = 'flag_getter.tz_ghost', match = '^��һЩ����˵�����������������ϵķ�Ĺ�У������������ٺ٣�һ����ʲô���������棡$', func = getter.tz_ghost_succeed, penetrate = 'waiting' }

-- ask �Ϲٽ��� about ����
function getter:tz_treasure()
  self:newsub{ class = 'find', object = '�Ϲٽ���', action = 'ask %id about ����' }
end
function getter:tz_treasure_succeed()
  self:disable_trigger_group 'flag_getter.tz_treasure'
  player.temp_flag.tz_treasure = true
end
trigger.new{ name = 'tz_treasure_succeed', group = 'flag_getter.tz_treasure', match = '^�����ڵڶ�ָ�ڵĶ�Ѩ�$', func = getter.tz_treasure_succeed, penetrate = 'waiting' }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return getter
