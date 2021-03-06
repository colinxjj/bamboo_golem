local item = {

--------------------------------------------------------------------------------
-- money

['ͭǮ'] = {
	name = 'ͭǮ',
  id = 'coin',
  type = 'money',
},

['����'] = {
	name = '����',
  id = 'silver',
  type = 'money',
},

['�ƽ�'] = {
	name = '�ƽ�',
  id = 'gold',
  type = 'money',
},

--------------------------------------------------------------------------------
-- food

['����'] = {
	name = '����',
  id = 'miantang',
  type = 'food',
  weight = 100,
  value = 50,
  consume_count = 1,
  food_supply = 30,
  source = {
    { type = 'get', location = '�����ȳ���', },
  },
},

['��ͷ'] = {
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
	name = '��Ѽ',
  id = 'kao ya',
  alternate_id = { 'kaoya', 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
  source = {
    { type = 'get', location = '����ɽ����', },
  },
},

['��Ѽ#DL'] = {
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
	name = '����',
  id = 'bao zi',
  alternate_id = { 'baozi', 'dumpling' },
  type = 'food',
  weight = 80,
  value = 30,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '����������', },
  },
},

['����#HZ'] = {
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
	name = '����',
  id = 'zong zi',
  alternate_id = { 'zongzi', 'zong' },
  type = 'food',
  weight = 150,
  value = 100,
  consume_count = 3,
  food_supply = 30,
  source = {
    { type = 'get', location = '���̳���', },
    { type = 'get', location = '��ľ����ʳ��', },
  },
},

['����#FZ'] = {
	name = '����',
  id = 'zongzi',
  type = 'food',
  weight = 100,
  value = 100,
  consume_count = 3,
  food_supply = 50,
},

['����������'] = {
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
	name = 'ˮ����',
  id = 'mi tao',
  alternate_id = { 'mitao', 'tao' },
  type = 'food',
  weight = 40,
  value = 1,
  consume_count = 4,
  food_supply = 30,
  source = {
    { type = 'get', location = '�䵱ɽ��ͤ', },
  },
},

['ˮ����#1'] = {
	name = 'ˮ����',
  id = 'tao',
  alternate_id = { 'mi tao' },
  type = 'food',
  weight = 40,
  value = 80,
  consume_count = 4,
  food_supply = 30,
  source = {
    { type = 'get', location = '����������', },
  },
},

['ˮ����#F'] = {
	name = 'ˮ����',
  id = 'shuimi tao',
  alternate_id = { 'shuimitao', 'tao' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['���Ϻ��'] = {
	name = '���Ϻ��',
  id = 'lingbai xiaren',
  alternate_id = { 'xiaren' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '����Ľ�ݳ���#1', },
  },
},

['ӣ�һ���'] = {
	name = 'ӣ�һ���',
  id = 'yingtao huotui',
  alternate_id = { 'huotui' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '����Ľ�ݳ���#1', },
  },
},

['��Ҷ������'] = {
	name = '��Ҷ������',
  id = 'dongsun-tang',
  alternate_id = { 'tang' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '����Ľ�ݳ���#1', },
  },
},

['�ձ�'] = {
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
	name = '�黨����',
  id = 'mahua bianzi',
  alternate_id = { 'mahua', 'bianzi' },
  type = 'food',
  weight = 100,
  value = 120,
  consume_count = 4,
  food_supply = 22,
},

['�ؼ��'] = {
	name = '�ؼ��',
  id = 'jian jiao',
  alternate_id = { 'jiao', 'dumpling' },
  type = 'food',
  weight = 100,
  value = 200,
  consume_count = 5,
  food_supply = 35,
},

['��Ѽ��'] = {
	name = '��Ѽ��',
  id = 'chou yadan',
  alternate_id = { 'yadan', 'egg' },
  type = 'food',
  weight = 70,
  value = 80,
  consume_count = 1,
  food_supply = 80,
},

['�������'] = {
	name = '�������',
  id = 'rou bing',
  alternate_id = { 'roubing' },
  type = 'food',
  weight = 300,
  value = 200,
  consume_count = 3,
  food_supply = 40,
},

['ƻ��'] = {
	name = 'ƻ��',
  id = 'ping guo',
  alternate_id = { 'pingguo', 'guo' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['����'] = {
	name = '����',
  id = 'bai li',
  alternate_id = { 'baili', 'li' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['â��'] = {
	name = 'â��',
  id = 'mang guo',
  alternate_id = { 'mangguo', 'guo' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['��֦'] = {
	name = '��֦',
  id = 'li zhi',
  alternate_id = { 'lizhi' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['���۹�'] = {
	name = '���۹�',
  id = 'hami gua',
  alternate_id = { 'hamigua', 'gua' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['����'] = {
	name = '����',
  id = 'ju zi',
  alternate_id = { 'juzi' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['���⴮'] = {
	name = '���⴮',
  id = 'yangrou chuan',
  alternate_id = { 'yangrou', 'chuan' },
  type = 'food',
  weight = 300,
  value = 200,
  consume_count = 3,
  food_supply = 50,
},

['��'] = {
	name = '��',
  id = 'nang',
  alternate_id = { 'cake' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
},

['���ܹ�'] = {
	name = '���ܹ�',
  id = 'hami gua',
  alternate_id = { 'hamigua', 'gua' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
  source = {
    { type = 'get', location = '�ؽ�������' },
  },
},

['���ܹ�#XX'] = {
	name = '���ܹ�',
  id = 'hamigua',
  alternate_id = { 'gua', 'melon' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 1,
  food_supply = 50,
},

['�׷�'] = {
	name = '�׷�',
  id = 'mi fan',
  alternate_id = { 'rice', 'fan' },
  type = 'food',
  weight = 50,
  consume_count = 5,
  food_supply = 40,
  source = {
    { type = 'get', location = '����ɽ����' },
    { type = 'get', location = '��ɽ����' },
    { type = 'get', location = '���ְ����' },
    { type = 'get', location = '�䵱ɽ����' },
    { type = 'get', location = '��Դ��ի��' },
    { type = 'get', location = '�����ȳ���', },
    { type = 'get', location = '����ׯ����', },
    { type = 'get', location = '�һ�������#2', },
    { type = 'get', location = '�һ�������#1', },
    { type = 'get', location = '��ݳ���', },
  },
},

['�׷�#TLS'] = {
	name = '�׷�',
  id = 'rice',
  alternate_id = { 'mi fan', 'fan' },
  type = 'food',
  weight = 50,
  value = 120,
  consume_count = 5,
  food_supply = 40,
  source = {
    { type = 'get', location = '�����³���' },
    { type = 'get', location = '������������ի��#W' },
    { type = 'get', location = '������������ի��#E' },
  },
},

['���'] = {
	name = '���',
  id = 'qingcai',
  type = 'food',
  weight = 100,
  value = 50,
  consume_count = 1,
  food_supply = 20,
  source = {
    { type = 'get', location = '�����ȳ���', },
  },
},

['���#TLS'] = {
	name = '���',
  id = 'qing cai',
  alternate_id = { 'cai' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
  source = {
    { type = 'get', location = '������������ի��#W' },
    { type = 'get', location = '������������ի��#E' },
  },
},

['�������'] = {
	name = { '������˿', '��������', '÷�˿���', '��������', '������˿', '���ͼ�Ƭ', '�峴Ϻ��', '�廨����', '��˿Ѭ��', '�Ǵ��Ź�', '������˿', '������Ϻ', '��Ƥ��Ѽ', '�����ض�', '��������', '���ͷ�Ƭ', '��������', '���ʹ೦', '��������', '���㶬��', '��䶹��', '���Ŷ���', '���ʸ���', '��������', 'ץ���Ｙ', 'ƬƤ����', '������Ƭ', '��Ϫ����', '��������', '������', '���ݴ���', },
  id = 'cai yao',
  alternate_id = { 'cai' },
  type = 'food',
  weight = 100,
  value = 200,
  consume_count = 5,
  food_supply = 35,
  source = {
    { type = 'get', location = '���޺�����' },
  },
},

['���Ŷ���'] = {
	name = '���Ŷ���',
  id = 'doufu',
  type = 'food',
  weight = 200,
  value = 60,
  consume_count = 3,
  food_supply = 50,
  source = {
    { type = 'get', location = '�䵱ɽ����' },
  },
},

['ըɽ��#DL'] = {
	name = 'ըɽ��',
  id = 'zha shanji',
  alternate_id = { 'shanji', 'ji' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
  source = {
    { type = 'get', location = '����������������' },
  },
},

['���׷�#TZ'] = {
	name = '���׷�',
  id = 'mi fan',
  alternate_id = { 'fan' },
  type = 'food',
  weight = 500,
  value = 30,
  consume_count = 3,
  food_supply = 30,
  source = {
    { type = 'get', location = '��������', },
  },
},

['���׷�#THD'] = {
	name = '���׷�',
  id = 'dami fan',
  alternate_id = { 'mifan', 'fan' },
  type = 'food',
  weight = 40,
  consume_count = 5,
  food_supply = 40,
  source = {
    { type = 'handler', handler = 'sit_and_wait', location = '�һ�������#1', cond = '( time.get_current_hour() >= 6 and time.get_current_hour() <= 8 ) or ( time.get_current_hour() >= 11 and time.get_current_hour() <= 13 ) or ( time.get_current_hour() >= 17 and time.get_current_hour() <= 20 )', },
    { type = 'handler', handler = 'sit_and_wait', location = '����ׯ����', cond = '( time.get_current_hour() >= 6 and time.get_current_hour() <= 8 ) or ( time.get_current_hour() >= 11 and time.get_current_hour() <= 13 ) or ( time.get_current_hour() >= 17 and time.get_current_hour() <= 20 )', },
  },
},

['ƬƤ����#TZ'] = {
	name = 'ƬƤ����',
  id = 'ruzhu',
  type = 'food',
  weight = 700,
  value = 300,
  consume_count = 5,
  food_supply = 100,
},

['����ţ��#TZ'] = {
	name = '����ţ��',
  id = 'hongshao niurou',
  alternate_id = { 'niurou' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['������Ҷ��'] = {
	name = '������Ҷ��',
  id = 'longjing caiyeji',
  alternate_id = { 'ji' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '��٢��ɽׯ����', },
    { type = 'get', location = '����Ľ�ݳ���#D', },
    { type = 'get', location = '���������', },
  },
},

['�����Բ'] = {
	name = '�����Բ',
  id = 'feicui yuyuan',
  alternate_id = { 'yuyuan' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '��٢��ɽׯ����', },
    { type = 'get', location = '����Ľ�ݳ���#D', },
    { type = 'get', location = '���������', },
  },
},

['÷����Ѽ'] = {
	name = '÷����Ѽ',
  id = 'meihua zaoya',
  alternate_id = { 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '��٢��ɽׯ����', },
    { type = 'get', location = '����Ľ�ݳ���#D', },
    { type = 'get', location = '���������', },
  },
},

['����'] = {
	name = '����',
  id = 'pu tao',
  alternate_id = { 'putao' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '��٢��ɽׯ����', },
  },
},

['��Բ'] = {
	name = '��Բ',
  id = 'gui yuan',
  alternate_id = { 'guiyuan' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '��٢��ɽׯ����', },
  },
},

['��֦'] = {
	name = '��֦',
  id = 'li zhi',
  alternate_id = { 'lizhi' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '����������', },
  },
},

['С����#GYZ'] = {
	name = 'С����',
  id = 'baozi',
  type = 'food',
  weight = 30,
  consume_count = 5,
  food_supply = 30,
  source = {
    { type = 'get', location = '����ׯ����', },
    { type = 'get', location = '�һ�������#1', },
  },
},

['����#GYZ'] = {
	name = '����',
  id = 'rou',
  alternate_id = { 'meat' },
  type = 'food',
  weight = 30,
  consume_count = 4,
  food_supply = 25,
  source = {
    { type = 'get', location = '����ׯ����', },
  },
},

['����#THD'] = {
	name = '����',
  id = 'rou',
  alternate_id = { 'meat' },
  type = 'food',
  weight = 60,
  value = 40,
  consume_count = 2,
  food_supply = 25,
  source = {
    { type = 'get', location = '�һ�������#2', },
    { type = 'get', location = '�һ�������#1', },
  },
},

['ץ���Ｙ'] = {
	name = 'ץ���Ｙ',
  id = 'zhuachao liji',
  alternate_id = { 'liji' },
  type = 'food',
  weight = 400,
  value = 100,
  consume_count = 1,
  food_supply = 50,
},

['��Ϫ����'] = {
	name = '��Ϫ����',
  id = 'liangxi cuishan',
  alternate_id = { 'cuishan' },
  type = 'food',
  weight = 500,
  value = 200,
  consume_count = 2,
  food_supply = 35,
},

['������'] = {
	name = '������',
  id = 'douhua',
  type = 'food',
  weight = 200,
  value = 120,
  consume_count = 1,
  food_supply = 30,
},

['������Ƭ'] = {
	name = '������Ƭ',
  id = 'rou pian',
  alternate_id = { 'rou' },
  type = 'food',
  weight = 200,
  value = 120,
  consume_count = 3,
  food_supply = 50,
},

['�Ǵ�����'] = {
	name = '�Ǵ�����',
  id = 'tangcu liyu',
  alternate_id = { 'liyu' },
  type = 'food',
  weight = 200,
  value = 250,
  consume_count = 3,
  food_supply = 30,
  source = {
    { type = 'get', location = '��������', },
  },
},

['ԭ������ţ��'] = {
	name = 'ԭ������ţ��',
  id = 'niurou',
  type = 'food',
  weight = 700,
  value = 190,
  consume_count = 2,
  food_supply = 50,
  source = {
    { type = 'get', location = '��������', },
  },
},

['����˿'] = {
	name = '����˿',
  id = 'kousansi',
  type = 'food',
  weight = 500,
  value = 80,
  consume_count = 1,
  food_supply = 45,
  source = {
    { type = 'get', location = '��������', },
  },
},

['��������'] = {
	name = '��������',
  id = 'fanqie yaoliu',
  alternate_id = { 'yaoliu' },
  type = 'food',
  weight = 500,
  value = 30,
  consume_count = 3,
  food_supply = 30,
},

['��������#SL'] = {
	name = '��������',
  id = 'mala doufu',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '����ɽի��', },
    { type = 'get', location = '����ɽ������ի��', },
  },
},

['Ԫ��#SL'] = {
	name = 'Ԫ��',
  id = 'yuanxiao',
  alternate_id = { 'yuan', 'xiao' },
  type = 'food',
  weight = 200,
  consume_count = 4,
  food_supply = 40,
},

['ܽ�ػ���#SL'] = {
	name = 'ܽ�ػ���',
  id = 'furong huagu',
  alternate_id = { 'huagu' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
},

['��֭��ź#SL'] = {
	name = '��֭��ź',
  id = 'mizhi tianou',
  alternate_id = { 'tianou' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '����ɽի��', },
    { type = 'get', location = '����ɽ������ի��', },
  },
},

['��������#EM'] = {
	name = '��������',
  id = 'liuli qiezi',
  alternate_id = { 'qiezi' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '����ɽի��', },
    { type = 'get', location = '����ɽ������ի��', },
  },
},

['��������#DL'] = {
	name = '��������',
  id = 'guoqiao mixian',
  alternate_id = { 'mixian' },
  type = 'food',
  weight = 80,
  value = 500,
  consume_count = 3,
  food_supply = 80,
  source = {
    { type = 'get', location = '�����ʹ����ŷ�', },
  },
},

['Ұ��#GM'] = {
	name = { 'Ұ��', '��÷' },
  id = 'ye guo',
  alternate_id = { 'guo' },
  type = 'food',
  weight = 25,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'cmd', cmd = 'cai guo', location = '����ɽ��԰', },
  },
},

--------------------------------------------------------------------------------
-- drinks

['��ˮ'] = {
	name = '��ˮ',
  id = 'water',
  type = 'drink',
  water_supply = 200,
  source = {
    { type = 'handler', handler = 'drink', location = '���޺�����Ȫ', },
    { type = 'handler', handler = 'drink', location = '���ݳǲ�¥', },
    { type = 'handler', handler = 'drink', location = '���ݳǲ�¥��¥', },
    { type = 'handler', handler = 'drink', location = '����������¥', },
    { type = 'handler', handler = 'drink', location = '�䵱ɽ��ͤ', },
    { type = 'handler', handler = 'drink', location = '������������ի��#E', },
    { type = 'handler', handler = 'drink', location = '���������ľ�', },
    { type = 'handler', handler = 'drink', location = '�����µ��ʮ�ŷ�#3', },
    { type = 'handler', handler = 'drink', location = '�����µ��ʮ�ŷ�#2', },
    { type = 'handler', handler = 'drink', location = '�����µ��ʮ�ŷ�#1', },
    { type = 'handler', handler = 'drink', location = '�һ�������#2', },
    { type = 'handler', handler = 'drink', location = '̩ɽ�׺�Ȫ', },
    { type = 'handler', handler = 'drink', location = '���ݳǺ���Ȫ', },
    { type = 'handler', handler = 'drink', location = '���ݳǲ��', },
    { type = 'handler', handler = 'drink', location = '��ɽ���ַ��ľ�', },
    { type = 'handler', handler = 'drink', location = '���������', },
    { type = 'handler', handler = 'drink', location = '��٢��ɽׯ��԰', },
    { type = 'handler', handler = 'drink', location = '����Ľ�ݳ���#D', },
    { type = 'handler', handler = 'drink', location = '���ݳ�Ӫ��ˮ', },
    { type = 'handler', handler = 'drink', location = '��ɽ��Ů��', },
    { type = 'handler', handler = 'drink', location = '��ɽ�ٲ�', },
    { type = 'handler', handler = 'drink', location = '��ľ�°���Ȫ', },
    { type = 'handler', handler = 'drink', location = '�ؽ�����', },
    { type = 'handler', handler = 'drink', location = '�ؽ���ʯΧ��', },
    { type = 'handler', handler = 'drink', location = '��ɽ����', },
    { type = 'handler', handler = 'drink', location = '����ɽ�ٲ�', },
    { type = 'handler', handler = 'drink', location = '�����ǲ��', },
    { type = 'handler', handler = 'drink', location = '���ݳ�СĹ��', },
    { type = 'handler', handler = 'drink', location = '���ݳǲ��', },
    { type = 'handler', handler = 'drink', location = '�ɶ��Ǻ�Ժ', },
    { type = 'handler', handler = 'drink', location = '�����ǲ��', },
    { type = 'handler', handler = 'drink', location = '���ݳ�����', },
    { type = 'handler', handler = 'drink', location = '����ɽ�յ�', },
  },
},

['˫����ˮ'] = {
	name = '˫����ˮ',
  id = 'double_water',
  type = 'drink',
  water_supply = 400,
  source = {
    { type = 'handler', handler = 'drink', location = '����ǿ�ջ', },
    { type = 'handler', handler = 'drink', location = '����ɳĮ����', },
    { type = 'handler', handler = 'drink', location = '�ؽ�������', },
    { type = 'handler', handler = 'drink', location = '����ɽ��԰', },
    { type = 'handler', handler = 'drink', location = '����ɽ������', },
    { type = 'handler', handler = 'drink', location = '����ɽ������', },
    { type = 'handler', handler = 'drink', location = '����ɽ�Ϻ���', },
    { type = 'handler', handler = 'drink', location = '����ɽ������', },
    { type = 'handler', handler = 'drink', location = '����ɽɽ��СϪ', },
  },
},

['��÷��'] = {
	name = '��÷��',
  id = 'suanmei tang',
  alternate_id = { 'tang' },
  type = 'drink',
  weight = 50,
  value = 10,
  consume_count = 3,
  water_supply = 30,
  source = {
    { type = 'get', location = '���̳���', },
    { type = 'get', location = '���̲���', },
    { type = 'get', location = '��ľ����ʳ��', },
  },
},

['���'] = {
	name = '���',
  id = 'xiang cha',
  alternate_id = { 'tea', 'cha', 'xiangcha' },
  type = 'drink',
  weight = 50,
  value = 10,
  consume_count = 2,
  water_supply = 25,
  source = {
    { type = 'get', location = '����ɽ����', },
    { type = 'get', location = '���ְ����', },
    { type = 'get', location = '�䵱ɽ����', },
    { type = 'get', location = '��Դ��ի��' },
    { type = 'get', location = '����Ľ��С��', },
    { type = 'get', location = '���������', },
    { type = 'get', location = '��٢��ɽׯ����', },
    { type = 'get', location = '�䵱ɽ��ͤ', },
  },
},

['����'] = {
	name = '����',
  id = 'ru lao',
  alternate_id = { 'cheese' },
  type = 'drink',
  weight = 700,
  value = 5000,
  consume_count = 1,
  food_supply = 200,
  water_supply = 200,
},

['���Ͳ�'] = {
	name = '���Ͳ�',
  id = 'suyou cha',
  alternate_id = { 'tea', 'cha' },
  type = 'drink',
  weight = 200,
  value = 80,
  consume_count = 3,
  food_supply = 10,
  water_supply = 10,
},

['���򻨲�'] = {
	name = '���򻨲�',
  id = 'moli huacha',
  alternate_id = { 'huacha', 'tea', 'cha' },
  type = 'drink',
  weight = 20,
  consume_count = 5,
  water_supply = 30,
  source = {
    { type = 'handler', handler = 'sit_and_wait', location = '�һ����跿', },
    { type = 'handler', handler = 'sit_and_wait', location = '����ׯ�跿', },
  },
},

['������#JQG'] = {
	name = '������',
  id = 'longjin cha',
  alternate_id = { 'lingjin', 'tea', 'cha' },
  type = 'drink',
  weight = 700,
  value = 1000,
  consume_count = 1,
  water_supply = 200,
},

--------------------------------------------------------------------------------
-- drink containers

['��ˮ��«'] = {
	name = '��ˮ��«',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '��ˮ',
    consume_count = 15,
    drunk_supply = 3,
  },
},

['��ˮ��«#2'] = {
	name = '��ˮ��«',
  id = 'qingshui hulu',
  alternate_id = { 'hulu', 'bottle' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 10,
  drink = {
    item = '��ˮ',
    consume_count = 10,
    drunk_supply = 10,
  },
  source = {
    { type = 'get', location = '��ɽ����', },
    { type = 'get', location = '����ɽի��', },
    { type = 'get', location = '����ɽ������ի��', },
  },
},

['ţƤ�ƴ�'] = {
	name = 'ţƤ�ƴ�',
  id = 'jiu dai',
  alternate_id = { 'jiudai', 'wineskin', 'dai' },
  type = 'drink_container',
  weight = 700,
  value = 20,
  capacity = 15,
  drink = {
    item = '�׾�',
    consume_count = 15,
    drunk_supply = 15,
  },
  source = {
    { type = 'get', location = '����������', },
  },
},

['����ƴ�'] = {
	name = '����ƴ�',
  id = 'huadiao jiudai',
  alternate_id = { 'jiu dai', 'huadiao', 'dai' },
  type = 'drink_container',
  weight = 700,
  value = 120,
  capacity = 20,
  drink = {
    item = '�����',
    consume_count = 20,
    drunk_supply = 6,
  },
},

['����ƴ�#DL'] = {
	name = '����ƴ�',
  id = 'jiudai',
  alternate_id = { 'skin', 'huadiao' },
  type = 'drink_container',
  weight = 700,
  value = 120,
  capacity = 20,
  drink = {
    item = '�����',
    consume_count = 20,
    drunk_supply = 6,
  },
},

['�ɲ���'] = {
	name = '�ɲ���',
  id = 'ci chawan',
  alternate_id = { 'chawan', 'ci' },
  type = 'drink_container',
  weight = 100,
  value = 100,
  capacity = 4,
  drink = {
    item = '��ˮ',
    consume_count = 4,
    drunk_supply = 0,
  },
},

['ˮ��#HS'] = {
	name = 'ˮ��',
  id = 'water bottle',
  alternate_id = { 'bottle' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 10,
  drink = {
    item = '��ˮ',
    consume_count = 10,
    drunk_supply = 5,
  },
},

['�վ�'] = {
	name = '�վ�',
  id = 'shao jiu',
  alternate_id = { 'shaojiu' },
  type = 'drink_container',
  weight = 700,
  value = 80,
  capacity = 15,
  drink = {
    item = '�����վ�',
    consume_count = 15,
    drunk_supply = 6,
  },
},

['���'] = {
	name = '���',
  id = 'cha hu',
  alternate_id = { 'hu' },
  type = 'drink_container',
  weight = 400,
  value = 80,
  capacity = 40,
  drink = {
    item = '��ˮ',
    consume_count = 40,
    drunk_supply = 0,
  },
},

['���«'] = {
	name = '���«',
  id = 'qing hulu',
  alternate_id = { 'hulu' },
  type = 'drink_container',
  weight = 400,
  value = 80,
  capacity = 60,
  drink = {
    item = '��Ȫˮ',
    consume_count = 60,
    drunk_supply = 0,
  },
  source = {
    { type = 'get', location = '���޺�����', },
    { type = 'get', location = '��ɽ����', },
  },
},

['�����'] = {
	name = '�����',
  id = 'jiunang',
  alternate_id = { 'wineskin', 'skin' },
  type = 'drink_container',
  weight = 700,
  value = 250,
  capacity = 400,
  drink = {
    item = '���̾�',
    consume_count = 10,
    drunk_supply = 40,
  },
},

['ˮ��'] = {
	name = 'ˮ��',
  id = 'shuinang',
  alternate_id = { 'wineskin', 'skin' },
  type = 'drink_container',
  weight = 500,
  value = 200,
  capacity = 300,
  drink = {
    item = '��ɽѩˮ',
    consume_count = 10,
    drunk_supply = 30,
  },
},

['���'] = {
	name = '���',
  id = 'zhuhu',
  alternate_id = { 'hu' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '��ˮ',
    consume_count = 15,
    drunk_supply = 15,
  },
},

['����#TLS'] = {
	name = '����',
  id = 'da wan',
  alternate_id = { 'wan', 'bowl' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = 'ˮ',
    consume_count = 15,
    drunk_supply = 3,
  },
  source = {
    { type = 'get', location = '�����³���', },
    { type = 'get', location = '������������ի��#W' },
    { type = 'get', location = '������������ի��#E' },
  },
},

['ϸ�ž�ƿ#DL'] = {
	name = 'ϸ�ž�ƿ',
  id = 'jiu ping',
  alternate_id = { 'jiu', 'ping' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '�׾�',
    consume_count = 15,
    drunk_supply = 3,
  },
  source = {
    { type = 'get', location = '����������������', },
  },
},

['�����'] = {
	name = '�����',
  id = 'dawan cha',
  alternate_id = { 'tea', 'cha' },
  type = 'drink',
  weight = 50,
  capacity = 0,
  drink = {
    item = '��ˮ',
    consume_count = 3,
    drunk_supply = 15,
  },
  source = {
    { type = 'get', location = '�䵱ɽ����', },
    { type = 'get', location = '��ݳ���', },
  },
},

--------------------------------------------------------------------------------
-- drugs

['��ҩ'] = {
	name = '��ҩ',
  id = 'jinchuang yao',
  alternate_id = { 'jin', 'jinchuang', 'yao' },
  type = 'drug',
  weight = 30,
  value = 3000,
  cure = { qi_max = 50 },
},

['������'] = {
	name = '������',
  id = 'yangjing dan',
  alternate_id = { 'dan' },
  type = 'drug',
  value = 100,
  delayed_effect = true,
  cure = { jing_max = 100 },
},

['�ٲݵ�'] = {
	name = '�ٲݵ�',
  id = 'baicao dan',
  alternate_id = { 'baicao', 'dan' },
  type = 'drug',
  weight = 200,
  value = 1500,
  cure = { qi = 90, qi_max = 90, jing = 90, jing_max = 90 },
},

['������'] = {
	name = '������',
  id = 'lianzi wan',
  alternate_id = { 'lianzi', 'wan' },
  type = 'drug',
  weight = 100,
  value = 5000,
  cure = { qi_max = 200 },
},

['������'] = {
	name = '������',
  id = 'zhengqi dan',
  alternate_id = { 'dan' },
  type = 'drug',
  weight = 100,
  value = 100,
  delayed_effect = true,
  cure = { jing_max = 100 },
},

['��Ԫɢ'] = {
	name = '��Ԫɢ',
  id = 'jinyuan san',
  alternate_id = { 'jinyuan', 'san' },
  type = 'drug',
  weight = 30,
  value = 5000,
  cure = { illness = true },
},

['����������'] = {
	name = '����������',
  id = 'wulong gao',
  alternate_id = { 'huiyang', 'wulong', 'gao' },
  type = 'drug',
  weight = 500,
  value = 3000,
  cure = { qi_max = 150 },
},

['�񶴺�ʯ��'] = {
	name = '�񶴺�ʯ��',
  id = 'heishi dan',
  alternate_id = { 'heishi', 'dan' },
  type = 'drug',
  value = 5000,
  cure = { hb_poison = true },
},

['���Ʊ�����'] = {
	name = '���Ʊ�����',
  id = 'baola wan',
  alternate_id = { 'sanhuang', 'baola', 'wan' },
  type = 'drug',
  weight = 20,
  value = 15000,
  cure = { qi_max = 300 },
},

['����ɢ'] = {
	name = '����ɢ',
  id = 'yuzhen san',
  alternate_id = { 'yuzhen', 'san' },
  type = 'drug',
  weight = 100,
  value = 5000,
  cure = { qi_max = 90 },
},

['��¶����ɢ'] = {
	name = '��¶����ɢ',
  id = 'qingxin san',
  alternate_id = { 'san' },
  type = 'drug',
  value = 10000,
  improve = { jingli_max = 1 },
  cond = 'player.enable.force and player.enable.force.skill == ["��Ԫ��"]',
},

['����ɢ'] = {
	name = '����ɢ',
  id = 'yuling san',
  alternate_id = { 'yuling', 'san' },
  type = 'drug',
  weight = 30,
  value = 20000,
  cure = { hot_poison = true },
},

--------------------------------------------------------------------------------
-- normal swords

['����'] = {
	name = '����',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
  source = {
    { type = 'get', location = '��������������', },
  },
},

['����#SWORD'] = {
	name = '����',
  id = 'changjian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
  source = {
    { type = 'get', location = '��Դ��������', },
  },
},

['����#SZ'] = {
	name = '����',
  id = 'changjian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 25,
},

['�ֽ�'] = {
	name = '�ֽ�',
  id = 'jian',
  alternate_id = { 'sword' },
  type = 'sword',
  weight = 6000,
  value = 2000,
  quality = 30,
},

['ľ��'] = {
	name = 'ľ��',
  id = 'mu jian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 300,
  value = 1270,
  quality = 5,
},

['��'] = {
	name = '��',
  id = 'zhu jian',
  alternate_id = { 'zhujian', 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 5,
},

['��#SZ'] = {
	name = '��',
  id = 'zhu jian',
  alternate_id = { 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 10,
},

['�廨��'] = {
	name = '�廨��',
  id = 'xiuhua zhen',
  alternate_id = { 'zhen', 'needle' },
  type = 'sword',
  weight = 500,
  value = 200,
  quality = 10,
},

--------------------------------------------------------------------------------
-- normal blades

['�ֵ�'] = {
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

['�ֵ�#SZ'] = {
	name = '�ֵ�',
  id = 'blade',
  type = 'blade',
  weight = 7000,
  value = 1000,
  quality = 20,
},

['�˵�#SZ'] = {
	name = '�˵�',
  id = 'cai dao',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 4000,
  value = 1500,
  quality = 15,
},

['�굶'] = {
	name = '�굶',
  id = 'ti dao',
  alternate_id = { 'dao', 'blade' },
  type = 'blade',
  weight = 100,
  value = 1000,
  quality = 2,
},

['����'] = {
	name = '����',
  id = 'ma dao',
  alternate_id = { 'dao', 'blade', 'madao' },
  type = 'blade',
  weight = 12000,
  value = 1500,
  quality = 20,
},

['�������䵶'] = {
	name = '�������䵶',
  id = 'wandao',
  type = 'blade',
  weight = 6000,
  value = 1500,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal hammers

['����#SZ'] = {
	name = '����',
  id = 'tie chui',
  alternate_id = { 'chui' },
  type = 'hammer',
  weight = 7000,
  value = 1500,
  quality = 30,
},

['���Ǵ�'] = {
	name = '���Ǵ�',
  id = 'liuxing chui',
  alternate_id = { 'chui', 'hammer' },
  type = 'hammer',
  weight = 10000,
  value = 1000,
  quality = 36,
},

['��ʯ��'] = {
	name = '��ʯ��',
  id = 'qingshi chui',
  alternate_id = { 'chui', 'hammer' },
  type = 'hammer',
  weight = 1200,
  value = 130,
  quality = 24,
},

--------------------------------------------------------------------------------
-- normal clubs

['����'] = {
	name = '����',
  id = 'tiegun',
  alternate_id = { 'gun' },
  type = 'club',
  weight = 5000,
  value = 100,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal daggers

['ذ��#SZ'] = {
	name = 'ذ��',
  id = 'bi shou',
  alternate_id = { 'shou' },
  type = 'dagger',
  weight = 4000,
  value = 1000,
  quality = 10,
},

['����ذ'] = {
	name = '����ذ',
  id = 'danren bi',
  alternate_id = { 'bi', 'dagger' },
  type = 'dagger',
  weight = 600,
  value = 120,
  quality = 15,
},

['��ɱذ��'] = {
	name = '��ɱذ��',
  id = 'ansha bishou',
  alternate_id = { 'bishou', 'dagger' },
  type = 'dagger',
  weight = 500,
  value = 1000,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal flutes

['����'] = {
	name = '����',
  id = 'yu xiao',
  alternate_id = { 'xiao' },
  type = 'flute',
  weight = 250,
  value = 2000,
  quality = 25,
},

['��'] = {
	name = '��',
  id = 'xiao',
  type = 'flute',
  weight = 150,
  value = 600,
  quality = 15,
},

--------------------------------------------------------------------------------
-- normal sticks

['���'] = {
	name = '���',
  id = 'zhu bang',
  alternate_id = { 'zhubang', 'bang' },
  type = 'stick',
  weight = 1500,
  value = 200,
  quality = 20,
},

['���#STICK'] = {
	name = '���',
  id = 'zhubang',
  type = 'stick',
  weight = 5000,
  value = 200,
  quality = 20,
},

['���#SZ'] = {
	name = '���',
  id = 'zhubang',
  type = 'stick',
  weight = 3000,
  value = 200,
  quality = 25,
},

--------------------------------------------------------------------------------
-- normal whips

['�ٽ���'] = {
	name = '�ٽ���',
  id = 'baijie lian',
  alternate_id = { 'lian', 'whip' },
  type = 'whip',
  weight = 900,
  value = 140,
  quality = 26,
},

['����'] = {
	name = '����',
  id = 'changbian',
  alternate_id = { 'bian' },
  type = 'whip',
  weight = 5000,
  value = 100,
  quality = 20,
},

['����'] = {
	name = '����',
  id = 'mabian',
  alternate_id = { 'bian' },
  type = 'whip',
  weight = 500,
  value = 300,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal hooks

['����'] = {
	name = '����',
  id = 'hook',
  alternate_id = { 'gou' },
  type = 'hook',
  weight = 5000,
  value = 4000,
  quality = 30,
},

--------------------------------------------------------------------------------
-- normal staffs

['������'] = {
	name = '������',
  id = 'siming chan',
  alternate_id = { 'chan', 'staff' },
  type = 'staff',
  weight = 4000,
  value = 3500,
  quality = 65,
},

['����'] = {
	name = '����',
  id = 'gangzhang',
  type = 'staff',
  weight = 5000,
  value = 1000,
  quality = 25,
},

--------------------------------------------------------------------------------
-- normal axes

['ӥ�츫'] = {
	name = 'ӥ�츫',
  id = 'yingzui fu',
  alternate_id = { 'fu', 'axe' },
  type = 'axe',
  weight = 1100,
  value = 130,
  quality = 28,
},

['�ָ�'] = {
	name = '�ָ�',
  id = 'gang fu',
  alternate_id = { 'fu', 'axe' },
  type = 'axe',
  weight = 40000,
  value = 2000,
  quality = 30,
},

--------------------------------------------------------------------------------
-- treasure axes

['������'] = {
	name = '������',
  id = 'jinlong duo',
  alternate_id = { 'duo', 'axe' },
  type = 'axe',
  weight = 20000,
  quality = 130,
  vanish_on_drop = true,
  cond = 'player.neili_max >= 1500 and player.str >= 30',
  source = {
    { type = 'handler', handler = 'ty_jia', location = '��Դ��������', is_once_per_session = true, },
  },
},

--------------------------------------------------------------------------------
-- treasure brushes

['���Ʊ�'] = {
	name = '���Ʊ�',
  id = 'huoyun bi',
  alternate_id = { 'bi', 'brush' },
  type = 'brush',
  weight = 15000,
  quality = 120,
  vanish_on_drop = true,
  cond = 'player.neili_max >= 1000 and player.str >= 30',
  source = {
    { type = 'handler', handler = 'ty_jia', location = '��Դ��������', is_once_per_session = true, },
  },
},

--------------------------------------------------------------------------------
-- normal armor

['����'] = {
	name = '����',
  id = 'tie jia',
  alternate_id = { 'tiejia', 'armor', 'jia' },
  type = 'cloth',
  weight = 20000,
  value = 2000,
  quality = 50,
},

['��令��'] = {
	name = '��令��',
  id = 'feicui huwan',
  alternate_id = { 'huwan' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['̴ľ����'] = {
	name = '̴ľ����',
  id = 'tanmu huxiong',
  alternate_id = { 'huxiong' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['���ﻤ��'] = {
	name = '���ﻤ��',
  id = 'danfeng huyao',
  alternate_id = { 'huyao' },
  type = 'waist',
  weight = 500,
  quality = 4,
},

['����̤����'] = {
	name = '����̤����',
  id = 'qilin suo',
  alternate_id = { 'suo' },
  type = 'neck',
  weight = 600,
  value = 3000,
  quality = 5,
},

['��������'] = {
	name = '��������',
  id = 'jinhu pifeng',
  alternate_id = { 'pifeng' },
  type = 'mantle',
  weight = 300,
  value = 300,
  quality = 10,
  attr = { dodge = 2 },
},

--------------------------------------------------------------------------------
-- treasure armor

['ľ������'] = {
	name = 'ľ������',
  id = 'mumian jiasha',
  alternate_id = { 'mimian', 'jiasha' },
  type = 'cloth',
  weight = 5000,
  quality = 150,
  vanish_on_drop = true,
},

--------------------------------------------------------------------------------
-- books

['���ᱸ����'] = {
	name = '���ᱸ����',
  id = 'ji fang',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 2500,
  read = { exp_required = 5000, cost = { jing = 20 }, difficulty = 22, },
  skill = { name = '��������', min = 0, max = 31 },
},

['Ԣ���'] = {
	name = 'Ԣ���',
  id = 'yuyi cao',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 5000,
  read = { exp_required = 6000, cost = { jing = 25 }, difficulty = 23, },
  skill = { name = '��������', min = 30, max = 41 },
},

['����ʶ��'] = {
	name = '����ʶ��',
  id = 'sangang shilue',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 6000,
  read = { exp_required = 10000, cost = { jing = 30 }, difficulty = 24, },
  skill = { name = '��������', min = 40, max = 51 },
},

['�ƽ𾵸�����'] = {
	name = '�ƽ𾵸�����',
  id = 'kejin jijie',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 2500,
  read = { exp_required = 150000, cost = { jing = 35 }, difficulty = 25, },
  skill = { name = '��������', min = 50, max = 61 },
  source = {
    { type = 'handler', handler = 'mbook_kejin', },
  },
},

['�����'] = {
	name = '�����',
  id = 'douzhen dinglun',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 3000,
  read = { exp_required = 200000, cost = { jing = 40 }, difficulty = 26, },
  skill = { name = '��������', min = 60, max = 71 },
},

['����ϡ����'] = {
	name = '����ϡ����',
  id = 'boji xidoufang',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 8000,
  read = { exp_required = 200000, cost = { jing = 45 }, difficulty = 27, },
  skill = { name = '��������', min = 70, max = 81 },
},

['���ݸ�Ŀ'] = {
	name = '���ݸ�Ŀ',
  id = 'bencao gangmu',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 300000,
  read = { exp_required = 100000, cost = { jing = 50 }, difficulty = 29, },
  skill = { name = '��������', min = 80, max = 101 },
},

['���ݾ���ע'] = {
	name = '���ݾ���ע',
  id = 'bencao jizhu',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 200000,
  read = { exp_required = 150000, cost = { jing = 60 }, difficulty = 30, },
  skill = { name = '��������', min = 100, max = 121 },
},

--------------------------------------------------------------------------------
-- misc

['������'] = {
	name = '������',
  id = 'cu shengzi',
  value = 1000,
},

['����'] = {
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
	name = 'ҩ��',
  id = 'yao chu',
  alternate_id = { 'chu' },
  desc = '����һ����ͨ��ҩ�õĳ�ͷ��',
  weight = 500,
  source = {
    { type = 'cmd', cmd = 'find yao chu', location = '�䵱ɽ�䵱�㳡', cond = 'player.party == "�䵱��"', is_once_per_session = true, }
  },
},

['����'] = {
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
	name = '����ʯ',
  id = 'lianxin shi',
  alternate_id = { 'lianxin', 'shi' },
  weight = 4000,
  source = {
    { type = 'get', location = '�䵱��ɽ�ŵ�#3', },
  },
},

['С��֦'] = {
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
	name = 'ͨ������',
  id = 'ling pai',
  weight = 20,
  source = {
    { type = 'cmd', cmd = 'ask lu gaoxuan about ͨ������', location = '������½������', npc = '½����', cond = 'player.party == "������"', },
    { type = 'handler', handler = 'sld_lingpai', location = '������½������', npc = '½����', cond = 'player.party ~= "������"', },
  },
  vanish_on_drop = true,
},

['������'] = {
	name = '������',
  id = 'jin wawa',
  alternate_id = { 'jin', 'wawa', 'yu' },
  weight = 3000,
  source = {
    { type = 'handler', handler = 'ty_fish', location = '��Դ���ٲ���', },
  },
},

['����'] = {
	name = '����',
  id = 'tie zhou',
  alternate_id = { 'zhou', 'boat' },
  weight = 10000,
  source = {
    { type = 'handler', handler = 'ty_boat', location = '��Դ��ɽ���ٲ�', },
  },
},

['����'] = {
	name = '����',
  id = 'teng',
  alternate_id = { 'shuteng' },
  weight = 1000,
  source = {
    { type = 'handler', handler = 'hs_shuteng', location = '��ɽ�ڶ�', },
  },
},

['�ٿ�'] = {
	name = '�ٿ�',
  id = 'teng kuang',
  alternate_id = { 'kuang', 'tengkuang' },
  weight = 500,
  source = {
    { type = 'handler', handler = 'hs_kuang', location = '��ɽ�ڶ�', },
  },
},

['��Կ��'] = {
	name = '��Կ��',
  id = 'hei yaoshi',
  alternate_id = { 'yaoshi', 'key' },
  weight = 1000,
  source = {
    { type = 'handler', handler = 'hmy_key', location = '��ľ���鷿', },
  },
},

['����'] = {
	name = '����',
  id = 'tie qiao',
  alternate_id = { 'qiao' },
  weight = 1500,
  value = 2000,
},

['���'] = {
	name = '���',
  id = 'liu huang',
  alternate_id = { 'liuhuang' },
  weight = 80,
  value = 99,
},

['̳��'] = {
	name = '̳��',
  id = 'tan zi',
  alternate_id = { 'tanzi' },
  weight = 1000,
  value = 499,
},

['����ƪ'] = {
	name = '����ƪ',
  id = 'tianshen pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['����ƪ'] = {
	name = '����ƪ',
  id = 'longshen pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['ҹ��ƪ'] = {
	name = 'ҹ��ƪ',
  id = 'yecha pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['Ǭ����ƪ'] = {
	name = 'Ǭ����ƪ',
  id = 'qiandapo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['������ƪ'] = {
	name = '������ƪ',
  id = 'axiuluo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['��¥��ƪ'] = {
	name = '��¥��ƪ',
  id = 'jialouluo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['������ƪ'] = {
	name = '������ƪ',
  id = 'jinnaluo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

['Ħ������ƪ'] = {
	name = 'Ħ������ƪ',
  id = 'mohuluojia pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'handler', handler = 'tlbb_book', location = '�����ʹ��鷿', },
  },
},

}

return item
