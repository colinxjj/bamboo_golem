
local getter = {}

--------------------------------------------------------------------------------
-- Flag getters for acquiring various temp player flags
--------------------------------------------------------------------------------

getter.data = {}

function getter:succeed()
	self:complete()
end

-- ask ��ǧ�� about �ֹ�
function getter:tz_ghost()
	self:newweaksub{ class = 'find', object = '��ǧ��', action = 'ask %id about �ֹ�' }
end
trigger.new{ name = 'tz_ghost_succeed', group = 'flag_getter.tz_ghost', match = '^��һЩ����˵�����������������ϵķ�Ĺ�У������������ٺ٣�һ����ʲô���������棡$', func = getter.succeed }

-- ask �Ϲٽ��� about ����
function getter:tz_treasure()
  self:newweaksub{ class = 'find', object = '�Ϲٽ���', action = 'ask %id about ����' }
end
trigger.new{ name = 'tz_treasure_succeed', group = 'flag_getter.tz_treasure', match = '^�����ڵڶ�ָ�ڵĶ�Ѩ�$', func = getter.succeed }

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
trigger.new{ name = 'jqg_gsz_agree_succeed', group = 'flag_getter.jqg_gsz_agree', match = '^����ֹ˵������\\S{4,6}��Ȼ�Ծ����������Ȥ��������㿴���ɡ���$', func = getter.succeed }

-- access to bookshelf at ����ʹ��鷿
function getter:dlhg_bookshelf()
	self:newweaksub{ class = 'find', object = '������', action = 'ask %id about ���' }
end
function getter:dlhg_bookshelf_succeed( _, t )
	player.temp_flag.tlbb_book_target = t[ 2 ]
	self:complete()
end
trigger.new{ name = 'dlhg_bookshelf_asked', group = 'flag_getter.dlhg_bookshelf', match = '^������˵������(����󹬣��Ȱ��Ұ������˲���|����ȥ��)(\\S+)(����|��������ȥ)����$', func = getter.dlhg_bookshelf_succeed }

-- access to ����ʹ���
function getter:dlhg_access()
	-- get the bookshelf flag
	if not player.temp_flag.dlhg_bookshelf then self:newsub{ class = 'get_flag', flag = 'dlhg_bookshelf' } return end
	-- get the book needed
	if not inventory.has_item( player.temp_flag.tlbb_book_target ) then self:newsub{ class = 'get_item', item = player.temp_flag.tlbb_book_target } return end
	-- find ������
	self:newweaksub{ class = 'find', object = '������', complete_func = getter.dlhg_access_give }
end
function getter:dlhg_access_give()
	self:send{ 'give ' .. item.get_id( player.temp_flag.tlbb_book_target ) .. ' to duan zhengming' }
end
trigger.new{ name = 'dlhg_access_succeed', group = 'flag_getter.dlhg_access', match = '^������˵�������ܺã�����Խ����ˡ���$', func = getter.succeed }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return getter
