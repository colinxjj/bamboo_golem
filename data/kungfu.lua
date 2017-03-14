local kungfu = {

--------------------------------------------------------------------------
-- force

['临济十二庄'] = {
	name = '临济十二庄',
	type = 'force',
	id = 'linji-zhuang',
},

['混天气功'] = {
	name = '混天气功',
	type = 'force',
	id = 'huntian-qigong',
},

['玉女心经'] = {
	name = '玉女心经',
	type = 'force',
	id = 'yunu-xinjing',
},

['玄天无极功'] = {
	name = '玄天无极功',
	type = 'force',
	id = 'xuantian-wuji',
	heal_msg = '$N盘膝坐下，蓦然想起百鸟朝凤的琴音在耳边游走飘荡，实以柔和的音律调理伤势。',
	heal_finish_msg = '过了良久，琴音顿止，$N蓦觉一股清幽安宁的感觉遍透全身。',
	heal_unfinish_msg = '过了一会，$N头晕脑涨，热血上涌，骤觉这伤势，非浅薄的琴音所能调理。',
	heal_halt_msg = '突然间琴音在脑海中止歇，$N便即惊醒，深吸了一口气，站起身来。',
},

['圣火神功'] = {
	name = '圣火神功',
	type = 'force',
	id = 'shenhuo-shengong',
	heal_msg = '$N盘膝而坐，双手十指张开，举在胸前，作火焰飞腾之状，运起圣火神功开始疗伤。',
	heal_finish_msg = '$N脸上流光浮现，一声：“焚我残躯，熊熊圣火，生亦何欢，死亦何苦？”，缓缓站起。',
	heal_unfinish_msg = '$N神态庄严，缓缓站起身来，但脸上血红，看来伤势还没有完全恢复。',
	heal_halt_msg = '$N脸颊胀红，头顶热气袅袅上升，猛地吸一口气，挣扎着爬了起来。',
},

['九阳神功'] = {
	name = '九阳神功',
	type = 'force',
	id = 'jiuyang-shengong',
	heal_msg = '$N盘膝坐下，依照经中所示的法门调息，只觉丹田中暖烘烘地、活泼泼地，真气流动。',
	heal_finish_msg = '九阳神功的威力，这时方才显现出来，在$N体内又运走数转，胸腹之间甚感温暖舒畅。',
	heal_unfinish_msg = '$N神态庄严，缓缓站起身来，但脸上血红，看来伤势还没有完全恢复。',
	heal_halt_msg = '$N脸颊胀红，头顶热气袅袅上升，猛地吸一口气，挣扎着爬了起来。',
},

['易筋经'] = {
	name = '易筋经',
	type = 'force',
	id = 'yijin-jing',
	heal_msg = '$N双手合什，盘膝而坐，口中念起“往生咒”，开始运功疗伤。',
	heal_finish_msg = '$N缓缓站起，只觉全身说不出的舒服畅快，便道：“善哉！善哉！本门易筋经当真是天下绝学！”',
	heal_unfinish_msg = '$N吐出瘀血，缓缓站起，但脸色苍白，看来还有伤在身。',
	heal_halt_msg = '$N一声：“阿弥陀佛”双袖挥动，压下内息，站起身来。',
},

['毒龙大法'] = {
	name = '毒龙大法',
	type = 'force',
	id = 'dulong-dafa',
},

['寒冰真气'] = {
	name = '寒冰真气',
	type = 'force',
	id = 'hanbing-zhenqi',
	heal_msg = '$N运起寒冰真气，开始缓缓运气疗伤。',
	heal_finish_msg = '$N内息一停，却见伤势已经全好了。',
	heal_unfinish_msg = '$N眉头一皱，“哇”地吐出一口瘀血，看来这伤还没有全好。',
	heal_halt_msg = '$N急急把内息一压，也不顾身上的伤势立即站了起来。',
},

['碧海潮生功'] = {
	name = '碧海潮生功',
	type = 'force',
	id = 'bihai-chaosheng',
	heal_msg = '$N凝神静气，内息随悠扬箫声在全身游走，恰似碧海浪涛般冲击受损被封经脉。',
	heal_finish_msg = '$N脸色渐渐变得舒缓，箫声亦随之急转直下，渐不可闻。',
	heal_unfinish_msg = '$N内息微弱，难以为济，箫声募然高亢渐而消失，人随之站起，猛地吐出一口鲜血。',
	heal_halt_msg = '$N突感周身不适，内息全然不受乐音指引，急忙停止吹奏，箫声骤然竭止。',
},

['归元吐纳法'] = {
	name = '归元吐纳法',
	type = 'force',
	id = 'guiyuan-tunafa',
	heal_msg = '$N神情肃然，双目虚闭，开始吸呐身周草木精华为已所用，恢复受损元气。',
	heal_finish_msg = '$N将草木精华与内息融纳一体，感觉伤势已然痊愈，神情也变得清朗起来。',
	heal_unfinish_msg = '$N内息难以为继，脸色愈发铁青，只好暂停疗伤，站了起来。',
	heal_halt_msg = '$N突感草木精华再难与内息融合,继续疗伤反而有损真元，急忙强压内息，缓缓站起。',
},

['氤氲紫气'] = {
	name = '氤氲紫气',
	type = 'force',
	id = 'yinyun-ziqi',
},

['龙象般若功'] = {
	name = '龙象般若功',
	type = 'force',
	id = 'longxiang-boruo',
},

['神照经'] = {
	name = '神照经',
	type = 'force',
	id = 'shenzhao-jing',
},

['九阴真功'] = {
	name = '九阴真功',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['冷泉神功'] = {
	name = '冷泉神功',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['紫霞神功'] = {
	name = '紫霞神功',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['神元功'] = {
	name = '神元功',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['枯荣禅功'] = {
	name = '枯荣禅功',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['乾天一阳功'] = {
	name = '乾天一阳功',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['化功大法'] = {
	name = '化功大法',
	type = 'force',
	id = 'jiuyin-zhengong',
},


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
