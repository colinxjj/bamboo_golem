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
-- food

['����'] = {
  iname = '����',
	name = '����',
  id = 'miantang',
  type = 'food',
  weight = 100,
  value = 50,
  consume_count = 1,
  food_supply = 30,
},

['��ͷ'] = {
  iname = '��ͷ',
	name = '��ͷ',
  id = 'man tou',
  alternate_id = { 'mantou', 'tou' },
  type = 'food',
  weight = 50,
  value = 40,
  consume_count = 2,
  food_supply = 40,
  source = {
    { type = 'get', location = '���ݳ�СĹ��', cond = 'player.party == "ؤ��"', },
    { type = 'get', location = '�ɶ��Ǻ�Ժ', cond = 'player.party == "ؤ��"', },
    { type = 'get', location = '���ݳ�����', cond = 'player.party == "ؤ��"', },
  },
},

['�±�'] = {
  iname = '�±�',
	name = '�±�',
  id = 'yue bing',
  alternate_id = { 'yuebing', 'bing' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['���㻨��'] = {
  iname = '���㻨��',
	name = '���㻨��',
  id = 'huasheng',
  alternate_id = { 'peanut' },
  type = 'food',
  weight = 60,
  value = 20,
  consume_count = 1,
  food_supply = 30,
},

['���㻨��#YZ'] = {
  iname = '���㻨��#YZ',
	name = '���㻨��',
  id = 'huasheng',
  alternate_id = { 'peanut' },
  type = 'food',
  weight = 60,
  value = 30,
  consume_count = 1,
  food_supply = 30,
},

['��䶹��'] = {
  iname = '��䶹��',
	name = '��䶹��',
  id = 'doufu',
  alternate_id = { 'tofu' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 1,
  food_supply = 50,
},

['��䶹��#DL'] = {
  iname = '��䶹��#DL',
	name = '��䶹��',
  id = 'feicui doufu',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 40,
  value = 100,
  consume_count = 2,
  food_supply = 50,
},

['�嶹��'] = {
  iname = '�嶹��',
	name = '�嶹��',
  id = 'ban doufu',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 40,
  value = 70,
  consume_count = 1,
  food_supply = 80,
},

['������'] = {
  iname = '������',
	name = '������',
  id = 'doufu gan',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 1,
  food_supply = 50,
},

['������'] = {
  iname = '������',
	name = '������',
  id = 'ji tui',
  alternate_id = { 'jitui', 'tui' },
  type = 'food',
  weight = 350,
  value = 30,
  consume_count = 4,
  food_supply = 40,
},

['��Ѽ'] = {
  iname = '��Ѽ',
	name = '��Ѽ',
  id = 'kao ya',
  alternate_id = { 'kaoya', 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['��Ѽ#DL'] = {
  iname = '��Ѽ#DL',
	name = '��Ѽ',
  id = 'kaoya',
  alternate_id = { 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'bao zi',
  alternate_id = { 'baozi', 'dumpling' },
  type = 'food',
  weight = 80,
  value = 30,
  consume_count = 3,
  food_supply = 20,
},

['����#HZ'] = {
  iname = '����#HZ',
	name = '����',
  id = 'baozi',
  alternate_id = { 'dumpling' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'zong zi',
  alternate_id = { 'zongzi', 'zong' },
  type = 'food',
  weight = 150,
  value = 100,
  consume_count = 3,
  food_supply = 30,
},

['����������'] = {
  iname = '����������',
	name = '����������',
  id = 'goubuli baozi',
  alternate_id = { 'baozi' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['��ɽ��'] = {
  iname = '��ɽ��',
	name = '��ɽ��',
  id = 'dong shanyang',
  alternate_id = { 'dong', 'shanyang' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['������'] = {
  iname = '������',
	name = '������',
  id = 'long chaoshou',
  alternate_id = { 'chaoshou' },
  type = 'food',
  weight = 200,
  value = 200,
  consume_count = 3,
  food_supply = 30,
},

['��������'] = {
  iname = '��������',
	name = '��������',
  id = 'yangrou paomo',
  alternate_id = { 'paomo' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 50,
},

['ɽ����'] = {
  iname = 'ɽ����',
	name = 'ɽ����',
  id = 'shanji rou',
  alternate_id = { 'rou' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['���Ͳ�'] = {
  iname = '���Ͳ�',
	name = '���Ͳ�',
  id = 'suyou cha',
  alternate_id = { 'tea', 'cha' },
  type = 'food',
  weight = 200,
  value = 80,
  consume_count = 3,
  food_supply = 10,
  water_supply = 10,
},

['ˮ����'] = {
  iname = 'ˮ����',
	name = 'ˮ����',
  id = 'mi tao',
  alternate_id = { 'mitao', 'tao' },
  type = 'food',
  weight = 40,
  value = 1,
  consume_count = 4,
  food_supply = 30,
},

['���Ϻ��'] = {
  iname = '���Ϻ��',
	name = '���Ϻ��',
  id = 'lingbai xiaren',
  alternate_id = { 'xiaren' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
},

['ӣ�һ���'] = {
  iname = 'ӣ�һ���',
	name = 'ӣ�һ���',
  id = 'yingtao huotui',
  alternate_id = { 'huotui' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
},

['��Ҷ������'] = {
  iname = '��Ҷ������',
	name = '��Ҷ������',
  id = 'dongsun-tang',
  alternate_id = { 'tang' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
},

['�ձ�'] = {
  iname = '�ձ�',
	name = '�ձ�',
  id = 'shao bing',
  alternate_id = { 'bing' },
  type = 'food',
  weight = 100,
  value = 200,
  consume_count = 3,
  food_supply = 35,
},

['����'] = {
  iname = '����',
	name = '����',
  id = 'you tiao',
  alternate_id = { 'youtiao' },
  type = 'food',
  weight = 100,
  value = 180,
  consume_count = 4,
  food_supply = 28,
},

['�黨����'] = {
  iname = '�黨����',
	name = '�黨����',
  id = 'mahua bianzi',
  alternate_id = { 'mahua', 'bianzi' },
  type = 'food',
  weight = 100,
  value = 120,
  consume_count = 4,
  food_supply = 22,
},

--------------------------------------------------------------------------------
-- drinks

['��ˮ'] = {
  iname = '��ˮ',
	name = '��ˮ',
  id = 'water',
  type = 'drink',
  water_supply = 120,
  source = {
    { type = 'local_handler', handler = 'drink', location = '����ǿ�ջ', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '���޺�����Ȫ', },
    { type = 'local_handler', handler = 'drink', location = '���ݳǲ�¥', },
    { type = 'local_handler', handler = 'drink', location = '���ݳǲ�¥��¥', },
    { type = 'local_handler', handler = 'drink', location = '����������¥', },
    { type = 'local_handler', handler = 'drink', location = '�䵱ɽ��ͤ', },
    { type = 'local_handler', handler = 'drink', location = '������������ի��#E', },
    { type = 'local_handler', handler = 'drink', location = '���������ľ�', },
    { type = 'local_handler', handler = 'drink', location = '�����µ��ʮ�ŷ�#3', },
    { type = 'local_handler', handler = 'drink', location = '�����µ��ʮ�ŷ�#2', },
    { type = 'local_handler', handler = 'drink', location = '�����µ��ʮ�ŷ�#1', },
    { type = 'local_handler', handler = 'drink', location = '�һ�������#2', },
    { type = 'local_handler', handler = 'drink', location = '̩ɽ�׺�Ȫ', },
    { type = 'local_handler', handler = 'drink', location = '���ݳǺ���Ȫ', },
    { type = 'local_handler', handler = 'drink', location = '���ݳǲ��', },
    { type = 'local_handler', handler = 'drink', location = '��ɽ���ַ��ľ�', },
    { type = 'local_handler', handler = 'drink', location = '���������', },
    { type = 'local_handler', handler = 'drink', location = '��٢��ɽׯ��԰', },
    { type = 'local_handler', handler = 'drink', location = '����Ľ�ݳ���#D', },
    { type = 'local_handler', handler = 'drink', location = '����ɳĮ����', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '���ݳ�Ӫ��ˮ', },
    { type = 'local_handler', handler = 'drink', location = '��ɽ��Ů��', },
    { type = 'local_handler', handler = 'drink', location = '��ɽ�ٲ�', },
    { type = 'local_handler', handler = 'drink', location = '��ľ�°���Ȫ', },
    { type = 'local_handler', handler = 'drink', location = '�ؽ�������', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '�ؽ�����', },
    { type = 'local_handler', handler = 'drink', location = '�ؽ���ʯΧ��', },
    { type = 'local_handler', handler = 'drink', location = '��ɽ����', },
    { type = 'local_handler', handler = 'drink', location = '����ɽ��԰', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '����ɽ�ٲ�', },
    { type = 'local_handler', handler = 'drink', location = '����ɽ������', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '����ɽ������', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '����ɽ�Ϻ���', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '����ɽ������', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '����ɽɽ��СϪ', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '�����ǲ��', },
    { type = 'local_handler', handler = 'drink', location = '���ݳ�СĹ��', },
    { type = 'local_handler', handler = 'drink', location = '���ݳǲ��', },
    { type = 'local_handler', handler = 'drink', location = '�ɶ��Ǻ�Ժ', },
    { type = 'local_handler', handler = 'drink', location = '�����ǲ��', },
    { type = 'local_handler', handler = 'drink', location = '���ݳ�����', },
    { type = 'local_handler', handler = 'drink', location = '����ɽ�յ�', },
    { type = 'local_handler', handler = 'instant_full', location = '�����ˮ̶����', },
  },
},

['��÷��'] = {
  iname = '��÷��',
	name = '��÷��',
  id = 'suanmei tang',
  alternate_id = { 'tang' },
  type = 'drink',
  weight = 50,
  value = 10,
  consume_count = 3,
  water_supply = 30,
},


--------------------------------------------------------------------------------
-- drink containers

['��ˮ��«'] = {
  iname = '��ˮ��«',
	name = '��ˮ��«',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
},

['ţƤ�ƴ�'] = {
  iname = 'ţƤ�ƴ�',
	name = 'ţƤ�ƴ�',
  id = 'jiu dai',
  alternate_id = { 'jiudai', 'wineskin', 'dai' },
  type = 'drink_container',
  weight = 700,
  value = 20,
  capacity = 15,
},

['����ƴ�'] = {
  iname = '����ƴ�',
	name = '����ƴ�',
  id = 'huadiao jiudai',
  alternate_id = { 'jiu dai', 'huadiao', 'dai' },
  type = 'drink_container',
  weight = 700,
  value = 120,
  capacity = 20,
},

['����ƴ�#DL'] = {
  iname = '����ƴ�#DL',
	name = '����ƴ�',
  id = 'jiudai',
  alternate_id = { 'skin', 'huadiao' },
  type = 'drink_container',
  weight = 700,
  value = 120,
  capacity = 20,
},

['�ɲ���'] = {
  iname = '�ɲ���',
	name = '�ɲ���',
  id = 'ci chawan',
  alternate_id = { 'chawan', 'ci' },
  type = 'drink_container',
  weight = 100,
  value = 100,
  capacity = 4,
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

['����̤����'] = {
  iname = '����̤����',
	name = '����̤����',
  id = 'qilin suo',
  alternate_id = { 'suo' },
  type = 'neck',
  weight = 600,
  value = 3000,
  quality = 5,
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
