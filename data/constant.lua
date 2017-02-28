-- Some useful constants

PROMPT = '> '

HEARTBEAT_INTERVAL = 0.2

IDLE_THRESHOLD = 60

CLI_PREFIX = 'bg'

DIR4 = { 'e', 'w', 's', 'n' }

DIR4_DIAGONAL = { 'ne', 'nw', 'se', 'sw' }

DIR8 = { 'e', 'w', 's', 'n', 'ne', 'nw', 'se', 'sw' }

DIR_ALL = { 'w', 'e', 'n', 's', 'nw', 'ne', 'sw', 'se', 'nu', 'nd', 'eu', 'ed', 'su', 'sd', 'wu', 'wd', 'd', 'u', 'enter', 'out' }

DIR_FULL = { e = 'east', w = 'west', s = 'south', n = 'north', sw = 'southwest', ne = 'northeast', nw = 'northwest', se = 'southeast', d = 'down', u = 'up', sd = 'southdown', nu = 'northup', su = 'southup', nd = 'northdown', wd = 'westdown', eu = 'eastup', wu = 'westup', ed = 'eastdown' }

DIR_ABBRE = { east = 'e', west = 'w', south = 's', north = 'n', southwest = 'sw', northeast = 'ne', northwest = 'nw', southeast = 'se', down = 'd', up = 'u', southdown = 'sd', northup = 'nu', southup = 'su', northdown = 'nd', westdown = 'wd', eastup = 'eu', westup = 'wu', eastdown = 'ed' }

DIR_REVERSE  =  { w = 'e', e = 'w', n = 's', s = 'n', ne = 'sw', sw = 'ne', se = 'nw', nw = 'se', u = 'd', d = 'u', nu = 'sd', sd = 'nu', nd = 'su', su = 'nd', eu = 'wd', wd = 'eu', ed = 'wu', wu = 'ed', enter = 'out', out = 'enter' }

CN_DIR = { ['北'] = 'n', ['东北'] = 'ne', ['东'] = 'e', ['东南'] = 'se', ['南'] = 's', ['西南'] = 'sw', ['西'] = 'w', ['西北'] = 'nw', ['北上'] = 'nu', ['北下'] = 'nd', ['南上'] = 'su', ['南下'] = 'sd', ['西上'] = 'wu', ['西下'] = 'wd', ['东上'] = 'eu', ['东下'] = 'ed' }

CN_HOUR = { ['子'] = 23, ['丑'] = 1, ['寅'] = 3, ['卯'] = 5, ['辰'] = 7, ['巳'] = 9, ['午'] = 11, ['未'] = 13, ['申'] = 15, ['酉'] = 17, ['戌'] = 19, ['亥'] = 21 }

CN_QUARTER = { ['正'] = 0, ['一刻'] = 0.5, ['二刻'] = 1, ['三刻'] = 1.5 }

CN_NUM = { ['一'] = 1, ['二'] = 2, ['三'] = 3, ['四'] = 4, ['五'] = 5, ['六'] = 6, ['七'] = 7, ['八'] = 8, ['九'] = 9 }

CN_UNIT = { ['十'] = 10, ['百'] = 100, ['千'] = 1000, ['万'] = 10000, ['亿'] = 100000000 }

KNOWLEDGE_LEVEL = {
	['新学乍用'] = 1, ['初窥门径'] = 2, ['略知一二'] = 3, ['半生不熟'] = 4,
	['马马虎虎'] = 5, ['已有小成'] = 6, ['融会贯通'] = 7, ['心领神会'] = 8,
	['了然於胸'] = 9, ['已有大成'] = 10, ['非同凡响'] = 11, ['举世无双'] = 12,
	['震古铄今'] = 13, ['无与伦比'] = 14, ['超凡入圣'] = 15, ['空前绝后'] = 16,
}

POWER_LEVEL = {
	['不堪一击'] = 1, ['毫不足虑'] = 2, ['不足挂齿'] = 3, ['初学乍练'] = 4, ['勉勉强强'] = 5,
	['初窥门径'] = 6, ['初出茅庐'] = 7, ['略知一二'] = 8, ['普普通通'] = 9, ['平平淡淡'] = 10,
	['平淡无奇'] = 11, ['粗通皮毛'] = 12, ['半生不熟'] = 13, ['马马虎虎'] = 14, ['略有小成'] = 15,
	['已有小成'] = 16, ['鹤立鸡群'] = 17, ['驾轻就熟'] = 18, ['青出于蓝'] = 19, ['融会贯通'] = 20,
	['心领神会'] = 21, ['炉火纯青'] = 22, ['了然于胸'] = 23, ['略有大成'] = 24, ['已有大成'] = 25,
	['豁然贯通'] = 26, ['出类拔萃'] = 27, ['无可匹敌'] = 28, ['技冠群雄'] = 29, ['神乎其技'] = 30,
	['出神入化'] = 31, ['非同凡响'] = 32, ['傲视群雄'] = 33, ['登峰造极'] = 34, ['无与伦比'] = 35,
	['所向披靡'] = 36, ['一代宗师'] = 37, ['精深奥妙'] = 38, ['神功盖世'] = 39, ['举世无双'] = 40,
	['惊世骇俗'] = 41, ['撼天动地'] = 42, ['震古铄今'] = 43, ['超凡入圣'] = 44, ['威镇寰宇'] = 45,
	['空前绝后'] = 46, ['天人合一'] = 47, ['深藏不露'] = 48, ['深不可测'] = 49, ['返璞归真'] = 50
}

IS_STACKABLE_ITEM = {
  ['黄金'] = true,
  ['白银'] = true,
  ['铜钱'] = true,
  ['石子'] = true,
  ['神龙镖'] = true,
  ['甩箭'] = true,
}

WEAPON_TYPE = {
	blade = '刀', sword = '剑', dagger = '匕首', flute = '箫', hook = '钩', axe = '斧', brush = '笔',
	staff = '杖', club = '棍', stick = '棒', hammer = '锤', whip = '鞭', throwing = '暗器' }

IS_SHARP_WEAPON = { blade = true, sword = true, dagger = true, hook = true, axe = true, }

ARMOR_TYPE = { cloth = '衣服', armor = '护甲', shoes = '鞋子', helm = '头盔', mantle = '披风' }
