
local getter = {}

--------------------------------------------------------------------------------
-- Flag getters for acquiring various temp player flags
--------------------------------------------------------------------------------

getter.data = {}

-- ask 裘千丈 about 闹鬼
function getter:tz_ghost()
	self:newweaksub{ class = 'find', object = '裘千丈', action = 'ask %id about 闹鬼' }
end
function getter:tz_ghost_succeed()
  self:disable_trigger_group 'flag_getter.tz_ghost'
  player.temp_flag.tz_ghost = true
	self:complete()
end
trigger.new{ name = 'tz_ghost_succeed', group = 'flag_getter.tz_ghost', match = '^听一些帮众说，经常听见无名峰上的坟墓中，传出响声！嘿嘿！一定有什么蹊跷在里面！$', func = getter.tz_ghost_succeed }

-- ask 上官剑南 about 宝物
function getter:tz_treasure()
  self:newweaksub{ class = 'find', object = '上官剑南', action = 'ask %id about 宝物' }
end
function getter:tz_treasure_succeed()
  self:disable_trigger_group 'flag_getter.tz_treasure'
  player.temp_flag.tz_treasure = true
	self:complete()
end
trigger.new{ name = 'tz_treasure_succeed', group = 'flag_getter.tz_treasure', match = '^宝物在第二指节的洞穴里。$', func = getter.tz_treasure_succeed }

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
function getter:jqg_gsz_agree_succeed()
  self:disable_trigger_group 'flag_getter.jqg_gsz_agree'
  player.temp_flag.jqg_gsz_agree = true
	self:complete()
end
trigger.new{ name = 'jqg_gsz_agree_succeed', group = 'flag_getter.jqg_gsz_agree', match = '^公孙止说道：「\\S{4,6}既然对绝情谷甚有兴趣，就请随便看看吧。」$', func = getter.jqg_gsz_agree_succeed }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return getter
