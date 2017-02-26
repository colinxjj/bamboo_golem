local npc = {

--------------------------------------------------------------------------------
-- 武馆

['王厨子'] = {
  name = '王厨子',
  id = 'wang chuzi',
  alternate_id = { 'wang', 'chuzi', },
  location = '武馆厨房',
  label = { food = true, water = true, },
},

['卜垣'] = {
  name = '卜垣',
  id = 'bo yuan',
  alternate_id = { 'bo', 'yuan', },
  location = '武馆书房',
  label = { literate = true, },
},

['吴坎'] = {
  name = '吴坎',
  id = 'wu kan',
  alternate_id = { 'wu', 'kan', },
  location = '武馆物品房',
},

['鲁坤'] = {
  name = '鲁坤',
  id = 'lu kun',
  alternate_id = { 'lu', 'kun', 'man', },
  location = '武馆武馆大厅',
},

['武馆教头'] = {
  name = '武馆教头',
  id = 'wuguan jiaotou',
  alternate_id = { 'jiaotou', },
  label = { master = true, },
},

['万震山'] = {
  name = '万震山',
  id = 'wan zhenshan',
  alternate_id = { 'wan', 'zhenshan', 'guanzhu' },
  location = '武馆冬暖阁',
},

['戚芳'] = {
  name = '戚芳',
  id = 'qi fang',
  alternate_id = { 'qi', 'fang', 'woman' },
  location = '武馆睡房',
},

--------------------------------------------------------------------------------
-- 扬州

['李半仙'] = {
  name = '李半仙',
  id = 'li banxian',
  alternate_id = { 'li', 'banxian', 'xiansheng' },
  location = '扬州城东大街',
  range = 2,
},

--------------------------------------------------------------------------------
-- 黄河流域

['胡斐'] = {
  name = '胡斐',
  id = 'hu fei',
  alternate_id = { 'hu', 'fei' },
  location = '黄河流域墓地',
},

--------------------------------------------------------------------------------
-- 峨嵋山

['灭绝师太'] = {
  name = '灭绝师太',
  id = 'miejue shitai',
  alternate_id = { 'miejue', 'shitai' },
  location = '峨嵋山后殿',
},

['静闲师太'] = {
  name = '静闲师太',
  id = 'jingxian shitai',
  alternate_id = { 'jingxian', 'shitai' },
  location = '峨嵋山清音阁',
},

--------------------------------------------------------------------------------
-- Banks

['钱缝'] = {
  name = '钱缝',
  id = 'qian feng',
  alternate_id = { 'qianfeng', 'qian', 'feng' },
  location = '扬州城天阁斋',
  label = { bank = true, },
},

['孙老板'] = {
  name = '孙老板',
  id = 'sun laoban',
  alternate_id = { 'sun', 'laoban' },
  location = '苏州城聚宝斋',
  label = { bank = true, },
},

['刘老板'] = {
  name = '刘老板',
  id = 'liu laoban',
  alternate_id = { 'liu', 'laoban' },
  location = '福州城通宝斋',
  label = { bank = true, },
},

['蒋调侯'] = {
  name = '蒋调侯',
  id = 'jiang tiaohou',
  alternate_id = { 'jiang', 'tiaohou' },
  location = '沧州城天音阁',
  label = { bank = true, },
},

['钱眼开'] = {
  name = '钱眼开',
  id = 'qian yankai',
  alternate_id = { 'qian' },
  location = '长安城威信钱庄',
  label = { bank = true, },
},

['王掌柜'] = {
  name = '王掌柜',
  id = 'wang zhanggui',
  alternate_id = { 'wang', 'zhanggui' },
  location = '成都城墨玉斋',
  label = { bank = true, },
},

['严掌柜'] = {
  name = '严掌柜',
  id = 'yan zhanggui',
  alternate_id = { 'yan', 'zhanggui' },
  location = '大理城大理钱庄',
  label = { bank = true, },
},

['张算盘'] = {
  name = '张算盘',
  id = 'zhang suanpan',
  alternate_id = { 'zhang', 'suanpan', 'pan' },
  location = '杭州城翠合斋',
  label = { bank = true, },
},

['龙卷风'] = {
  name = '龙卷风',
  id = 'long juanfeng',
  alternate_id = { 'long', 'juanfeng' },
  location = '明教勒马斋',
  label = { bank = true, },
},

['朱富'] = {
  name = '朱富',
  id = 'zhu fu',
  alternate_id = { 'zhu', 'fu' },
  location = '塘沽城钱庄',
  label = { bank = true, },
},

['言达平'] = {
  name = '言达平',
  id = 'yan daping',
  alternate_id = { 'yan', 'daping' },
  location = '武馆帐房',
  label = { bank = true, },
},

['钱善人'] = {
  name = '钱善人',
  id = 'qian shanren',
  alternate_id = { 'qian', 'banker' },
  location = '襄阳城宝龙斋',
  label = { bank = true, },
},

['马掌柜'] = {
  name = '马掌柜',
  id = 'ma zhanggui',
  alternate_id = { 'ma', 'zhanggui' },
  location = '星宿海万宝斋',
  label = { bank = true, },
},

['黄真'] = {
  name = '黄真',
  id = 'huang zhen',
  alternate_id = { 'huang', 'zhen' },
  location = '星宿海天阁斋分店',
  label = { bank = true, },
},

--------------------------------------------------------------------------------
-- Other

['官兵'] = {
  name = '官兵',
  id = 'guan bing',
  alternate_id = { 'bing', 'guanbing', 'soldier' },
  is_not_unique = true,
  location = '武馆睡房',
},

}

npc.bank_list, npc.shop_list, npc.pawnshop_list, npc.grocery_list  = {}, {}, {}, {}
for name, person in pairs( npc ) do
  if person.label and person.label.bank then npc.bank_list[ name ] = person end
  if person.label and person.label.shop then npc.shop_list[ name ] = person end
  if person.label and person.label.pawnshop then npc.pawnshop_list[ name ] = person end
  if person.label and person.label.grocery then npc.grocery_list[ name ] = person end
end

return npc
