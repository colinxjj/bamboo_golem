local kungfu = {

	--------------------------------------------------------------------------
	-- knowledge

	['��������'] = {
		name = '��������',
		type = 'knowledge',
		id = 'medicine',
	},

--------------------------------------------------------------------------
-- basic

['�����Ṧ'] = {
	name = '�����Ṧ',
	type = 'basic',
	id = 'dodge',
	source = {
		{ min = 0, max = 31, location = '��٢��ɽׯ�뷿', attr = 'int', cmd = 'ta sign', cost = { jing = 15 } },
		{ min = 20, max = 59, location = '����ׯ���䳡', attr = 'int', cmd = 'jump zhuang;jump down', cost = { jingli = 55 } },
		{ min = 50, max = 99, location = '�һ������䳡', attr = 'int', cmd = 'jump zhuang;jump down', cost = { jingli = 50 } },
		{ min = 20, max = 100, location = '��٢��ɽׯ����', attr = 'int', cmd = 'yue tree', cost = { jingli = 25 } },
		{ min = 30, max = 100, location = '���̱�ˮ��̶', attr = 'int', cmd = 'walk', cost = { jing = 25 } },
		{ min = 0, max = 100, location = '����ɽ��ʮ����#1', attr = 'dex', cmd = 'sw;ne', cost = { jingli = 20 } },
		{ min = 0, max = 100, location = '����ɽʮ����#3', attr = 'dex', cmd = 'sw;ne', cost = { jingli = 20 } },
	}
},

['�����ڹ�'] = {
	name = '�����ڹ�',
	type = 'basic',
	id = 'force',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['�����м�'] = {
	name = '�����м�',
	type = 'basic',
	id = 'parry',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['�����Ʒ�'] = {
	name = '�����Ʒ�',
	type = 'basic',
	id = 'strike',
	source = {
		{ min = 30, max = 101, location = '���ݳ�����㳡', jingli_cost = 50, handler = 'yz_tree' },
	}
},

['�����ȷ�'] = {
	name = '�����ȷ�',
	type = 'basic',
	id = 'leg',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['�����ַ�'] = {
	name = '�����ַ�',
	type = 'basic',
	id = 'hand',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['����צ��'] = {
	name = '����צ��',
	type = 'basic',
	id = 'claw',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['����ȭ��'] = {
	name = '����ȭ��',
	type = 'basic',
	id = 'cuff',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['����ָ��'] = {
	name = '����ָ��',
	type = 'basic',
	id = 'finger',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'sword',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'blade',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'stick',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'hook',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['�����ȷ�'] = {
	name = '�����ȷ�',
	type = 'basic',
	id = 'staff',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['�����ʷ�'] = {
	name = '�����ʷ�',
	type = 'basic',
	id = 'brush',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'axe',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['�����޷�'] = {
	name = '�����޷�',
	type = 'basic',
	id = 'whip',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'club',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'throwing',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['����ذ��'] = {
	name = '����ذ��',
	type = 'basic',
	id = 'dagger',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

['��������'] = {
	name = '��������',
	type = 'basic',
	id = 'hammer',
	source = {
		{ min = 30, max = 101, location = '', jingli_cost = 50, cmd = '' },
	}
},

--------------------------------------------------------------------------
-- force

default_force = {
	dazuo_start_msg = '�������������ù���һ����Ϣ��ʼ������������',
	dazuo_end_msg = '���˹���ϣ�վ��������',
	dazuo_halt_msg = '����������е�����ǿ��ѹ�ص��վ��������',
	heal_start_msg = '����ϥ���£���ʼ�˹����ˡ�',
	heal_finish_msg = '���˹���ϣ�վ������������ȥ��ɫ�����������ӡ�',
	heal_unfinish_msg = '���˹���ϣ�����վ����������ɫ������������ࡣ',
	heal_halt_msg = '��һ���³�һ����Ѫ������վ��������',
},

['�ټ�ʮ��ׯ'] = {
	name = '�ټ�ʮ��ׯ',
	type = 'force',
	id = 'linji-zhuang',
	dazuo_start_msg = '��ϯ�ض������������죬���Ϻ��ʱ��ʱ�֣���Ϣ˳��������������',
	dazuo_end_msg = '�㽫��Ϣ���˸�С���죬���ص���չ�վ��������',
	dazuo_halt_msg = '�㳤��һ����������Ϣ�������˻�ȥ��վ��������',
},

['��������'] = {
	name = '��������',
	type = 'force',
	id = 'huntian-qigong',
	dazuo_start_msg = '���������£�˫��ƽ����˫ϥ��Ĭ��ھ�����ʼ��������ķ���',
	dazuo_end_msg = '�������뵤�������ת�����������չ���˫��̧��վ��������',
	dazuo_halt_msg = '����ɫһ����Ѹ��������վ��������',
},

['��Ů�ľ�'] = {
	name = '��Ů�ľ�',
	type = 'force',
	id = 'yunu-xinjing',
	dazuo_start_msg = '���������һ�����������۾���������Ů�ľ�����Ϣ�������п�ʼ��ת��',
	dazuo_end_msg = '���������������뵤������۾������������һ������',
	dazuo_halt_msg = '����Ϣһת��Ѹ��������ֹͣ����Ϣ����ת��',
},

['�����޼���'] = {
	name = '�����޼���',
	type = 'force',
	id = 'xuantian-wuji',
	dazuo_start_msg = '�����������޼��񹦣����۵��һ����������֫������������',
	dazuo_end_msg = '����Ƭ�̣���о��Լ��Ѿ��������޼������۵����������վ��������',
	dazuo_halt_msg = '��Ҵҽ���Ϣ���˻�ȥ����һ��������վ��������',
	heal_start_msg = '����ϥ���£���Ȼ������񳯷�������ڶ�������Ʈ����ʵ����͵����ɵ������ơ�',
	heal_finish_msg = '�������ã�������ֹ�������һ�����İ����ĸо���͸ȫ��',
	heal_unfinish_msg = '����һ�ᣬ��ͷ�����ǣ���Ѫ��ӿ����������ƣ���ǳ�����������ܵ���',
	heal_halt_msg = 'ͻȻ���������Ժ���ֹЪ����㼴���ѣ�������һ������վ��������',
},

['ʥ����'] = {
	name = 'ʥ����',
	type = 'force',
	id = 'shenghuo-shengong',
	dazuo_start_msg = '����ϥ������˫�ִ�����ǰ�ɻ���״�������������þ����е���������һ����������ӿ�뵤�',
	dazuo_end_msg = '�㽫������Ϣ��ͨ���������������۾���վ��������',
	dazuo_halt_msg = '������΢΢����������������վ��������',
	heal_start_msg = '����ϥ������˫��ʮָ�ſ���������ǰ�����������֮״������ʥ���񹦿�ʼ���ˡ�',
	heal_finish_msg = '���������⸡�֣�һ���������Ҳ���������ʥ������λ�������οࣿ��������վ��',
	heal_unfinish_msg = '����̬ׯ�ϣ�����վ��������������Ѫ�죬�������ƻ�û����ȫ�ָ���',
	heal_halt_msg = '�������ͺ죬ͷ�����������������͵���һ����������������������',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'jiuyang-shengong',
	dazuo_start_msg = '����ϥ��������ʹ�����������³������������뼹�ǣ�ע�����䣬������������֮���硣',
	dazuo_end_msg = '������������һ��Ԫ����������˫�ۣ�ֻ����ȫ����������������������Ȼ����֮����',
	dazuo_halt_msg = '������΢΢����������������վ��������',
	heal_start_msg = '����ϥ���£����վ�����ʾ�ķ��ŵ�Ϣ��ֻ��������ů���ء������õأ�����������',
	heal_finish_msg = '�����񹦵���������ʱ�������ֳ���������������������ת���ظ�֮��������ů�泩��',
	heal_unfinish_msg = '����̬ׯ�ϣ�����վ��������������Ѫ�죬�������ƻ�û����ȫ�ָ���',
	heal_halt_msg = '�������ͺ죬ͷ�����������������͵���һ����������������������',
},

['�׽'] = {
	name = '�׽',
	type = 'force',
	id = 'yijin-jing',
	dazuo_start_msg = '���������죬�ų�һ�������Ϣ˳��������������',
	dazuo_end_msg = '�㽫��Ϣ���˸�С���죬���ص���չ�վ��������',
	dazuo_halt_msg = '�㳤��һ����������Ϣ�������˻�ȥ��վ��������',
	heal_start_msg = '��˫�ֺ�ʲ����ϥ�������������������䡱����ʼ�˹����ˡ�',
	heal_finish_msg = '�㻺��վ��ֻ��ȫ��˵������������죬����������գ����գ������׽���������¾�ѧ����',
	heal_unfinish_msg = '���³���Ѫ������վ�𣬵���ɫ�԰ף���������������',
	heal_halt_msg = '��һ�����������ӷ�˫��Ӷ���ѹ����Ϣ��վ��������',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'dulong-dafa',
	dazuo_start_msg = '����ϥ���£�˫�ֺ�ʮ����ͷ����Ǳ��������һ�ź������������Χ��������˫��ð��һ˿�̹⡣',
	dazuo_end_msg = '��ֿ�˫�֣������������£����е��̹�Ҳ��������������',
	dazuo_halt_msg = '��˫�ۻ����պϣ�Ƭ���͵������������̹⼱�������',
},

['��������'] = {
	name = '��������',
	type = 'force',
	id = 'hanbing-zhenqi',
	dazuo_start_msg = '�����󽣾���������������������������ת����',
	dazuo_end_msg = '�㽫��������������֮�ư�����һ�ܣ��о����������ˡ�',
	dazuo_halt_msg = '��˫��һ��������ѹ����Ϣվ��������',
	heal_start_msg = '�����𺮱���������ʼ�����������ˡ�',
	heal_finish_msg = '����Ϣһͣ��ȴ�������Ѿ�ȫ���ˡ�',
	heal_unfinish_msg = '��üͷһ�壬���ۡ����³�һ����Ѫ���������˻�û��ȫ�á�',
	heal_halt_msg = '�㼱������Ϣһѹ��Ҳ�������ϵ���������վ��������',
},

['�̺�������'] = {
	name = '�̺�������',
	type = 'force',
	id = 'bihai-chaosheng',
	dazuo_start_msg = '���������£�˫Ŀ΢�գ�˫���������������̫�������˺�һ���������顣',
	dazuo_end_msg = '�㽫��Ϣ������һ��С���죬�������뵤�˫��һ��վ��������',
	heal_start_msg = '������������Ϣ������������ȫ�����ߣ�ǡ�Ʊ̺����ΰ������𱻷⾭����',
	heal_finish_msg = '����ɫ��������滺����������֮��תֱ�£��������š�',
	heal_unfinish_msg = '����Ϣ΢��������Ϊ�ã�����ļȻ�߿�������ʧ������֮վ���͵��³�һ����Ѫ��',
	heal_halt_msg = '��ͻ�������ʣ���ϢȫȻ��������ָ������æֹͣ���࣬������Ȼ��ֹ��',
},

['��Ԫ���ɷ�'] = {
	name = '��Ԫ���ɷ�',
	type = 'force',
	id = 'guiyuan-tunafa',
	dazuo_start_msg = '����ϥ���£�������������ͼ��ȡ���֮������ֻ�������ܰ�����������ضٺϣ����ܰ�ããһƬ��',
	dazuo_end_msg = '��˫��΢�գ���������ؾ���֮����������,����ػָ��������չ�վ��������',
	dazuo_halt_msg = '����Ϣһת��Ѹ�������������չ�վ��������',
	heal_start_msg = '��������Ȼ��˫Ŀ��գ���ʼ�������ܲ�ľ����Ϊ�����ã��ָ�����Ԫ����',
	heal_finish_msg = '�㽫��ľ��������Ϣ����һ�壬�о�������ȻȬ��������Ҳ�������������',
	heal_unfinish_msg = '����Ϣ����Ϊ�̣���ɫ�������ֻ࣬����ͣ���ˣ�վ��������',
	heal_halt_msg = '��ͻ�в�ľ������������Ϣ�ں�,�������˷���������Ԫ����æǿѹ��Ϣ������վ��',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'yinyun-ziqi',
	dazuo_start_msg = '����ϥ������˫Ŀ���գ�������һ�������뵤�������һ����Ϣ�������Ѩ��������������֮����',
	dazuo_end_msg = '�㽫��Ϣ����������ʮ�����죬���ص��ֻ����ȫ��ů����ġ�',
	dazuo_halt_msg = '��΢һ��ü������Ϣѹ�ص������һ������վ��������',
},

['���������'] = {
	name = '���������',
	type = 'force',
	id = 'longxiang-boruo',
	dazuo_start_msg = '��(����������ϥ��������������������һƬ�������������Ҿ��磬һ�����ȵ���Ϣ���ζ�����֮������|���������Ŀ�������ִ����������Ⱥ������������֮���䣬��Ȼ֮�������������Ҿ���)��',
	dazuo_end_msg = '��(ֻ����Ԫ��һ��ȫ�������������Ը��ӣ��̲�ס��Хһ��������վ������|�е��Լ��������Ϊһ�壬ȫ����ˬ��ԡ���磬�̲�ס�泩��������һ���������������۾�)��',
	dazuo_halt_msg = '��(�е��������ͣ�ֻ��и����Ϣ������������������͸�����亹|�е��������ң�ȫ�����ȣ�ֻ���չ�վ������)��',
},

['���վ�'] = {
	name = '���վ�',
	type = 'force',
	id = 'shenzhao-jing',
	dazuo_start_msg = '��������ϥ������˫�ְ�����ǰ������һ��ů���澭��������ת��',
	dazuo_end_msg = '��һ�������н������������ӵ�վ��������',
	dazuo_halt_msg = '���͵�����˫�ۣ�˫��Ѹ�ٻظ���࣬��ϸ�������ܡ�',
},

['�����湦'] = {
	name = '�����湦',
	type = 'force',
	id = 'jiuyin-zhengong',
	dazuo_start_msg = '���������£�˫Ŀ΢�գ�˫���������������̫�������˺�һ���������顣',
	dazuo_end_msg = '�㽫��Ϣ������һ��С���죬�������뵤�˫��һ��վ��������',
},

['��Ȫ��'] = {
	name = '��Ȫ��',
	type = 'force',
	id = 'lengquan-shengong',
	dazuo_start_msg = '�����󽣾���������������������������ת����',
	dazuo_end_msg = '�㽫��������������֮�ư�����һ�ܣ��о����������ˡ�',
	dazuo_halt_msg = '��˫��һ��������ѹ����Ϣվ��������',
	heal_start_msg = '�����𺮱���������ʼ�����������ˡ�',
	heal_finish_msg = '����Ϣһͣ��ȴ�������Ѿ�ȫ���ˡ�',
	heal_unfinish_msg = '��üͷһ�壬���ۡ����³�һ����Ѫ���������˻�û��ȫ�á�',
	heal_halt_msg = '�㼱������Ϣһѹ��Ҳ�������ϵ���������վ��������',
},

['��ϼ��'] = {
	name = '��ϼ��',
	type = 'force',
	id = 'zixia-gong',
	dazuo_start_msg = '����Ϣ�������������������ִ�������֮�ϣ�����ǰ���˸�������������Ϣ���߸���������',
	dazuo_end_msg = '�㽫��Ϣ����һ�����죬ֻ�е�ȫ��̩ͨ��������ů���ģ�˫��һ�֣�����վ��������',
	dazuo_halt_msg = '������һ��������Ϣѹ�ص��˫��һ��վ��������',
},

['��Ԫ��'] = {
	name = '��Ԫ��',
	type = 'force',
	id = 'shenyuan-gong',
	dazuo_start_msg = '������һվ��˫�ֻ���̧������һ������������ʼ��������ת��',
	dazuo_end_msg = '�㽫����������������������һȦ���������뵤������֣�������һ������',
	dazuo_halt_msg = '��üͷһ�壬�������������ַ���������',
},

['��������'] = {
	name = '��������',
	type = 'force',
	id = 'kurong-changong',
	dazuo_start_msg = '����ϥ���£���Ŀ��ʲ��Ĭ�˿���������ֻ����������������ʼ�����ڻ����ζ���',
	dazuo_end_msg = '������������������һ�����죬�����������ڵ������̧�����۾���',
	dazuo_halt_msg = '��˫��һ�֣�������ȭ����������Ѹ�ٽ������ڡ�',
},

['Ǭ��һ����'] = {
	name = 'Ǭ��һ����',
	type = 'force',
	id = 'qiantian-yiyang',
	dazuo_start_msg = '����ϥ���£���Ŀ��ʲ������Ǭ��һ���񹦣�һ�ɴ���������ʼ��������ת��',
	dazuo_end_msg = '������������������һ�����죬���������ڵ�������������۾���',
	dazuo_halt_msg = '��˫��һ�֣�ƽ̯���أ�Ѹ��������ֹͣ������������',
},

['������'] = {
	name = '������',
	type = 'force',
	id = 'huagong-dafa',
	dazuo_start_msg = '�����˵�������ڶ��������Ƴ����������������㻺��Ʈ������о����ھ���ʼ������ǿ�ˡ�',
	dazuo_end_msg = '��о�����ԽתԽ�죬�Ϳ�Ҫ������Ŀ����ˣ�����æ�ջض��غ���Ϣ����Цһ��վ��������',
	dazuo_halt_msg = '��˫��һ�����������һ�����⣬��������һЦ��վ��������',
},


--------------------------------------------------------------------------
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
