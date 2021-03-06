
local handler = {}

--------------------------------------------------------------------------------
-- Special step handlers for walking and traversing
--------------------------------------------------------------------------------

-- a table to store persistent path variables
handler.data = {}

--------------------------------------------------------------------------------
-- Special step handlers

-- just idle
function handler:idle() end

-- look again
function handler:look_again()
	self:send{ 'l' }
end

-- wait for a period of time and then look again
function handler:wait_and_look( from, to, duration )
	map.block_exit( from, to, duration )
	self:newsub{ class = 'kill_time', duration = duration, can_move = true, complete_func = handler.look_again }
end

-- check if the player can fly across rivers
local function is_able_to_fly( cmd )
	if cmd == 'duhe' then return player.enable.dodge and player.enable.dodge.level >= 250 and player.neili_max >= 3000
	elseif cmd == 'dujiang' then return player.enable.dodge and player.enable.dodge.level >= 270 and player.neili_max >= 3500
	elseif cmd == 'zong' then return player.enable.dodge and player.enable.dodge.level >= 300 and player.neili_max >= 4000
	end
end

-- 长江
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
		if room.get().exit.enter then self:send{ 'enter' } return end -- if boat is here, enter it
		t.to_yell = t.to_yell or { [ t.loc.w ] = true, [ t.loc.c ] = true, [ t.loc.e ] = true }
		if t.to_yell[ t.curr_loc ] then -- yell at current location
			self:send{ 'yell boat' }
			t.to_yell[ t.curr_loc ] = nil
			self:newweaksub{ class = 'kill_time', duration = 1, complete_func = handler.cross_cj }
		elseif next( t.to_yell ) then -- go to next location and yell
			local c = t.curr_loc == t.loc.w and 'e'
						 or t.curr_loc == t.loc.e and 'w'
						 or t.to_yell[ t.loc.e ] and 'e'
						 or 'w'
			self:listen{ event = 'located', func = handler.cross_cj, id = 'step_handler.cross_cj', sequence = 99, keep_eval = false }
 			self:send{ c }
		else -- kill time and do another round of yell
			t.to_yell = nil
			self:newweaksub{ class = 'kill_time', complete_func = handler.cross_cj }
		end
	end
end

-- 黄河、黑木崖、澜沧江
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
local function get_fly_jingli_req( cmd )
	return cmd == 'dujiang' and 1200 or 1000
end
local function get_fly_neili_req( cmd )
	return cmd == 'dujiang' and 1300
			or cmd == 'duhe' and 900
			or cmd == 'zong' and 1500
end
function handler:fly()
	-- recover jingli and/or neili as needed
	if player.jingli < get_fly_jingli_req( self.step.cmd ) or player.neili < get_fly_neili_req( self.step.cmd ) then handler.fly_recover( self ) return end
	-- since this handler is always called by other handlers, it needs to take care of trigger enabling itself
	self:enable_trigger_group 'step_handler.fly'
	-- remove existing listeners, to avoid double triggering
	event.remove_listener_by_id 'step_handler.fly'
	if room.get().exit.enter then
		handler.fly_wait( self )
	else
		self:send{ self.step.yell_cmd or 'yell boat', self.step.cmd }
	end
end
function handler:fly_recover()
	self:newsub{ class = 'recover', jingli = get_fly_jingli_req( self.step.cmd ), neili = get_fly_neili_req( self.step.cmd ), stay_here = true }
end
function handler:fly_wait()
	self:listen{ event = 'ferry_left', id = 'step_handler.fly', func = self.resume }
	self:listen{ event = 'fly_ready', id = 'step_handler.fly', func = self.resume }
	self:newweaksub{ class = 'kill_time', complete_func = handler.fly }
end
function handler:fly_done()
	player.neili = player.neili - 1200
	player.jingli = player.jingli - 600
	self:disable_trigger_group 'step_handler.fly'
	addbusy( 5 )
end
trigger.new{ name = 'fly_wait', group = 'step_handler.fly', match = '^(> )*(峭壁实在太陡了|江面太宽了|河面太宽了|有竹篓就坐上去吧|有船不坐)', func = handler.fly_wait }
trigger.new{ name = 'fly_done', group = 'step_handler.fly', match = '^(> )*你在(江中渡船|黄河中渡船|河中渡船|崖间竹篓)上轻轻一点', func = handler.fly_done }
trigger.new{ name = 'fly_recover', group = 'step_handler.fly', match = '^(> )*你的(精力|真气)不够了', func = handler.fly_recover }

-- 乘坐渡船。黄河、长江、汉水、黑木崖猩猩滩、大雪山绞盘等
function handler:embark()
	if room.get().exit.enter then self:send{ 'enter' } return end
	self:send{ self.step.cmd ~= 'enter' and self.step.cmd or 'yell boat' }
	self:newweaksub{ class = 'kill_time', complete_func = handler.embark }
end

-- 下船。渡船、竹篓、藤筐等
function handler:disembark()
	self:listen{ event = 'ferry_arrived', func = handler.get_out, id = 'disembark' }
	self:newweaksub{ class = 'kill_time', complete_func = handler.disembark }
end
function handler:get_out()
	self:send{ 'out' }
end

-- 客栈
local hotel_waiter_tbl = {
	default = { name = '店小二', id = 'xiao er' },
	['福州城吉祥客栈'] = { name = '小二', id = 'xiao er' },
	['襄阳城江湖客栈'] = { name = '小二', id = 'xiao er' },
	['大雪山招财大车店'] = { name = '李招财', id = 'li zhaocai' },
}
function handler:hotel( t )
	local obj = hotel_waiter_tbl[ t.from.id ] or hotel_waiter_tbl.default
	if room.has_object( obj ) then
		self:send{ ( 'give 5 silver to %s;%s' ):format( obj.id, t.cmd ) }
	else
		map.block_exit( t.from, t.to, 60 )
		self:fail()
	end
end

-- 峨嵋山后山小路
function handler:emei_move_stone()
	if room.get().exit.nd then
		self:send{ 'nd' }
	else
		self:send{ 'move stone'; retry_msg = '你使尽了吃奶的力气', complete_func = handler.emei_move_stone_go }
	end
end
function handler:emei_move_stone_go()
	self:send{ 'nd' }
end

-- 峨嵋山洗象池

-- 黑木崖石门
hmy_shimen_tbl = {
	'教主文成武德，一统江湖', '教主千秋万载，一统江湖', '属下忠心为主，万死不辞', '教主令旨英明，算无遗策',
	'教主烛照天下，造福万民', '教主战无不胜，攻无不克', '日月神教文成武德、仁义英明', '教主中兴圣教，泽被苍生',
}
function handler:hmy_shimen( name )
	if room.get().exit.wu then self:send{ 'wu' } return end
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

-- 嵩山少林圣僧塔
local sl_fota_tbl = {
	['嵩山少林无色台'] = 'say 今日大欢喜，舍却危脆身;sheshen',
	['嵩山少林无相牌'] = 'fushi pai',
	['嵩山少林天鸣禅台'] = 'say 若得不驰散，深入实相不;shenru',
	['嵩山少林苦慧坪'] = 'say 其心无所乐;taotuo',
	['嵩山少林晦智圣座'] = 'canchan zuo',
}
function handler:sl_fota( t )
	local retry_until_msg = ( t.to.id == '嵩山少林无相牌' and '你突然有一种出掌的冲动，便想一掌击出。' ) or ( t.to.id == '嵩山少林晦智圣座' and '你在虚空中，感觉大师座下打开了一个小门。' )
	self:send{ sl_fota_tbl[ t.to.id ]; retry_until_msg = retry_until_msg, complete_func = retry_until_msg and handler.sl_fota_go }
end
function handler:sl_fota_go()
	local c = self.step.to.id == '嵩山少林无相牌' and 'chuzhang pai' or 'enter'
	self:send{ c }
end

-- 归云庄小河
function handler:gyz_river( t )
	if room.has_object{ name = '老者', id = 'lao zhe' } then
		self:send{ t.cmd }
	else -- leave and reenter to reset the room
		self:send{ room.get().exit.w and 'w' or 'e' }
	end
end

-- 航海到桃花岛
function handler:thd_onboard()
	handler.data.thd_curr_coord = { x = 1, y = 1 }
	self:send{ 'ask lao da about 桃花岛;ask lao da about 价钱;give 3 gold to lao da' }
end
function handler:thd_sail( _, tbl )
	local dir, curr, dest = tbl and tbl[ 2 ], handler.data.thd_curr_coord, player.temp_flag.thd_coord
	if not curr then return end
	curr.x = dir == '西' and curr.x - 1 or dir == '东' and curr.x + 1 or curr.x
	curr.y = dir == '北' and curr.y - 1 or dir == '南' and curr.y + 1 or curr.y
	if dest.x > curr.x then
		if dir ~= '东' then self:send{ 'turn e' } end
	elseif dest.x < curr.x then
		if dir ~= '西' then self:send{ 'turn w' } end
	elseif dest.y > curr.y then
		if dir ~= '南' then self:send{ 'turn s' } end
	elseif dest.y < curr.y then
		if dir ~= '北' then self:send{ 'turn n' } end
	end
end
trigger.new{ name = 'thd_sail', group = 'step_handler.thd_sail', match = '^(> )*小船正向着(\\S+)方前进。$', func = handler.thd_sail }

-- 离开桃花岛
function handler:thd_leave( t )
	if room.has_object '黄药师' then
		self:send{ 'ask huang yaoshi about 离岛' }
	else
		handler.wait_and_look( self, t.from, t.to, 60 )
	end
end
function handler:thd_leave_wait()
	self:newsub{ class = 'kill_time', complete_func = handler.thd_leave }
end
trigger.new{ name = 'thd_leave_wait', group = 'step_handler.thd_leave', match = '^黄药师说道：「小船已经送别的客人了', func = handler.thd_leave_wait }

-- 绝情谷小溪
function handler:jqg_river( t )
	t = self.step
	if inventory.is_wielded() then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = handler.jqg_river }
	elseif t.from.id == '绝情谷小溪边' then
		local room = room.get()
		if not room.desc then self:send{ 'l' } return end
		if not string.find( room.desc, '你沿岸迂回数次，发现溪中好象有艘小舟。' ) then
			self:newsub{ class = 'kill_time', complete_func = handler.look_again }
		else
			self:send{ t.cmd }
		end
	else
		self:send{ t.cmd }
	end
end

-- 绝情谷鳄鱼潭
-- TODO kill 鳄鱼 first and then ta corpse

-- 绝情谷谷底水潭
-- TODO ensure encumbrance > 50% for qian down, < 30% for qian up, and < 40% for qian zuoshang

-- 天山百丈涧、峨嵋山后山小路
function handler:wield_sharp_weapon()
	if not inventory.is_wielded() or not item.is_type( inventory.get_wielded().name, 'sharp_weapon' ) then
		self:newsub{ class = 'manage_inventory', action = 'wield', item = 'sharp_weapon', complete_func = handler.wield_sharp_weapon }
	else
		handler.data[ self.step.to.id ] = nil -- a workaround to reset maze data for 峨嵋山灌木丛
		self:send{ self.step.cmd }
	end
end

-- 神龙岛
-- from 海滩 to 小木筏
function handler:sld_enter()
	if room.has_object '木筏' then
		self:send{ 'zuo mufa' }
	elseif room.has_object '大木头' then
		self:send{ 'bang mu tou;#wa 400;zuo mufa' }
	elseif not inventory.is_wielded() or not item.is_type( inventory.get_wielded().name, 'sharp_weapon' ) then
		self:newsub{ class = 'manage_inventory', action = 'wield', item = 'sharp_weapon', complete_func = handler.sld_enter }
	else
		self:send{ 'chop tree' }
	end
end
function handler:sld_chop()
	room.add_object '大木头'
	handler.sld_enter( self )
end
trigger.new{ name = 'sld_chop', group = 'step_handler.sld_enter', match = '^只听“咔嚓”一声，周围的几棵大树已被你用\\S+砍成几截。$', func = handler.sld_chop }
-- from 小木筏 to 渡口
function handler:sld_mufa()
	self:send{ 'hua mufa' }
end
trigger.new{ name = 'sld_mufa', group = 'step_handler.sld_mufa', match = '^(> )*小木筏顺着海风，一直向东飘去。$', func = handler.sld_mufa }
-- from 渡口 to 小帆船
function handler:sld_leave()
	self:send{ 'give ling pai to chuan fu' }
	inventory.remove_item '通行令牌'
end

-- 神龙岛蛇窟
-- from 山崖 to 蛇窟
function handler:sld_sheku()
	self:send{ 'kan 崖底'; retry_msg = '崖底笼罩在迷雾中，什么也看不清', complete_func = handler.sld_sheku_go }
end
function handler:sld_sheku_go()
	self:send{ 'climb 山藤' }
end
-- from 蛇窟 to 树林
function handler:sld_sheku_leave()
	self:send{ 'go south'; retry_until_msg = '^(> )*树林 - ' }
end

-- from 萧府后院 to 萧府树林

-- 大理王府
-- TODO 如果门派不是天龙寺，那么晚8点到早5点之间需要杀掉npc

-- 昆仑山洞天福地
-- TODO hide 九阳真经 before leave

-- 明教密室
-- TODO make sure wielded axe

-- from 华山山涧#SE to 华山万年松
-- TODO make sure encumbrance < 50%
function handler:hs_pine()
	self:send{ 'bang shengzi;climb up' }
	inventory.remove_item '绳子'
end

-- 华山思过崖洞口

-- 武当后山茅屋

-- 武当后山古道
function handler:wdhs_gudao( t )
	if room.has_object '采药道长' then
		self:send{ 'give yao chu to caiyao daozhang' }
		inventory.add_item '绳子'
	else
		handler.wait_and_look( self, t.from, t.to, 60 )
	end
end

-- 武当后山猢狲愁
function handler:wdhs_husun()
	if not inventory.has_item '绳子' then self:fail() return end
	self:send{ 'bang song;climb down' }
end

-- 武当后山万年松
function handler:wdhs_jump( t )
	if not inventory.has_item '毛毯#WD' then self:fail() return end
	inventory.remove_item( t.to.id == '武当后山万年松' and '绳子' or '毛毯#WD' )
	self:send{ 'jump down' }
end

-- 襄阳郊外大山洞
function handler:xyjw_cave()
	self:send{ 'dian shuzhi;l qingtai;#wb 1500;clean qingtai;l zi;l mu;#wb 1500;kneel mu;#wb 1500;zuan dong;#wb 1500' }
	inventory.remove_item '小树枝'
end

-- 襄阳郊外峭壁
function handler:xyjw_cliff()
	self:send{ 'l shibi'; retry_msg = '但见石壁草木不生', complete_func = handler.xyjw_cliff_go }
end
function handler:xyjw_cliff_go()
	self:send{ '#wb 3500;mo qingtai;cuan up;#wb 3500' }
end

-- 嵩山少林迎客亭、襄阳郊外剑冢、姑苏慕容小舍
function handler:unwield_weapon()
	if inventory.is_wielded() then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = handler.unwield_weapon }
	else
		self:send{ self.step.cmd }
	end
end

-- from 桃源县山谷瀑布 to 桃源县瀑布中
function handler:ty_enter_waterfall( t )
	if room.has_object '渔人' then
		self:send{ 'ask yu ren about 一灯大师;l pubu' }
	else
		handler.wait_and_look( self, t.from, t.to, 60 )
	end
end
function handler:ty_waterfall_look_result( _, t )
	if t[ 2 ] == '你目光顺着瀑布往下流动' then -- no people in the waterfall
		self:send{ 'tiao pubu' }
	else
		self:newsub{ class = 'kill_time', complete_func = handler.ty_enter_waterfall_look_again }
	end
end
function handler:ty_enter_waterfall_look_again()
	self:send{ 'l pubu' }
end
trigger.new{ name = 'ty_enter_waterfall_look', group = 'step_handler.ty_enter_waterfall', match = '^(> )*(那瀑布奔腾而去，水沫四溅|你目光顺着瀑布往下流动)', func = handler.ty_waterfall_look_result }

-- from 桃源县山谷瀑布 to 桃源县铁舟上
function handler:ty_waterfall_to_boat()
	self:send{ 'zhi boat' }
end
function handler:ty_waterfall_to_boat_fail()
	self:newsub{ class = 'kill_time', complete_func = handler.ty_waterfall_to_boat }
end
trigger.new{ name = 'ty_waterfall_to_boat_fail', group = 'step_handler.ty_waterfall_to_boat', match = '^(> )*瀑布的水流过于湍急，现在已经有艘铁舟在河中了，你还是先等会吧。', func = handler.ty_waterfall_to_boat_fail }

-- 桃源县铁舟上
function handler:ty_boat()
	if inventory.is_wielded() then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = handler.ty_boat }
	else
		inventory.remove_item '铁舟'
		self:send{ 'wield jiang;hua boat' }
	end
end
function handler:ty_boat_disembark()
		self:send{ 'tiao shandong' }
end
trigger.new{ name = 'ty_boat_disembark', group = 'step_handler.ty_boat', match = '^那铁舟缓缓向前驶去，绿柳丛间时有飞鸟鸣啭，忽然钻入了一个山洞。$', func = handler.ty_boat_disembark }

-- 桃源县岸边
function handler:ty_qiaozi()
	if room.get().has_qiaozi_prompt then
		self:send{ 'answer 青山相待，白云相爱。梦不到紫罗袍共黄金带。一茅斋，野花开，管甚谁家兴废谁成败？陋巷单瓢亦乐哉。贫，气不改！达，志不改！;pa teng' }
	else
		self:listen{ event = 'qiaozi_prompt', id = 'step_handler.ty_qiaozi', func = handler.ty_qiaozi }
	end
end

-- 桃源县山坡
function handler:ty_nongfu()
	handler.data.ty_shusheng = nil -- reset data for shusheng
	self:send{ 'tuo shi' }
end
function handler:ty_nongfu_ok()
	self:send{ '#wb 1500;e' }
end
trigger.new{ name = 'ty_nongfu_ok', group = 'step_handler.ty_nongfu', match = '^农夫双手托住大石，臂上运劲，挺起大石，对你说道：「多谢相助，你过去吧。」', func = handler.ty_nongfu_ok }

-- 桃源县石梁尽头
local ty_shusheng_tbl = {
	'ask shu sheng about 一灯大师',
	'ask shu sheng about 题目',
	'answer 辛未状元',
	'answer 霜凋荷叶，独脚鬼戴逍遥巾',
	'answer 魑魅魍魉，四小鬼各自肚肠',
	'n'
}
function handler:ty_shusheng( t )
	if room.has_object '书生' then
		local i = handler.data.ty_shusheng
		self:send{ ty_shusheng_tbl[ i or 1 ] }
	else
		handler.wait_and_look( self, t.from, t.to, 60 )
	end
end
function handler:ty_shusheng_update( _, t )
	handler.data.ty_shusheng = t[ 1 ] == '我出三道题目' and 2
													or t[ 1 ] == '这里有一首诗' and 3
													or t[ 1 ] == '好好，果然不错' and 4
													or t[ 1 ] == '我还有一联' and 5
													or t[ 1 ] == '在下拜服' and 6
													or t[ 1 ] == '我师傅就在前面' and 6
	handler.ty_shusheng( self )
end
trigger.new{ name = 'ty_shusheng_update', group = 'step_handler.ty_shusheng', match = '^书生.*说道：「\\S*(我出三道题目|这里有一首诗|好好，果然不错|我还有一联|在下拜服|我师傅就在前面)', func = handler.ty_shusheng_update }

-- 铁掌山大石室
function handler:tz_treasure_room ()
	player.temp_flag.tz_treasure = nil
	self:send{ 'tui gate' }
end

-- 大雪山绝顶

-- 佛山镇密室

-- 成都城书房

-- 黑木崖小石屋
function handler:hmy_shiwu()
	if room.get().exit.d then
		self:send{ 'd' }
	else
		self:send{ 'tui qiang;open men;d' }
		inventory.remove_item '黑钥匙'
	end
end

-- drop certain items before leaving a room
local drop_item_tbl = {
	['天山厨房'] = { '青葫芦', '米饭' },
	['蝴蝶谷厨房'] = { '面汤', '米饭', '青菜' },
	['昆仑山厨房'] = { '香茶', '米饭', '烤鸭' },
	['明教厨房'] = { '粽子', '酸梅汤' },
	['明教茶室'] = { '酸梅汤' },
	['黑木崖膳食房'] = { '粽子', '酸梅汤' },
	['武当山茶亭'] = { '水蜜桃', '香茶' },
	['长乐帮厨房'] = { '香茶', '米饭' },
	['武当山厨房'] = { '香茶', '米饭', '麻婆豆腐', '大碗茶' },
	['桃源县斋堂'] = { '香茶', '米饭' },
	['武馆厨房'] = { '大碗茶', '米饭' },
	['桃花岛饭厅#1'] = { '大米饭#THD' },
	['归云庄饭厅'] = { '大米饭#THD' },
	['桃花岛茶房'] = { '茉莉花茶' },
	['归云庄茶房'] = { '茉莉花茶' },
	['莆田少林凉亭'] = { '茉莉花茶' },
	['华山饭厅'] = { '米饭', '包子', '梁溪脆鳝', '鸡豆花', '麻婆豆腐', '锅巴肉片', '烤鸡腿', '抓炒里脊', '糖醋鲤鱼', '原笼粉蒸牛肉', '五香花生', '扣三丝', '番茄腰柳' },
	['大雪山斋堂'] = { '酥油茶' },
	['嵩山少林斋堂'] = { '麻辣豆腐#SL', '芙蓉花菇#SL', '密汁甜藕#SL' },
	['铁掌山厨房'] = { '大米饭#TZ', '片皮乳猪#TZ', '红烧牛肉#TZ' },
}
function handler:drop_item( t )
	if not t.has_dropped then
		t.has_dropped = true
		self:newsub{ class = 'manage_inventory', action = 'drop', item = drop_item_tbl[ t.from.id ] }
	else
		self:send{ t.cmd }
	end
end

-- 嘉峪关东城门
function handler:pass_check( t )
	if room.has_object '边防官兵' then self:send{ '#wa 2000' } end
	self:send{ t.cmd }
end

-- 扬州城树上
function handler:yz_tree()
	if room.has_object '张巡捕' then
		self:newsub{ class = 'kill_time', complete_func = handler.yz_tree }
	else
		self:send{ 'climb up' }
	end
end

-- 大雪山岩石
function handler:xs_leave_rock( t )
	if player.shen < 0 then
		-- clear negative shen first TODO
	else
		if room.has_object '狄云' then
			self:send{ 'ask di yun about 离开;jump up' }
		else
			handler.wait_and_look( self, t.from, t.to, 60 )
		end
	end
end

-- 嵩山少林广场
function handler:sl_entrance()
	self:send{ room.get().exit.n and 'n' or 'knock gate;n' }
end
function handler:sl_entrance_fail()
	map.block_exit( self.step.from, self.step.to, math.huge ) -- block the exit infinitely
	self:fail()
end
trigger.new{ name = 'sl_entrance_fail', group = 'step_handler.sl_entrance', match = '^壮年僧人说道：这位施主请回罢，本寺不接待俗人。$', func = handler.sl_entrance_fail }

-- 嵩山少林断崖坪

-- 福州城南门, 福州城西门, 伊犁城南城门, 华山思过崖, 归云庄小酒馆, 扬州城珠宝店, 扬州城瘦西湖酒馆
function handler:check_gate( t )
	if room.get().exit[ t.cmd ] then
		self:send{ t.cmd }
	else
		-- TODO if the gate will soon open, wait instead of fail
		map.block_exit( t.from, t.to, 60 )
		self:fail()
	end
end

--------------------------------------------------------------------------------
-- Maze handlers

-- 嵩山少林塔林、嵩山少林竹林、嵩山少林松树林、杭州城长廊、武馆竹林、桃花岛绿竹林、铁掌山松树林、明教密道、苏州城杏子林、星宿海南疆沙漠
local simple_path_pos_tbl = { ['嵩山少林塔林#N'] = 10, ['嵩山少林松树林#2'] = 8, ['铁掌山松树林#2'] = 4 }
	function handler:simple_path_set_pos( t )
		handler.data[ t.to.id ] = simple_path_pos_tbl[ t.from.id ] or 0
		self:send{ t.cmd }
	end
local simple_path_tbl = {
	['嵩山少林塔林#S'] = { 'se', 's', 'se', 'ne', 'e', 'sw', 'e', 'n', 'se'; is_reverse = true },
	['嵩山少林塔林#N'] = { 'n', 'nw', 'sw', 'w', 'ne', 'w', 's', 'nw', 'sw'; has_reverse = true },
	['嵩山少林松树林#1'] = { 'w', 'e', 'n', 's', 'e', 'n', 'e'; is_reverse = true },
	['嵩山少林松树林#2'] = { 'e', 's', 'e', 'n', 'n', 'e', 'w'; has_reverse = true },
	['铁掌山松树林#1'] = { 'w', 's', 'e'; is_reverse = true },
	['铁掌山松树林#2'] = { 'n', 'w', 'n'; has_reverse = true },

	['嵩山少林竹林#4'] = { 'n', 's', 'w', 'e', 'w', 'e', 'e', 's', 'w', 'n' },
	['杭州城长廊#E'] = { 'n', 's', 'e' },
	['武馆竹林#E'] = { 'e', 'n', 'n' },
	['桃花岛积翠亭'] = { 'n', 's', 'w', 'e', 'n', 'n', 's', 'e', 'w', 'n', 's' }, -- TODO split exit room?
	['桃花岛草地'] = { 's', 's', 'w', 'n', 's' }, -- TODO split exit room?
	['明教秘道出口'] = { 'w', 's', 'e', 's', 'w', 'n' }, -- TODO split exit room?
	['丐帮杏子林#2'] = { 'e', 'n', 'w', 'n', 'e', 'w', 'n' },
	['星宿海南疆沙漠#2'] = { 'sw', 'se' },
}
function handler:simple_path( t )
	t.path = t.path or simple_path_tbl[ t.to.id ]
	local pos = handler.data[ t.from.id ]
	if pos then
		pos = t.path.is_reverse and pos - 1 or pos + 1
	  local cmd = t.path[ pos ]
		-- if this isn't the last step, tell self.check_step that we're not yet out of the maze
		if ( t.path.is_reverse and pos == 1 ) or ( not t.path.is_reverse and pos == #t.path ) then
			self.is_still_in_step, handler.data[ t.from.id ] = nil
		else
			handler.data[ t.from.id ] = pos
			self.is_still_in_step = true
		end
	  self:send{ cmd }
	else -- handle situation where we don't have pos info (resort to random walk)
		self:send{ t.path[ math.random( #t.path ) ] }
	end
end

-- 大理城东山间小路、长安城长街、长安城柏树林、星宿海、星宿海大沙漠、回疆草原边缘、归云庄湖滨小路、杭州城柳林、华山菜地
function handler:go_straight( t )
	self:send{ t.cmd }
end

-- 天龙寺松树林、终南山黑林、慕容地下迷宫
function handler:reset_data( t )
	handler.data[ t.to.id ] = nil
	self:send{ t.cmd }
end
local cord_tbl = {
	['天龙寺小洞天'] = { x = 6, y = 7 }, -- 需要随机先天智力大于20
	['天龙寺龙树院'] = { x = -5, y = 6 },
	['天龙寺石板路#NE'] = { x = 0, y = -50 },
	['姑苏慕容库房'] = { x = 6, y = 7 }, -- 需要随机先天智力大于20
	['姑苏慕容正堂'] = { x = -5, y = 6 },
	['姑苏慕容地道#3'] = { x = 0, y = -50 },
	['终南山灌木丛'] = { x = 6, y = 3 },
	['终南山树林'] = { x = -6, y = 3 },
}
function handler:cord( t )
	t.dest = t.dest or cord_tbl[ t.to.id ]
	handler.data[ t.from.id ] = handler.data[ t.from.id ] or {}
	local d = handler.data[ t.from.id ]
	d.x, d.y = d.x or 0, d.y or 0
	if t.dest.y > d.y then self:send{ 'n' }; d.y = d.y + 1 return end
	if t.dest.y < d.y then self:send{ 's' }; d.y = d.y - 1 return end
	-- handle x only after y is done, to avoid premature exit in 终南山黑林
	if t.dest.x > d.x then self:send{ 'e' }; d.x = d.x + 1 return end
	if t.dest.x < d.x then self:send{ 'w' }; d.x = d.x - 1 return end
	self:send{ 'e' }; d.x = d.x + 1
end

-- from 天龙寺松树林#2 to 天龙寺松树林#M，峨嵋山古德林
local alt_step_tbl = {
	['峨嵋山古德林#2'] = { 'n', 's' },
	['天龙寺松树林#M'] = { 'n', 'w' },
}
function handler:alternate_step( t )
	self.is_step_need_desc = true -- with this approach we can get room desc before step_ok is checked, but when the handler is called for the 1st time, it won't try to get room desc for the current room
	handler.data[ t.to.id ] = nil -- a workaround to reset cord data for 天龙寺松树林#M
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
	handler.data[ t.from.id ] = handler.data[ t.from.id ] or {}
	handler.data[ t.to.id ] = nil -- a workaround to reset data for 回疆针叶林#M
	local d = handler.data[ t.from.id ]
	d.x, d.y = d.x or 0, d.y or 0
	if t.dest.x > d.x then self:send{ 'n' }; d.x = d.x + 1 return end
	if t.dest.x < d.x then self:send{ 'e' }; d.x = d.x - 1 return end
	if t.dest.y > d.y then self:send{ 's' }; d.y = d.y + 1 return end
	if t.dest.y < d.y then self:send{ 'w' }; d.y = d.y - 1 return end
	if t.dest.z then self:send{ t.dest.z } return end
end

-- 回疆针叶林、回疆大戈壁（回疆绿洲方向）、峨嵋山灌木丛、终南山石室、兰州城沙漠
local fixed_step_tbl = {
	['回疆针叶林#E'] = { 'n:10', 's:10', 'e:10', 'w:10' },
	['回疆回疆绿洲'] = { 'n:11', 'w:7', 's:7', 'e:7', 'n:7' },
	['终南山石室#2D'] = { 'n:6', 'w:6', 's:6', 'e:6' },
	['峨嵋山灌木丛#2'] = { 'ed:4', 'sw:1', 'ne:5', 'ne:5', 'ne:5', 'ne:5', 'ne:5' },
	['兰州城青城'] = { 'n:3', 'w:1000' },
}
local patt = lpeg.C( lpeg.R 'az'^1 ) * ':' * ( lpeg.R'09'^1 / tonumber )
function handler:fixed_step( t )
	handler.data[ t.from.id ] = handler.data[ t.from.id ] or {}
	local d = handler.data[ t.from.id ]
	d.step, d.phase = d.step and d.step + 1 or 1, d.phase or 1
	t.path = t.path or fixed_step_tbl[ t.to.id ]
	if d.phase > #t.path then self:fail() end
	local c, n = patt:match( t.path[ d.phase ] )
	if d.step > n then
		d.phase, d.step = d.phase + 1, 0
		self:send{ 'yun jingli' } -- TODO a temp workaround to avoid dying in 峨嵋山灌木丛
		self:step_handler( t )
	else
		self:send{ c }
	end
end

-- 梅庄梅林
function handler:plum_entry( t )
	handler.data.plum = { entry_point = t.from.id }
	self:send{ t.cmd }
end
function handler:plum( t )
	handler.data.plum = handler.data.plum or {}
	local list = handler.data.plum
	t.forward = list.entry_point ~= t.to.id and ( t.forward == nil and true or t.forward ) or false
	if t.forward and not room.get().desc then self:send{ 'l' } return end
	if t.forward then table.insert( list, room.get().exit ) end
	local node, revdir = list[ #list ], DIR_REVERSE[ t.cmd ]
	node[ revdir ] = node[ revdir ] and 0 or nil
	for dir, v in pairs( node ) do
		if v ~= 0 and v ~= nil then t.cmd, t.forward = dir, true; break end
		if v ~= nil then t.cmd, t.forward = dir, false end
	end
	node[ t.cmd ] = nil
	if not next( node ) then table.remove( list ) end
	self:send{ t.cmd }
end

-- 襄阳郊外树林
local xyjw_shulin_path = { 'n', 'e', 'n', 'e', 'w', 's', 'n', 's', 's', 'n' }
function handler:xyjw_shulin( t )
	local room, pos = room.get(), handler.data[ t.from.id ]
	if not room.desc and not pos then self:send{ 'l' } return end
	pos = ( room.exit.s == '山路' and 1 )
		 or ( room.exit.n == '山路' and 8 )
		 or ( pos and pos < 10 and pos + 1 )
		 or ( pos and 1 )
	handler.data[ t.from.id ] = pos
	self:send{ ( pos == 1 and t.to.id == '襄阳郊外山路#1' and 's' )
					or ( pos == 8 and t.to.id == '襄阳郊外山路#2' and 'n' )
					or ( pos and xyjw_shulin_path[ pos ] )
					or xyjw_shulin_path[ math.random( 10 ) ] }
end

-- 绝情谷竹林
local jqg_zhulin_path = { 'n', 'w', 's', 'e', 'w' }
function handler:jqg_zhulin( t )
	local room, pos = room.get(), handler.data[ t.from.id ]
	pos = ( room.exit.su and 1 )
				or ( pos and pos < 5 and pos + 1 )
				or ( room.exit.wd and nil )
	handler.data[ t.from.id ] = pos
	self:send{ ( room.exit.su and t.to.id == '绝情谷山顶平地' and 'su' )
					or ( room.exit.wd and t.to.id == '绝情谷水塘' and 'wd' )
					or ( pos and jqg_zhulin_path[ pos ] )
					or jqg_zhulin_path[ math.random( 4 ) ] }
end

-- from 明教紫杉林#9 to X字门，明教树林
function handler:look_self_dir( t )
	if not room.get().desc then self:send{ 'l' } return end
	for dir, roomname in pairs( room.get().exit ) do
		if roomname == t.to.name then self:send{ dir } return end
	end
end

-- 明教紫杉林，华山松树林，from 福州城小岛 to 福州城沙滩#1
local look_around_cond_tbl = {
	['明教紫杉林#5'] = { exit = function( exit ) return exit.e == '厚土旗' end },
	['明教紫杉林#1'] = { exit = function( exit ) return string.find( exit.e, '旗' ) or string.find( exit.w, '旗' ) end },
	['明教紫杉林#9'] = {	exit = function( exit ) return string.find( exit.e, "字门" ) end,
											alt_exit = function( exit ) return string.find( exit.e, '旗' ) or string.find( exit.w, '旗' ) end,
											look = function( roomname ) return roomname == '紫杉林' end	},
	['福州城沙滩#1'] = { exit = function( exit ) return exit.w == '小岛' and exit.n end,
											alt_exit = function( exit ) return true end,
											look = function( roomname ) return roomname == '沙滩' end },
	['华山松树林#E'] = { exit = function( exit ) return exit.e == '石屋' end,
											alt_exit = function( exit ) return exit.s ~= '空地' end, },
}
function handler:look_around( t )
	if not room.get().desc then self:send{ 'l' } return end
	self.is_step_need_desc = true
	local cond = look_around_cond_tbl[ t.to.id ]
	t.is_look_ok = cond.look or function() return true end
	t.is_exit = cond.exit
	t.is_alt_exit = cond.alt_exit or function() return false end
	handler.look( self, t )
end
function handler:look( t )
	t.exit_dir_list, t.look_dir_list = {}, {}
	for dir, roomname in pairs( room.get().exit ) do
		table.insert( t.exit_dir_list, dir )
		if t.is_look_ok( roomname ) then t.look_dir_list[ dir ] = true end
	end
	self:newsub{ class = 'get_info', room = t.look_dir_list, complete_func = handler.look_around_result }
end
function handler:look_around_result( result )
	local t = self.step
	for dir, room in pairs( result or {} ) do
		if t.is_exit( room.exit ) then self:send{ dir } return end
		if t.is_alt_exit( room.exit ) then t.alt_exit = dir end
	end
	if t.alt_exit or t.cmd then -- go alternate exit or back to XX旗
		self:send{ t.alt_exit or t.cmd }
		t.alt_exit = nil
	else -- go random direction
		self:send{ t.exit_dir_list[ math.random( #t.exit_dir_list ) ] }
	end
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
	local pos, room = handler.data.wdhs_conglin_pos, room.get()
	if not room.desc and not pos then self:send{ 'l' } return end
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
			self:send{ cmd  .. ( room.name == '积雪丛林' and ';#wb 3500' or '' ) } -- wait 3 seconds after leaving a 积雪丛林 room because of busy
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
					self:send{ dir  .. ( room.name == '积雪丛林' and ';#wb 3500' or '' ) }
					return
				end
			end
			-- look around
			handler.wdhs_conglin_look( self, t )
		end
	end
end
-- look around
function handler:wdhs_conglin_look( t )
	local room, look_dir_list = room.get(), {}
	for dir, roomname in pairs( room.exit ) do
		if roomname == room.name then look_dir_list[ dir ] = true end
	end
	self:newsub{ class = 'get_info', room = look_dir_list, complete_func = handler.wdhs_conglin_look_result }
end
-- parse look result
function handler:wdhs_conglin_look_result( result )
	local t = self.step
	for dir, room in pairs( result or {} ) do
		if wdhs_conglin_locate( room ) then self:send{ dir } return end -- go to room that can be uniquely identified
		t.alt_exit = dir
	end
	if t.alt_exit then -- go alternate exit (exit leading to room with same name)
		self:send{ t.alt_exit .. ( room.name == '积雪丛林' and ';#wb 3500' or '' ) }
		t.alt_exit = nil
	else -- go random direction
		self:send{ DIR8[ math.random( 8 ) ] .. ( room.name == '积雪丛林' and ';#wb 3500' or '' )  }
	end
end

-- 武当山后院小径
function handler:wd_xiaojing( t )
	t = self.step
	local prompt = room.get().xiaojing_prompt
	if t.to.id == '武当山小径#2' then
		self:send{ 'n' }
	elseif prompt then
		self:send{ prompt }
		t.waited = nil
	elseif not t.waited then
		t.waited = true
		self:listen{ event = 'xiaojing_prompt', id = 'step_handler.wd_xiaojing', func = handler.wd_xiaojing }
		self:newweaksub{ class = 'kill_time', complete_func = handler.wd_xiaojing }
	else
		t.waited = nil
		self:send{ DIR4[ math.random( 4 ) ] }
	end
end

-- 归云庄九宫桃花阵
local num = lpeg.C( ( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九' + '十' )^1 )
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
function handler:gyz_jiugong()
	handler.data.jiugong = handler.data.jiugong or {}
	local room, t = room.get(), handler.data.jiugong
	if t.has_exited then handler.data.jiugong = nil return end
	t.inv_count, t.pos = t.inv_count or 0, get_pos( room )
	if not room.desc and not t[ t.pos ] then self:send{ 'l' } return end
	local taohua_count = t[ t.pos ] or get_taohua_count( room )
	if not t.taohua_adjusted and taohua_count ~= 5 and t.inv_count >= 5 - taohua_count then
		t.taohua_adjusted = true
		t.inv_count = t.inv_count + taohua_count - 5
		t[ t.pos ] = 5
		if taohua_count > 5 then
			self:send{ 'get ' .. taohua_count - 5 .. ' taohua'; complete_func = handler.gyz_jiugong }
		elseif taohua_count < 5 then
			self:send{ 'drop ' .. 5 - taohua_count .. ' taohua'; complete_func = handler.gyz_jiugong }
		end
	else
		t[ t.pos ] = t[ t.pos ] or taohua_count
		t.taohua_adjusted = false
		t.step_num = t.step_num or t.pos - 1
		t.step_num = t.step_num < 16 and t.step_num + 1 or 1
		self:send{ gyz_jiugong_path[ t.step_num ] }
	end
end
function handler:gyz_jiugong_exited()
	handler.data.jiugong = handler.data.jiugong or {}
	handler.data.jiugong.has_exited = true
end
trigger.new{ name = 'gyz_jiugong_exited', group = 'step_handler.gyz_jiugong', match = '^桃花阵中忽然发出一阵“轧轧”的声音，随后现出一条道路，你赶忙走了出去。$', func = handler.gyz_jiugong_exited }

-- 桃花岛桃花阵, from 桃花岛绿竹林 to 桃花岛河塘
-- TODO 1. support combinations of multiple types of items as identifiers of rooms (no more simple coin count as id) 2. switch between multiple types of items as necessary (based on factors like inventory item count)
local item, cn_item = 'coin', '铜钱'
-- return number of items on the ground
local function get_item_count( room )
	return not room.object[ cn_item ] and 0 or room.object[ cn_item ].count
end
-- check if a room has empty exit
local function has_empty_exit( room, t )
	local room, i  = t.map[ room ], 0
	for _, dir in pairs( DIR4 ) do
		if room[ dir ] then i = i + 1 end
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
      if to and to ~= 'a' and from ~= to -- ignore exit to alt maze exits (to 积翠亭 or 草地) or to the same room
			and not processed[ to ] -- only add per room once
			and ( t.map[ to ].is_reliable ~= false or target == 'unsure' ) -- ignore unreliable room if target isn't 'unsure'
			and ( not t.map[ to ].is_bad or target == 'bad' or target == 'exit' ) then -- ignore bad room if target isn't 'bad' or 'exit'
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
	local item_count = get_item_count( room.get() )

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
	-- after a reliable step?
	if t.map[ t.prev ].is_reliable and t.expected > 0 and expected_room.is_reliable then
		if t.prev ~= t.expected then t.map[ t.prev ].is_reliable = nil end -- remove prev room's reliable tag since after initial set up it could cause problems (e.g. other rooms with same item count). This would result in a single room still has the tag but that should be no problem.
		action.adjust_item_to_expected = true
	-- item count match expectation?
	elseif item_count == t.expected then
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
	if action.adjust_item_to_new_unique or action.adjust_item_to_expected then
		local new_count = t.expected
		if action.adjust_item_to_new_unique then
			new_count = get_new_unique_id( t )
			if t.expected ~= 0 then -- add the new count as an alternate to the old unreliable count
				t.map[ t.expected ].alternate = t.map[ t.expected ].alternate or {}
				t.map[ t.expected ].alternate[ new_count ] = true
			end
		end
		if new_count ~= item_count then
			local cmd = new_count > item_count and 'drop' or 'get'
			local num = math.abs( new_count - item_count )
			self:send{ ( '%s %d %s' ):format( cmd, num, item ) }
			item_count = new_count
			t.map[ item_count ] = t.map[ item_count ] or { id = item_count }
			t.map[ item_count ].drop_time = os.time()
		end
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
				if type( to ) == 'number' and to ~= t.curr and t.map[ to ].is_reliable then reliable_dir = dir; break end
			end
		end
		if reliable_dir then
			move( self, reliable_dir )
		else -- otherwise, look around
			handler.breadcrumb_look( self, t )
		end
	end
end
-- look around
function handler:breadcrumb_look( t )
	local look_dir_list = {}
	for _, dir in pairs( DIR4 ) do -- check 4 directions
		local d = t.map[ t.curr ][ dir ]
		if t.map[ t.curr ].is_reliable == false or not d or ( type( d ) == 'number' and t.map[ d ].is_reliable == false ) then -- if this room is unreliable, or we don't have data for a dir or the room in that dir is marked as unreliable, then look at it, but avoid exits with string labels
			look_dir_list[ dir ] = true
		end
	end
	self:newsub{ class = 'get_info', room = look_dir_list, complete_func = handler.breadcrumb_look_result }
end
-- parse look result
function handler:breadcrumb_look_result( result )
	local t = self.step
	for dir, room in pairs( result or {} ) do
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

	if t.preferred_exit then -- if got preferred exit, then go this dir
		move( self, t.preferred_exit )
		t.preferred_exit, t.alt_exit = nil
	elseif t.alt_exit then -- then, if got alternate exit, then go this dir
		move( self, t.alt_exit )
		t.alt_exit = nil
	else -- otherwise, walk to a room that has an exit leading to an unknown or empty room, or is marked unreliable, or is marked as bad
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

-- 桃花岛八卦桃花阵
function handler:thd_bagua( t )
	if not map.is_current_location '桃花岛八卦桃花阵' then
		local c = string.sub( player.temp_flag.thd_bagua, 1, 1 ) == '1' and 'e' or 'w'
		self:send{ c }
	else
		t.step_num = t.step_num or 1
		local prev = string.sub( player.temp_flag.thd_bagua, t.step_num, t.step_num )
		t.step_num = t.step_num + 1
		local c = string.sub( player.temp_flag.thd_bagua, t.step_num, t.step_num )
		c = prev == c and 's' or 'e'
		self:send{ c }
	end
end
function handler:thd_bagua_blocked()
	player.temp_flag.thd_bagua = nil
	self:newsub{ class = 'get_flag', flag = 'thd_bagua', complete_func = handler.thd_bagua }
end
trigger.new{ name = 'thd_bagua_blocked', group = 'step_handler.thd_bagua', match = '^(> )*你感觉这个桃花阵中暗藏八卦，隐隐生出阻力，将你推了回来！$', func = handler.thd_bagua_blocked }

-- 桃花岛墓道
local thd_mudao_tbl = {
	{ 'nu', 'n', 'nd', 'ne', 'e', 'se', 'su', 's', 'sd', 'sw', 'w', 'nw' },
	{ 'nw', 'nu', 'n', 'nd', 'ne', 'e', 'se', 'su', 's', 'sd', 'sw', 'w' },
}
-- from 桃花岛墓道#M to 桃花岛墓道#2
function handler:thd_mudao( t )
	t = self.step
	local room = room.get()
	-- arrived at 桃花岛墓道#2?
	if room.exit.d and not room.exit.out then self:check_step() return end
	-- intercept next located event, i.e. handle failures here instead of by the standard routine
	self:listen{ event = 'located', func = handler.thd_mudao, id = 'step_handler.thd_mudao', sequence = 99, keep_eval = false }
	-- returned to 桃花岛墓道#1?
	if room.exit.out then
		-- ignore first room because of repetition bug
		if not t.is_fail_known and t.offset ~= 'reset_done' then t.is_fail_known = true return end
		-- reset vars
		t.is_fail_known, t.round = nil, 1
		t.offset = not t.offset and 'later'
						or ( t.offset == 'later' and 'earlier' )
						or ( t.offset == 'earlier' and 'reset' )
						or nil
		if t.offset == 'reset' then -- get time again if tried three hour variations
			t.offset = 'reset_done'
			self:newsub{ class = 'get_info', time = 'forced', complete_func = handler.thd_mudao }
			return
		end
		-- go down again
		self:send{ 'd' }
		return
	end
	local hour = time.get_current_hour()
	-- wait if hour is 0, since there's no exit during this hour
	if hour < 1 then
		local sec = ( 1 - hour ) * 60 + 5 -- wait until 1 am
		self:newsub{ class = 'kill_time', duration = sec, complete_func = handler.thd_mudao }
		return
	end
	hour = math.floor( hour )
	hour = ( t.offset == 'later' and hour + 1 )
			or ( t.offset == 'earlier' and hour - 1 )
			or hour
	hour = hour > 12 and hour - 12 or ( hour < 1 and 12 ) or hour
	-- otherwise move to next room
	t.round = t.round or 1
	self:send{ thd_mudao_tbl[ t.round ][ hour ] }
	t.round = t.round + 1
end
-- from 桃花岛墓道#2 to 桃花岛墓道#M
function handler:thd_mudao_up( t )
	local room = room.get()
	if os.time() - room.time > 5 then self:send{ 'l' } return end -- refresh room data if stale
	for _, dir in pairs( DIR_ALL ) do
		if dir ~= 'd' and room.exit[ dir ] then self:send{ dir } return end
	end
end

-- 桃花岛太极阵
-- 两仪层
function handler:thd_liangyi( t )
	t = self.step
	if not t.has_time then -- update time info
		t.has_time = true
		self:newsub{ class = 'get_info', time = 'forced', complete_func = handler.thd_liangyi }
		return
	end
	local room = room.get()
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
		local room, wuxing_dest, sixiang_dest, is_central_ok = room.get()
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
function handler:thd_wuxing()
	local room = room.get()
	if room.name == '石坟' then self:check_step() return end
	local dir = thd_wuxing_step_tbl[ handler.data.wuxing ][ room.name ]
	self:listen{ event = 'located', func = handler.thd_wuxing, id = 'step_handler.thd_wuxing', sequence = 99, keep_eval = false }
	self:send{ dir }
end

-- 天山山涧
local patt = any_but '灌木'^1 * '灌木，' * lpeg.C( any_but '方'^1 ) * '方似乎能走过去'
function handler:ts_longtan()
	local room = room.get()
	if not room.desc then self:send{ 'l' } return end
	local dir = CN_DIR[ patt:match( room.desc ) ]
	self:send{ dir }
end

-- 无量山大松林
local wls_songlin_tbl = { { 'w', 'e' }, { 'w', 'e', 's' }, { 'w', 'n' } }
function handler:wls_songlin( t )
	local room = room.get()
	t.step_count = t.step_count and t.step_count + 1 or 1
	if t.step_count > 50 then self:fail() end -- limit to 50 steps since this maze can be a dead lock
	if not room.desc then self:send{ 'l' } return end
	local pos = room.exit.s == '后院' and 1 or room.exit.e == '大瀑布' and 3 or 2
	if pos == 1 and t.to.id == '无量山后院' then self:send{ 's' } return end
	if pos == 3 and t.to.id == '无量山大瀑布' then self:send{ 'e' } return end
	local t = wls_songlin_tbl[ pos ]
	self:send{ t[ math.random( #t ) ] }
end

-- 无量山山路 (quest)

-- 蝴蝶谷花圃
-- TODO better handling to keep jing up
function handler:hdg_huapu( t )
	t = self.step
	t.i = t.i or 1
	local room = room.get()
	if room.name == t.to.name then self:check_step() return end
	if room.name == '牛棚' then self:send{ 'nd' } return end
	self:listen{ event = 'located', func = handler.hdg_huapu, id = 'step_handler.hdg_huapu', sequence = 99, keep_eval = false }
	t.i = t.i + 1
	if t.i > 5 then self:send{ 'yun jing' }; t.i = 0 end
	self:send{ DIR4[ math.random( 4 ) ] }
end

-- 星宿海毒虫谷
function handler:xx_duchonggu()
	local dir = room.get().exit.se and 'se' or 'e'
	self:send{ dir }
end

-- 神龙岛药圃
local sld_yaopu_step_tbl = { 'northwest', 'north', 'northeast', 'east', 'southeast', 'south', 'southwest', 'west' }
local sld_yaopu_pos_tbl = { 1, 7, 4, 5, 2, 6, 3, 8 }
function handler:sld_yaopu()
	if not time.uptime then self:newsub{ class = 'get_info', uptime = 'forced', complete_func = handler.sld_yaopu } return end
	local offset, clist, step = math.modf( time.get_uptime() % 1800 / 225 ), {}
	for i = 1, 8 do
		step = sld_yaopu_pos_tbl[ i ] + offset
		step = step > 8 and step % 8 or step
		step = 'to ' .. sld_yaopu_step_tbl[ step ]
		clist[ #clist + 1 ] = step
	end
	self:send( clist )
end

-- 萧府树林

-- 华山秘洞

-- 峨嵋山九老洞
function handler:em_jiulao( t )
	t = self.step
	if t.to.id == '峨嵋山九老洞口' then
		if inventory.has_item '火折' then
			self:send{ 'drop fire'; complete_func = handler.em_jiulao }
		else
			self:send{ 'leave' }
		end
	elseif not t.wait then
		t.wait = true
		self:send{ 'use fire;n;ne;e;se;s;sw;w;nw;out' }
		inventory.remove_item '火折'
	end
end

-- 天山山道 (quest)

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return handler
