
local handler = {}

--------------------------------------------------------------------------------
-- This module contains step handler functions for maps
--------------------------------------------------------------------------------

-- a table to store persistent path variables
handler.data = {}

--------------------------------------------------------------------------------
-- Special step handlers

-- check if the player can fly across rivers
local function is_able_to_fly( cmd )
	if cmd == 'duhe' then return player.enable.dodge and player.enable.dodge.level >= 250 and player.neili_max >= 3000
	elseif cmd == 'dujiang' then return player.enable.dodge and player.enable.dodge.level >= 270 and player.neili_max >= 3500
	elseif cmd == 'zong' then return player.enable.dodge and player.enable.dodge.level >= 300 and player.neili_max >= 4000
	end
end

-- 长江
-- TODO make sure have silver
local cj_layout = {
	['长江北岸'] = { w = '扬州城长江北岸#W', c = '扬州城长江北岸#C', e = '扬州城长江北岸#E' },
	['长江南岸'] = { w = '扬州城长江南岸#W', c = '扬州城长江南岸#C', e = '扬州城长江南岸#E' },
}
function handler:cross_cj( t )
	t = self.step
	t.loc = t.loc or cj_layout[ t.from.name ]
	t.curr_loc = map.get_current_location()[ 1 ].id
	if is_able_to_fly( t.cmd ) then
		-- in order to fly first go to the center
		if t.curr_loc ~= t.loc.c then
			local c = t.curr_loc == t.loc.w and 'e'
						 or t.curr_loc == t.loc.e and 'w'
		  self:listen{ event = 'located', func = handler.cross_cj, id = 'step_handler.cross_cj', sequence = 99, keep_eval = false }
			self:send{ c }
			return
		end
		-- then hand over to fly handler
		handler.fly( self )
	else -- try to embark across all 3 positions
		if map.get_current_room().exit.enter then self:send{ 'enter' }; return end -- if boat is here, enter it
		t.to_yell = t.to_yell or { [ t.loc.w ] = true, [ t.loc.c ] = true, [ t.loc.e ] = true }
		if t.to_yell[ t.curr_loc ] then -- yell at current location
			self:send{ 'yell boat' }
			t.to_yell[ t.curr_loc ] = nil
			self:newweaksub{ class = 'killtime', duration = 1, complete_func = handler.cross_cj }
		elseif next( t.to_yell ) then -- go to next location and yell
			local c = t.curr_loc == t.loc.w and 'e'
						 or t.curr_loc == t.loc.e and 'w'
						 or t.to_yell[ t.loc.e ] and 'e'
						 or 'w'
			self:listen{ event = 'located', func = handler.cross_cj, id = 'step_handler.cross_cj', sequence = 99, keep_eval = false }
 			self:send{ c }
		else -- kill time and do another round of yell
			t.to_yell = nil
			self:newweaksub{ class = 'killtime', complete_func = handler.cross_cj }
		end
	end
end

-- 黄河、黑木崖、澜沧江
-- TODO make sure have silver
local yell_tbl = {
	['黑木崖日月坪'] = 'yell xiaya',
	['黑木崖崖顶'] = 'yell shangya',
}
function handler:fly_across( t )
	t.yell_cmd = yell_tbl[ t.to.id ]
	if not is_able_to_fly( t.cmd ) then -- can't fly, hand over to embark handler
		t.cmd = t.yell_cmd
		handler.embark( self )
	else handler.fly( self ) end -- hand over to fly handler
end

-- 飞越江河。长江、黄河、黑木崖、澜沧江等。
function handler:fly()
	-- since this handler is always called by other handlers, it needs to take care of trigger enabling itself
	self:enable_trigger_group 'step_handler.fly'
	if map.get_current_room().exit.enter then
		self:newsub{ class = 'killtime', complete_func = handler.fly }
	else
		self:send{ self.step.yell_cmd or 'yell boat', self.step.cmd }
	end
end
function handler:fly_wait()
	self:newsub{ class = 'killtime', complete_func = handler.fly }
end
function handler:fly_done()
	self:disable_trigger_group 'step_handler.fly'
	addbusy( 6 )
end
trigger.new{ name = 'fly_wait', group = 'step_handler.fly', match = '^(> )*(峭壁实在太陡了|江面太宽了|河面太宽了|有竹篓就坐上去吧|有船不坐)', func = handler.fly_wait }
trigger.new{ name = 'fly_done', group = 'step_handler.fly', match = '^(> )*你在(江中渡船|黄河中渡船|河中渡船|崖间竹篓)上轻轻一点', func = handler.fly_done }

-- 乘坐渡船。黄河、长江、汉水、黑木崖猩猩滩、大雪山绞盘等
-- TODO make sure have silver
function handler:embark()
	if map.get_current_room().exit.enter then self:send{ 'enter' }; return end
	self:send{ self.step.cmd ~= 'enter' and self.step.cmd or 'yell boat' }
	self:newsub{ class = 'killtime', complete_func = handler.embark }
end

-- 下船。渡船、竹篓、藤筐等
function handler:disembark()
	self:listen{ event = 'ferry_arrived', func = handler.getout, id = 'disembark' }
	self:newweaksub{ class = 'killtime', complete_func = handler.disembark }
end
function handler:getout()
	self:send{ 'out' }
end

-- 姑苏慕容
-- TODO make sure have silver
function handler:mr_embark( t )
	self:send{ t.cmd }
end

-- 峨嵋山后山小路
function handler:emei_move_stone( name )
	if name == 'emei_move_stone_succeed' then self:send{ 'nd' }
	else self:send{ 'move stone' } end
end
trigger.new{ name = 'emei_move_stone_fail', group = 'step_handler.emei_move_stone', match = '^(> )*你使尽了吃奶的力气，也没搬开大石头。', func = handler.emei_move_stone }
trigger.new{ name = 'emei_move_stone_succeed', group = 'step_handler.emei_move_stone', match = '^(> )*你双膀较劲，搬开了大石头。', func = handler.emei_move_stone }

-- 黑木崖石门
hmy_shimen_tbl = {
	'教主文成武德，一统江湖',
	'教主千秋万载，一统江湖',
	'属下忠心为主，万死不辞',
	'教主令旨英明，算无遗策',
	'教主烛照天下，造福万民',
	'教主战无不胜，攻无不克',
	'日月神教文成武德、仁义英明',
	'教主中兴圣教，泽被苍生',
}
function handler:hmy_shimen( name )
	if map.get_current_room().exit.wu then self:send{ 'wu' }; return end
	local t = self.step
	t.count = t.count or 0
	if name == 'hmy_shimen_succeed' then
		self:send{ 'wu' }
	else
		t.count = t.count < 8 and t.count + 1 or 1
		local c = 'whisper jia ' .. hmy_shimen_tbl[ t.count ]
		self:send{ c }
	end
end
trigger.new{ name = 'hmy_shimen_fail', group = 'step_handler.hmy_shimen', match = '^贾布听后，眉头紧缩，没有说话。$', func = handler.hmy_shimen }
trigger.new{ name = 'hmy_shimen_succeed', group = 'step_handler.hmy_shimen', match = '^只听贾布说了声：嗯。。是本教兄弟吧？请进来吧。$', func = handler.hmy_shimen }

-- 嵩山松林圣僧塔
local sl_fota_tbl = {
	['嵩山少林无色台'] = 'say 今日大欢喜，舍却危脆身;sheshen',
	['嵩山少林无相牌'] = 'fushi pai',
	['嵩山少林天鸣禅台'] = 'say 若得不驰散，深入实相不;shenru',
	['嵩山少林苦慧坪'] = 'say 其心无所乐;taotuo',
	['嵩山少林晦智圣座'] = 'canchan zuo',
}
function handler:sl_fota()
	local t = self.step
	if t.to.id ~= '嵩山少林无相牌' and t.to.id ~= '嵩山少林晦智圣座' then
		self:send{ sl_fota_tbl[ t.to.id ] }
	elseif t.succeed then
		local c = t.to.id == '嵩山少林无相牌' and 'chuzhang pai' or 'enter'
		self:send{ c }
	else
		self:listen{ event = 'prompt', func = handler.sl_fota, id = 'step_handler.sl_fota' }
		self:send{ sl_fota_tbl[ t.to.id ] }
	end
end
function handler:sl_fota_succeed()
	self.step.succeed = true
end
trigger.new{ name = 'sl_fota_fushi', group = 'step_handler.sl_fota', match = '^你突然有一种出掌的冲动，便想一掌击出。$', func = handler.sl_fota_succeed }
trigger.new{ name = 'sl_fota_canchan', group = 'step_handler.sl_fota', match = '^你在虚空中，感觉大师座下打开了一个小门。$', func = handler.sl_fota_succeed }

-- 归云庄小河
-- TODO check if old man is actually there
function handler:gyz_river( t )
	self:send{ t.cmd }
end

-- 牛家村小海港坐船
-- TODO prepare money
-- TODO handle special price under age 16
function handler:thd_onboard()
	local loc = map.get_current_location()[ 1 ]
	if not handler.data.thd_sail then
		if loc.id ~= '牛家村密室' then
			self:newsub{ class = 'go', to = '牛家村密室', complete_func = handler.thd_onboard }
		else
			self:send{ 'open xiang' }
		end
	elseif loc.id ~= '牛家村小渔港' then
		self:newsub{ class = 'go', to = '牛家村小渔港', complete_func = handler.thd_onboard }
	else
		self:send{ 'ask lao da about 桃花岛;ask lao da about 价钱;give 3 gold to lao da' }
	end
end
function handler:thd_onboard_got_cord( _, t )
	handler.data.thd_sail = { x = tonumber( t[ 2 ] ), y = tonumber( t[ 3 ] ) }
	handler.thd_onboard( self )
end
trigger.new{ name = 'thd_onboard_got_cord', group = 'step_handler.thd_onboard', match = '^(> )*你用劲打开了箱子，发现里面竟藏有着无数的大内密宝。而在珠宝的下面，有一张发黄的海图。中间的一个地方用粗笔画了个圆圈，旁边用潦草的字迹写着\\((\\d+),(\\d+)\\)的字样。$', func = handler.thd_onboard_got_cord }
-- 航海到桃花岛
function handler:thd_sail( t )
	t.x, t.y = 1, 1
	self:send{ 'turn e' }
end
function handler:thd_sail_progress( _, tbl )
	local t = self.step
	local dir = tbl[ 2 ]
	t.x = dir == '西' and t.x - 1 or dir == '东' and t.x + 1 or t.x
	t.y = dir == '北' and t.y - 1 or dir == '南' and t.y + 1 or t.y
	if not handler.data.thd_sail then
		handler.data.thd_sail = { x = 0, y = 0 }
		self:send{ 'ask gong about location' }
		return
 	end
	local dest = handler.data.thd_sail
	if dest.x > t.x then
		if dir ~= '东' then self:send{ 'turn e' } end
	elseif dest.x < t.x then
		if dir ~= '西' then self:send{ 'turn w' } end
	elseif dest.y > t.y then
		if dir ~= '南' then self:send{ 'turn s' } end
	elseif dest.y < t.y then
		if dir ~= '北' then self:send{ 'turn n' } end
	end
end
function handler:thd_sail_cord( _, t )
	self.step.x = tonumber( t[ 1 ] )
	self.step.y = tonumber( t[ 2 ] )
end
trigger.new{ name = 'thd_sail_progress', group = 'step_handler.thd_sail', match = '^(> )*小船正向着(\\S+)方前进。$', func = handler.thd_sail_progress }
trigger.new{ name = 'thd_sail_cord', group = 'step_handler.thd_sail', match = '^艄公看了看海图，说道：我们现在的位置是\\((\\d+)\\,(\\d+)\\)。$', func = handler.thd_sail_cord }

-- 绝情谷小溪
-- TODO make sure player doesn't have weapon equipped
-- TODO if boat is temporarily unavailable, then need to try again
function handler:gyz_river( t )
	self:send{ t.cmd }
end

-- 绝情谷大厅
-- TODO make sure 公孙止 is there

-- 绝情谷鳄鱼潭
-- TODO kill 鳄鱼 first and then ta corpse

-- 绝情谷谷底水潭
-- TODO ensure encumbrance > 50% for qian down, < 30% for qian up, and < 40% for qian zuoshang

-- from 终南山石棺 to 终南山石室#3D
-- TODO make sure have fire

-- 天山百丈涧
-- TODO make sure have sharp weapon

-- 神龙岛
-- TODO make sure have shengzi and sharp weapon

-- 铁掌山洞穴（上官剑南）
-- TODO ask 裘千丈 about 闹鬼 first

-- from 萧府后院 to 萧府树林

-- 大理皇宫后宫

-- 大理王府
-- TODO 如果门派不是天龙寺，那么晚8点到早5点之间需要杀掉npc

-- 昆仑山洞天福地
-- TODO hide 九阳真经 behind before leave

-- 明教密室
-- TODO make sure wielded axe

-- from 华山山涧#SE to 华山万年松
-- TODO get sheng zi first and encumbrance < 50%

-- 华山思过崖洞口
-- TODO get fire and sword

--------------------------------------------------------------------------------
-- Maze handlers

-- 嵩山少林塔林、嵩山少林竹林、嵩山少林松树林、华山松树林、杭州城长廊、武馆竹林、桃花岛绿竹林、铁掌山松树林、明教密道、苏州城杏子林
-- TODO store position info in such cases for later use
local simple_path_tbl = {
	['嵩山少林舍利院'] = { 'ne', 'se', 'n', 'e', 'sw', 'e', 'ne', 'se', 's', 'se', 'e', 'nw', 'w' },
	['嵩山少林古佛舍利塔'] = { 'ne', 'n', 'nw', 'sw', 'w', 'ne', 'w', 's', 'nw', 'sw', 'n', 'se', 'e' },
	['嵩山少林竹林#4'] = { 'n', 's', 'w', 'e', 'w', 'e', 'e', 's', 'w', 'n', },
	['嵩山少林山路#8'] = { 'e', 'n', 'e', 's', 'n', 'e', 'w', 's' },
	['嵩山少林青云坪'] = { 'e', 's', 'e', 'n', 'n', 'e', 'w', 's' },
	['华山石屋'] = { 'n', 'e', 'e', 'e', 'n', 'e', 'e', 'e', 'w' },
	['杭州城黄龙洞'] = { 'n', 's', 'e', 'w' },
	['武馆假山'] = { 'e', 'n', 'n', 'w' },
	['桃花岛积翠亭'] = { 'n', 's', 'w', 'e', 'n', 'n', 's', 'e', 'w', 'n', 's' },
	['桃花岛草地'] = { 's', 's', 'w', 'n', 's' },
	['铁掌山松树林#1'] = { 'e', 's', 'w' },
	['铁掌山松树林#2'] = { 'n', 'w', 'n' },
	['明教秘道出口'] = { 'w', 's', 'e', 's', 'w', 'n' },
	['丐帮杏子林#2'] = { 'e', 'n', 'w', 'n', 'e', 'w', 'n' },
}
function handler:simple_path( t )
  t.pos = t.pos and t.pos + 1 or 1
	t.path = t.path or simple_path_tbl[ t.to.id ]
  local cmd = t.path[ t.pos ]
  if cmd then -- next step
    self:send{ cmd }
  else -- reset to a random step
    t.pos = math.random( #t.path ) - 1
    self:step_handler( t )
  end
end

-- 大理城东山间小路、长安城长街、长安城柏树林、星宿海、兰州城沙漠、星宿海大沙漠、回疆草原边缘、归云庄湖滨小路、杭州城柳林、华山菜地
function handler:go_straight( t )
	self:send{ t.cmd }
end

-- 天龙寺松树林、慕容地下迷宫
local cord_tbl = {
	['天龙寺小洞天'] = { x = 6, y = 7 }, -- 需要随机先天智力大于20
	['天龙寺龙树院'] = { x = -5, y = 6 },
	['天龙寺石板路#NE'] = { x = 0, y = -30 },
	['姑苏慕容库房'] = { x = 6, y = 7 }, -- 需要随机先天智力大于20
	['姑苏慕容正堂'] = { x = -5, y = 6 },
	['姑苏慕容地道#3'] = { x = 0, y = -30 },
}
function handler:cord( t )
	t.dest = t.dest or cord_tbl[ t.to.id ]
	t.x, t.y = t.x or 0, t.y or 0
	if t.dest.x > t.x then self:send{ 'e' }; t.x = t.x + 1; return end
	if t.dest.x < t.x then self:send{ 'w' }; t.x = t.x - 1; return end
	if t.dest.y > t.y then self:send{ 'n' }; t.y = t.y + 1; return end
	if t.dest.y < t.y then self:send{ 's' }; t.y = t.y - 1; return end
	self:send{ 'e' }; t.x = t.x + 1
end

-- from 天龙寺松树林#2 to 天龙寺松树林#M，峨嵋山古德林
local alt_step_tbl = {
	['峨嵋山古德林#2'] = { 'n', 's' },
	['天龙寺松树林#M'] = { 'n', 'w' },
}
function handler:alternate_step( t )
	self.step_need_desc = true -- with this approach we can get room desc before step_ok is checked, but when the handler is called for the 1st time, it won't try to get room desc for the current room
	local step = alt_step_tbl[ t.to.id ]
	t.cmd = t.cmd == step[ 1 ] and step[ 2 ] or step[ 1 ]
	self:send{ t.cmd }
end

-- 回疆大戈壁、峨嵋山小竹林
local twisted_cord_tbl = {
	['白驼山白驼山'] = { x = 6, y = -5 },
	['回疆针叶林#M'] = { x = 0, y = -12 },
	['回疆草棚'] = { x = 0, y = 11 },
	['峨嵋山冷杉林#1'] = { x = 6, y = -5, z = 'n' },
	['峨嵋山九老洞口'] = { x = 6, y = 5, z = 's' },
	['峨嵋山万佛顶'] = { x = -6, y = -5, z = 'e' },
	['峨嵋山八十四盘#3'] = { x = -6, y = 5, z = 'w' },
}
function handler:twisted_cord( t )
	t.dest = t.dest or twisted_cord_tbl[ t.to.id ]
	t.x, t.y = t.x or 0, t.y or 0
	if t.dest.x > t.x then self:send{ 'n' }; t.x = t.x + 1; return end
	if t.dest.x < t.x then self:send{ 'e' }; t.x = t.x - 1; return end
	if t.dest.y > t.y then self:send{ 's' }; t.y = t.y + 1; return end
	if t.dest.y < t.y then self:send{ 'w' }; t.y = t.y - 1; return end
	if t.dest.z then self:send{ t.dest.z }; return end
end

-- 回疆针叶林、回疆大戈壁（回疆绿洲方向）、终南山黑林、峨嵋山灌木丛、终南山石室
local fixed_step_tbl = {
	['回疆针叶林#E'] = { 'n:10', 's:10', 'e:10', 'w:10' },
	['回疆回疆绿洲'] = { 'n:11', 'w:7', 's:7', 'e:7', 'n:7' },
	['终南山灌木丛'] = { 'n:4', 'e:6' },
	['终南山树林'] = { 'n:4', 'w:6' },
	['终南山石室#2D'] = { 'n:6', 'w:6', 's:6', 'e:6' },
	['峨嵋山灌木丛#2'] = { 'ed:4', 'sw:1', 'ne:5', 'ne:5', 'ne:5', 'ne:5', 'ne:5' },
}
local patt = lpeg.C( lpeg.R 'az'^1 ) * ':' * ( lpeg.R'09'^1 / tonumber )
function handler:fixed_step( t )
	t.step, t.phase = t.step and t.step + 1 or 1, t.phase or 1
	t.path = t.path or fixed_step_tbl[ t.to.id ]
	if t.phase > #t.path then self:fail() end
	local c, n = patt:match( t.path[ t.phase ] )
	if t.step > n then
		t.phase, t.step = t.phase + 1, 0
		self:send{ 'yun jingli' } -- FIXME a temp workaround to avoid dying in 峨嵋山灌木丛
		self:step_handler( t )
	else
		self:send{ c }
	end
end

-- 梅庄梅林
function handler:meilin( t )
	t.list, t.forward = t.list or {}, t.forward == nil and true or t.forward
	if t.forward and not map.get_current_room().desc then self:send{ 'l' }; return end
	if t.forward then table.insert( t.list, map.get_current_room().exit ) end
	local node, revdir = t.list[ #t.list ], DIR_REVERSE[ t.cmd ]
	node[ revdir ] = node[ revdir ] and 0 or nil
	for dir, v in pairs( node ) do
		if v ~= 0 and v ~= nil then t.cmd, t.forward = dir, true; break end
		if v ~= nil then t.cmd, t.forward = dir, false end
	end
	node[ t.cmd ] = nil
	if not next( node ) then table.remove( t.list ) end
	self:send{ t.cmd }
end

-- 襄阳郊外树林
local xy_shulin_path = { 'n', 'e', 'n', 'e', 'w', 's', 'n', 's', 's', 'n' }
function handler:xy_shulin( t )
	local room = map.get_current_room()
	if not room.desc and not t.pos then self:send{ 'l' }; return end
	t.pos = ( room.exit.s == '山路' and 1 )
				or ( room.exit.n == '山路' and 8 )
				or ( t.pos and t.pos < 10 and t.pos + 1 )
				or ( t.pos and 1 )
	self:send{ ( t.pos == 1 and t.to.id == '襄阳郊外山路#1' and 's' )
					or ( t.pos == 8 and t.to.id == '襄阳郊外山路#2' and 'n' )
					or ( t.pos and xy_shulin_path[ t.pos ] )
					or xy_shulin_path[ math.random( 10 ) ] }
end

-- 绝情谷竹林
local jqg_zhulin_path = { 'n', 'w', 's', 'e', 'w' }
function handler:jqg_zhulin( t )
	local room = map.get_current_room()
	t.pos = ( room.exit.su and 1 )
				or ( t.pos and t.pos < 5 and t.pos + 1 )
				or ( room.exit.wd and nil )
	self:send{ ( room.exit.su and t.to.id == '绝情谷山顶平地' and 'su' )
					or ( room.exit.wd and t.to.id == '绝情谷水塘' and 'wd' )
					or ( t.pos and jqg_zhulin_path[ t.pos ] )
					or jqg_zhulin_path[ math.random( 4 ) ] }
end

-- from 明教紫杉林#9 to X字门，明教树林
function handler:look_self_dir( t )
	if not map.get_current_room().desc then self:send{ 'l' }; return end
	for dir, roomname in pairs( map.get_current_room().exit ) do
		if roomname == t.to.name then self:send{ dir }; return end
	end
end

-- 明教紫杉林，from 福州城小岛 to 福州城沙滩#1
local look_around_cond_tbl = {
	['明教紫杉林#5'] = { exit = function( exit ) return exit.e == '厚土旗' end },
	['明教紫杉林#1'] = { exit = function( exit ) return string.find( exit.e, '旗' ) or string.find( exit.w, '旗' ) end },
	['明教紫杉林#9'] = {	exit = function( exit ) return string.find( exit.e, "字门" ) end,
											alt_exit = function( exit ) return string.find( exit.e, '旗' ) or string.find( exit.w, '旗' ) end,
											look = function( roomname ) return roomname == '紫杉林' end	},
	['福州城沙滩#1'] = { exit = function( exit ) return exit.w == '小岛' and exit.n end,
											alt_exit = function( exit ) return true end,
											look = function( roomname ) return roomname == '沙滩' end },
}
function handler:look_around( t )
	if not map.get_current_room().desc then self:send{ 'l' }; return end
	self.step_need_desc = true
	local cond = look_around_cond_tbl[ t.to.id ]
	t.is_look_ok = cond.look or function() return true end
	t.is_exit = cond.exit
	t.is_alt_exit = cond.alt_exit or function() return false end
	t.look = coroutine.wrap( handler.look )
	t.look( self, t )
end
function handler:look( t )
	local exit, dir_list = map.get_current_room().exit, {}
	for dir, roomname in pairs( exit ) do
		table.insert( dir_list, dir )
		if t.is_look_ok( roomname ) then
			self:newsub{ class = 'getinfo', room = dir, complete_func = handler.look_around_result }
			coroutine.yield()
		end
	end
	if t.alt_exit or t.cmd then -- go alternate exit or back to XX旗
		self:send{ t.alt_exit or t.cmd }
		t.alt_exit = nil
	else -- go random direction
		self:send{ dir_list[ math.random( #dir_list ) ] }
	end
end
function handler:look_around_result( result )
	local t = self.step
	for dir, room in pairs( result ) do
		if t.is_exit( room.exit ) then self:send{ dir }; return end
		if t.is_alt_exit( room.exit ) then t.alt_exit = dir end
	end
	t.look( self, t )
end

-- 武当后山丛林
local fingerprint = {
	'aaaaaAAaA', 'aaAaaAAaa', 'aaaaaAAAa', 'abbaAaAAa',
	'bBBAAabaa', 'bBBbbBBBB', 'bBBBBbBBb', 'bBBccBbbc',
	'cbbbCCCcC', 'cCbCccCCb', 'cbCcCbCCc', 'cdcCcCcCC',
	'dcCCDdDDD', 'dDDDDDDdd', 'ddDdDeDDD', 'ddDeDDDDD',
}
local fp_match_tbl = { a = 'aAB', b = 'bABC', c = 'cBCD', d = 'dCD', e = 'e' }
local wdhs_layout = { ['武当后山烈火丛林'] = 1, ['武当后山落叶丛林'] = 2, ['武当后山积雪丛林'] = 3, ['武当后山阔叶丛林'] = 4, ['武当后山丛林边缘#2'] = 5 }
local wdhs_fpath = { 'w', 'n', 'n', 'w', 'nw', 'n', 'sw', 'n', 'se', 'ne', 's', 'e', 'ne', 'se', 'e' }
local wdhs_bpath = { 'e', 's', 'sw', 'e', 'n', 'sw', 'n', 'w', 'se', 'ne', 's', 'se', 'ne', nil, 'se' }
local function wdhs_conglin_locate( room ) -- return room no. that matches given exits
	local e, result = room.exit, {}
	local f = room.name == '烈火丛林' and 'a'
				 or room.name == '落叶丛林' and 'b'
				 or room.name == '积雪丛林' and 'c'
				 or room.name == '阔叶丛林' and 'd'
	for _, dir in ipairs( DIR8 ) do
		f = f .. ( e[ dir ] == '烈火丛林' and 'a'
						or e[ dir ] == '落叶丛林' and 'b'
						or e[ dir ] == '积雪丛林' and 'c'
						or e[ dir ] == '阔叶丛林' and 'd'
						or e[ dir ] == '丛林边缘' and 'e' )
	end
	for roomno, fp in pairs( fingerprint ) do
		local diff
		for pos = 1, 9 do
			local a, b = string.sub( f, pos, pos ), string.sub( fp, pos, pos )
			if not string.find( fp_match_tbl[ a ], b ) then diff = true; break end
		end
		if not diff then table.insert( result, roomno ) end
	end
	if #result == 1 then return result[ 1 ] else return end
end
function handler:wdhs_conglin( t )
	local pos, room = handler.data.wdhs_conglin_pos, map.get_current_room()
	if not room.desc and not pos then self:send{ 'l' }; return end
	if pos then -- if exact position is known, then just walk the path
		-- go to 武当后山丛林边缘#2 if in correct position
		if pos > 14 and t.to.id == '武当后山丛林边缘#2' then
			handler.data.wdhs_conglin_pos = nil
			self:send{ pos == 15 and 'ne' or 's' }
			return
		end
		-- otherwise, walk the forward or backward path
		local forward = wdhs_layout[ t.from.id ] < wdhs_layout[ t.to.id ]
		local cmd = forward and wdhs_fpath[ pos ] or wdhs_bpath[ 17 - pos ]
		if cmd then
			self:send{ cmd  .. ( room.name == '积雪丛林' and ';#wa 3000' or '' ) } -- wait 3 seconds after leaving a 积雪丛林 room because of busy
			handler.data.wdhs_conglin_pos = pos + ( forward and 1 or -1 )
		else -- lost path, clear position and re-evaluate
			handler.data.wdhs_conglin_pos = nil
			self:step_handler( t )
		end
	else -- if exact position is unknown
		local cur_pos = wdhs_conglin_locate( room )
		if cur_pos then -- if current room can be uniquely identified
			handler.data.wdhs_conglin_pos = cur_pos
			self:step_handler( t )
		else
			-- check for exit leading to dest
			for dir, roomname in pairs( room.exit ) do
				if roomname == t.to.name then
					handler.data.wdhs_conglin_pos = nil
					self:send{ dir  .. ( room.name == '积雪丛林' and ';#wa 3000' or '' ) }
					return
				end
			end
			-- look around
			t.look_around = coroutine.wrap( handler.wdhs_conglin_look )
			t.look_around( self, t )
		end
	end
end
-- look around
function handler:wdhs_conglin_look( t )
	local room = map.get_current_room()
	for dir, roomname in pairs( room.exit ) do
		if roomname == room.name then
			self:newsub{ class = 'getinfo', room = dir, complete_func = handler.wdhs_conglin_look_result }
			coroutine.yield()
		end
	end
	if t.alt_exit then -- go alternate exit (exit leading to room with same name)
		self:send{ t.alt_exit .. ( room.name == '积雪丛林' and ';#wa 3000' or '' ) }
		t.alt_exit = nil
	else -- go random direction
		self:send{ DIR8[ math.random( 8 ) ] .. ( room.name == '积雪丛林' and ';#wa 3000' or '' )  }
	end
end
-- parse look result
function handler:wdhs_conglin_look_result( result )
	local t = self.step
	for dir, room in pairs( result ) do
		if wdhs_conglin_locate( room ) then self:send{ dir }; return end -- go to room that can be uniquely identified
		t.alt_exit = dir
	end
	t.look_around( self, t )
end

-- 武当山后院小径

-- 萧府树林

-- 归云庄九宫桃花阵
local num = lpeg.C ( ( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九' + '十' )^1 )
local patt = lpeg.P '有' * num * '株桃花('
local spatt = any_but( patt )^0 * patt
local gyz_jiugong_path = { 'e', 'e', 's', 'w', 'w', 's', 'e', 'e', 'w', 'w', 'n', 'e', 'e', 'n', 'w', 'w' }
local gyz_jiugong_tbl = {
	xoxo = 1, xxxo = 2, oxxo = 3,
	xoxx = 6, xxxx = 5, oxxx = 4,
	xoox = 7, xxox = 8, oxox = 9,
}
local function get_taohua_count( room )
	local n = spatt:match( room.desc )
	n = n and cntonumber( n ) or 0
	return n
end
local function get_pos( room )
	local f = ''
	for _, dir in pairs( DIR4 ) do
		f = f .. ( room.exit[ dir ] and 'x' or 'o' )
	end
	return gyz_jiugong_tbl[ f ]
end
function handler:gyz_jiugong( t )
	t = self.step
	local room = map.get_current_room()
	if t.exited then return end
	t.inv_count, t.curr_pos = t.inv_count or 0, get_pos( room )
	if not room.desc and not t[ t.curr_pos ] then self:send{ 'l' }; return end
	local taohua_count = t[ t.curr_pos ] or get_taohua_count( room )
	if not t.taohua_adjusted and taohua_count ~= 5 and t.inv_count >= 5 - taohua_count then
		t.taohua_adjusted = true
		t.inv_count = t.inv_count + taohua_count - 5
		if taohua_count > 5 then
			self:send{ 'get ' .. taohua_count - 5 .. ' taohua' }
		elseif taohua_count < 5 then
			self:send{ 'drop ' .. 5 - taohua_count .. ' taohua' }
		end
		t[ t.curr_pos ] = 5
		self:listen{ event = 'prompt', func = handler.gyz_jiugong, id = 'step_handler.gyz_jiugong' }
	else
		t[ t.curr_pos ] = t[ t.curr_pos ] or taohua_count
		t.taohua_adjusted = false
		t.step_num = t.step_num or t.curr_pos - 1
		t.step_num = t.step_num < 16 and t.step_num + 1 or 1
		self:send{ gyz_jiugong_path[ t.step_num ] }
	end
end
function handler:gyz_jiugong_exited()
	self.step.exited = true
end
trigger.new{ name = 'gyz_jiugong_exited', group = 'step_handler.gyz_jiugong', match = '^桃花阵中忽然发出一阵“轧轧”的声音，随后现出一条道路，你赶忙走了出去。$', func = handler.gyz_jiugong_exited }

-- 桃花岛桃花阵, from 桃花岛绿竹林 to 桃花岛河塘
-- TODO make sure have enough number of marker items
-- TODO 1. support combinations of multiple types of items as identifiers of rooms (no more simple coin count as id) 2. switch between multiple types of items as necessary (based on factors like inventory item count)
local item = 'coin'
local cn_item = '铜钱'
-- return number of items on the ground
local function get_item_count( room )
	return not room.object[ cn_item ] and 0 or room.object[ cn_item ].count
end
-- check if a room has empty exit
local function has_empty_exit( room, t )
	local data, i  = t.map[ room ], 0
	for _, dir in pairs( DIR4 ) do
		if data[ dir ] then i = i + 1 end
	end
	if i < 4 then return true end
end
-- check if a room is completely unknown
local function is_unknown( room, t )
	for _, dir in pairs( DIR4 ) do
		if t.map[ room ][ dir ] then return end
	end
	return true
end
-- find a new unique numeric id for a room
local function get_new_unique_id( t )
	for i = 1, 100 do
		if not t.map[ i ] then return i end
	end
	error 'step_handler.breadcrumb - failed to find available id under 100'
end
-- return a clean-slate map
local function get_clean_map( t )
	return t.from.id == '桃花岛桃花阵' and { { id = 1 } } -- a single blank room
				 or { { id = 1, w = 2, is_reliable = true },
							{ id = 2, n = 3, is_reliable = true },
							{ id = 3, s = 4, is_reliable = true },
							{ id = 4, s = 5, is_reliable = true },
							{ id = 5, is_reliable = true } } -- predefined partial structure for 桃花岛绿竹林#2
end
-- find path to nearest room with empty exit or is unreliable, or to maze exit
local function findpath_to( target, t )
	message.debug( '开始生成路径，目标为 ' .. target )
	local list, list_pos, processed, prev, cpath, path, rev_path, to, dest = { t.curr }, 1, { [ t.curr ] = true }, {}, {}, {}, {}
  while list[ list_pos ] do
    from = list[ list_pos ]
		-- found dest?
    if ( target == 'exit' and t.map[ from ].id == 'x' )
		or ( target == 'unknown' and is_unknown( from, t ) )
		or ( target == 'unsure' and not t.map[ from ].is_bad and ( has_empty_exit( from, t ) or t.map[ from ].is_reliable == false ) )
		or ( target == 'bad' and t.map[ from ].is_bad ) then dest = from; break end
		-- evaluate rooms linked from this one
    for _, dir in pairs( DIR4 ) do
			to = t.map[ from ][ dir ]
      if to
			and to ~= 'a' -- ignore exits to alt maze exits (to 积翠亭 or 草地)
			and from ~= to -- ignore exit to same room
			and not processed[ to ] -- only add per room once
			and ( t.map[ to ].is_reliable ~= false or target == 'unsure' ) -- ignore unreliable room if target isn't 'unsure'
			and ( not t.map[ to ].is_bad or target == 'bad' ) then -- ignore bad room if target isn't 'bad'
      	prev[ to ], list[ #list + 1 ], processed[ to ] =  from, to, true
      end
    end
    list_pos = list_pos + 1 -- move to next node
  end
	if not dest then return end -- path generation failed
	while dest do -- generate reverse path
		rev_path[ #rev_path + 1 ] = dest
		dest = prev[ dest ]
	end
	for i = #rev_path, 1, -1 do -- generate path
		path[ #path + 1 ] = rev_path[ i ]
	end
	message.debug( '生成的房间路径为 ' .. table.concat( path, '> ') )
	for i, from in ipairs( path ) do -- generate cmd list
		local room, to = t.map[ from ], path[ i + 1 ]
		if not to then break end -- reached last node in path?
		for _, dir in pairs( DIR4 ) do
			if room[ dir ] == to then cpath[ #cpath + 1 ] = dir; break end
		end
	end
	if target == 'exit' then cpath[ #cpath + 1 ] = 'n' end
	message.debug( '生成的命令路径为 ' .. table.concat( cpath, '; ') )
	return cpath
end
-- move to a direction
local function move( self, dir )
	local t = self.step
	t.prev, t.prev_dir = t.curr, dir
	t.expected = t.map[ t.curr ][ dir ] or 0
	self:send{ dir }
end
-- the main handler
function handler:breadcrumb( t )
	local item_count = get_item_count( map.get_current_room() )

	if not t.map then -- initialze the map
		-- try to reuse previous map
		t.map = handler.data[ t.from.id ]
		-- no previous map, map is complete but non-reusable, or older than 15 minutes?
		if not t.map or ( t.map.is_complete and not t.map.is_reusable ) or os.time() - t.map.update_time > 900 then
			t.map = get_clean_map( t ) -- use a clean-slate map
		end
 	end

	-- if map is complete and reusable, try to walk to exit directly
	if t.map.is_complete and t.map.is_reusable then
		if not t.path_to_exit then
			t.curr = 1
			t.path_to_exit = findpath_to( 'exit', t )
			-- path generation failed?
			if not t.path_to_exit and item_count ~= 0 then
				t.curr = item_count -- try path generation again based the assumption that current room == item count on ground
				t.path_to_exit = findpath_to( 'exit', t )
			end
			t.map.update_time = os.time() -- everytime the map is reused, update the time
		end
		-- has path to exit?
		if t.path_to_exit and next( t.path_to_exit ) then -- start or keep on walking
			local dir = table.remove( t.path_to_exit, 1 )
			self:send{ dir }
			return -- skip all subsequent evaluation
		elseif t.path_to_exit then -- no more steps but didn't exit the maze, have to start from scratch
			message.debug '之前的路径无效，从头开始'
			t.path_to_exit = nil
			t.map = { { id = 1 }; is_reusable = false } -- use a blank map and mark the map as non-reusable since we're not starting from the entry point
		else -- path generation failed, have to start from scratch
			t.map = get_clean_map( t ) -- use a clean-slate map
		end
	end

	-- if expected to arrive at (alt) maze exit
	if type( t.expected ) == 'string' then
		t.map[ t.expected ] = t.map[ t.expected ] or { id = t.expected }
		-- at real maze exit?
		if t.expected == 'x' then -- final touches to the map
			t.map.is_complete = true
			t.map.is_reusable = t.map.is_reusable ~= false
			message.debug( '当前地图的可复用性为 ' .. tostring( t.map.is_reusable ) )
		end
		t.map.update_time = os.time()
		handler.data[ t.from.id ] = t.map
		self:send{ t.expected == 'x' and 'n' or 's' }
		return
	end

	-- item count evaluation
	t.expected, t.prev = t.expected or 1, t.prev or 1
	local expected_room, action = t.map[ t.expected ], {}
	-- item count match expectation?
	if item_count == t.expected then
		if t.expected == 0 or expected_room.is_reliable == false then
			action.adjust_item_to_new_unique = true
		end
	elseif t.map[ t.prev ].is_reliable and t.expected > 0 and expected_room.is_reliable then
		if t.prev ~= t.expected then t.map[ t.prev ].is_reliable = nil end -- remove prev room's reliable tag since after initial set up it could cause problems (e.g. other rooms with same item count). This would result in a single room still has the tag but that should be no problem.
		action.adjust_item_to_expected = true
	elseif item_count == 0 then
		if not expected_room.drop_time or os.time() - expected_room.drop_time > 60 then
			action.adjust_item_to_expected = true
		else
			action.adjust_item_to_new_unique = true
			action.mark_prev_unreliable = true
		end
	elseif t.expected ~= 0 then
	 	if expected_room.is_reliable ~= false or not expected_room.alternate or not expected_room.alternate[ item_count ] then
			action.mark_prev_unreliable = true
			if t.map[ item_count ] and t.map[ item_count ].is_reliable == false then
				action.adjust_item_to_new_unique = true
			end
		end
	end

	-- mark prev room as unreliable if necessary
	if action.mark_prev_unreliable then
		message.debug '将之前房间的数据标为不可靠'
		t.map[ t.prev ].is_reliable = false
		t.path = nil -- delete existing path since there's map error
	end

	-- adjust item count if necessary (when at exit, skip this step)
	if ( action.adjust_item_to_new_unique or action.adjust_item_to_expected ) then
		local new_count = t.expected
		if action.adjust_item_to_new_unique then
			new_count = get_new_unique_id( t )
			if t.expected ~= 0 then -- add the new count as an alternate to the old unreliable count
				t.map[ t.expected ].alternate = t.map[ t.expected ].alternate or {}
				t.map[ t.expected ].alternate[ new_count ] = true
			end
		end
		local cmd = new_count > item_count and 'drop' or 'get'
		local num = math.abs( new_count - item_count )
		self:send{ ( '%s %d %s' ):format( cmd, num, item ) }
		item_count = new_count
		t.map[ item_count ] = t.map[ item_count ] or { id = item_count }
		t.map[ item_count ].drop_time = os.time()
	end

	-- use number of items on ground as identifier of the room
	t.curr = item_count
	t.map[ t.curr ] = t.map[ t.curr ] or { id = t.curr }
	-- update exit info of prev node
	if t.prev_dir then t.map[ t.prev ][ t.prev_dir ] = t.curr end
	-- reset obsolete vars
	t.prev, t.prev_dir, t.expected = nil

	if t.path and next( t.path ) then -- is walking a path, continue walking
		local dir = table.remove( t.path, 1 )
		move( self, dir )
	else
		-- if this reliable room has a reliable neighbor, walk to it
		local reliable_dir, to
		if t.map[ t.curr ].is_reliable then
			for _, dir in pairs( DIR4 ) do
				to = t.map[ t.curr ][ dir ]
				if type( to ) == 'number' and t.map[ to ].is_reliable then reliable_dir = dir; break end
			end
		end
		if reliable_dir then
			move( self, reliable_dir )
		else -- otherwise, look around
			t.look_around = coroutine.wrap( handler.breadcrumb_look )
			t.look_around( self, t )
		end
	end
end
-- look around
function handler:breadcrumb_look( t )
	for _, dir in pairs( DIR4 ) do -- check 4 directions
		local d = t.map[ t.curr ][ dir ]
		if t.map[ t.curr ].is_reliable == false or not d or ( type( d ) == 'number' and t.map[ d ].is_reliable == false ) then -- if this room is unreliable, or we don't have data for a dir or the room in that dir is marked as unreliable, then look at it, but avoid exits with string labels
			self:newsub{ class = 'getinfo', room = dir, complete_func = handler.breadcrumb_look_result }
			coroutine.yield()
		end
	end
	if t.preferred_exit then -- if got preferred exit, then go this dir
		move( self, t.preferred_exit )
		t.preferred_exit, t.alt_exit = nil
	elseif t.alt_exit then -- then, if got alternate exit, then go this dir
		move( self, t.alt_exit )
		t.alt_exit = nil
	else -- otherwise, walk to a room that has an exit leading to an unknown or empty room, or is marked unreliable
		t.path = findpath_to( 'unknown', t ) or findpath_to( 'unsure', t ) or findpath_to( 'bad', t )
		if t.path then
			local dir = table.remove( t.path, 1 )
			move( self, dir )
		else -- if no path, then mark all rooms as unreliable and start over
			for _, room in ipairs( t.map ) do
				room.is_reliable = false
			end
			t.map.is_reusable = false -- mark current map as non-reusable because of poor quality
			self:send{ 'l' }
		end
	end
end
-- parse look result
function handler:breadcrumb_look_result( result )
	local t = self.step
	for dir, room in pairs( result ) do
		-- already at room exit?
		if room.name ~= t.from.name then -- if we have to look around at maze exit to know that we're at one, then things are seriously wrong
			handler.data[ t.from.id ] = nil -- clear all data
			self:send{ dir } -- exit maze
			return
		end

		-- next room is maze exit?
		if room.exit.n ~= t.from.name then
			t.map[ t.curr ][ dir ] = 'x'
			move( self, dir )
			return
		-- next room is alt maze exit?
		elseif room.exit.s ~= t.from.name then
			t.map[ t.curr ][ dir ] = 'a'
			-- only take alt maze exit to 积翠亭 if it's to the north of this room (because that's when we're probably at 绿竹林 pos 10)
			if room.exit.s == '草地' or dir == 'n' then
				t.map[ t.curr ].is_bad = true -- mark current room as bad so that we try to avoid it whenever possible
				move( self, dir )
				return
			end
		else
			local item_count = get_item_count( room )
			t.map[ t.curr ][ dir ] = item_count > 0 and item_count or nil -- only update info for dir with items
			t.map[ item_count ] = item_count > 0 and ( t.map[ item_count ] or { id = item_count } ) or nil  -- add an map entry for first-time seen non-empty room
			if item_count > 0 and is_unknown( item_count, t ) then t.preferred_exit = dir end -- prefer exit to completely unknown room
			if item_count == 0 or ( t.map[ item_count ].is_reliable == false and not t.map[ item_count ].is_bad ) then t.alt_exit = dir end -- then, prefer exit to an empty room or unreliable room (so that we can fix it first)
		end
	end
	t.look_around( self, t )
end

-- 桃花岛八卦桃花阵
-- TODO pre-check to look bagua when passing by
function handler:thd_bagua( t )
	local loc = map.get_current_location()[ 1 ]
	if not handler.data.thd_bagua then
		if loc.id ~= '桃花岛方厅' then
			self:newsub{ class = 'go', to = '桃花岛方厅', complete_func = handler.thd_bagua }
		else
			self:send{ 'l bagua' }
		end
		return
	end
	if loc.id == '桃花岛山冈' or loc.id == '桃花岛小院' then
		local c = string.sub( handler.data.thd_bagua, 1, 1 ) == '1' and 'e' or 'w'
		self:send{ c }
	elseif loc.id == '桃花岛八卦桃花阵' then
		t.step_num = t.step_num or 1
		local prev = string.sub( handler.data.thd_bagua, t.step_num, t.step_num )
		t.step_num = t.step_num + 1
		local c = string.sub( handler.data.thd_bagua, t.step_num, t.step_num )
		c = prev == c and 's' or 'e'
		self:send{ c }
	else
		self:newsub{ class = 'go', to = '桃花岛山冈', complete_func = handler.thd_bagua }
	end
end
local thd_bagua_tbl = {
	['乾'] = '111', ['兑'] = '011', ['离'] = '101', ['震'] = '001',
	['巽'] = '110', ['坎'] = '010', ['艮'] = '100', ['坤'] = '000',
}
function handler:thd_bagua_parse( _, t )
	local s = ''
	for i = 1, 8 do
		local char = string.sub( t[ 1 ], i * 2 - 1, i * 2 )
		s = s .. thd_bagua_tbl[ char ]
	end
	handler.data.thd_bagua = s
	handler.thd_bagua( self, self.step )
end
function handler:thd_bagua_blocked()
	handler.data.thd_bagua = nil
	handler.thd_bagua( self, self.step )
end
trigger.new{ name = 'thd_bagua', group = 'step_handler.thd_bagua', match = '^一个奇怪的铁八卦，上面按顺时针顺序排列着：(\\S+)。$', func = handler.thd_bagua_parse }
trigger.new{ name = 'thd_bagua_blocked', group = 'step_handler.thd_bagua', match = '^(> )*你感觉这个桃花阵中暗藏八卦，隐隐生出阻力，将你推了回来！$', func = handler.thd_bagua_blocked }

-- 桃花岛墓道
local thd_mudao_tbl = {
	{ 'nu', 'n', 'nd', 'ne', 'e', 'se', 'su', 's', 'sd', 'sw', 'w', 'nw' },
	{ 'nw', 'nu', 'n', 'nd', 'ne', 'e', 'se', 'su', 's', 'sd', 'sw', 'w' },
}
-- from 桃花岛墓道#M to 桃花岛墓道#2
function handler:thd_mudao( t )
	t = self.step
	local room = map.get_current_room()
	-- arrived at 桃花岛墓道#2?
	if room.exit.d and not room.exit.out then self:send{ 'l' }; return end
	-- intercept next located event, i.e. handle failures here instead of by the standard routine
	self:listen{ event = 'located', func = handler.thd_mudao, id = 'step_handler.thd_mudao', sequence = 99, keep_eval = false }
	-- returned to 桃花岛墓道#1?
	if room.exit.out then
		-- ignore first room because of repetition bug
		if not t.is_fail_known then t.is_fail_known = true; return end
		-- reset vars
		t.is_fail_known, t.round = nil, 1
		-- adjust time accordingly
		time.hour, time.calibrate_time, time.update_time, player.time_update_time = math.ceil( time.get_current_hour() ), os.time(), os.time(), os.time()
		-- go down again
		self:send{ 'd' }
		return
	end
	local hour = time.get_current_hour()
	-- wait if hour is 0, since there's no exit during this hour
	if hour < 1 then
		local sec = ( 1 - hour ) * 60 + 5 -- wait until 1 am
		self:newsub{ class = 'killtime', duration = sec, complete_func = handler.thd_mudao }
		return
	end
	hour = math.floor( hour )
	hour = hour > 12 and hour - 12 or hour
	-- otherwise move to next room
	t.round = t.round or 1
	self:send{ thd_mudao_tbl[ t.round ][ hour ] }
	t.round = t.round + 1
end
-- from 桃花岛墓道#2 to 桃花岛墓道#M
function handler:thd_mudao_up( t )
	local room = map.get_current_room()
	for _, dir in pairs( DIR_ALL ) do
		if dir ~= 'd' and room.exit[ dir ] then self:send{ dir }; return end
	end
end

-- 桃花岛太极阵
-- 两仪层
function handler:thd_liangyi( t )
	t = self.step
	if not t.has_time then -- update time info
		t.has_time = true
		self:newsub{ class = 'getinfo', time = 'forced', complete_func = handler.thd_liangyi }
		return
	end
	local room = map.get_current_room()
	if not t.dir or room.name ~= '两仪' then
		t.dir = time.day > 15 and 'sw' or 'ne'
		self:listen{ event = 'located', func = handler.thd_liangyi, id = 'step_handler.thd_liangyi', sequence = 99, keep_eval = false }
		self:send{ room.name == '两仪' and t.dir or DIR_REVERSE[ t.dir ] }
	else
		self:send{ 'd' }
	end
end
-- 四象层
local thd_wuxing_tbl = {
	['金'] = { -1, -1, -1, 1, 1, 1, 1, 2, 2, 2, 2, -1 },
	['木'] = { 1, 2, 2, 2, 2, -1, -1, -1, -1, 1, 1, 1 },
	['水'] = { 2, 2, -1, -1, -1, -1, 1, 1, 1, 1, 2, 2 },
	['火'] = { 1, 1, 1, 1, 2, 2, 2, 2, -1, -1, -1, -1 },
	['土'] = { -1, -1, -1, -1, 1, 1, 1, 1, 2, 2, 2, 2 },
}
local thd_sixiang_exit_tbl = { ['土'] = '四象', ['水'] = '太阴', ['火'] = '太阳', ['木'] = '少阴', ['金'] = '少阳', }
function handler:thd_sixiang( t )
	t = self.step
	local hour = time.get_current_hour()
	if not t.is_going_down then
		local dir = ( hour >= 5 and hour < 11 and 'e' )
						 or ( hour >= 11 and hour < 17 and 's' )
						 or ( hour >= 17 and hour < 23 and 'w' )
						 or ( hour >= 23 or hour < 5 and 'n' )
		t.is_going_down = 'find'
		self:listen{ event = 'located', func = handler.thd_sixiang, id = 'step_handler.thd_sixiang', sequence = 99, keep_eval = false }
		self:send{ dir }
	elseif t.is_going_down == 'find' then
		local ok_list = {}
		for wx, t in pairs( thd_wuxing_tbl ) do
			if t[ time.month ] > 0 then ok_list[ wx ] = t[ time.month ] end
		end
		local room, wuxing_dest, sixiang_dest, is_central_ok = map.get_current_room()
		for wx, score in pairs( ok_list ) do
			sixiang_dest, wuxing_dest = thd_sixiang_exit_tbl[ wx ], wx
			if sixiang_dest == room.name then break end
			if sixiang_dest == '四象' then is_central_ok = true end
		end
		if sixiang_dest == room.name then -- go to 五行 from current room
			handler.data.wuxing = ok_list[ wuxing_dest ]
			self:send{ 'd' }
		else -- go to 五行 from another room
			t.is_going_down = 'ready'
			sixiang_dest = is_central_ok and '四象' or sixiang_dest -- prefer central room
			wuxing_dest = sixiang_dest == '四象' and '土' or wuxing_dest
			handler.data.wuxing = ok_list[ wuxing_dest ]
			self:newsub{ class = 'go', to = '桃花岛' .. sixiang_dest, complete_func = handler.thd_sixiang }
		end
	else
		self:send{ 'd' }
	end
end
-- 五行层
local thd_wuxing_step_tbl = {
	{ ['金'] = 'shui', ['水'] = 'mu', ['木'] = 'huo', ['火'] = 'tu', ['土'] = 'jin', },
	{ ['金'] = 'mu', ['木'] = 'tu', ['土'] = 'shui', ['水'] = 'huo', ['火'] = 'jin', },
}
function handler:thd_wuxing( t )
	local room = map.get_current_room()
	if room.name == '石坟' then self:send{ 'l' }; return end
	local dir = thd_wuxing_step_tbl[ handler.data.wuxing ][ room.name ]
	self:listen{ event = 'located', func = handler.thd_wuxing, id = 'step_handler.thd_wuxing', sequence = 99, keep_eval = false }
	self:send{ dir }
end

-- 天山山涧
local patt = any_but '灌木'^1 * '灌木，' * lpeg.C( any_but '方'^1 ) * '方似乎能走过去'
function handler:ts_longtan( t )
	local room = map.get_current_room()
	if not room.desc then self:send{ 'l' }; return end
	local dir = CN_DIR[ patt:match( room.desc ) ]
	self:send{ dir }
end

-- 无量山大松林
-- TODO limit to a certain number of steps since this maze can be a dead lock
local wls_songlin_tbl = { { 'w', 'e' }, { 'w', 'e', 's' }, { 'w', 'n' } }
function handler:wls_songlin( t )
	local room = map.get_current_room()
	if not room.desc then self:send{ 'l' }; return end
	local pos = room.exit.s == '后院' and 1 or room.exit.e == '大瀑布' and 3 or 2
	if pos == 1 and t.to.id == '无量山后院' then self:send{ 's' }; return end
	if pos == 3 and t.to.id == '无量山大瀑布' then self:send{ 'e' }; return end
	local t = wls_songlin_tbl[ pos ]
	self:send{ t[ math.random( #t ) ] }
end

-- 无量山山路 (quest)

-- 蝴蝶谷花圃
-- TODO better handling to keep jing up
function handler:hdg_huapu( t )
	t = self.step
	t.i = t.i or 1
	local room = map.get_current_room()
	if room.name == t.to.name then self:send{ 'l' }; return end
	if room.name == '牛棚' then self:send{ 'nd' }; return end
	self:listen{ event = 'located', func = handler.hdg_huapu, id = 'step_handler.hdg_huapu', sequence = 99, keep_eval = false }
	t.i = t.i + 1
	if t.i > 10 then self:send{ 'yun jing' }; t.i = 0 end
	self:send{ DIR4[ math.random( 4 ) ] }
end

-- 星宿海毒虫谷
function handler:xx_duchonggu( t )
	local dir = map.get_current_room().exit.se and 'se' or 'e'
	self:send{ dir }
end

-- 华山秘洞

-- 峨嵋山九老洞

-- 天山山道 (quest)

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return handler
