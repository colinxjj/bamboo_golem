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

['奚长老'] = {
  name = '奚长老',
  id = 'xi zhanglao',
  alternate_id = { 'xi', 'zhanglao' },
  location = '扬州城墓室',
},

--------------------------------------------------------------------------------
-- 大理

['褚万里'] = {
  name = '褚万里',
  id = 'zhu wanli',
  alternate_id = { 'zhu', 'wanli' },
  location = '大理城驿站',
},

['段正淳'] = {
  name = '段正淳',
  id = 'duan zhengchun',
  alternate_id = { 'duan', 'master' },
  location = '大理王府暖阁',
},

['段正明'] = {
  name = '段正明',
  id = 'duan zhengming',
  alternate_id = { 'duan', 'master' },
  location = '大理皇宫正厅',
},

--------------------------------------------------------------------------------
-- 天龙寺

['枯荣长老'] = {
  name = '枯荣长老',
  id = 'kurong zhanglao',
  alternate_id = { 'kurong', 'zhanglao' },
  location = '天龙寺龙树院',
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

['孤鸿子'] = {
  name = '孤鸿子',
  id = 'guhong zi',
  alternate_id = { 'guhong', 'zi' },
  location = '峨嵋山山洞',
},

--------------------------------------------------------------------------------
-- 桃花岛

['黄蓉'] = {
  name = '黄蓉',
  id = 'huang rong',
  alternate_id = { 'huang', 'rong' },
  location = '桃花岛内室#1',
},

['黄药师'] = {
  name = '黄药师',
  id = 'huang yaoshi',
  alternate_id = { 'huang', 'yaoshi' },
  location = '桃花岛积翠亭',
},

['周伯通'] = {
  name = '周伯通',
  id = 'zhou botong',
  alternate_id = { 'zhou', 'botong' },
  location = '桃花岛积翠亭',
},

--------------------------------------------------------------------------------
-- 归云庄

['陆乘风'] = {
  name = '陆乘风',
  id = 'lu chengfeng',
  alternate_id = { 'lu', 'chengfeng' },
  location = '归云庄书房',
},

['陆冠英'] = {
  name = '陆冠英',
  id = 'lu guanying',
  alternate_id = { 'lu', 'guanying' },
  location = '归云庄前厅',
},

--------------------------------------------------------------------------------
-- 兰州城

['苗人凤'] = {
  name = '苗人凤',
  id = 'miao renfeng',
  alternate_id = { 'miao', 'renfeng' },
  location = '兰州城正厅',
},

--------------------------------------------------------------------------------
-- 武当山

['宋远桥'] = {
  name = '宋远桥',
  id = 'song yuanqiao',
  alternate_id = { 'song' },
  location = '武当山三清殿',
},

['采药道长'] = {
  name = '采药道长',
  id = 'caiyao daozhang',
  alternate_id = { 'caiyao', 'daozhang' },
  location = '武当山山路#2',
},

['张三丰'] = {
  name = '张三丰',
  id = 'zhang sanfeng',
  alternate_id = { 'zhang', 'sanfeng' },
  location = '武当山后山小院',
},

['谷虚道长'] = {
  name = '谷虚道长',
  id = 'guxu daozhang',
  alternate_id = { 'guxu' },
  location = '武当山复真观',
  provide = {
    { item = '檀木护胸', cmd = 'ask guxu daozhang about 护胸', cond = 'player.party == "武当派"', },
    { item = '丹凤护腰', cmd = 'ask guxu daozhang about 护腰', cond = 'player.party == "武当派"', },
    { item = '翡翠护腕', cmd = 'ask guxu daozhang about 护腕', cond = 'player.party == "武当派"', },
  },
},

--------------------------------------------------------------------------------
-- 嵩山

['左冷禅'] = {
  name = '左冷禅',
  id = 'zuo lengchan',
  alternate_id = { 'zuo', 'lengchan' },
  location = '嵩山封禅台',
},

--------------------------------------------------------------------------------
-- 丐帮

['洪七公'] = {
  name = '洪七公',
  id = 'hong qigong',
  alternate_id = { 'hong', 'qigong' },
  location = '丐帮后院',
},

['鲁有脚'] = {
  name = '鲁有脚',
  id = 'lu youjiao',
  alternate_id = { 'lu', 'youjiao' },
  location = '丐帮土地庙',
},

--------------------------------------------------------------------------------
-- 铁掌山

['上官剑南'] = {
  name = '上官剑南',
  id = 'shangguan jiannan',
  alternate_id = { 'shangguan', 'jiannan' },
  location = '铁掌山石室',
},

['裘千仞'] = {
  name = '裘千仞',
  id = 'qiu qianren',
  alternate_id = { 'qiu', 'qianren' },
  location = '铁掌山后厢房',
},

['裘千丈'] = {
  name = '裘千丈',
  id = 'qiu qianzhang',
  alternate_id = { 'qiu', 'qianzhang' },
  location = '铁掌山广场',
  range = 2,
},

--------------------------------------------------------------------------------
-- 牛家村

['傻姑'] = {
  name = '傻姑',
  id = 'sha gu',
  alternate_id = { 'shagu' },
  location = '牛家村小酒店',
},

--------------------------------------------------------------------------------
-- 大雪山

['血刀老祖'] = {
  name = '血刀老祖',
  id = 'xuedao laozu',
  alternate_id = { 'xuedaolaozu', 'laozu' },
  location = '大雪山雪谷',
},

['狄云'] = {
  name = '狄云',
  id = 'di yun',
  alternate_id = { 'di', 'yun' },
  location = '大雪山岩石',
},

['鸠摩智'] = {
  name = '鸠摩智',
  id = 'jiumo zhi',
  alternate_id = { 'jiumo', 'zhi' },
  location = '大雪山法堂二楼',
},

['宝象'] = {
  name = '宝象',
  id = 'bao xiang',
  alternate_id = { 'baoxiang', 'bao', 'xiang' },
  location = '大雪山入幽口',
},

--------------------------------------------------------------------------------
-- 苏州城

['丁典'] = {
  name = '丁典',
  id = 'ding dian',
  alternate_id = { 'ding' },
  location = '苏州城监狱',
},

--------------------------------------------------------------------------------
-- 昆仑山

['殷离'] = {
  name = '殷离',
  id = 'yin li',
  alternate_id = { 'yin', 'li' },
  location = '昆仑山昆仑派山门',
  range = 10,
},

['何太冲'] = {
  name = '何太冲',
  id = 'he taichong',
  alternate_id = { 'he' },
  location = '昆仑山铁琴居',
},

['班淑娴'] = {
  name = '班淑娴',
  id = 'ban shuxian',
  alternate_id = { 'ban' },
  location = '昆仑山三圣堂',
},

['何足道'] = {
  name = '何足道',
  id = 'he zudao',
  alternate_id = { 'he' },
  location = '昆仑山惊神峰',
},

--------------------------------------------------------------------------------
-- 绝情谷

['杨过'] = {
  name = '杨过',
  id = 'yang guo',
  alternate_id = { 'yang', 'guo' },
  location = '绝情谷小室',
},

['小龙女'] = {
  name = '小龙女',
  id = 'xiao longnv',
  alternate_id = { 'xiao', 'longnv' },
  location = '绝情谷大室',
},

['公孙止'] = {
  name = '公孙止',
  id = 'gongsun zhi',
  alternate_id = { 'gongsun', 'zhi' },
  location = '绝情谷大厅',
},

--------------------------------------------------------------------------------
-- 福州城

['吴长老'] = {
  name = '吴长老',
  id = 'wu zhanglao',
  alternate_id = { 'wu', 'zhanglao' },
  location = '福州城船舱',
},

['陈近南'] = {
  name = '陈近南',
  id = 'chen jinnan',
  alternate_id = { 'chen', 'jinnan' },
  location = '福州城石桥',
  range = 3,
},

--------------------------------------------------------------------------------
-- 嵩山少林

['慕容博'] = {
  name = '慕容博',
  id = 'murong bo',
  alternate_id = { 'murong', 'bo' },
  location = '嵩山少林小屋',
},

['渡劫'] = {
  name = '渡劫',
  id = 'du jie',
  alternate_id = { 'du', 'jie' },
  location = '嵩山少林金刚伏魔圈',
  power_level = 24,
  loot = { '木棉袈裟' },
  provide = {
    { item = '木棉袈裟', cmd = 'ask du jie about 木棉袈裟', cond = 'player.power_level_parry >= 25' },
  },
},

['渡难'] = {
  name = '渡难',
  id = 'du nan',
  alternate_id = { 'du', 'nan' },
  location = '嵩山少林金刚伏魔圈',
},

['渡厄'] = {
  name = '渡厄',
  id = 'du e',
  alternate_id = { 'du', 'e' },
  location = '嵩山少林金刚伏魔圈',
},

--------------------------------------------------------------------------------
-- 华山

['岳不群'] = {
  name = '岳不群',
  id = 'yue buqun',
  alternate_id = { 'yue', 'buqun' },
  location = '华山正气堂',
},

['宁中则'] = {
  name = '宁中则',
  id = 'ning zhongze',
  alternate_id = { 'ning' },
  location = '华山正气堂',
},

['令狐冲'] = {
  name = '令狐冲',
  id = 'linghu chong',
  alternate_id = { 'linghu', 'chong' },
  location = '华山小山路#2',
  range = 2,
},

['岳灵珊'] = {
  name = '岳灵珊',
  id = 'yue lingshan',
  alternate_id = { 'yue', 'lingshan' },
  location = '华山祭坛',
},

['穆人清'] = {
  name = '穆人清',
  id = 'mu renqing',
  alternate_id = { 'mu', 'renqing' },
  location = '华山石屋',
},

--------------------------------------------------------------------------------
-- 华山村

['巫婆'] = {
  name = '巫婆',
  id = 'wu po',
  alternate_id = { 'wu', 'po' },
  location = '华山村玄坛庙',
},

--------------------------------------------------------------------------------
-- 明教

['张无忌'] = {
  name = '张无忌',
  id = 'zhang wuji',
  alternate_id = { 'zhang', 'wuji' },
  location = '明教圣火堂',
},

--------------------------------------------------------------------------------
-- 大草原

['金轮法王'] = {
  name = '金轮法王',
  id = 'jinlun fawang',
  alternate_id = { 'jinlunfawang', 'jinlun', 'fawang' },
  location = '大草原牛皮大帐',
},

['忽必烈'] = {
  name = '忽必烈',
  id = 'hu bilie',
  alternate_id = { 'hu', 'hubilie' },
  location = '大草原牛皮大帐',
},

--------------------------------------------------------------------------------
-- 回疆

['苏鲁克'] = {
  name = '苏鲁克',
  id = 'su luke',
  alternate_id = { 'suluke', 'su' },
  location = '回疆苏鲁克的家',
},

['计老人'] = {
  name = '计老人',
  id = 'ji laoren',
  alternate_id = { 'ji' },
  location = '回疆小屋',
},

--------------------------------------------------------------------------------
-- 黑木崖

['东方不败'] = {
  name = '东方不败',
  id = 'dongfang bubai',
  alternate_id = { 'dongfang', 'bubai' },
  location = '黑木崖小舍',
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

['崔算盘'] = {
  name = '崔算盘',
  id = 'cui suanpan',
  alternate_id = { 'cui', 'zhanggui' },
  location = '杭州城金华斋',
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
-- Shops

['商人#SLD'] = {
  name = '商人',
  id = 'shang ren',
  alternate_id = { 'shang', 'ren' },
  location = '神龙岛海滩',
  label = { shop = true, },
  catalogue = { '粗绳子', '火折', }
},

['商人#TS'] = {
  name = '商人',
  id = 'shang ren',
  alternate_id = { 'ren' },
  location = '泰山岱宗坊',
  label = { shop = true, },
  catalogue = { '养精丹', '火折', }
},

['铁匠#TG'] = {
  name = '铁匠',
  id = 'tie jiang',
  alternate_id = { 'tie', 'jiang' },
  location = '塘沽城武器铺',
  label = { shop = true, },
  catalogue = { '长剑', '钢剑', '铁甲', '钢刀', }
},

['铁匠#SZ'] = {
  name = '铁匠',
  id = 'tie jiang',
  alternate_id = { 'tie', 'jiang' },
  location = '苏州城打铁铺',
  label = { shop = true, },
  catalogue = { '长剑#SZ', '钢剑', '菜刀#SZ', '钢刀#SZ', '铁锤#SZ', '匕首#SZ' }
},

['刀疤张'] = {
  name = '刀疤张',
  id = 'zhujian shi',
  alternate_id = { 'shi' },
  location = '中原神州兵器铺',
  label = { shop = true, },
  catalogue = { '长剑#YZ', '钢刀', '流星锤', '铁棍', '钢杖', '长鞭', '单钩', '竹棒#YZ', '钢斧' }
},

['铸剑师'] = {
  name = '铸剑师',
  id = 'daoba zhang',
  alternate_id = { 'daoba', 'zhang' },
  location = '中原神州兵器铺',
  label = { shop = true, },
  catalogue = { '长剑#YZ', '钢刀', '流星锤', '铁棍', '钢杖', '长鞭', '单钩', '竹棒#YZ', '钢斧', '暗杀匕首' }
},

['木匠#XY'] = {
  name = '木匠',
  id = 'mu jiang',
  alternate_id = { 'mujiang', 'mu', 'jiang' },
  location = '襄阳城木匠铺',
  label = { shop = true, },
  catalogue = { '木剑' }
},

['小贩子#SZ'] = {
  name = '小贩子',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '苏州城宝带桥',
  label = { shop = true, },
  catalogue = { '清水葫芦', '竹剑#SZ', '火折', '竹棒#SZ' }
},

['小贩子#EM'] = {
  name = '小贩子',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '峨嵋山草棚',
  label = { shop = true, },
  catalogue = { '清水葫芦#EM', '竹剑', '火折', '长剑', '铁锹' }
},

['小贩子#MJ'] = {
  name = '小贩子',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '峨嵋山草棚',
  label = { shop = true, },
  catalogue = { '牛皮酒袋', '包子', '竹壶' }
},

['江来福'] = {
  name = '江来福',
  id = 'jiang laifu',
  alternate_id = { 'jiang', 'jianglaifu', 'laifu' },
  location = '大雪山来福杂货',
  label = { shop = true, },
  catalogue = { '火折', '酥油茶', '麒麟踏云锁' }
},

['沈铁匠'] = {
  name = '沈铁匠',
  id = 'shen tiejiang',
  alternate_id = { 'shen', 'smith' },
  location = '佛山镇铁匠铺',
  label = { shop = true, },
  catalogue = { '百节链', '单刃匕', '磬石锤', '四明铲', '鹰嘴斧' }
},

['小二#FZ'] = {
  name = '小二',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '福州城吉祥客栈',
  label = { shop = true, },
  catalogue = { '火折' }
},

['小二#XY'] = {
  name = '小二',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '襄阳城江湖客栈',
  label = { shop = true, },
  catalogue = { '火折' }
},

['朱老板'] = {
  name = '朱老板',
  id = 'zhu laoban',
  alternate_id = { 'zhu', 'laoban' },
  location = '扬州城珠宝店',
  label = { shop = true, },
  catalogue = { '玉箫' }
},

['珠宝商#CA'] = {
  name = '珠宝商',
  id = 'zhubao shang',
  alternate_id = { 'shang', 'laoban' },
  location = '长安城珠宝行',
  label = { shop = true, },
  catalogue = { '玉箫' }
},

['萧老板'] = {
  name = '萧老板',
  id = 'xiao laoban',
  alternate_id = { 'xiao', 'laoban' },
  location = '扬州城乐器店',
  label = { shop = true, },
  catalogue = { '箫' }
},

['于三娘'] = {
  name = '于三娘',
  id = 'yu sanniang',
  alternate_id = { 'yu', 'sanniang' },
  location = '襄阳城成衣铺',
  label = { shop = true, },
  catalogue = { '锦虎披风' }
},

['小贩#NY'] = {
  name = '小贩',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '南阳城城中心',
  label = { shop = true, },
  catalogue = { '水壶' }
},

['老裁缝#CA'] = {
  name = '老裁缝',
  id = 'lao caifeng',
  alternate_id = { 'caifeng' },
  location = '长安城裁缝铺',
  label = { shop = true, },
  catalogue = { '锦虎披风' }
},

['买卖提'] = {
  name = '买卖提',
  id = 'maimaiti',
  alternate_id = { 'seller' },
  location = '伊犁城商铺',
  label = { shop = true, },
  catalogue = { '火折', '青葫芦', '大酒囊', '水囊', '乳酪', '马刀', '马鞭', '寓意草', '阿拉伯弯刀', '硫磺', '坛子' }
},

['波斯生意人'] = {
  name = '波斯生意人',
  id = 'shengyi ren',
  alternate_id = { 'dealer', 'ren' },
  location = '回疆哈萨克小店',
  label = { shop = true, },
  catalogue = { '哈密瓜', '大酒囊', '水囊', '乳酪', '马刀', '马鞭', '阿拉伯弯刀' }
},

--------------------------------------------------------------------------------
-- Food shops

['跑堂#XY'] = {
  name = '跑堂',
  id = 'pao tang',
  alternate_id = { 'waiter', 'pao', 'tang' },
  location = '襄阳城小吃店',
  label = { shop = true, },
  catalogue = { '面汤', '馒头', '月饼' }
},

['跑堂#YZ'] = {
  name = '跑堂',
  id = 'pao tang',
  alternate_id = { 'waiter', 'paotang' },
  location = '扬州城小吃店',
  label = { shop = true, },
  catalogue = { '烤鸡腿', '烤鸭', '月饼', '包子', '牛皮酒袋', '花雕酒袋' }
},

['跑堂#JX'] = {
  name = '跑堂',
  id = 'paotang',
  alternate_id = { 'waiter' },
  location = '嘉兴城烟雨楼#1',
  label = { shop = true, },
  catalogue = { '烤鸡腿', '烤鸭', '月饼', '包子', '牛皮酒袋', '花雕酒袋' }
},

['跑堂#FZ'] = {
  name = '跑堂',
  id = 'pao tang',
  alternate_id = { 'waiter', 'pao' },
  location = '福州城酒馆',
  label = { shop = true, },
  catalogue = { '馒头', '烤鸭', '月饼', '包子', '牛皮酒袋', '花雕酒袋' }
},

['跑堂#PDZ'] = {
  name = '跑堂',
  id = 'paotang',
  alternate_id = { 'waiter' },
  location = '福州城酒馆',
  label = { shop = true, },
  catalogue = { '烤鸡腿', '烤鸭', '包子', '牛皮酒袋', '花雕酒袋' }
},

['跑堂#TG'] = {
  name = '跑堂',
  id = 'paotang',
  alternate_id = { 'waiter' },
  location = '塘沽城小酒馆',
  label = { shop = true, },
  catalogue = { '烤鸡腿', '烤鸭', '包子', '月饼', '牛皮酒袋', '花雕酒袋' }
},

['茶博士#XY'] = {
  name = '茶博士',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '襄阳城天香楼',
  label = { shop = true, },
  catalogue = { '五香花生' }
},

['茶博士#YZ'] = {
  name = '茶博士',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '扬州城茶馆',
  label = { shop = true, },
  catalogue = { '五香花生#YZ', '翡翠豆腐' }
},

['茶博士#DL'] = {
  name = '茶博士',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '大理城茶馆',
  label = { shop = true, },
  catalogue = { '五香花生#YZ', '翡翠豆腐' }
},

['茶博士#FZ'] = {
  name = '茶博士',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '福州城茶楼',
  label = { shop = true, },
  catalogue = { '五香花生' }
},

['茶馆小二'] = {
  name = '茶馆小二',
  id = 'chaguan xiaoer',
  alternate_id = { 'xiaoer', 'waiter' },
  location = '长安城茶馆',
  label = { shop = true, },
  catalogue = { '五香花生', '茶壶' }
},

['店小二#HZTXL'] = {
  name = '店小二',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '杭州城天香楼',
  label = { shop = true, },
  catalogue = { '菱白虾仁', '樱桃火腿', '菏叶冬笋汤', '烤鸭', '花雕酒袋', '包子#HZ' }
},

['店小二#SZ'] = {
  name = '店小二',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '苏州城春在楼',
  label = { shop = true, },
  catalogue = { '菱白虾仁', '樱桃火腿', '菏叶冬笋汤', '烤鸭', '牛皮酒袋', '包子#HZ' }
},

['店小二#LZZ'] = {
  name = '店小二',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '柳宗镇四季小吃店',
  label = { shop = true, },
  catalogue = { '烤鸡腿', '馒头', '面汤', '包子', '牛皮酒袋' }
},

['张千'] = {
  name = '张千',
  id = 'zhang qian',
  alternate_id = { 'zhang', 'qian' },
  location = '大理城风味小吃店',
  label = { shop = true, },
  catalogue = { '狗不理包子', '东山羊', '龙抄手', '羊肉泡馍' }
},

['豆腐西施'] = {
  name = '豆腐西施',
  id = 'doufu xishi',
  alternate_id = { 'xishi' },
  location = '大理城豆腐坊',
  label = { shop = true, },
  catalogue = { '翡翠豆腐#DL', '板豆腐', '豆腐干' }
},

['欧阳老板'] = {
  name = '欧阳老板',
  id = 'ouyang laoban',
  alternate_id = { 'ouyang' },
  location = '大理城豆腐坊',
  label = { shop = true, },
  catalogue = { '花雕酒袋#DL', '山鸡肉', '烤鸭#DL' }
},

['侍女#SZ'] = {
  name = '侍女',
  id = 'shi nv',
  alternate_id = { 'nv', 'waiter' },
  location = '苏州城茶馆',
  label = { shop = true, },
  catalogue = { '水蜜桃#SZ', '瓷茶碗' }
},

['王老汉'] = {
  name = '王老汉',
  id = 'wang laohan',
  alternate_id = { 'wang' },
  location = '佛山镇烧饼摊',
  label = { shop = true, },
  catalogue = { '烧饼', '油条', '麻花辫子' }
},

['万老板'] = {
  name = '万老板',
  id = 'wan laoban',
  alternate_id = { 'laoban' },
  location = '佛山镇英雄楼',
  label = { shop = true, },
  catalogue = { '素煎饺', '牛皮酒袋' }
},

['萨老板'] = {
  name = '萨老板',
  id = 'sa laoban',
  alternate_id = { 'sa', 'laoban' },
  location = '福州城小酒馆',
  label = { shop = true, },
  catalogue = { '牛皮酒袋', '花雕酒袋', '烤鸡腿', '粽子#FZ', '臭鸭蛋' }
},

['烧饼刘'] = {
  name = '烧饼刘',
  id = 'shaobing liu',
  alternate_id = { 'liu' },
  location = '襄阳城烧饼铺',
  label = { shop = true, },
  catalogue = { '烧饼' }
},

['包子王'] = {
  name = '包子王',
  id = 'baozi wang',
  alternate_id = { 'wang' },
  location = '襄阳城包子铺',
  label = { shop = true, },
  catalogue = { '包子' }
},

['胡贵'] = {
  name = '胡贵',
  id = 'hu gui',
  alternate_id = { 'hu', 'gui', 'hugui' },
  location = '大雪山溢香楼',
  label = { shop = true, },
  catalogue = { '烧酒', '大王肉饼' }
},

['胖嫂'] = {
  name = '胖嫂',
  id = 'pang sao',
  alternate_id = { 'pangsao', 'sao' },
  location = '长安城水果店',
  label = { shop = true, },
  catalogue = { '苹果', '白梨', '芒果', '水蜜桃', '荔枝', '哈蜜瓜', '桔子' }
},

['阿拉木罕'] = {
  name = '阿拉木罕',
  id = 'alamuhan',
  alternate_id = { 'ala', 'muhan' },
  location = '伊犁城客栈',
  label = { shop = true, },
  catalogue = { '羊肉串', '馕', '哈密瓜#XX' }
},

--------------------------------------------------------------------------------
-- Pharmacies

['老者#FZ'] = {
  name = '老者',
  id = 'lao zhe',
  alternate_id = { 'lao', 'zhe' },
  location = '福州城药铺',
  label = { shop = true, },
  catalogue = { '金创药', '养精丹', '百草丹' }
},

['药铺伙计#HZ'] = {
  name = '药铺伙计',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '杭州城万年春',
  label = { shop = true, },
  catalogue = { '莲子丸', '正气丹' }
},

['药铺伙计#SZ'] = {
  name = '药铺伙计',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '苏州城立春堂',
  label = { shop = true, },
  catalogue = { '莲子丸', '正气丹' }
},

['药铺伙计#YZ'] = {
  name = '药铺伙计',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '扬州城药铺',
  label = { shop = true, },
  catalogue = { '金创药', '养精丹', '金元散', '肘後备急方' }
},

['药铺伙计#PDZ'] = {
  name = '药铺伙计',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '平定州药铺',
  label = { shop = true, },
  catalogue = { '金创药', '养精丹', '肘後备急方' }
},

['伙计#LZ'] = {
  name = '伙计',
  id = 'huoji',
  location = '兰州城皮货药材店',
  label = { shop = true, },
  catalogue = { '金创药' }
},

['平一指'] = {
  name = '平一指',
  id = 'ping yizhi',
  alternate_id = { 'ping' },
  location = '襄阳城药材铺',
  label = { shop = true, },
  catalogue = { '金创药', '回阳五龙膏' }
},

['薛慕华'] = {
  name = '薛慕华',
  id = 'xue muhua',
  alternate_id = { 'xue' },
  location = '柳宗镇正厅#2',
  label = { shop = true, },
  catalogue = { '金创药', '回阳五龙膏' }
},

['药师#SS'] = {
  name = '药师',
  id = 'yao shi',
  alternate_id = { 'yao', 'shi' },
  location = '嵩山药房',
  label = { shop = true, },
  catalogue = { '金创药', '回阳五龙膏' }
},

['药师#MJ'] = {
  name = '药师',
  id = 'yao shi',
  alternate_id = { 'yao', 'shi' },
  location = '明教药房',
  label = { shop = true, },
  catalogue = { '金创药', '回阳五龙膏', '暗杀匕首', '玉洞黑石丹', '三黄宝腊丸', '玉真散', '三冈识略' }
},

['胡青牛'] = {
  name = '胡青牛',
  id = 'hu qingniu',
  alternate_id = { 'hu' },
  location = '蝴蝶谷厢房#N',
  label = { shop = true, },
  catalogue = { '金创药', '回阳五龙膏', '玉洞黑石丹', '三黄宝腊丸', '玉真散', '玉露清新散', '天王护心丹', '百草丹', '玉灵散' }
},

--------------------------------------------------------------------------------
-- Groceries

['牛老板#XY'] = {
  name = '牛老板',
  id = 'niu laoban',
  alternate_id = { 'niu', 'laoban' },
  location = '襄阳城杂货铺',
  label = { shop = true, grocery = true, },
  catalogue = { '火折' }
},

['刘老实'] = {
  name = '刘老实',
  id = 'liu laoshi',
  alternate_id = { 'liu', 'laoshi' },
  location = '长安城杂货铺',
  label = { shop = true, grocery = true, },
  catalogue = { '火折', '绣花针' }
},

['杂货铺老板#JX'] = {
  name = '杂货铺老板',
  id = 'lao ban',
  alternate_id = { 'laoban' },
  location = '嘉兴城杂货铺',
  label = { shop = true, grocery = true, },
  catalogue = { '清水葫芦', '竹剑', '火折', '竹棒' }
},

['李老板#HZ'] = {
  name = '李老板',
  id = 'li laoban',
  alternate_id = { 'li' },
  location = '杭州城杂货铺',
  label = { shop = true, grocery = true, },
  catalogue = { '长剑', '钢刀', '火折', '竹棒' }
},

['陈阿婆'] = {
  name = '陈阿婆',
  id = 'chen apo',
  alternate_id = { 'chen', 'apo' },
  location = '福州城杂货铺',
  label = { shop = true, grocery = true, },
  catalogue = { '绣花针' }
},

['杂货铺老板#YZ'] = {
  name = '杂货铺老板',
  id = 'lao ban',
  alternate_id = { 'laoban' },
  location = '扬州城杂货铺',
  label = { grocery = true, },
},

['赵老板#DL'] = {
  name = '赵老板',
  id = 'zhao laoban',
  alternate_id = { 'zhao', 'laoban' },
  location = '大理城杂货铺',
  label = { grocery = true, },
},

['小贩#HS'] = {
  name = '小贩',
  id = 'xiao fan',
  location = '华山村杂货铺',
  label = { shop = true, grocery = true, },
  catalogue = { '水壶' }
},

['伙计#TG'] = {
  name = '伙计',
  id = 'huo ji',
  alternate_id = { 'huoji' },
  location = '塘沽城杂货铺',
  label = { grocery = true, },
},

['李老板#FS'] = {
  name = '李老板',
  id = 'li',
  alternate_id = { 'laoban' },
  location = '佛山镇杂货店',
  label = { shop = true, grocery = true, },
  catalogue = { '火折', '剃刀' }
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

--------------------------------------------------------------------------------
-- generate special npc list

npc.bank_list, npc.shop_list, npc.pawnshop_list, npc.grocery_list  = {}, {}, {}, {}
for name, person in pairs( npc ) do
  if person.label and person.label.bank then npc.bank_list[ name ] = person end
  if person.label and person.label.shop then npc.shop_list[ name ] = person end
  if person.label and person.label.pawnshop then npc.pawnshop_list[ name ] = person end
  if person.label and person.label.grocery then npc.grocery_list[ name ] = person end
end

return npc
