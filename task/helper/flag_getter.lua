
local getter = {}

--------------------------------------------------------------------------------
-- Flag getters for acquiring various temp player flags
--------------------------------------------------------------------------------

getter.data = {}

function getter:succeed()
	self:complete()
end

-- ask 裘千丈 about 闹鬼
function getter:tz_ghost()
	self:newweaksub{ class = 'find', object = '裘千丈', action = 'ask %id about 闹鬼' }
end
trigger.new{ name = 'tz_ghost_succeed', group = 'flag_getter.tz_ghost', match = '^听一些帮众说，经常听见无名峰上的坟墓中，传出响声！嘿嘿！一定有什么蹊跷在里面！$', func = getter.succeed }

-- ask 上官剑南 about 宝物
function getter:tz_treasure()
  self:newweaksub{ class = 'find', object = '上官剑南', action = 'ask %id about 宝物' }
end
trigger.new{ name = 'tz_treasure_succeed', group = 'flag_getter.tz_treasure', match = '^宝物在第二指节的洞穴里。$', func = getter.succeed }

-- look 铁八卦 at 桃花岛方厅
function getter:thd_bagua()
	if not map.is_current_location '桃花岛方厅' then
		self:newsub{ class = 'go', to = '桃花岛方厅' }
	else
		self:send{ 'l bagua' }
	end
end
local thd_bagua_tbl = { ['乾'] = '111', ['兑'] = '011', ['离'] = '101', ['震'] = '001', ['巽'] = '110', ['坎'] = '010', ['艮'] = '100', ['坤'] = '000', }
function getter:thd_bagua_parse( _, t )
	local s = ''
	for i = 1, 8 do
		local char = string.sub( t[ 1 ], i * 2 - 1, i * 2 )
		s = s .. thd_bagua_tbl[ char ]
	end
	player.temp_flag.thd_bagua = s
	self:complete()
end
trigger.new{ name = 'thd_bagua_look', group = 'flag_getter.thd_bagua', match = '^一个奇怪的铁八卦，上面按顺时针顺序排列着：(\\S+)。$', func = getter.thd_bagua_parse }

-- get the coordinates of thd
function getter:thd_coord()
	if not map.is_current_location '牛家村密室' then
		self:newsub{ class = 'go', to = '牛家村密室' }
	else
		self:send{ 'open xiang' }
	end
end
function getter:thd_coord_parse( _, t )
	player.temp_flag.thd_coord = { x = tonumber( t[ 2 ] ), y = tonumber( t[ 3 ] ) }
	self:complete()
end
trigger.new{ name = 'thd_coord_look', group = 'flag_getter.thd_coord', match = '^(> )*你用劲打开了箱子，发现里面竟藏有着无数的大内密宝。而在珠宝的下面，有一张发黄的海图。中间的一个地方用粗笔画了个圆圈，旁边用潦草的字迹写着\\((\\d+),(\\d+)\\)的字样。$', func = getter.thd_coord_parse }

-- ask 公孙止 about 绝情谷
function getter:jqg_gsz_agree()
  self:newweaksub{ class = 'find', object = '公孙止', action = 'ask %id about 绝情谷' }
end
trigger.new{ name = 'jqg_gsz_agree_succeed', group = 'flag_getter.jqg_gsz_agree', match = '^公孙止说道：「\\S{4,6}既然对绝情谷甚有兴趣，就请随便看看吧。」$', func = getter.succeed }

-- access to bookshelf at 大理皇宫书房
function getter:dlhg_bookshelf()
	self:newweaksub{ class = 'find', object = '段正明', action = 'ask %id about 入后宫' }
end
function getter:dlhg_bookshelf_succeed( _, t )
	player.temp_flag.tlbb_book_target = t[ 2 ]
	self:complete()
end
trigger.new{ name = 'dlhg_bookshelf_asked', group = 'flag_getter.dlhg_bookshelf', match = '^段正明说道：「(想入后宫，先帮我把天龙八部的|让你去找)(\\S+)(找来|，还不快去)。」$', func = getter.dlhg_bookshelf_succeed }

-- access to 大理皇宫后宫
function getter:dlhg_access()
	-- get the bookshelf flag
	if not player.temp_flag.dlhg_bookshelf then self:newsub{ class = 'get_flag', flag = 'dlhg_bookshelf' } return end
	-- get the book needed
	if not inventory.has_item( player.temp_flag.tlbb_book_target ) then self:newsub{ class = 'get_item', item = player.temp_flag.tlbb_book_target } return end
	-- find 段正明
	self:newweaksub{ class = 'find', object = '段正明', complete_func = getter.dlhg_access_give }
end
function getter:dlhg_access_give()
	self:send{ 'give ' .. item.get_id( player.temp_flag.tlbb_book_target ) .. ' to duan zhengming' }
end
trigger.new{ name = 'dlhg_access_succeed', group = 'flag_getter.dlhg_access', match = '^段正明说道：「很好，你可以进后宫了。」$', func = getter.succeed }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return getter
