local item = {

--------------------------------------------------------------------------------
-- money

['铜钱'] = {
  iname = '铜钱',
	name = '铜钱',
  id = 'coin',
  type = 'money',
},

['白银'] = {
  iname = '白银',
	name = '白银',
  id = 'silver',
  type = 'money',
},

['黄金'] = {
  iname = '黄金',
	name = '黄金',
  id = 'gold',
  type = 'money',
},

--------------------------------------------------------------------------------
-- food

['面汤'] = {
  iname = '面汤',
	name = '面汤',
  id = 'miantang',
  type = 'food',
  weight = 100,
  value = 50,
  consume_count = 1,
  food_supply = 30,
  source = {
    { type = 'get', location = '蝴蝶谷厨房', },
  },
},

['馒头'] = {
  iname = '馒头',
	name = '馒头',
  id = 'man tou',
  alternate_id = { 'mantou', 'tou' },
  type = 'food',
  weight = 50,
  value = 40,
  consume_count = 2,
  food_supply = 40,
  source = {
    { type = 'get', location = '扬州城小墓室', cond = 'player.party == "丐帮"', },
    { type = 'get', location = '成都城后院', cond = 'player.party == "丐帮"', },
    { type = 'get', location = '沧州城厅堂', cond = 'player.party == "丐帮"', },
  },
},

['月饼'] = {
  iname = '月饼',
	name = '月饼',
  id = 'yue bing',
  alternate_id = { 'yuebing', 'bing' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['五香花生'] = {
  iname = '五香花生',
	name = '五香花生',
  id = 'huasheng',
  alternate_id = { 'peanut' },
  type = 'food',
  weight = 60,
  value = 20,
  consume_count = 1,
  food_supply = 30,
},

['五香花生#YZ'] = {
  iname = '五香花生#YZ',
	name = '五香花生',
  id = 'huasheng',
  alternate_id = { 'peanut' },
  type = 'food',
  weight = 60,
  value = 30,
  consume_count = 1,
  food_supply = 30,
},

['翡翠豆腐'] = {
  iname = '翡翠豆腐',
	name = '翡翠豆腐',
  id = 'doufu',
  alternate_id = { 'tofu' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 1,
  food_supply = 50,
},

['翡翠豆腐#DL'] = {
  iname = '翡翠豆腐#DL',
	name = '翡翠豆腐',
  id = 'feicui doufu',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 40,
  value = 100,
  consume_count = 2,
  food_supply = 50,
},

['板豆腐'] = {
  iname = '板豆腐',
	name = '板豆腐',
  id = 'ban doufu',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 40,
  value = 70,
  consume_count = 1,
  food_supply = 80,
},

['豆腐干'] = {
  iname = '豆腐干',
	name = '豆腐干',
  id = 'doufu gan',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 1,
  food_supply = 50,
},

['烤鸡腿'] = {
  iname = '烤鸡腿',
	name = '烤鸡腿',
  id = 'ji tui',
  alternate_id = { 'jitui', 'tui' },
  type = 'food',
  weight = 350,
  value = 30,
  consume_count = 4,
  food_supply = 40,
},

['烤鸭'] = {
  iname = '烤鸭',
	name = '烤鸭',
  id = 'kao ya',
  alternate_id = { 'kaoya', 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
  source = {
    { type = 'get', location = '昆仑山厨房', },
  },
},

['烤鸭#DL'] = {
  iname = '烤鸭#DL',
	name = '烤鸭',
  id = 'kaoya',
  alternate_id = { 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['包子'] = {
  iname = '包子',
	name = '包子',
  id = 'bao zi',
  alternate_id = { 'baozi', 'dumpling' },
  type = 'food',
  weight = 80,
  value = 30,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '神龙岛厨房', },
  },
},

['包子#HZ'] = {
  iname = '包子#HZ',
	name = '包子',
  id = 'baozi',
  alternate_id = { 'dumpling' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
},

['粽子'] = {
  iname = '粽子',
	name = '粽子',
  id = 'zong zi',
  alternate_id = { 'zongzi', 'zong' },
  type = 'food',
  weight = 150,
  value = 100,
  consume_count = 3,
  food_supply = 30,
  source = {
    { type = 'get', location = '明教厨房', },
    { type = 'get', location = '黑木崖膳食房', },
  },
},

['粽子#FZ'] = {
  iname = '粽子#FZ',
	name = '粽子',
  id = 'zongzi',
  type = 'food',
  weight = 100,
  value = 100,
  consume_count = 3,
  food_supply = 50,
},

['狗不理包子'] = {
  iname = '狗不理包子',
	name = '狗不理包子',
  id = 'goubuli baozi',
  alternate_id = { 'baozi' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['东山羊'] = {
  iname = '东山羊',
	name = '东山羊',
  id = 'dong shanyang',
  alternate_id = { 'dong', 'shanyang' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['龙抄手'] = {
  iname = '龙抄手',
	name = '龙抄手',
  id = 'long chaoshou',
  alternate_id = { 'chaoshou' },
  type = 'food',
  weight = 200,
  value = 200,
  consume_count = 3,
  food_supply = 30,
},

['羊肉泡馍'] = {
  iname = '羊肉泡馍',
	name = '羊肉泡馍',
  id = 'yangrou paomo',
  alternate_id = { 'paomo' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 50,
},

['山鸡肉'] = {
  iname = '山鸡肉',
	name = '山鸡肉',
  id = 'shanji rou',
  alternate_id = { 'rou' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['酥油茶'] = {
  iname = '酥油茶',
	name = '酥油茶',
  id = 'suyou cha',
  alternate_id = { 'tea', 'cha' },
  type = 'food',
  weight = 200,
  value = 80,
  consume_count = 3,
  food_supply = 10,
  water_supply = 10,
},

['水蜜桃'] = {
  iname = '水蜜桃',
	name = '水蜜桃',
  id = 'mi tao',
  alternate_id = { 'mitao', 'tao' },
  type = 'food',
  weight = 40,
  value = 1,
  consume_count = 4,
  food_supply = 30,
  source = {
    { type = 'get', location = '武当山茶亭', },
  },
},

['水蜜桃#1'] = {
  iname = '水蜜桃#1',
	name = '水蜜桃',
  id = 'tao',
  alternate_id = { 'mi tao' },
  type = 'food',
  weight = 40,
  value = 80,
  consume_count = 4,
  food_supply = 30,
  source = {
    { type = 'get', location = '燕子坞内堂', },
  },
},

['水蜜桃#F'] = {
  iname = '水蜜桃#F',
	name = '水蜜桃',
  id = 'shuimi tao',
  alternate_id = { 'shuimitao', 'tao' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['菱白虾仁'] = {
  iname = '菱白虾仁',
	name = '菱白虾仁',
  id = 'lingbai xiaren',
  alternate_id = { 'xiaren' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '姑苏慕容厨房#1', },
  },
},

['樱桃火腿'] = {
  iname = '樱桃火腿',
	name = '樱桃火腿',
  id = 'yingtao huotui',
  alternate_id = { 'huotui' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '姑苏慕容厨房#1', },
  },
},

['菏叶冬笋汤'] = {
  iname = '菏叶冬笋汤',
	name = '菏叶冬笋汤',
  id = 'dongsun-tang',
  alternate_id = { 'tang' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '姑苏慕容厨房#1', },
  },
},

['烧饼'] = {
  iname = '烧饼',
	name = '烧饼',
  id = 'shao bing',
  alternate_id = { 'bing' },
  type = 'food',
  weight = 100,
  value = 200,
  consume_count = 3,
  food_supply = 35,
},

['油条'] = {
  iname = '油条',
	name = '油条',
  id = 'you tiao',
  alternate_id = { 'youtiao' },
  type = 'food',
  weight = 100,
  value = 180,
  consume_count = 4,
  food_supply = 28,
},

['麻花辫子'] = {
  iname = '麻花辫子',
	name = '麻花辫子',
  id = 'mahua bianzi',
  alternate_id = { 'mahua', 'bianzi' },
  type = 'food',
  weight = 100,
  value = 120,
  consume_count = 4,
  food_supply = 22,
},

['素煎饺'] = {
  iname = '素煎饺',
	name = '素煎饺',
  id = 'jian jiao',
  alternate_id = { 'jiao', 'dumpling' },
  type = 'food',
  weight = 100,
  value = 200,
  consume_count = 5,
  food_supply = 35,
},

['臭鸭蛋'] = {
  iname = '臭鸭蛋',
	name = '臭鸭蛋',
  id = 'chou yadan',
  alternate_id = { 'yadan', 'egg' },
  type = 'food',
  weight = 70,
  value = 80,
  consume_count = 1,
  food_supply = 80,
},

['大王肉饼'] = {
  iname = '大王肉饼',
	name = '大王肉饼',
  id = 'rou bing',
  alternate_id = { 'roubing' },
  type = 'food',
  weight = 300,
  value = 200,
  consume_count = 3,
  food_supply = 40,
},

['苹果'] = {
  iname = '苹果',
	name = '苹果',
  id = 'ping guo',
  alternate_id = { 'pingguo', 'guo' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['白梨'] = {
  iname = '白梨',
	name = '白梨',
  id = 'bai li',
  alternate_id = { 'baili', 'li' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['芒果'] = {
  iname = '芒果',
	name = '芒果',
  id = 'mang guo',
  alternate_id = { 'mangguo', 'guo' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['荔枝'] = {
  iname = '荔枝',
	name = '荔枝',
  id = 'li zhi',
  alternate_id = { 'lizhi' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['哈蜜瓜'] = {
  iname = '哈蜜瓜',
	name = '哈蜜瓜',
  id = 'hami gua',
  alternate_id = { 'hamigua', 'gua' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['桔子'] = {
  iname = '桔子',
	name = '桔子',
  id = 'ju zi',
  alternate_id = { 'juzi' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
},

['羊肉串'] = {
  iname = '羊肉串',
	name = '羊肉串',
  id = 'yangrou chuan',
  alternate_id = { 'yangrou', 'chuan' },
  type = 'food',
  weight = 300,
  value = 200,
  consume_count = 3,
  food_supply = 50,
},

['馕'] = {
  iname = '馕',
	name = '馕',
  id = 'nang',
  alternate_id = { 'cake' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
},

['哈密瓜'] = {
  iname = '哈密瓜',
	name = '哈密瓜',
  id = 'hami gua',
  alternate_id = { 'hamigua', 'gua' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 2,
  food_supply = 25,
  source = {
    { type = 'get', location = '回疆坎儿井' },
  },
},

['哈密瓜#XX'] = {
  iname = '哈密瓜#XX',
	name = '哈密瓜',
  id = 'hamigua',
  alternate_id = { 'gua', 'melon' },
  type = 'food',
  weight = 40,
  value = 40,
  consume_count = 1,
  food_supply = 50,
},

['米饭'] = {
  iname = '米饭',
	name = '米饭',
  id = 'mi fan',
  alternate_id = { 'rice', 'fan' },
  type = 'food',
  weight = 50,
  consume_count = 5,
  food_supply = 40,
  source = {
    { type = 'get', location = '昆仑山厨房' },
    { type = 'get', location = '天山厨房' },
    { type = 'get', location = '长乐帮厨房' },
    { type = 'get', location = '武当山厨房' },
    { type = 'get', location = '桃源县斋堂' },
    { type = 'get', location = '蝴蝶谷厨房', },
    { type = 'get', location = '归云庄厨房', },
    { type = 'get', location = '桃花岛厨房#2', },
    { type = 'get', location = '桃花岛厨房#1', },
    { type = 'get', location = '武馆厨房', },
  },
},

['米饭#TLS'] = {
  iname = '米饭#TLS',
	name = '米饭',
  id = 'rice',
  alternate_id = { 'mi fan', 'fan' },
  type = 'food',
  weight = 50,
  value = 120,
  consume_count = 5,
  food_supply = 40,
  source = {
    { type = 'get', location = '天龙寺厨房' },
    { type = 'get', location = '天龙寺天龙寺斋堂#W' },
    { type = 'get', location = '天龙寺天龙寺斋堂#E' },
  },
},

['青菜'] = {
  iname = '青菜',
	name = '青菜',
  id = 'qingcai',
  type = 'food',
  weight = 100,
  value = 50,
  consume_count = 1,
  food_supply = 20,
  source = {
    { type = 'get', location = '蝴蝶谷厨房', },
  },
},

['青菜#TLS'] = {
  iname = '青菜#TLS',
	name = '青菜',
  id = 'qing cai',
  alternate_id = { 'cai' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
  source = {
    { type = 'get', location = '天龙寺天龙寺斋堂#W' },
    { type = 'get', location = '天龙寺天龙寺斋堂#E' },
  },
},

['各类菜肴'] = {
  iname = '各类菜肴',
	name = { '麻辣肚丝', '松仁玉米', '梅菜扣肉', '五香腊肠', '鱼香肉丝', '红油鸡片', '清炒虾仁', '五花焖肉', '青丝熏鱼', '糖醋排骨', '京酱肉丝', '油炝大虾', '脆皮烤鸭', '红烧素鹅', '宫保鸡丁', '红油肺片', '嫩汆猪肝', '走油脆肠', '爆炒腰花', '麝香冬笋', '翡翠豆腐', '麻婆豆腐', '三鲜腐竹', '番茄腰柳', '抓炒里脊', '片皮乳猪', '锅巴肉片', '梁溪脆鳝', '干煸尤鱼', '重庆火锅', '碧螺春卷', },
  id = 'cai yao',
  alternate_id = { 'cai' },
  type = 'food',
  weight = 100,
  value = 200,
  consume_count = 5,
  food_supply = 35,
  source = {
    { type = 'get', location = '星宿海厨房' },
  },
},

['麻婆豆腐'] = {
  iname = '麻婆豆腐',
	name = '麻婆豆腐',
  id = 'doufu',
  type = 'food',
  weight = 200,
  value = 60,
  consume_count = 3,
  food_supply = 50,
  source = {
    { type = 'get', location = '武当山厨房' },
  },
},

['炸山鸡#DL'] = {
  iname = '炸山鸡#DL',
	name = '炸山鸡',
  id = 'zha shanji',
  alternate_id = { 'shanji', 'ji' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
  source = {
    { type = 'get', location = '大理王府王府厨房' },
  },
},

['大米饭#TZ'] = {
  iname = '大米饭#TZ',
	name = '大米饭',
  id = 'mi fan',
  alternate_id = { 'fan' },
  type = 'food',
  weight = 500,
  value = 30,
  consume_count = 3,
  food_supply = 30,
  source = {
    { type = 'get', location = '萧府厨房', },
  },
},

['大米饭#THD'] = {
  iname = '大米饭#THD',
	name = '大米饭',
  id = 'dami fan',
  alternate_id = { 'mifan', 'fan' },
  type = 'food',
  weight = 40,
  consume_count = 5,
  food_supply = 40,
  source = {
    { type = 'local_handler', handler = 'sit_and_wait', location = '桃花岛饭厅#1', cond = '( time.get_current_hour() >= 6 and time.get_current_hour() <= 8 ) or ( time.get_current_hour() >= 11 and time.get_current_hour() <= 13 ) or ( time.get_current_hour() >= 17 and time.get_current_hour() <= 20 )', },
    { type = 'local_handler', handler = 'sit_and_wait', location = '归云庄饭厅', cond = '( time.get_current_hour() >= 6 and time.get_current_hour() <= 8 ) or ( time.get_current_hour() >= 11 and time.get_current_hour() <= 13 ) or ( time.get_current_hour() >= 17 and time.get_current_hour() <= 20 )', },
  },
},

['片皮乳猪#TZ'] = {
  iname = '片皮乳猪#TZ',
	name = '片皮乳猪',
  id = 'ruzhu',
  type = 'food',
  weight = 700,
  value = 300,
  consume_count = 5,
  food_supply = 50, -- is actually 100
},

['红烧牛肉#TZ'] = {
  iname = '红烧牛肉#TZ',
	name = '红烧牛肉',
  id = 'hongshao niurou',
  alternate_id = { 'niurou' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 3,
  food_supply = 60,
},

['龙井菜叶鸡'] = {
  iname = '龙井菜叶鸡',
	name = '龙井菜叶鸡',
  id = 'longjing caiyeji',
  alternate_id = { 'ji' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '曼佗罗山庄厨房', },
    { type = 'get', location = '姑苏慕容厨房#D', },
    { type = 'get', location = '燕子坞厨房', },
  },
},

['翡翠鱼圆'] = {
  iname = '翡翠鱼圆',
	name = '翡翠鱼圆',
  id = 'feicui yuyuan',
  alternate_id = { 'yuyuan' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '曼佗罗山庄厨房', },
    { type = 'get', location = '姑苏慕容厨房#D', },
    { type = 'get', location = '燕子坞厨房', },
  },
},

['梅花糟鸭'] = {
  iname = '梅花糟鸭',
	name = '梅花糟鸭',
  id = 'meihua zaoya',
  alternate_id = { 'ya' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '曼佗罗山庄厨房', },
    { type = 'get', location = '姑苏慕容厨房#D', },
    { type = 'get', location = '燕子坞厨房', },
  },
},

['葡萄'] = {
  iname = '葡萄',
	name = '葡萄',
  id = 'pu tao',
  alternate_id = { 'putao' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '曼佗罗山庄客厅', },
  },
},

['桂圆'] = {
  iname = '桂圆',
	name = '桂圆',
  id = 'gui yuan',
  alternate_id = { 'guiyuan' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '曼佗罗山庄客厅', },
  },
},

['荔枝'] = {
  iname = '荔枝',
	name = '荔枝',
  id = 'li zhi',
  alternate_id = { 'lizhi' },
  type = 'food',
  weight = 80,
  value = 50,
  consume_count = 3,
  food_supply = 20,
  source = {
    { type = 'get', location = '燕子坞内堂', },
  },
},

['小笼包#GYZ'] = {
  iname = '小笼包#GYZ',
	name = '小笼包',
  id = 'baozi',
  type = 'food',
  weight = 30,
  consume_count = 5,
  food_supply = 30,
  source = {
    { type = 'get', location = '归云庄厨房', },
    { type = 'get', location = '桃花岛厨房#1', },
  },
},

['猪肉#GYZ'] = {
  iname = '猪肉#GYZ',
	name = '猪肉',
  id = 'rou',
  alternate_id = { 'meat' },
  type = 'food',
  weight = 30,
  consume_count = 4,
  food_supply = 25,
  source = {
    { type = 'get', location = '归云庄厨房', },
  },
},

['猪肉#THD'] = {
  iname = '猪肉#THD',
	name = '猪肉',
  id = 'rou',
  alternate_id = { 'meat' },
  type = 'food',
  weight = 60,
  value = 40,
  consume_count = 2,
  food_supply = 25,
  source = {
    { type = 'get', location = '桃花岛厨房#2', },
    { type = 'get', location = '桃花岛厨房#1', },
  },
},

['抓炒里脊'] = {
  iname = '抓炒里脊',
	name = '抓炒里脊',
  id = 'zhuachao liji',
  alternate_id = { 'liji' },
  type = 'food',
  weight = 400,
  value = 100,
  consume_count = 1,
  food_supply = 50,
},

['梁溪脆鳝'] = {
  iname = '梁溪脆鳝',
	name = '梁溪脆鳝',
  id = 'liangxi cuishan',
  alternate_id = { 'cuishan' },
  type = 'food',
  weight = 500,
  value = 200,
  consume_count = 2,
  food_supply = 35,
},

['鸡豆花'] = {
  iname = '鸡豆花',
	name = '鸡豆花',
  id = 'douhua',
  type = 'food',
  weight = 200,
  value = 120,
  consume_count = 1,
  food_supply = 30,
},

['锅巴肉片'] = {
  iname = '锅巴肉片',
	name = '锅巴肉片',
  id = 'rou pian',
  alternate_id = { 'rou' },
  type = 'food',
  weight = 200,
  value = 120,
  consume_count = 3,
  food_supply = 50,
},

['糖醋鲤鱼'] = {
  iname = '糖醋鲤鱼',
	name = '糖醋鲤鱼',
  id = 'tangcu liyu',
  alternate_id = { 'liyu' },
  type = 'food',
  weight = 200,
  value = 250,
  consume_count = 3,
  food_supply = 30,
  source = {
    { type = 'get', location = '萧府厨房', },
  },
},

['原笼粉蒸牛肉'] = {
  iname = '原笼粉蒸牛肉',
	name = '原笼粉蒸牛肉',
  id = 'niurou',
  type = 'food',
  weight = 700,
  value = 190,
  consume_count = 2,
  food_supply = 50,
  source = {
    { type = 'get', location = '萧府厨房', },
  },
},

['扣三丝'] = {
  iname = '扣三丝',
	name = '扣三丝',
  id = 'kousansi',
  type = 'food',
  weight = 500,
  value = 80,
  consume_count = 1,
  food_supply = 45,
  source = {
    { type = 'get', location = '萧府厨房', },
  },
},

['番茄腰柳'] = {
  iname = '番茄腰柳',
	name = '番茄腰柳',
  id = 'fanqie yaoliu',
  alternate_id = { 'yaoliu' },
  type = 'food',
  weight = 500,
  value = 30,
  consume_count = 3,
  food_supply = 30,
},

['麻辣豆腐#SL'] = {
  iname = '麻辣豆腐#SL',
	name = '麻辣豆腐',
  id = 'mala doufu',
  alternate_id = { 'doufu' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '峨嵋山斋堂', },
    { type = 'get', location = '峨嵋山福寿庵斋堂', },
  },
},

['元宵#SL'] = {
  iname = '元宵#SL',
	name = '元宵',
  id = 'yuanxiao',
  alternate_id = { 'yuan', 'xiao' },
  type = 'food',
  weight = 200,
  consume_count = 4,
  food_supply = 40,
},

['芙蓉花菇#SL'] = {
  iname = '芙蓉花菇#SL',
	name = '芙蓉花菇',
  id = 'furong huagu',
  alternate_id = { 'huagu' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
},

['密汁甜藕#SL'] = {
  iname = '密汁甜藕#SL',
	name = '密汁甜藕',
  id = 'mizhi tianou',
  alternate_id = { 'tianou' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '峨嵋山斋堂', },
    { type = 'get', location = '峨嵋山福寿庵斋堂', },
  },
},

['琉璃茄子#EM'] = {
  iname = '琉璃茄子#EM',
	name = '琉璃茄子',
  id = 'liuli qiezi',
  alternate_id = { 'qiezi' },
  type = 'food',
  weight = 200,
  value = 150,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'get', location = '峨嵋山斋堂', },
    { type = 'get', location = '峨嵋山福寿庵斋堂', },
  },
},

['过桥米线#DL'] = {
  iname = '过桥米线#DL',
	name = '过桥米线',
  id = 'guoqiao mixian',
  alternate_id = { 'mixian' },
  type = 'food',
  weight = 80,
  value = 500,
  consume_count = 3,
  food_supply = 80,
  source = {
    { type = 'get', location = '大理皇宫御膳房', },
  },
},

['野果#GM'] = {
  iname = '野果#GM',
	name = { '野果', '杨梅' },
  id = 'ye guo',
  alternate_id = { 'guo' },
  type = 'food',
  weight = 25,
  consume_count = 4,
  food_supply = 40,
  source = {
    { type = 'cmd', cmd = 'cai guo', location = '终南山果园', },
  },
},

--------------------------------------------------------------------------------
-- drinks

['清水'] = {
  iname = '清水',
	name = '清水',
  id = 'water',
  type = 'drink',
  water_supply = 120,
  source = {
    { type = 'local_handler', handler = 'drink', location = '伊犁城客栈', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '星宿海月牙泉', },
    { type = 'local_handler', handler = 'drink', location = '福州城茶楼', },
    { type = 'local_handler', handler = 'drink', location = '福州城茶楼二楼', },
    { type = 'local_handler', handler = 'drink', location = '襄阳城天香楼', },
    { type = 'local_handler', handler = 'drink', location = '武当山茶亭', },
    { type = 'local_handler', handler = 'drink', location = '天龙寺天龙寺斋堂#E', },
    { type = 'local_handler', handler = 'drink', location = '天龙寺无心井', },
    { type = 'local_handler', handler = 'drink', location = '天龙寺点苍十九峰#3', },
    { type = 'local_handler', handler = 'drink', location = '天龙寺点苍十九峰#2', },
    { type = 'local_handler', handler = 'drink', location = '天龙寺点苍十九峰#1', },
    { type = 'local_handler', handler = 'drink', location = '桃花岛饭厅#2', },
    { type = 'local_handler', handler = 'drink', location = '泰山白鹤泉', },
    { type = 'local_handler', handler = 'drink', location = '苏州城憨憨泉', },
    { type = 'local_handler', handler = 'drink', location = '苏州城茶馆', },
    { type = 'local_handler', handler = 'drink', location = '嵩山少林佛心井', },
    { type = 'local_handler', handler = 'drink', location = '燕子坞厨房', },
    { type = 'local_handler', handler = 'drink', location = '曼佗罗山庄后花园', },
    { type = 'local_handler', handler = 'drink', location = '姑苏慕容厨房#D', },
    { type = 'local_handler', handler = 'drink', location = '明教沙漠绿洲', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '兰州城营盘水', },
    { type = 'local_handler', handler = 'drink', location = '华山玉女祠', },
    { type = 'local_handler', handler = 'drink', location = '华山瀑布', },
    { type = 'local_handler', handler = 'drink', location = '黑木崖百丈泉', },
    { type = 'local_handler', handler = 'drink', location = '回疆坎儿井', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '回疆马棚', },
    { type = 'local_handler', handler = 'drink', location = '回疆黑石围子', },
    { type = 'local_handler', handler = 'drink', location = '恒山苦甜井', },
    { type = 'local_handler', handler = 'drink', location = '终南山果园', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '昆仑山瀑布', },
    { type = 'local_handler', handler = 'drink', location = '无量山东湖边', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '无量山北湖边', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '无量山南湖边', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '无量山西湖边', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '无量山山中小溪', limit = 200, },
    { type = 'local_handler', handler = 'drink', location = '大理城茶馆', },
    { type = 'local_handler', handler = 'drink', location = '扬州城小墓室', },
    { type = 'local_handler', handler = 'drink', location = '扬州城茶馆', },
    { type = 'local_handler', handler = 'drink', location = '成都城后院', },
    { type = 'local_handler', handler = 'drink', location = '长安城茶馆', },
    { type = 'local_handler', handler = 'drink', location = '沧州城厅堂', },
    { type = 'local_handler', handler = 'drink', location = '白驼山空地', },
  },
},

['酸梅汤'] = {
  iname = '酸梅汤',
	name = '酸梅汤',
  id = 'suanmei tang',
  alternate_id = { 'tang' },
  type = 'drink',
  weight = 50,
  value = 10,
  consume_count = 3,
  water_supply = 30,
  source = {
    { type = 'get', location = '明教厨房', },
    { type = 'get', location = '明教茶室', },
    { type = 'get', location = '黑木崖膳食房', },
  },
},

['香茶'] = {
  iname = '香茶',
	name = '香茶',
  id = 'xiang cha',
  alternate_id = { 'tea', 'cha', 'xiangcha' },
  type = 'drink',
  weight = 50,
  value = 10,
  consume_count = 2,
  water_supply = 25,
  source = {
    { type = 'get', location = '昆仑山厨房', },
    { type = 'get', location = '长乐帮厨房', },
    { type = 'get', location = '武当山厨房', },
    { type = 'get', location = '桃源县斋堂' },
    { type = 'get', location = '姑苏慕容小厅', },
    { type = 'get', location = '燕子坞大厅', },
    { type = 'get', location = '曼佗罗山庄客厅', },
    { type = 'get', location = '武当山茶亭', },
  },
},

['乳酪'] = {
  iname = '乳酪',
	name = '乳酪',
  id = 'ru lao',
  alternate_id = { 'cheese' },
  type = 'drink',
  weight = 700,
  value = 5000,
  consume_count = 1,
  food_supply = 160,
  water_supply = 160,
},

['酥油茶'] = {
  iname = '酥油茶',
	name = '酥油茶',
  id = 'suyou cha',
  alternate_id = { 'tea', 'cha' },
  type = 'drink',
  weight = 200,
  value = 80,
  consume_count = 3,
  food_supply = 10,
  water_supply = 10,
},

['茉莉花茶'] = {
  iname = '茉莉花茶',
	name = '茉莉花茶',
  id = 'moli huacha',
  alternate_id = { 'huacha', 'tea', 'cha' },
  type = 'drink',
  weight = 20,
  consume_count = 5,
  water_supply = 30,
  source = {
    { type = 'local_handler', handler = 'sit_and_wait', location = '桃花岛茶房', },
    { type = 'local_handler', handler = 'sit_and_wait', location = '归云庄茶房', },
  },
},

['龙井茶#JQG'] = {
  iname = '龙井茶#JQG',
	name = '龙井茶',
  id = 'longjin cha',
  alternate_id = { 'lingjin', 'tea', 'cha' },
  type = 'drink',
  weight = 700,
  value = 1000,
  consume_count = 1,
  water_supply = 160,
},

--------------------------------------------------------------------------------
-- drink containers

['清水葫芦'] = {
  iname = '清水葫芦',
	name = '清水葫芦',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '清水',
    consume_count = 15,
    drunk_supply = 3,
  },
},

['清水葫芦#2'] = {
  iname = '清水葫芦#2',
	name = '清水葫芦',
  id = 'qingshui hulu',
  alternate_id = { 'hulu', 'bottle' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 10,
  drink = {
    item = '清水',
    consume_count = 10,
    drunk_supply = 10,
  },
  source = {
    { type = 'get', location = '华山饭厅', },
    { type = 'get', location = '峨嵋山斋堂', },
    { type = 'get', location = '峨嵋山福寿庵斋堂', },
  },
},

['牛皮酒袋'] = {
  iname = '牛皮酒袋',
	name = '牛皮酒袋',
  id = 'jiu dai',
  alternate_id = { 'jiudai', 'wineskin', 'dai' },
  type = 'drink_container',
  weight = 700,
  value = 20,
  capacity = 15,
  drink = {
    item = '米酒',
    consume_count = 15,
    drunk_supply = 15,
  },
  source = {
    { type = 'get', location = '神龙岛厨房', },
  },
},

['花雕酒袋'] = {
  iname = '花雕酒袋',
	name = '花雕酒袋',
  id = 'huadiao jiudai',
  alternate_id = { 'jiu dai', 'huadiao', 'dai' },
  type = 'drink_container',
  weight = 700,
  value = 120,
  capacity = 20,
  drink = {
    item = '花雕酒',
    consume_count = 20,
    drunk_supply = 6,
  },
},

['花雕酒袋#DL'] = {
  iname = '花雕酒袋#DL',
	name = '花雕酒袋',
  id = 'jiudai',
  alternate_id = { 'skin', 'huadiao' },
  type = 'drink_container',
  weight = 700,
  value = 120,
  capacity = 20,
  drink = {
    item = '花雕酒',
    consume_count = 20,
    drunk_supply = 6,
  },
},

['瓷茶碗'] = {
  iname = '瓷茶碗',
	name = '瓷茶碗',
  id = 'ci chawan',
  alternate_id = { 'chawan', 'ci' },
  type = 'drink_container',
  weight = 100,
  value = 100,
  capacity = 4,
  drink = {
    item = '茶水',
    consume_count = 4,
    drunk_supply = 0,
  },
},

['水壶#HS'] = {
  iname = '水壶#HS',
	name = '水壶',
  id = 'water bottle',
  alternate_id = { 'bottle' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 10,
  drink = {
    item = '清水',
    consume_count = 10,
    drunk_supply = 5,
  },
},

['烧酒'] = {
  iname = '烧酒',
	name = '烧酒',
  id = 'shao jiu',
  alternate_id = { 'shaojiu' },
  type = 'drink_container',
  weight = 700,
  value = 80,
  capacity = 15,
  drink = {
    item = '青稞烧酒',
    consume_count = 15,
    drunk_supply = 6,
  },
},

['茶壶'] = {
  iname = '茶壶',
	name = '茶壶',
  id = 'cha hu',
  alternate_id = { 'hu' },
  type = 'drink_container',
  weight = 400,
  value = 80,
  capacity = 40,
  drink = {
    item = '茶水',
    consume_count = 40,
    drunk_supply = 0,
  },
},

['青葫芦'] = {
  iname = '青葫芦',
	name = '青葫芦',
  id = 'qing hulu',
  alternate_id = { 'hulu' },
  type = 'drink_container',
  weight = 400,
  value = 80,
  capacity = 60,
  drink = {
    item = '甘泉水',
    consume_count = 60,
    drunk_supply = 0,
  },
  source = {
    { type = 'get', location = '星宿海厨房', },
    { type = 'get', location = '天山厨房', },
  },
},

['大酒囊'] = {
  iname = '大酒囊',
	name = '大酒囊',
  id = 'jiunang',
  alternate_id = { 'wineskin', 'skin' },
  type = 'drink_container',
  weight = 700,
  value = 250,
  capacity = 400,
  drink = {
    item = '马奶酒',
    consume_count = 10,
    drunk_supply = 40,
  },
},

['水囊'] = {
  iname = '水囊',
	name = '水囊',
  id = 'shuinang',
  alternate_id = { 'wineskin', 'skin' },
  type = 'drink_container',
  weight = 500,
  value = 200,
  capacity = 300,
  drink = {
    item = '天山雪水',
    consume_count = 10,
    drunk_supply = 30,
  },
},

['竹壶'] = {
  iname = '竹壶',
	name = '竹壶',
  id = 'zhuhu',
  alternate_id = { 'hu' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '清水',
    consume_count = 15,
    drunk_supply = 15,
  },
},

['大碗#TLS'] = {
  iname = '大碗#TLS',
	name = '大碗',
  id = 'da wan',
  alternate_id = { 'wan', 'bowl' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '水',
    consume_count = 15,
    drunk_supply = 3,
  },
  source = {
    { type = 'get', location = '天龙寺厨房', },
    { type = 'get', location = '天龙寺天龙寺斋堂#W' },
    { type = 'get', location = '天龙寺天龙寺斋堂#E' },
  },
},

['细磁酒瓶#DL'] = {
  iname = '细磁酒瓶#DL',
	name = '细磁酒瓶',
  id = 'jiu ping',
  alternate_id = { 'jiu', 'ping' },
  type = 'drink_container',
  weight = 700,
  value = 100,
  capacity = 15,
  drink = {
    item = '米酒',
    consume_count = 15,
    drunk_supply = 3,
  },
  source = {
    { type = 'get', location = '大理王府王府厨房', },
  },
},

['大碗茶'] = {
  iname = '大碗茶',
	name = '大碗茶',
  id = 'dawan cha',
  alternate_id = { 'tea', 'cha' },
  type = 'drink',
  weight = 50,
  capacity = 0,
  drink = {
    item = '茶水',
    consume_count = 3,
    drunk_supply = 15,
  },
  source = {
    { type = 'get', location = '武当山厨房', },
    { type = 'get', location = '武馆厨房', },
  },
},

--------------------------------------------------------------------------------
-- drugs

['金创药'] = {
  iname = '金创药',
	name = '金创药',
  id = 'jinchuang yao',
  alternate_id = { 'jin', 'jinchuang', 'yao' },
  type = 'drug',
  weight = 30,
  value = 3000,
  cure = { qi_max = 50 },
},

['养精丹'] = {
  iname = '养精丹',
	name = '养精丹',
  id = 'yangjing dan',
  alternate_id = { 'dan' },
  type = 'drug',
  value = 100,
  delayed_effect = true,
  cure = { jing_max = 100 },
},

['百草丹'] = {
  iname = '百草丹',
	name = '百草丹',
  id = 'baicao dan',
  alternate_id = { 'baicao', 'dan' },
  type = 'drug',
  weight = 200,
  value = 1500,
  cure = { qi = 90, qi_max = 90, jing = 90, jing_max = 90 },
},

['莲子丸'] = {
  iname = '莲子丸',
	name = '莲子丸',
  id = 'lianzi wan',
  alternate_id = { 'lianzi', 'wan' },
  type = 'drug',
  weight = 100,
  value = 5000,
  cure = { qi_max = 200 },
},

['正气丹'] = {
  iname = '正气丹',
	name = '正气丹',
  id = 'zhengqi dan',
  alternate_id = { 'dan' },
  type = 'drug',
  weight = 100,
  value = 100,
  delayed_effect = true,
  cure = { jing_max = 100 },
},

['金元散'] = {
  iname = '金元散',
	name = '金元散',
  id = 'jinyuan san',
  alternate_id = { 'jinyuan', 'san' },
  type = 'drug',
  weight = 30,
  value = 5000,
  cure = { illness = true },
},

['回阳五龙膏'] = {
  iname = '回阳五龙膏',
	name = '回阳五龙膏',
  id = 'wulong gao',
  alternate_id = { 'huiyang', 'wulong', 'gao' },
  type = 'drug',
  weight = 500,
  value = 3000,
  cure = { qi_max = 150 },
},

['玉洞黑石丹'] = {
  iname = '玉洞黑石丹',
	name = '玉洞黑石丹',
  id = 'heishi dan',
  alternate_id = { 'heishi', 'dan' },
  type = 'drug',
  value = 5000,
  cure = { hb_poison = true },
},

['三黄宝腊丸'] = {
  iname = '三黄宝腊丸',
	name = '三黄宝腊丸',
  id = 'baola wan',
  alternate_id = { 'sanhuang', 'baola', 'wan' },
  type = 'drug',
  weight = 20,
  value = 15000,
  cure = { qi_max = 300 },
},

['玉真散'] = {
  iname = '玉真散',
	name = '玉真散',
  id = 'yuzhen san',
  alternate_id = { 'yuzhen', 'san' },
  type = 'drug',
  weight = 100,
  value = 5000,
  cure = { qi_max = 90 },
},

['玉露清新散'] = {
  iname = '玉露清新散',
	name = '玉露清新散',
  id = 'qingxin san',
  alternate_id = { 'san' },
  type = 'drug',
  value = 10000,
  improve = { jingli_max = 1 },
  cond = 'player.enable.force and player.enable.force.skill == ["神元功"]',
},

['玉灵散'] = {
  iname = '玉灵散',
	name = '玉灵散',
  id = 'yuling san',
  alternate_id = { 'yuling', 'san' },
  type = 'drug',
  weight = 30,
  value = 20000,
  cure = { hot_poison = true },
},

--------------------------------------------------------------------------------
-- normal swords

['长剑'] = {
  iname = '长剑',
	name = '长剑',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
  source = {
    { type = 'get', location = '大理王府兵器房', },
  },
},

['长剑#SWORD'] = {
  iname = '长剑#SWORD',
	name = '长剑',
  id = 'changjian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
  source = {
    { type = 'get', location = '桃源县练功房', },
  },
},

['长剑#SZ'] = {
  iname = '长剑#SZ',
	name = '长剑',
  id = 'changjian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 25,
},

['钢剑'] = {
  iname = '钢剑',
	name = '钢剑',
  id = 'jian',
  alternate_id = { 'sword' },
  type = 'sword',
  weight = 6000,
  value = 2000,
  quality = 30,
},

['木剑'] = {
  iname = '木剑',
	name = '木剑',
  id = 'mu jian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 300,
  value = 1270,
  quality = 5,
},

['竹剑'] = {
  iname = '竹剑',
	name = '竹剑',
  id = 'zhu jian',
  alternate_id = { 'zhujian', 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 5,
},

['竹剑#SZ'] = {
  iname = '竹剑#SZ',
	name = '竹剑',
  id = 'zhu jian',
  alternate_id = { 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 10,
},

['绣花针'] = {
  iname = '绣花针',
	name = '绣花针',
  id = 'xiuhua zhen',
  alternate_id = { 'zhen', 'needle' },
  type = 'sword',
  weight = 500,
  value = 200,
  quality = 10,
},

--------------------------------------------------------------------------------
-- normal blades

['钢刀'] = {
  iname = '钢刀',
	name = '钢刀',
  id = 'blade',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 5000,
  value = 1000,
  quality = 20,
  source = {
    { type = 'cmd', cmd = 'na dao', location = '天山兵器室', }
  }
},

['钢刀#SZ'] = {
  iname = '钢刀#SZ',
	name = '钢刀',
  id = 'blade',
  type = 'blade',
  weight = 7000,
  value = 1000,
  quality = 20,
},

['菜刀#SZ'] = {
  iname = '菜刀#SZ',
	name = '菜刀',
  id = 'cai dao',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 4000,
  value = 1500,
  quality = 15,
},

['剃刀'] = {
  iname = '剃刀',
	name = '剃刀',
  id = 'ti dao',
  alternate_id = { 'dao', 'blade' },
  type = 'blade',
  weight = 100,
  value = 1000,
  quality = 2,
},

['马刀'] = {
  iname = '马刀',
	name = '马刀',
  id = 'ma dao',
  alternate_id = { 'dao', 'blade', 'madao' },
  type = 'blade',
  weight = 12000,
  value = 1500,
  quality = 20,
},

['阿拉伯弯刀'] = {
  iname = '阿拉伯弯刀',
	name = '阿拉伯弯刀',
  id = 'wandao',
  type = 'blade',
  weight = 6000,
  value = 1500,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal hammers

['铁锤#SZ'] = {
  iname = '铁锤#SZ',
	name = '铁锤',
  id = 'tie chui',
  alternate_id = { 'chui' },
  type = 'hammer',
  weight = 7000,
  value = 1500,
  quality = 30,
},

['流星锤'] = {
  iname = '流星锤',
	name = '流星锤',
  id = 'liuxing chui',
  alternate_id = { 'chui', 'hammer' },
  type = 'hammer',
  weight = 10000,
  value = 1000,
  quality = 36,
},

['磬石锤'] = {
  iname = '磬石锤',
	name = '磬石锤',
  id = 'qingshi chui',
  alternate_id = { 'chui', 'hammer' },
  type = 'hammer',
  weight = 1200,
  value = 130,
  quality = 24,
},

--------------------------------------------------------------------------------
-- normal clubs

['铁棍'] = {
  iname = '铁棍',
	name = '铁棍',
  id = 'tiegun',
  alternate_id = { 'gun' },
  type = 'club',
  weight = 5000,
  value = 100,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal daggers

['匕首#SZ'] = {
  iname = '匕首#SZ',
	name = '匕首',
  id = 'bi shou',
  alternate_id = { 'shou' },
  type = 'dagger',
  weight = 4000,
  value = 1000,
  quality = 10,
},

['单刃匕'] = {
  iname = '单刃匕',
	name = '单刃匕',
  id = 'danren bi',
  alternate_id = { 'bi', 'dagger' },
  type = 'dagger',
  weight = 600,
  value = 120,
  quality = 15,
},

['暗杀匕首'] = {
  iname = '暗杀匕首',
	name = '暗杀匕首',
  id = 'ansha bishou',
  alternate_id = { 'bishou', 'dagger' },
  type = 'dagger',
  weight = 500,
  value = 1000,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal flutes

['玉箫'] = {
  iname = '玉箫',
	name = '玉箫',
  id = 'yu xiao',
  alternate_id = { 'xiao' },
  type = 'flute',
  weight = 250,
  value = 2000,
  quality = 25,
},

['箫'] = {
  iname = '箫',
	name = '箫',
  id = 'xiao',
  type = 'flute',
  weight = 150,
  value = 600,
  quality = 15,
},

--------------------------------------------------------------------------------
-- normal sticks

['竹棒'] = {
  iname = '竹棒',
	name = '竹棒',
  id = 'zhu bang',
  alternate_id = { 'zhubang', 'bang' },
  type = 'stick',
  weight = 1500,
  value = 200,
  quality = 20,
},

['竹棒#STICK'] = {
  iname = '竹棒#STICK',
	name = '竹棒',
  id = 'zhubang',
  type = 'stick',
  weight = 5000,
  value = 200,
  quality = 20,
},

['竹棒#SZ'] = {
  iname = '竹棒#SZ',
	name = '竹棒',
  id = 'zhubang',
  type = 'stick',
  weight = 3000,
  value = 200,
  quality = 25,
},

--------------------------------------------------------------------------------
-- normal whips

['百节链'] = {
  iname = '百节链',
	name = '百节链',
  id = 'baijie lian',
  alternate_id = { 'lian', 'whip' },
  type = 'whip',
  weight = 900,
  value = 140,
  quality = 26,
},

['长鞭'] = {
  iname = '长鞭',
	name = '长鞭',
  id = 'changbian',
  alternate_id = { 'bian' },
  type = 'whip',
  weight = 5000,
  value = 100,
  quality = 20,
},

['马鞭'] = {
  iname = '马鞭',
	name = '马鞭',
  id = 'mabian',
  alternate_id = { 'bian' },
  type = 'whip',
  weight = 500,
  value = 300,
  quality = 20,
},

--------------------------------------------------------------------------------
-- normal hooks

['单钩'] = {
  iname = '单钩',
	name = '单钩',
  id = 'hook',
  alternate_id = { 'gou' },
  type = 'hook',
  weight = 5000,
  value = 4000,
  quality = 30,
},

--------------------------------------------------------------------------------
-- normal staffs

['四明铲'] = {
  iname = '四明铲',
	name = '四明铲',
  id = 'siming chan',
  alternate_id = { 'chan', 'staff' },
  type = 'staff',
  weight = 4000,
  value = 3500,
  quality = 65,
},

['钢杖'] = {
  iname = '钢杖',
	name = '钢杖',
  id = 'gangzhang',
  type = 'staff',
  weight = 5000,
  value = 1000,
  quality = 25,
},

--------------------------------------------------------------------------------
-- normal axes

['鹰嘴斧'] = {
  iname = '鹰嘴斧',
	name = '鹰嘴斧',
  id = 'yingzui fu',
  alternate_id = { 'fu', 'axe' },
  type = 'axe',
  weight = 1100,
  value = 130,
  quality = 28,
},

['钢斧'] = {
  iname = '钢斧',
	name = '钢斧',
  id = 'gang fu',
  alternate_id = { 'fu', 'axe' },
  type = 'axe',
  weight = 40000,
  value = 2000,
  quality = 30,
},

--------------------------------------------------------------------------------
-- treasure axes

['金龙夺'] = {
  iname = '金龙夺',
	name = '金龙夺',
  id = 'jinlong duo',
  alternate_id = { 'duo', 'axe' },
  type = 'axe',
  weight = 20000,
  quality = 130,
  vanish_on_drop = true,
  cond = 'player.neili_max >= 1500 and player.str >= 30',
  source = {
    { type = 'local_handler', handler = 'ty_jia', location = '桃源县练功房', is_once_per_session = true, },
  },
},

--------------------------------------------------------------------------------
-- treasure brushes

['火云笔'] = {
  iname = '火云笔',
	name = '火云笔',
  id = 'huoyun bi',
  alternate_id = { 'bi', 'brush' },
  type = 'brush',
  weight = 15000,
  quality = 120,
  vanish_on_drop = true,
  cond = 'player.neili_max >= 1000 and player.str >= 30',
  source = {
    { type = 'local_handler', handler = 'ty_jia', location = '桃源县练功房', is_once_per_session = true, },
  },
},

--------------------------------------------------------------------------------
-- normal armor

['铁甲'] = {
  iname = '铁甲',
	name = '铁甲',
  id = 'tie jia',
  alternate_id = { 'tiejia', 'armor', 'jia' },
  type = 'cloth',
  weight = 20000,
  value = 2000,
  quality = 50,
},

['翡翠护腕'] = {
  iname = '翡翠护腕',
	name = '翡翠护腕',
  id = 'feicui huwan',
  alternate_id = { 'huwan' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['檀木护胸'] = {
  iname = '檀木护胸',
	name = '檀木护胸',
  id = 'tanmu huxiong',
  alternate_id = { 'huxiong' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['丹凤护腰'] = {
  iname = '丹凤护腰',
	name = '丹凤护腰',
  id = 'danfeng huyao',
  alternate_id = { 'huyao' },
  type = 'waist',
  weight = 500,
  quality = 4,
},

['麒麟踏云锁'] = {
  iname = '麒麟踏云锁',
	name = '麒麟踏云锁',
  id = 'qilin suo',
  alternate_id = { 'suo' },
  type = 'neck',
  weight = 600,
  value = 3000,
  quality = 5,
},

['锦虎披风'] = {
  iname = '锦虎披风',
	name = '锦虎披风',
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

['木棉袈裟'] = {
  iname = '木棉袈裟',
	name = '木棉袈裟',
  id = 'mumian jiasha',
  alternate_id = { 'mimian', 'jiasha' },
  type = 'cloth',
  weight = 5000,
  quality = 150,
  vanish_on_drop = true,
},

--------------------------------------------------------------------------------
-- books

['肘後备急方'] = {
  iname = '肘後备急方',
	name = '肘後备急方',
  id = 'ji fang',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 2500,
  read = { exp_required = 5000, jing_cost = 20, difficulty = 22, },
  skill = { name = '本草术理', min = 0, max = 31 },
},

['寓意草'] = {
  iname = '寓意草',
	name = '寓意草',
  id = 'yuyi cao',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 5000,
  read = { exp_required = 6000, jing_cost = 25, difficulty = 23, },
  skill = { name = '本草术理', min = 30, max = 41 },
},

['三冈识略'] = {
  iname = '三冈识略',
	name = '三冈识略',
  id = 'sangang shilue',
  alternate_id = { 'medicine book' },
  type = 'book',
  weight = 500,
  value = 6000,
  read = { exp_required = 10000, jing_cost = 30, difficulty = 24, },
  skill = { name = '本草术理', min = 40, max = 51 },
},

--------------------------------------------------------------------------------
-- misc

['粗绳子'] = {
  iname = '粗绳子',
	name = '粗绳子',
  id = 'cu shengzi',
  value = 1000,
},

['火折'] = {
  iname = '火折',
	name = '火折',
  id = 'fire',
  weight = 80,
  value = 100,
  source = {
    { type = 'get', location = '终南山灵室', },
    { type = 'get', location = '星宿海天然石洞', },
  },
},

['毛毯#WD'] = {
  iname = '毛毯#WD',
	name = '毛毯',
  id = 'mao tan',
  alternate_id = { 'tan' },
  desc = '一张由纯羊毛织成的毛毯。毛线细密十分保暖。',
  weight = 600,
  source = {
    { type = 'cmd', cmd = 'find mao tan', location = '武当山女休息室', },
    { type = 'cmd', cmd = 'find mao tan', location = '武当山男休息室', },
  },
},

['药锄'] = {
  iname = '药锄',
	name = '药锄',
  id = 'yao chu',
  alternate_id = { 'chu' },
  desc = '这是一把普通采药用的锄头。',
  weight = 500,
  source = {
    { type = 'cmd', cmd = 'find yao chu', location = '武当山武当广场', cond = 'player.party == "武当派"', is_once_per_session = true, }
  },
},

['绳子'] = {
  iname = '绳子',
	name = '绳子',
  id = 'sheng zi',
  alternate_id = { 'sheng' },
  desc = '这是一捆长长的麻绳，最适合于攀爬之用。',
  source = {
    { type = 'get', location = '华山寝室', },
  },
  weight = 400,
},

['练心石'] = {
  iname = '练心石',
	name = '练心石',
  id = 'lianxin shi',
  alternate_id = { 'lianxin', 'shi' },
  weight = 4000,
  source = {
    { type = 'get', location = '武当后山古道#3', },
  },
},

['小树枝'] = {
  iname = '小树枝',
	name = '小树枝',
  id = 'xiao shuzhi',
  alternate_id = { 'shuzhi' },
  desc = '这是一枝小树枝。',
  weight = 1000,
  source = {
    { type = 'get', location = '昆仑山云杉林#1', },
    { type = 'get', location = '明教树林深处#5', },
    { type = 'get', location = '明教树林#M1', },
    { type = 'get', location = '曼佗罗山庄柳树林#N', },
    { type = 'get', location = '苏州城虎丘山', },
    { type = 'get', location = '苏州城灵岩山', },
  },
},

['通行令牌'] = {
  iname = '通行令牌',
	name = '通行令牌',
  id = 'ling pai',
  weight = 20,
  source = {
    { type = 'cmd', cmd = 'ask lu gaoxuan about 通行令牌', location = '神龙岛陆府正厅', npc = '陆高轩', cond = 'player.party == "神龙教"', },
    { type = 'local_handler', handler = 'sld_lingpai', location = '神龙岛陆府正厅', npc = '陆高轩', cond = 'player.party ~= "神龙教"', },
  },
  vanish_on_drop = true,
},

['金娃娃'] = {
  iname = '金娃娃',
	name = '金娃娃',
  id = 'jin wawa',
  alternate_id = { 'jin', 'wawa', 'yu' },
  weight = 3000,
  source = {
    { type = 'local_handler', handler = 'ty_fish', location = '桃源县瀑布中', },
  },
},

['铁舟'] = {
  iname = '铁舟',
	name = '铁舟',
  id = 'tie zhou',
  alternate_id = { 'zhou', 'boat' },
  weight = 10000,
  source = {
    { type = 'local_handler', handler = 'ty_boat', location = '桃源县山谷瀑布', },
  },
},

['树藤'] = {
  iname = '树藤',
	name = '树藤',
  id = 'teng',
  alternate_id = { 'shuteng' },
  weight = 1000,
  source = {
    { type = 'local_handler', handler = 'hs_shuteng', location = '华山壁顶', },
  },
},

['藤筐'] = {
  iname = '藤筐',
	name = '藤筐',
  id = 'teng kuang',
  alternate_id = { 'kuang', 'tengkuang' },
  weight = 500,
  source = {
    { type = 'local_handler', handler = 'hs_kuang', location = '华山壁顶', },
  },
},

['黑钥匙'] = {
  iname = '黑钥匙',
	name = '黑钥匙',
  id = 'hei yaoshi',
  alternate_id = { 'yaoshi', 'key' },
  weight = 1000,
  source = {
    { type = 'local_handler', handler = 'hmy_key', location = '黑木崖书房', },
  },
},

['铁锹'] = {
  iname = '铁锹',
	name = '铁锹',
  id = 'tie qiao',
  alternate_id = { 'qiao' },
  weight = 1500,
  value = 2000,
},

['硫磺'] = {
  iname = '硫磺',
	name = '硫磺',
  id = 'liu huang',
  alternate_id = { 'liuhuang' },
  weight = 80,
  value = 99,
},

['坛子'] = {
  iname = '坛子',
	name = '坛子',
  id = 'tan zi',
  alternate_id = { 'tanzi' },
  weight = 1000,
  value = 499,
},

['天神篇'] = {
  iname = '天神篇',
	name = '天神篇',
  id = 'tianshen pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['龙神篇'] = {
  iname = '龙神篇',
	name = '龙神篇',
  id = 'longshen pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['夜叉篇'] = {
  iname = '夜叉篇',
	name = '夜叉篇',
  id = 'yecha pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['乾达婆篇'] = {
  iname = '乾达婆篇',
	name = '乾达婆篇',
  id = 'qiandapo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['阿修罗篇'] = {
  iname = '阿修罗篇',
	name = '阿修罗篇',
  id = 'axiuluo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['迦楼罗篇'] = {
  iname = '迦楼罗篇',
	name = '迦楼罗篇',
  id = 'jialouluo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['紧那罗篇'] = {
  iname = '紧那罗篇',
	name = '紧那罗篇',
  id = 'jinnaluo pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

['摩呼罗迦篇'] = {
  iname = '摩呼罗迦篇',
	name = '摩呼罗迦篇',
  id = 'mohuluojia pian',
  alternate_id = { 'shu', 'book' },
  weight = 80,
  source = {
    { type = 'local_handler', handler = 'tlbb_book', location = '大理皇宫书房', },
  },
},

}

return item
