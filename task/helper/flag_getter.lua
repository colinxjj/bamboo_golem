
local getter = {}

--------------------------------------------------------------------------------
-- Flag getters for acquiring various temp player flags
--------------------------------------------------------------------------------

getter.data = {}

-- ask ��ǧ�� about �ֹ�
function getter:tz_ghost()
	self:newweaksub{ class = 'find', object = '��ǧ��', action = 'ask %id about �ֹ�' }
end
function getter:tz_ghost_succeed()
  self:disable_trigger_group 'flag_getter.tz_ghost'
  player.temp_flag.tz_ghost = true
	self:complete()
end
trigger.new{ name = 'tz_ghost_succeed', group = 'flag_getter.tz_ghost', match = '^��һЩ����˵�����������������ϵķ�Ĺ�У������������ٺ٣�һ����ʲô���������棡$', func = getter.tz_ghost_succeed }

-- ask �Ϲٽ��� about ����
function getter:tz_treasure()
  self:newweaksub{ class = 'find', object = '�Ϲٽ���', action = 'ask %id about ����' }
end
function getter:tz_treasure_succeed()
  self:disable_trigger_group 'flag_getter.tz_treasure'
  player.temp_flag.tz_treasure = true
	self:complete()
end
trigger.new{ name = 'tz_treasure_succeed', group = 'flag_getter.tz_treasure', match = '^�����ڵڶ�ָ�ڵĶ�Ѩ�$', func = getter.tz_treasure_succeed }

-- look ������ at �һ�������
function getter:thd_bagua()
	if not map.is_current_location '�һ�������' then
		self:newsub{ class = 'go', to = '�һ�������' }
	else
		self:send{ 'l bagua' }
	end
end
local thd_bagua_tbl = { ['Ǭ'] = '111', ['��'] = '011', ['��'] = '101', ['��'] = '001', ['��'] = '110', ['��'] = '010', ['��'] = '100', ['��'] = '000', }
function getter:thd_bagua_parse( _, t )
	local s = ''
	for i = 1, 8 do
		local char = string.sub( t[ 1 ], i * 2 - 1, i * 2 )
		s = s .. thd_bagua_tbl[ char ]
	end
	player.temp_flag.thd_bagua = s
	self:complete()
end
trigger.new{ name = 'thd_bagua_look', group = 'flag_getter.thd_bagua', match = '^һ����ֵ������ԣ����水˳ʱ��˳�������ţ�(\\S+)��$', func = getter.thd_bagua_parse }

-- get the coordinates of thd
function getter:thd_coord()
	if not map.is_current_location 'ţ�Ҵ�����' then
		self:newsub{ class = 'go', to = 'ţ�Ҵ�����' }
	else
		self:send{ 'open xiang' }
	end
end
function getter:thd_coord_parse( _, t )
	player.temp_flag.thd_coord = { x = tonumber( t[ 2 ] ), y = tonumber( t[ 3 ] ) }
	self:complete()
end
trigger.new{ name = 'thd_coord_look', group = 'flag_getter.thd_coord', match = '^(> )*���þ��������ӣ��������澹�����������Ĵ����ܱ��������鱦�����棬��һ�ŷ��Ƶĺ�ͼ���м��һ���ط��ôֱʻ��˸�ԲȦ���Ա����ʲݵ��ּ�д��\\((\\d+),(\\d+)\\)��������$', func = getter.thd_coord_parse }

-- ask ����ֹ about �����
function getter:jqg_gsz_agree()
  self:newweaksub{ class = 'find', object = '����ֹ', action = 'ask %id about �����' }
end
function getter:jqg_gsz_agree_succeed()
  self:disable_trigger_group 'flag_getter.jqg_gsz_agree'
  player.temp_flag.jqg_gsz_agree = true
	self:complete()
end
trigger.new{ name = 'jqg_gsz_agree_succeed', group = 'flag_getter.jqg_gsz_agree', match = '^����ֹ˵������\\S{4,6}��Ȼ�Ծ����������Ȥ��������㿴���ɡ���$', func = getter.jqg_gsz_agree_succeed }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return getter
