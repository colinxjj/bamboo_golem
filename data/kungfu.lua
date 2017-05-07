local kungfu = {

	--------------------------------------------------------------------------
	-- knowledge

	['本草术理'] = {
		name = '本草术理',
		type = 'knowledge',
		id = 'medicine',
	},

--------------------------------------------------------------------------
-- basic

['基本轻功'] = {
	name = '基本轻功',
	type = 'basic',
	id = 'dodge',
	source = {
		{ min = 0, max = 31, location = '曼佗罗山庄闺房', attr = 'int', cmd = 'ta sign', cost = { jing = 15 } },
		{ min = 20, max = 59, location = '归云庄练武场', attr = 'int', cmd = 'jump zhuang;jump down', cost = { jingli = 55 } },
		{ min = 50, max = 99, location = '桃花岛练武场', attr = 'int', cmd = 'jump zhuang;jump down', cost = { jingli = 50 } },
		{ min = 20, max = 100, location = '曼佗罗山庄树上', attr = 'int', cmd = 'yue tree', cost = { jingli = 25 } },
		{ min = 30, max = 100, location = '明教碧水寒潭', attr = 'int', cmd = 'walk', cost = { jing = 25 } },
		{ min = 0, max = 100, location = '峨嵋山八十四盘#1', attr = 'dex', cmd = 'sw;ne', cost = { jingli = 20 } },
		{ min = 0, max = 100, location = '峨嵋山十二盘#3', attr = 'dex', cmd = 'sw;ne', cost = { jingli = 20 } },
	}
},

['基本内功'] = {
	name = '基本内功',
	type = 'basic',
	id = 'force',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本招架'] = {
	name = '基本招架',
	type = 'basic',
	id = 'parry',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本掌法'] = {
	name = '基本掌法',
	type = 'basic',
	id = 'strike',
	source = {
		{ min = 30, max = 101, location = '扬州城中央广场', jingli_cost = 50, handler = 'yz_tree' },
	}
},

['基本腿法'] = {
	name = '基本腿法',
	type = 'basic',
	id = 'leg',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本手法'] = {
	name = '基本手法',
	type = 'basic',
	id = 'hand',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本爪法'] = {
	name = '基本爪法',
	type = 'basic',
	id = 'claw',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本拳法'] = {
	name = '基本拳法',
	type = 'basic',
	id = 'cuff',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本指法'] = {
	name = '基本指法',
	type = 'basic',
	id = 'finger',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本剑法'] = {
	name = '基本剑法',
	type = 'basic',
	id = 'sword',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本刀法'] = {
	name = '基本刀法',
	type = 'basic',
	id = 'blade',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本棒法'] = {
	name = '基本棒法',
	type = 'basic',
	id = 'stick',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本钩法'] = {
	name = '基本钩法',
	type = 'basic',
	id = 'hook',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本杖法'] = {
	name = '基本杖法',
	type = 'basic',
	id = 'staff',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本笔法'] = {
	name = '基本笔法',
	type = 'basic',
	id = 'brush',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本斧法'] = {
	name = '基本斧法',
	type = 'basic',
	id = 'axe',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本鞭法'] = {
	name = '基本鞭法',
	type = 'basic',
	id = 'whip',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本棍法'] = {
	name = '基本棍法',
	type = 'basic',
	id = 'club',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本暗器'] = {
	name = '基本暗器',
	type = 'basic',
	id = 'throwing',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本匕法'] = {
	name = '基本匕法',
	type = 'basic',
	id = 'dagger',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['基本锤法'] = {
	name = '基本锤法',
	type = 'basic',
	id = 'hammer',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

--------------------------------------------------------------------------
-- force

default_force = {
	dazuo_start_msg = '你坐下来运气用功，一股内息开始在体内流动。',
	dazuo_end_msg = '你运功完毕，站了起来。',
	dazuo_halt_msg = '你把正在运行的真气强行压回丹田，站了起来。',
	heal_start_msg = '你盘膝坐下，开始运功疗伤。',
	heal_finish_msg = '你运功完毕，站起身来，看上去气色饱满，精神抖擞。',
	heal_unfinish_msg = '你运功完毕，缓缓站了起来，脸色看起来好了许多。',
	heal_halt_msg = '你一震，吐出一口瘀血，缓缓站了起来。',
},

['临济十二庄'] = {
	name = '临济十二庄',
	type = 'force',
	id = 'linji-zhuang',
	dazuo_start_msg = '你席地而坐，五心向天，脸上红光时隐时现，内息顺经脉缓缓流动。',
	dazuo_end_msg = '你将内息走了个小周天，流回丹田，收功站了起来。',
	dazuo_halt_msg = '你长出一口气，将内息急速退了回去，站了起来。',
},

['混天气功'] = {
	name = '混天气功',
	type = 'force',
	id = 'huntian-qigong',
	dazuo_start_msg = '你随意坐下，双手平放在双膝，默念口诀，开始运起独门心法。',
	dazuo_end_msg = '你吸气入丹田，真气运转渐缓，慢慢收功，双手抬起，站了起来。',
	dazuo_halt_msg = '你面色一沉，迅速收气，站了起来。',
},

['玉女心经'] = {
	name = '玉女心经',
	type = 'force',
	id = 'yunu-xinjing',
	dazuo_start_msg = '你轻轻的吸一口气，闭上眼睛，运起玉女心经，内息在脉络中开始运转。',
	dazuo_end_msg = '你慢慢收气，归入丹田，睁开眼睛，轻轻的吐了一口气。',
	dazuo_halt_msg = '你内息一转，迅速收气，停止了内息的运转。',
},

['玄天无极功'] = {
	name = '玄天无极功',
	type = 'force',
	id = 'xuantian-wuji',
	dazuo_start_msg = '你运起玄天无极神功，气聚丹田，一股真气在四肢百脉中流动。',
	dazuo_end_msg = '过了片刻，你感觉自己已经将玄天无极神功气聚丹田，深吸口气站了起来。',
	dazuo_halt_msg = '你匆匆将内息退了回去，吸一口气缓缓站了起来。',
	heal_start_msg = '你盘膝坐下，蓦然想起百鸟朝凤的琴音在耳边游走飘荡，实以柔和的音律调理伤势。',
	heal_finish_msg = '过了良久，琴音顿止，你蓦觉一股清幽安宁的感觉遍透全身。',
	heal_unfinish_msg = '过了一会，你头晕脑涨，热血上涌，骤觉这伤势，非浅薄的琴音所能调理。',
	heal_halt_msg = '突然间琴音在脑海中止歇，你便即惊醒，深吸了一口气，站起身来。',
},

['圣火神功'] = {
	name = '圣火神功',
	type = 'force',
	id = 'shenghuo-shengong',
	dazuo_start_msg = '你盘膝而坐，双手垂于胸前成火焰状，深吸口气，让经络中的真气化做一股灼流缓缓涌入丹田。',
	dazuo_end_msg = '你将周身内息贯通经脉，缓缓睁开眼睛，站了起来。',
	dazuo_halt_msg = '你周身微微颤动，长出口气，站了起来。',
	heal_start_msg = '你盘膝而坐，双手十指张开，举在胸前，作火焰飞腾之状，运起圣火神功开始疗伤。',
	heal_finish_msg = '你脸上流光浮现，一声：“焚我残躯，熊熊圣火，生亦何欢，死亦何苦？”，缓缓站起。',
	heal_unfinish_msg = '你神态庄严，缓缓站起身来，但脸上血红，看来伤势还没有完全恢复。',
	heal_halt_msg = '你脸颊胀红，头顶热气袅袅上升，猛地吸一口气，挣扎着爬了起来。',
},

['九阳神功'] = {
	name = '九阳神功',
	type = 'force',
	id = 'jiuyang-shengong',
	dazuo_start_msg = '你盘膝而坐，运使九阳，气向下沉，由两肩收入脊骨，注于腰间，进入人我两忘之境界。',
	dazuo_end_msg = '你呼翕九阳，抱一含元，缓缓睁开双眼，只觉得全身真气流动，体内阳气已然充旺之极。',
	dazuo_halt_msg = '你周身微微颤动，长出口气，站了起来。',
	heal_start_msg = '你盘膝坐下，依照经中所示的法门调息，只觉丹田中暖烘烘地、活泼泼地，真气流动。',
	heal_finish_msg = '九阳神功的威力，这时方才显现出来，在你体内又运走数转，胸腹之间甚感温暖舒畅。',
	heal_unfinish_msg = '你神态庄严，缓缓站起身来，但脸上血红，看来伤势还没有完全恢复。',
	heal_halt_msg = '你脸颊胀红，头顶热气袅袅上升，猛地吸一口气，挣扎着爬了起来。',
},

['易筋经'] = {
	name = '易筋经',
	type = 'force',
	id = 'yijin-jing',
	dazuo_start_msg = '你五心向天，排除一切杂念，内息顺经脉缓缓流动。',
	dazuo_end_msg = '你将内息走了个小周天，流回丹田，收功站了起来。',
	dazuo_halt_msg = '你长出一口气，将内息急速退了回去，站了起来。',
	heal_start_msg = '你双手合什，盘膝而坐，口中念起“往生咒”，开始运功疗伤。',
	heal_finish_msg = '你缓缓站起，只觉全身说不出的舒服畅快，便道：“善哉！善哉！本门易筋经当真是天下绝学！”',
	heal_unfinish_msg = '你吐出瘀血，缓缓站起，但脸色苍白，看来还有伤在身。',
	heal_halt_msg = '你一声：“阿弥陀佛”双袖挥动，压下内息，站起身来。',
},

['毒龙大法'] = {
	name = '毒龙大法',
	type = 'force',
	id = 'dulong-dafa',
	dazuo_start_msg = '你盘膝坐下，双手合十置于头顶，潜运内力，一团黑气渐渐将你包围了起来，双眼冒出一丝绿光。',
	dazuo_end_msg = '你分开双手，黑气慢慢沉下，眼中的绿光也渐渐暗淡下来。',
	dazuo_halt_msg = '你双眼缓缓闭合，片刻猛地睁开，两道绿光急射而出。',
},

['寒冰真气'] = {
	name = '寒冰真气',
	type = 'force',
	id = 'hanbing-zhenqi',
	dazuo_start_msg = '你手捏剑诀，将寒冰真气提起在体内慢慢转动。',
	dazuo_end_msg = '你将寒冰真气按周天之势搬运了一周，感觉精神充沛多了。',
	dazuo_halt_msg = '你双眼一睁，极速压下内息站了起来。',
	heal_start_msg = '你运起寒冰真气，开始缓缓运气疗伤。',
	heal_finish_msg = '你内息一停，却见伤势已经全好了。',
	heal_unfinish_msg = '你眉头一皱，“哇”地吐出一口瘀血，看来这伤还没有全好。',
	heal_halt_msg = '你急急把内息一压，也不顾身上的伤势立即站了起来。',
},

['碧海潮生功'] = {
	name = '碧海潮生功',
	type = 'force',
	id = 'bihai-chaosheng',
	dazuo_start_msg = '你盘腿坐下，双目微闭，双手掌心相向成虚握太极，天人合一，练气入虚。',
	dazuo_end_msg = '你将内息又运了一个小周天，缓缓导入丹田，双臂一震，站了起来。',
	heal_start_msg = '你凝神静气，内息随悠扬箫声在全身游走，恰似碧海浪涛般冲击受损被封经脉。',
	heal_finish_msg = '你脸色渐渐变得舒缓，箫声亦随之急转直下，渐不可闻。',
	heal_unfinish_msg = '你内息微弱，难以为济，箫声募然高亢渐而消失，人随之站起，猛地吐出一口鲜血。',
	heal_halt_msg = '你突感周身不适，内息全然不受乐音指引，急忙停止吹奏，箫声骤然竭止。',
},

['归元吐纳法'] = {
	name = '归元吐纳法',
	type = 'force',
	id = 'guiyuan-tunafa',
	dazuo_start_msg = '你盘膝坐下，暗运内力，试图采取天地之精华，只觉得四周暗潮渐生，天地顿合，四周白茫茫一片。',
	dazuo_end_msg = '你双眼微闭，缓缓将天地精华之气吸入体内,见天地恢复清明，收功站了起来。',
	dazuo_halt_msg = '你内息一转，迅速收气，缓缓收功站了起来。',
	heal_start_msg = '你神情肃然，双目虚闭，开始吸呐身周草木精华为已所用，恢复受损元气。',
	heal_finish_msg = '你将草木精华与内息融纳一体，感觉伤势已然痊愈，神情也变得清朗起来。',
	heal_unfinish_msg = '你内息难以为继，脸色愈发铁青，只好暂停疗伤，站了起来。',
	heal_halt_msg = '你突感草木精华再难与内息融合,继续疗伤反而有损真元，急忙强压内息，缓缓站起。',
},

['氤氲紫气'] = {
	name = '氤氲紫气',
	type = 'force',
	id = 'yinyun-ziqi',
	dazuo_start_msg = '你盘膝而坐，双目紧闭，深深吸一口气引入丹田，慢慢让一股内息在周身大穴流动，渐入忘我之境。',
	dazuo_end_msg = '你将内息在体内运行十二周天，返回丹田，只觉得全身暖洋洋的。',
	dazuo_halt_msg = '你微一簇眉，将内息压回丹田，长出一口气，站了起来。',
},

['龙象般若功'] = {
	name = '龙象般若功',
	type = 'force',
	id = 'longxiang-boruo',
	dazuo_start_msg = '你(抉弃杂念盘膝坐定，手捏气诀，脑中一片空明，渐入无我境界，一道炽热的内息在任督二脉之间游走|收敛心神闭目打坐，手搭气诀，调匀呼吸，感受天地之深邃，自然之精华，渐入无我境界)。',
	dazuo_end_msg = '你(只觉神元归一，全身精力弥漫，无以复加，忍不住长啸一声，徐徐站了起来|感到自己和天地融为一体，全身清爽如浴春风，忍不住舒畅的呻吟了一声，缓缓睁开了眼睛)。',
	dazuo_halt_msg = '你(感到烦躁难耐，只得懈了内息，轻吁口气，身上涔涔透出层冷汗|感到呼吸紊乱，全身燥热，只好收功站了起来)。',
},

['神照经'] = {
	name = '神照经',
	type = 'force',
	id = 'shenzhao-jing',
	dazuo_start_msg = '你慢慢盘膝而坐，双手摆于胸前，体内一股暖流随经脉缓缓流转。',
	dazuo_end_msg = '你一个周天行将下来，精神抖擞的站了起来。',
	dazuo_halt_msg = '你猛的睁开双眼，双手迅速回复体侧，仔细打量四周。',
},

['九阴真功'] = {
	name = '九阴真功',
	type = 'force',
	id = 'jiuyin-zhengong',
	dazuo_start_msg = '你盘腿坐下，双目微闭，双手掌心相向成虚握太极，天人合一，练气入虚。',
	dazuo_end_msg = '你将内息又运了一个小周天，缓缓导入丹田，双臂一震，站了起来。',
},

['冷泉神功'] = {
	name = '冷泉神功',
	type = 'force',
	id = 'lengquan-shengong',
	dazuo_start_msg = '你手捏剑诀，将寒冰真气提起在体内慢慢转动。',
	dazuo_end_msg = '你将寒冰真气按周天之势搬运了一周，感觉精神充沛多了。',
	dazuo_halt_msg = '你双眼一睁，极速压下内息站了起来。',
	heal_start_msg = '你运起寒冰真气，开始缓缓运气疗伤。',
	heal_finish_msg = '你内息一停，却见伤势已经全好了。',
	heal_unfinish_msg = '你眉头一皱，“哇”地吐出一口瘀血，看来这伤还没有全好。',
	heal_halt_msg = '你急急把内息一压，也不顾身上的伤势立即站了起来。',
},

['紫霞功'] = {
	name = '紫霞功',
	type = 'force',
	id = 'zixia-gong',
	dazuo_start_msg = '你屏息静气，坐了下来，左手搭在右手之上，在胸前捏了个剑诀，引导内息游走各处经脉。',
	dazuo_end_msg = '你将内息走满一个周天，只感到全身通泰，丹田中暖烘烘的，双手一分，缓缓站了起来。',
	dazuo_halt_msg = '你心神一动，将内息压回丹田，双臂一振站了起来。',
},

['神元功'] = {
	name = '神元功',
	type = 'force',
	id = 'shenyuan-gong',
	dazuo_start_msg = '你随意一站，双手缓缓抬起，深吸一口气，真气开始在体内运转。',
	dazuo_end_msg = '你将真气在体内沿脉络运行了一圈，缓缓纳入丹田，放下手，长吐了一口气。',
	dazuo_halt_msg = '你眉头一皱，急速运气，把手放了下来。',
},

['枯荣禅功'] = {
	name = '枯荣禅功',
	type = 'force',
	id = 'kurong-changong',
	dazuo_start_msg = '你盘膝坐下，垂目合什，默运枯荣禅功，只觉冷热两股真气开始在体内缓缓游动。',
	dazuo_end_msg = '你真气在体内运行了一个周天，冷热真气收于丹田，慢慢抬起了眼睛。',
	dazuo_halt_msg = '你双掌一分，屈掌握拳，两股真气迅速交汇消融。',
},

['乾天一阳功'] = {
	name = '乾天一阳功',
	type = 'force',
	id = 'qiantian-yiyang',
	dazuo_start_msg = '你盘膝坐下，闭目合什，运起乾天一阳神功，一股纯阳真气开始在体内运转。',
	dazuo_end_msg = '你真气在体内运行了一个周天，缓缓收气于丹田，慢慢睁开了眼睛。',
	dazuo_halt_msg = '你双掌一分，平摊在胸，迅速收气，停止真气的流动。',
},

['化功大法'] = {
	name = '化功大法',
	type = 'force',
	id = 'huagong-dafa',
	dazuo_start_msg = '你气运丹田，将体内毒素慢慢逼出，控制着它环绕你缓缓飘动。你感觉到内劲开始有所加强了。',
	dazuo_end_msg = '你感觉毒素越转越快，就快要脱离你的控制了！你连忙收回毒素和内息，冷笑一声站了起来。',
	dazuo_halt_msg = '你双眼一睁，眼中射出一道精光，接着阴阴一笑，站了起来。',
},


--------------------------------------------------------------------------
-- quest skills

['五虎断门刀'] = {
	name = '五虎断门刀',
	type = 'blade',
	id = 'wuhu-duanmendao',
	power = {
		{ from = 1, to = 150, power = 1, },
		{ from = 150, to = 999, power = 1.1, },
	},
	fn = {
		duan = {
			name = '断字诀',
			type = 'combo',
			req = {
				neili = 1500,
				neili_max = 2000,
				jingli = 1000,
				enable = { parry = '五虎断门刀', },
				skill = { ['五虎断门刀'] = 150 },
			},
			power = {
				{ from = 150, to = 250, power = 1.7, busy_pref = 1 },
				{ from = 250, to = 999, power = 2, busy_pref = 0.7 },
			},
		},
	},
},

['躺尸剑法'] = {
	name = '躺尸剑法',
	type = 'sword',
	id = 'tangshi-jianfa',
	power = {
		{ from = 1, to = 999, power = 0.3, },
	},
	fn = {
		erguang = {
			name = '耳光式',
			type = 'combo',
			req = {
				neili = 100,
				neili_max = 500,
				enable = { parry = '躺尸剑法' },
				skill = { ['躺尸剑法'] = 80, ['基本剑法'] = 80 },
		},
			power = {
				{ from = 80, to = 150, power = 1.8, busy_pref = 0.7 },
				{ from = 150, to = 999, power = 1.5, busy_pref = 0.7 },
			},
		},
	},
},

['金蛇剑法'] = {
	name = '金蛇剑法',
	type = 'sword',
	id = 'jinshe-jianfa',
	power = {
		{ from = 1, to = 999, power = 1, },
	},
	fn = {
		kuangwu = {
			name = '金蛇狂舞',
			type = 'combo',
			req = {
				neili = 900,
				neili_max = 1400,
				jingli = 800,
				enable = { parry = '金蛇剑法', strike = '金蛇游身掌' },
				prepare = { '金蛇游身掌' },
				skill = { ['金蛇剑法'] = 120, ['金蛇游身掌'] = 120, enable_force = 170, },
				stat = { str = 27, dex = 27 }
		},
			power = {
				{ from = 120, to = 999, power = 1.5, busy_pref = 0.7 },
			},
		},
	},
},

['金蛇游身掌'] = {
	name = '金蛇游身掌',
	type = 'strike',
	id = 'jinshe-zhangfa',
	power = {
		{ from = 1, to = 999, power = 1.2, },
	},
},


--------------------------------------------------------------------------
-- thd skills

['玉箫剑法'] = {
	name = '玉箫剑法',
	type = 'sword',
	id = 'yuxiao-jian',
	power = {
		{ from = 1, to = 150, power = 1.1, },
		{ from = 150, to = 999, power = 1.2, },
	},
	fn = {
		qimen = {
			name = '奇门玉箫',
			type = 'combo',
			weapon = 'flute',
			req = {
				neili = 700,
				neili_max = 1000,
				jingli = 500,
				enable = { parry = '玉箫剑法', },
				skill = { ['玉箫剑法'] = 100, ['碧海潮生功'] = 100, ['玉箫剑法'] = 100, ['奇门八卦'] = 100, },
			},
			power = {
				{ from = 100, to = 400, power = 1.7, busy_pref = 1 },
				{ from = 400, to = 999, power = 2, busy_pref = 0.7 },
			},
		},
		feiying = {
			name = '飞影',
			type = 'combo',
			weapon = 'flute',
			req = {
				neili = 4000,
				neili_max = 7500,
				jingli = 2500,
				enable = { parry = '玉箫剑法', },
				skill = { ['玉箫剑法'] = 350, ['碧海潮生功'] = 350, ['奇门八卦'] = 180, ['弹指神通'] = 350, ['兰花拂穴手'] = 350, ['落英神剑掌'] = 350, ['旋风扫叶腿'] = 350, ['随波逐流'] = 350, },
			},
			power = {
				{ from = 350, to = 400, power = 1.9, busy_pref = 1 },
				{ from = 400, to = 999, power = 2.2, busy_pref = 0.7 },
			},
		},
	},
},

['随波逐流'] = {
	name = '随波逐流',
	type = 'dodge',
	id = 'suibo-zhuliu',
	fn = {
		wuzhuan = {
			name = '奇门五转',
			type = 'powerup',
			req = {
				neili = 1500,
				jingli = 800,
				skill = { ['随波逐流'] = 150, ['碧海潮生功'] = 150, ['奇门八卦'] = 150, },
				stat = { dex = 30 }
			},
			power = {
				{ from = 150, to = 999, power = 2.2 },
			},
		},
	},
},

}

return kungfu
