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
-- normal weapon

['长剑'] = {
  iname = '长剑',
	name = '长剑',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
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
  alternate_id = { 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 5,
},

['竹棒'] = {
  iname = '竹棒',
	name = '竹棒',
  id = 'zhubang',
  type = 'stick',
  weight = 3000,
  value = 200,
  quality = 25,
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
-- vendor drinks

['清水葫芦'] = {
  iname = '清水葫芦',
	name = '清水葫芦',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'bottle',
  weight = 700,
  value = 100,
  capacity = 15,
},

--------------------------------------------------------------------------------
-- vendor misc goods

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
-- misc

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
    { type = 'cmd', cmd = 'find yao chu', location = '武当山武当广场', cond = 'player.party == "武当派"', }
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

}

return item
