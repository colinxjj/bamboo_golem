local kungfu = {

--------------------------------------------------------------------------
-- force

['�ټ�ʮ��ׯ'] = {
	name = '�ټ�ʮ��ׯ',
	type = 'force',
	id = 'linji-zhuang',
},

['��������'] = {
	name = '��������',
	type = 'force',
	id = 'huntian-qigong',
},

['��Ů�ľ�'] = {
	name = '��Ů�ľ�',
	type = 'force',
	id = 'yunu-xinjing',
},

['�����޼���'] = {
	name = '�����޼���',
	type = 'force',
	id = 'xuantian-wuji',
	heal_msg = '$N��ϥ���£���Ȼ������񳯷�������ڶ�������Ʈ����ʵ����͵����ɵ������ơ�',
	heal_finish_msg = '�������ã�������ֹ��$N���һ�����İ����ĸо���͸ȫ��',
	heal_unfinish_msg = '����һ�ᣬ$Nͷ�����ǣ���Ѫ��ӿ����������ƣ���ǳ�����������ܵ���',
	heal_halt_msg = 'ͻȻ���������Ժ���ֹЪ��$N�㼴���ѣ�������һ������վ��������',
},

['ʥ����'] = {
	name = 'ʥ����',
	type = 'force',
	id = 'shenhuo-shengong',
	heal_msg = '$N��ϥ������˫��ʮָ�ſ���������ǰ�����������֮״������ʥ���񹦿�ʼ���ˡ�',
	heal_finish_msg = '$N�������⸡�֣�һ���������Ҳ���������ʥ������λ�������οࣿ��������վ��',
	heal_unfinish_msg = '$N��̬ׯ�ϣ�����վ��������������Ѫ�죬�������ƻ�û����ȫ�ָ���',
	heal_halt_msg = '$N�����ͺ죬ͷ�����������������͵���һ����������������������',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'jiuyang-shengong',
	heal_msg = '$N��ϥ���£����վ�����ʾ�ķ��ŵ�Ϣ��ֻ��������ů���ء������õأ�����������',
	heal_finish_msg = '�����񹦵���������ʱ�������ֳ�������$N������������ת���ظ�֮��������ů�泩��',
	heal_unfinish_msg = '$N��̬ׯ�ϣ�����վ��������������Ѫ�죬�������ƻ�û����ȫ�ָ���',
	heal_halt_msg = '$N�����ͺ죬ͷ�����������������͵���һ����������������������',
},

['�׽'] = {
	name = '�׽',
	type = 'force',
	id = 'yijin-jing',
	heal_msg = '$N˫�ֺ�ʲ����ϥ�������������������䡱����ʼ�˹����ˡ�',
	heal_finish_msg = '$N����վ��ֻ��ȫ��˵������������죬����������գ����գ������׽���������¾�ѧ����',
	heal_unfinish_msg = '$N�³���Ѫ������վ�𣬵���ɫ�԰ף���������������',
	heal_halt_msg = '$Nһ�����������ӷ�˫��Ӷ���ѹ����Ϣ��վ��������',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'dulong-dafa',
},

['��������'] = {
	name = '��������',
	type = 'force',
	id = 'hanbing-zhenqi',
	heal_msg = '$N���𺮱���������ʼ�����������ˡ�',
	heal_finish_msg = '$N��Ϣһͣ��ȴ�������Ѿ�ȫ���ˡ�',
	heal_unfinish_msg = '$Nüͷһ�壬���ۡ����³�һ����Ѫ���������˻�û��ȫ�á�',
	heal_halt_msg = '$N��������Ϣһѹ��Ҳ�������ϵ���������վ��������',
},

['�̺�������'] = {
	name = '�̺�������',
	type = 'force',
	id = 'bihai-chaosheng',
	heal_msg = '$N����������Ϣ������������ȫ�����ߣ�ǡ�Ʊ̺����ΰ������𱻷⾭����',
	heal_finish_msg = '$N��ɫ��������滺����������֮��תֱ�£��������š�',
	heal_unfinish_msg = '$N��Ϣ΢��������Ϊ�ã�����ļȻ�߿�������ʧ������֮վ���͵��³�һ����Ѫ��',
	heal_halt_msg = '$Nͻ�������ʣ���ϢȫȻ��������ָ������æֹͣ���࣬������Ȼ��ֹ��',
},

['��Ԫ���ɷ�'] = {
	name = '��Ԫ���ɷ�',
	type = 'force',
	id = 'guiyuan-tunafa',
	heal_msg = '$N������Ȼ��˫Ŀ��գ���ʼ�������ܲ�ľ����Ϊ�����ã��ָ�����Ԫ����',
	heal_finish_msg = '$N����ľ��������Ϣ����һ�壬�о�������ȻȬ��������Ҳ�������������',
	heal_unfinish_msg = '$N��Ϣ����Ϊ�̣���ɫ�������ֻ࣬����ͣ���ˣ�վ��������',
	heal_halt_msg = '$Nͻ�в�ľ������������Ϣ�ں�,�������˷���������Ԫ����æǿѹ��Ϣ������վ��',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'yinyun-ziqi',
},

['���������'] = {
	name = '���������',
	type = 'force',
	id = 'longxiang-boruo',
},

['���վ�'] = {
	name = '���վ�',
	type = 'force',
	id = 'shenzhao-jing',
},

['�����湦'] = {
	name = '�����湦',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['��Ȫ��'] = {
	name = '��Ȫ��',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['��ϼ��'] = {
	name = '��ϼ��',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['��Ԫ��'] = {
	name = '��Ԫ��',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['��������'] = {
	name = '��������',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['Ǭ��һ����'] = {
	name = 'Ǭ��һ����',
	type = 'force',
	id = 'jiuyin-zhengong',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'jiuyin-zhengong',
},


-- quest skills

['�廢���ŵ�'] = {
	name = '�廢���ŵ�',
	type = 'blade',
	id = 'wuhu-duanmendao',
	power = {
		{ from = 1, to = 150, power = 1, },
		{ from = 150, to = 999, power = 1.1, },
	},
	fn = {
		duan = {
			name = '���־�',
			type = 'combo',
			req = {
				neili = 1500,
				neili_max = 2000,
				jingli = 1000,
				enable = { parry = '�廢���ŵ�', },
				skill = { ['�廢���ŵ�'] = 150 },
			},
			power = {
				{ from = 150, to = 250, power = 1.7, busy_pref = 1 },
				{ from = 250, to = 999, power = 2, busy_pref = 0.7 },
			},
		},
	},
},

['��ʬ����'] = {
	name = '��ʬ����',
	type = 'sword',
	id = 'tangshi-jianfa',
	power = {
		{ from = 1, to = 999, power = 0.3, },
	},
	fn = {
		erguang = {
			name = '����ʽ',
			type = 'combo',
			req = {
				neili = 100,
				neili_max = 500,
				enable = { parry = '��ʬ����' },
				skill = { ['��ʬ����'] = 80, ['��������'] = 80 },
		},
			power = {
				{ from = 80, to = 150, power = 1.8, busy_pref = 0.7 },
				{ from = 150, to = 999, power = 1.5, busy_pref = 0.7 },
			},
		},
	},
},

['���߽���'] = {
	name = '���߽���',
	type = 'sword',
	id = 'jinshe-jianfa',
	power = {
		{ from = 1, to = 999, power = 1, },
	},
	fn = {
		kuangwu = {
			name = '���߿���',
			type = 'combo',
			req = {
				neili = 900,
				neili_max = 1400,
				jingli = 800,
				enable = { parry = '���߽���', strike = '����������' },
				prepare = { '����������' },
				skill = { ['���߽���'] = 120, ['����������'] = 120, enable_force = 170, },
				stat = { str = 27, dex = 27 }
		},
			power = {
				{ from = 120, to = 999, power = 1.5, busy_pref = 0.7 },
			},
		},
	},
},

['����������'] = {
	name = '����������',
	type = 'strike',
	id = 'jinshe-zhangfa',
	power = {
		{ from = 1, to = 999, power = 1.2, },
	},
},


--------------------------------------------------------------------------
-- thd skills

['���｣��'] = {
	name = '���｣��',
	type = 'sword',
	id = 'yuxiao-jian',
	power = {
		{ from = 1, to = 150, power = 1.1, },
		{ from = 150, to = 999, power = 1.2, },
	},
	fn = {
		qimen = {
			name = '��������',
			type = 'combo',
			weapon = 'flute',
			req = {
				neili = 700,
				neili_max = 1000,
				jingli = 500,
				enable = { parry = '���｣��', },
				skill = { ['���｣��'] = 100, ['�̺�������'] = 100, ['���｣��'] = 100, ['���Ű���'] = 100, },
			},
			power = {
				{ from = 100, to = 400, power = 1.7, busy_pref = 1 },
				{ from = 400, to = 999, power = 2, busy_pref = 0.7 },
			},
		},
		feiying = {
			name = '��Ӱ',
			type = 'combo',
			weapon = 'flute',
			req = {
				neili = 4000,
				neili_max = 7500,
				jingli = 2500,
				enable = { parry = '���｣��', },
				skill = { ['���｣��'] = 350, ['�̺�������'] = 350, ['���Ű���'] = 180, ['��ָ��ͨ'] = 350, ['������Ѩ��'] = 350, ['��Ӣ����'] = 350, ['����ɨҶ��'] = 350, ['�沨����'] = 350, },
			},
			power = {
				{ from = 350, to = 400, power = 1.9, busy_pref = 1 },
				{ from = 400, to = 999, power = 2.2, busy_pref = 0.7 },
			},
		},
	},
},

['�沨����'] = {
	name = '�沨����',
	type = 'dodge',
	id = 'suibo-zhuliu',
	fn = {
		wuzhuan = {
			name = '������ת',
			type = 'powerup',
			req = {
				neili = 1500,
				jingli = 800,
				skill = { ['�沨����'] = 150, ['�̺�������'] = 150, ['���Ű���'] = 150, },
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
