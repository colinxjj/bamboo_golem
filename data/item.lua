local item = {

--------------------------------------------------------------------------------
-- money

['ͭǮ'] = {
  iname = 'ͭǮ',
	name = 'ͭǮ',
  id = 'coin',
  type = 'money',
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'silver',
  type = 'money',
},

['�ƽ�'] = {
  iname = '�ƽ�',
	name = '�ƽ�',
  id = 'gold',
  type = 'money',
},

--------------------------------------------------------------------------------
-- normal weapon

['����'] = {
  iname = '����',
	name = '����',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
},

['�ֽ�'] = {
  iname = '�ֽ�',
	name = '�ֽ�',
  id = 'jian',
  alternate_id = { 'sword' },
  type = 'sword',
  weight = 6000,
  value = 2000,
  quality = 30,
},

['�ֵ�'] = {
  iname = '�ֵ�',
	name = '�ֵ�',
  id = 'blade',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 5000,
  value = 1000,
  quality = 20,
  source = {
    { type = 'cmd', cmd = 'na dao', location = '��ɽ������', }
  }
},

['ľ��'] = {
  iname = 'ľ��',
	name = 'ľ��',
  id = 'mu jian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 300,
  value = 1270,
  quality = 5,
},

['��'] = {
  iname = '��',
	name = '��',
  id = 'zhu jian',
  alternate_id = { 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 5,
},

['���'] = {
  iname = '���',
	name = '���',
  id = 'zhubang',
  type = 'stick',
  weight = 3000,
  value = 200,
  quality = 25,
},

['�廨��'] = {
  iname = '�廨��',
	name = '�廨��',
  id = 'xiuhua zhen',
  alternate_id = { 'zhen', 'needle' },
  type = 'sword',
  weight = 500,
  value = 200,
  quality = 10,
},

--------------------------------------------------------------------------------
-- vendor drinks

['��ˮ��«'] = {
  iname = '��ˮ��«',
	name = '��ˮ��«',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'bottle',
  weight = 700,
  value = 100,
  capacity = 15,
},

--------------------------------------------------------------------------------
-- vendor misc goods

['������'] = {
  iname = '������',
	name = '������',
  id = 'cu shengzi',
  value = 1000,
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'fire',
  weight = 80,
  value = 100,
  source = {
    { type = 'get', location = '����ɽ����', },
    { type = 'get', location = '���޺���Ȼʯ��', },
  },
},

--------------------------------------------------------------------------------
-- normal armor

['����'] = {
  iname = '����',
	name = '����',
  id = 'tie jia',
  alternate_id = { 'tiejia', 'armor', 'jia' },
  type = 'cloth',
  weight = 20000,
  value = 2000,
  quality = 50,
},

['��令��'] = {
  iname = '��令��',
	name = '��令��',
  id = 'feicui huwan',
  alternate_id = { 'huwan' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['̴ľ����'] = {
  iname = '̴ľ����',
	name = '̴ľ����',
  id = 'tanmu huxiong',
  alternate_id = { 'huxiong' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['���ﻤ��'] = {
  iname = '���ﻤ��',
	name = '���ﻤ��',
  id = 'danfeng huyao',
  alternate_id = { 'huyao' },
  type = 'waist',
  weight = 500,
  quality = 4,
},

--------------------------------------------------------------------------------
-- treasure armor

['ľ������'] = {
  iname = 'ľ������',
	name = 'ľ������',
  id = 'mumian jiasha',
  alternate_id = { 'mimian', 'jiasha' },
  type = 'cloth',
  weight = 5000,
  quality = 150,
  vanish_on_drop = true,
},

--------------------------------------------------------------------------------
-- misc

['ë̺#WD'] = {
  iname = 'ë̺#WD',
	name = 'ë̺',
  id = 'mao tan',
  alternate_id = { 'tan' },
  desc = 'һ���ɴ���ë֯�ɵ�ë̺��ë��ϸ��ʮ�ֱ�ů��',
  weight = 600,
  source = {
    { type = 'cmd', cmd = 'find mao tan', location = '�䵱ɽŮ��Ϣ��', },
    { type = 'cmd', cmd = 'find mao tan', location = '�䵱ɽ����Ϣ��', },
  },
},

['ҩ��'] = {
  iname = 'ҩ��',
	name = 'ҩ��',
  id = 'yao chu',
  alternate_id = { 'chu' },
  desc = '����һ����ͨ��ҩ�õĳ�ͷ��',
  weight = 500,
  source = {
    { type = 'cmd', cmd = 'find yao chu', location = '�䵱ɽ�䵱�㳡', cond = 'player.party == "�䵱��"', }
  },
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'sheng zi',
  alternate_id = { 'sheng' },
  desc = '����һ�����������������ʺ�������֮�á�',
  source = {
    { type = 'get', location = '��ɽ����', },
  },
  weight = 400,
},

['����ʯ'] = {
  iname = '����ʯ',
	name = '����ʯ',
  id = 'lianxin shi',
  alternate_id = { 'lianxin', 'shi' },
  weight = 4000,
  source = {
    { type = 'get', location = '�䵱��ɽ�ŵ�#3', },
  },
},

['С��֦'] = {
  iname = 'С��֦',
	name = 'С��֦',
  id = 'xiao shuzhi',
  alternate_id = { 'shuzhi' },
  desc = '����һ֦С��֦��',
  weight = 1000,
  source = {
    { type = 'get', location = '����ɽ��ɼ��#1', },
    { type = 'get', location = '���������#5', },
    { type = 'get', location = '��������#M1', },
    { type = 'get', location = '��٢��ɽׯ������#N', },
    { type = 'get', location = '���ݳǻ���ɽ', },
    { type = 'get', location = '���ݳ�����ɽ', },
  },
},

['ͨ������'] = {
  iname = 'ͨ������',
	name = 'ͨ������',
  id = 'ling pai',
  weight = 20,
  source = {
    { type = 'cmd', cmd = 'ask lu gaoxuan about ͨ������', location = '������½������', npc = '½����', cond = 'player.party == "������"', },
    { type = 'local_handler', handler = 'sld_lingpai', location = '������½������', npc = '½����', cond = 'player.party ~= "������"', },
  },
  vanish_on_drop = true,
},

['������'] = {
  iname = '������',
	name = '������',
  id = 'jin wawa',
  alternate_id = { 'jin', 'wawa', 'yu' },
  weight = 3000,
  source = {
    { type = 'local_handler', handler = 'ty_fish', location = '��Դ���ٲ���', },
  },
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'tie zhou',
  alternate_id = { 'zhou', 'boat' },
  weight = 10000,
  source = {
    { type = 'local_handler', handler = 'ty_boat', location = '��Դ��ɽ���ٲ�', },
  },
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'teng',
  alternate_id = { 'shuteng' },
  weight = 1000,
  source = {
    { type = 'local_handler', handler = 'hs_shuteng', location = '��ɽ�ڶ�', },
  },
},

['�ٿ�'] = {
  iname = '�ٿ�',
	name = '�ٿ�',
  id = 'teng kuang',
  alternate_id = { 'kuang', 'tengkuang' },
  weight = 500,
  source = {
    { type = 'local_handler', handler = 'hs_kuang', location = '��ɽ�ڶ�', },
  },
},

['��Կ��'] = {
  iname = '��Կ��',
	name = '��Կ��',
  id = 'hei yaoshi',
  alternate_id = { 'yaoshi', 'key' },
  weight = 1000,
  source = {
    { type = 'local_handler', handler = 'hmy_key', location = '��ľ���鷿', },
  },
},

}

return item
