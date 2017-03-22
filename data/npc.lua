local npc = {

--------------------------------------------------------------------------------
-- ���

['������'] = {
  name = '������',
  id = 'wang chuzi',
  alternate_id = { 'wang', 'chuzi', },
  location = '��ݳ���',
  label = { food = true, water = true, },
},

['��ԫ'] = {
  name = '��ԫ',
  id = 'bo yuan',
  alternate_id = { 'bo', 'yuan', },
  location = '����鷿',
  label = { literate = true, },
},

['�⿲'] = {
  name = '�⿲',
  id = 'wu kan',
  alternate_id = { 'wu', 'kan', },
  location = '�����Ʒ��',
},

['³��'] = {
  name = '³��',
  id = 'lu kun',
  alternate_id = { 'lu', 'kun', 'man', },
  location = '�����ݴ���',
},

['��ݽ�ͷ'] = {
  name = '��ݽ�ͷ',
  id = 'wuguan jiaotou',
  alternate_id = { 'jiaotou', },
  label = { master = true, },
},

['����ɽ'] = {
  name = '����ɽ',
  id = 'wan zhenshan',
  alternate_id = { 'wan', 'zhenshan', 'guanzhu' },
  location = '��ݶ�ů��',
},

['�ݷ�'] = {
  name = '�ݷ�',
  id = 'qi fang',
  alternate_id = { 'qi', 'fang', 'woman' },
  location = '���˯��',
},

--------------------------------------------------------------------------------
-- ����

['�����'] = {
  name = '�����',
  id = 'li banxian',
  alternate_id = { 'li', 'banxian', 'xiansheng' },
  location = '���ݳǶ����',
  range = 2,
},

['�ɳ���'] = {
  name = '�ɳ���',
  id = 'xi zhanglao',
  alternate_id = { 'xi', 'zhanglao' },
  location = '���ݳ�Ĺ��',
},

--------------------------------------------------------------------------------
-- ����

['������'] = {
  name = '������',
  id = 'zhu wanli',
  alternate_id = { 'zhu', 'wanli' },
  location = '�������վ',
},

['������'] = {
  name = '������',
  id = 'duan zhengchun',
  alternate_id = { 'duan', 'master' },
  location = '��������ů��',
},

['������'] = {
  name = '������',
  id = 'duan zhengming',
  alternate_id = { 'duan', 'master' },
  location = '����ʹ�����',
},

--------------------------------------------------------------------------------
-- ������

['���ٳ���'] = {
  name = '���ٳ���',
  id = 'kurong zhanglao',
  alternate_id = { 'kurong', 'zhanglao' },
  location = '����������Ժ',
},

--------------------------------------------------------------------------------
-- �ƺ�����

['���'] = {
  name = '���',
  id = 'hu fei',
  alternate_id = { 'hu', 'fei' },
  location = '�ƺ�����Ĺ��',
},

--------------------------------------------------------------------------------
-- ����ɽ

['���ʦ̫'] = {
  name = '���ʦ̫',
  id = 'miejue shitai',
  alternate_id = { 'miejue', 'shitai' },
  location = '����ɽ���',
},

['����ʦ̫'] = {
  name = '����ʦ̫',
  id = 'jingxian shitai',
  alternate_id = { 'jingxian', 'shitai' },
  location = '����ɽ������',
},

['�º���'] = {
  name = '�º���',
  id = 'guhong zi',
  alternate_id = { 'guhong', 'zi' },
  location = '����ɽɽ��',
},

--------------------------------------------------------------------------------
-- �һ���

['����'] = {
  name = '����',
  id = 'huang rong',
  alternate_id = { 'huang', 'rong' },
  location = '�һ�������#1',
},

['��ҩʦ'] = {
  name = '��ҩʦ',
  id = 'huang yaoshi',
  alternate_id = { 'huang', 'yaoshi' },
  location = '�һ�������ͤ',
},

['�ܲ�ͨ'] = {
  name = '�ܲ�ͨ',
  id = 'zhou botong',
  alternate_id = { 'zhou', 'botong' },
  location = '�һ�������ͤ',
},

--------------------------------------------------------------------------------
-- ����ׯ

['½�˷�'] = {
  name = '½�˷�',
  id = 'lu chengfeng',
  alternate_id = { 'lu', 'chengfeng' },
  location = '����ׯ�鷿',
},

['½��Ӣ'] = {
  name = '½��Ӣ',
  id = 'lu guanying',
  alternate_id = { 'lu', 'guanying' },
  location = '����ׯǰ��',
},

--------------------------------------------------------------------------------
-- ���ݳ�

['���˷�'] = {
  name = '���˷�',
  id = 'miao renfeng',
  alternate_id = { 'miao', 'renfeng' },
  location = '���ݳ�����',
},

--------------------------------------------------------------------------------
-- �䵱ɽ

['��Զ��'] = {
  name = '��Զ��',
  id = 'song yuanqiao',
  alternate_id = { 'song' },
  location = '�䵱ɽ�����',
},

['��ҩ����'] = {
  name = '��ҩ����',
  id = 'caiyao daozhang',
  alternate_id = { 'caiyao', 'daozhang' },
  location = '�䵱ɽɽ·#2',
},

['������'] = {
  name = '������',
  id = 'zhang sanfeng',
  alternate_id = { 'zhang', 'sanfeng' },
  location = '�䵱ɽ��ɽСԺ',
},

['�������'] = {
  name = '�������',
  id = 'guxu daozhang',
  alternate_id = { 'guxu' },
  location = '�䵱ɽ�����',
  provide = {
    { item = '̴ľ����', cmd = 'ask guxu daozhang about ����', cond = 'player.party == "�䵱��"', },
    { item = '���ﻤ��', cmd = 'ask guxu daozhang about ����', cond = 'player.party == "�䵱��"', },
    { item = '��令��', cmd = 'ask guxu daozhang about ����', cond = 'player.party == "�䵱��"', },
  },
},

--------------------------------------------------------------------------------
-- ��ɽ

['������'] = {
  name = '������',
  id = 'zuo lengchan',
  alternate_id = { 'zuo', 'lengchan' },
  location = '��ɽ����̨',
},

--------------------------------------------------------------------------------
-- ؤ��

['���߹�'] = {
  name = '���߹�',
  id = 'hong qigong',
  alternate_id = { 'hong', 'qigong' },
  location = 'ؤ���Ժ',
},

['³�н�'] = {
  name = '³�н�',
  id = 'lu youjiao',
  alternate_id = { 'lu', 'youjiao' },
  location = 'ؤ��������',
},

--------------------------------------------------------------------------------
-- ����ɽ

['�Ϲٽ���'] = {
  name = '�Ϲٽ���',
  id = 'shangguan jiannan',
  alternate_id = { 'shangguan', 'jiannan' },
  location = '����ɽʯ��',
},

['��ǧ��'] = {
  name = '��ǧ��',
  id = 'qiu qianren',
  alternate_id = { 'qiu', 'qianren' },
  location = '����ɽ���᷿',
},

['��ǧ��'] = {
  name = '��ǧ��',
  id = 'qiu qianzhang',
  alternate_id = { 'qiu', 'qianzhang' },
  location = '����ɽ�㳡',
  range = 2,
},

--------------------------------------------------------------------------------
-- ţ�Ҵ�

['ɵ��'] = {
  name = 'ɵ��',
  id = 'sha gu',
  alternate_id = { 'shagu' },
  location = 'ţ�Ҵ�С�Ƶ�',
},

--------------------------------------------------------------------------------
-- ��ѩɽ

['Ѫ������'] = {
  name = 'Ѫ������',
  id = 'xuedao laozu',
  alternate_id = { 'xuedaolaozu', 'laozu' },
  location = '��ѩɽѩ��',
},

['����'] = {
  name = '����',
  id = 'di yun',
  alternate_id = { 'di', 'yun' },
  location = '��ѩɽ��ʯ',
},

['�Ħ��'] = {
  name = '�Ħ��',
  id = 'jiumo zhi',
  alternate_id = { 'jiumo', 'zhi' },
  location = '��ѩɽ���ö�¥',
},

['����'] = {
  name = '����',
  id = 'bao xiang',
  alternate_id = { 'baoxiang', 'bao', 'xiang' },
  location = '��ѩɽ���Ŀ�',
},

--------------------------------------------------------------------------------
-- ���ݳ�

['����'] = {
  name = '����',
  id = 'ding dian',
  alternate_id = { 'ding' },
  location = '���ݳǼ���',
},

--------------------------------------------------------------------------------
-- ����ɽ

['����'] = {
  name = '����',
  id = 'yin li',
  alternate_id = { 'yin', 'li' },
  location = '����ɽ������ɽ��',
  range = 10,
},

['��̫��'] = {
  name = '��̫��',
  id = 'he taichong',
  alternate_id = { 'he' },
  location = '����ɽ���پ�',
},

['�����'] = {
  name = '�����',
  id = 'ban shuxian',
  alternate_id = { 'ban' },
  location = '����ɽ��ʥ��',
},

['�����'] = {
  name = '�����',
  id = 'he zudao',
  alternate_id = { 'he' },
  location = '����ɽ�����',
},

--------------------------------------------------------------------------------
-- �����

['���'] = {
  name = '���',
  id = 'yang guo',
  alternate_id = { 'yang', 'guo' },
  location = '�����С��',
},

['С��Ů'] = {
  name = 'С��Ů',
  id = 'xiao longnv',
  alternate_id = { 'xiao', 'longnv' },
  location = '����ȴ���',
},

['����ֹ'] = {
  name = '����ֹ',
  id = 'gongsun zhi',
  alternate_id = { 'gongsun', 'zhi' },
  location = '����ȴ���',
},

--------------------------------------------------------------------------------
-- ���ݳ�

['�ⳤ��'] = {
  name = '�ⳤ��',
  id = 'wu zhanglao',
  alternate_id = { 'wu', 'zhanglao' },
  location = '���ݳǴ���',
},

['�½���'] = {
  name = '�½���',
  id = 'chen jinnan',
  alternate_id = { 'chen', 'jinnan' },
  location = '���ݳ�ʯ��',
  range = 3,
},

--------------------------------------------------------------------------------
-- ��ɽ����

['Ľ�ݲ�'] = {
  name = 'Ľ�ݲ�',
  id = 'murong bo',
  alternate_id = { 'murong', 'bo' },
  location = '��ɽ����С��',
},

['�ɽ�'] = {
  name = '�ɽ�',
  id = 'du jie',
  alternate_id = { 'du', 'jie' },
  location = '��ɽ���ֽ�շ�ħȦ',
  power_level = 24,
  loot = { 'ľ������' },
  provide = {
    { item = 'ľ������', cmd = 'ask du jie about ľ������', cond = 'player.power_level_parry >= 25' },
  },
},

['����'] = {
  name = '����',
  id = 'du nan',
  alternate_id = { 'du', 'nan' },
  location = '��ɽ���ֽ�շ�ħȦ',
},

['�ɶ�'] = {
  name = '�ɶ�',
  id = 'du e',
  alternate_id = { 'du', 'e' },
  location = '��ɽ���ֽ�շ�ħȦ',
},

--------------------------------------------------------------------------------
-- ��ɽ

['����Ⱥ'] = {
  name = '����Ⱥ',
  id = 'yue buqun',
  alternate_id = { 'yue', 'buqun' },
  location = '��ɽ������',
},

['������'] = {
  name = '������',
  id = 'ning zhongze',
  alternate_id = { 'ning' },
  location = '��ɽ������',
},

['�����'] = {
  name = '�����',
  id = 'linghu chong',
  alternate_id = { 'linghu', 'chong' },
  location = '��ɽСɽ·#2',
  range = 2,
},

['����ɺ'] = {
  name = '����ɺ',
  id = 'yue lingshan',
  alternate_id = { 'yue', 'lingshan' },
  location = '��ɽ��̳',
},

['������'] = {
  name = '������',
  id = 'mu renqing',
  alternate_id = { 'mu', 'renqing' },
  location = '��ɽʯ��',
},

--------------------------------------------------------------------------------
-- ��ɽ��

['����'] = {
  name = '����',
  id = 'wu po',
  alternate_id = { 'wu', 'po' },
  location = '��ɽ����̳��',
},

--------------------------------------------------------------------------------
-- ����

['���޼�'] = {
  name = '���޼�',
  id = 'zhang wuji',
  alternate_id = { 'zhang', 'wuji' },
  location = '����ʥ����',
},

--------------------------------------------------------------------------------
-- ���ԭ

['���ַ���'] = {
  name = '���ַ���',
  id = 'jinlun fawang',
  alternate_id = { 'jinlunfawang', 'jinlun', 'fawang' },
  location = '���ԭţƤ����',
},

['������'] = {
  name = '������',
  id = 'hu bilie',
  alternate_id = { 'hu', 'hubilie' },
  location = '���ԭţƤ����',
},

--------------------------------------------------------------------------------
-- �ؽ�

['��³��'] = {
  name = '��³��',
  id = 'su luke',
  alternate_id = { 'suluke', 'su' },
  location = '�ؽ���³�˵ļ�',
},

['������'] = {
  name = '������',
  id = 'ji laoren',
  alternate_id = { 'ji' },
  location = '�ؽ�С��',
},

--------------------------------------------------------------------------------
-- ��ľ��

['��������'] = {
  name = '��������',
  id = 'dongfang bubai',
  alternate_id = { 'dongfang', 'bubai' },
  location = '��ľ��С��',
},

--------------------------------------------------------------------------------
-- Banks

['Ǯ��'] = {
  name = 'Ǯ��',
  id = 'qian feng',
  alternate_id = { 'qianfeng', 'qian', 'feng' },
  location = '���ݳ����ի',
  label = { bank = true, },
},

['���ϰ�'] = {
  name = '���ϰ�',
  id = 'sun laoban',
  alternate_id = { 'sun', 'laoban' },
  location = '���ݳǾ۱�ի',
  label = { bank = true, },
},

['���ϰ�'] = {
  name = '���ϰ�',
  id = 'liu laoban',
  alternate_id = { 'liu', 'laoban' },
  location = '���ݳ�ͨ��ի',
  label = { bank = true, },
},

['������'] = {
  name = '������',
  id = 'jiang tiaohou',
  alternate_id = { 'jiang', 'tiaohou' },
  location = '���ݳ�������',
  label = { bank = true, },
},

['Ǯ�ۿ�'] = {
  name = 'Ǯ�ۿ�',
  id = 'qian yankai',
  alternate_id = { 'qian' },
  location = '����������Ǯׯ',
  label = { bank = true, },
},

['���ƹ�'] = {
  name = '���ƹ�',
  id = 'wang zhanggui',
  alternate_id = { 'wang', 'zhanggui' },
  location = '�ɶ���ī��ի',
  label = { bank = true, },
},

['���ƹ�'] = {
  name = '���ƹ�',
  id = 'yan zhanggui',
  alternate_id = { 'yan', 'zhanggui' },
  location = '����Ǵ���Ǯׯ',
  label = { bank = true, },
},

['������'] = {
  name = '������',
  id = 'cui suanpan',
  alternate_id = { 'cui', 'zhanggui' },
  location = '���ݳǽ�ի',
  label = { bank = true, },
},

['�����'] = {
  name = '�����',
  id = 'long juanfeng',
  alternate_id = { 'long', 'juanfeng' },
  location = '��������ի',
  label = { bank = true, },
},

['�츻'] = {
  name = '�츻',
  id = 'zhu fu',
  alternate_id = { 'zhu', 'fu' },
  location = '������Ǯׯ',
  label = { bank = true, },
},

['�Դ�ƽ'] = {
  name = '�Դ�ƽ',
  id = 'yan daping',
  alternate_id = { 'yan', 'daping' },
  location = '����ʷ�',
  label = { bank = true, },
},

['Ǯ����'] = {
  name = 'Ǯ����',
  id = 'qian shanren',
  alternate_id = { 'qian', 'banker' },
  location = '�����Ǳ���ի',
  label = { bank = true, },
},

['���ƹ�'] = {
  name = '���ƹ�',
  id = 'ma zhanggui',
  alternate_id = { 'ma', 'zhanggui' },
  location = '���޺���ի',
  label = { bank = true, },
},

['����'] = {
  name = '����',
  id = 'huang zhen',
  alternate_id = { 'huang', 'zhen' },
  location = '���޺����ի�ֵ�',
  label = { bank = true, },
},

--------------------------------------------------------------------------------
-- Shops

['����#SLD'] = {
  name = '����',
  id = 'shang ren',
  alternate_id = { 'shang', 'ren' },
  location = '��������̲',
  label = { shop = true, },
  catalogue = { '������', '����', }
},

['����#TS'] = {
  name = '����',
  id = 'shang ren',
  alternate_id = { 'ren' },
  location = '̩ɽ��ڷ�',
  label = { shop = true, },
  catalogue = { '������', '����', }
},

['����#TG'] = {
  name = '����',
  id = 'tie jiang',
  alternate_id = { 'tie', 'jiang' },
  location = '������������',
  label = { shop = true, },
  catalogue = { '����', '�ֽ�', '����', '�ֵ�', }
},

['����#SZ'] = {
  name = '����',
  id = 'tie jiang',
  alternate_id = { 'tie', 'jiang' },
  location = '���ݳǴ�����',
  label = { shop = true, },
  catalogue = { '����#SZ', '�ֽ�', '�˵�#SZ', '�ֵ�#SZ', '����#SZ', 'ذ��#SZ' }
},

['������'] = {
  name = '������',
  id = 'zhujian shi',
  alternate_id = { 'shi' },
  location = '��ԭ���ݱ�����',
  label = { shop = true, },
  catalogue = { '����#YZ', '�ֵ�', '���Ǵ�', '����', '����', '����', '����', '���#YZ', '�ָ�' }
},

['����ʦ'] = {
  name = '����ʦ',
  id = 'daoba zhang',
  alternate_id = { 'daoba', 'zhang' },
  location = '��ԭ���ݱ�����',
  label = { shop = true, },
  catalogue = { '����#YZ', '�ֵ�', '���Ǵ�', '����', '����', '����', '����', '���#YZ', '�ָ�', '��ɱذ��' }
},

['ľ��#XY'] = {
  name = 'ľ��',
  id = 'mu jiang',
  alternate_id = { 'mujiang', 'mu', 'jiang' },
  location = '������ľ����',
  label = { shop = true, },
  catalogue = { 'ľ��' }
},

['С����#SZ'] = {
  name = 'С����',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '���ݳǱ�����',
  label = { shop = true, },
  catalogue = { '��ˮ��«', '��#SZ', '����', '���#SZ' }
},

['С����#EM'] = {
  name = 'С����',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '����ɽ����',
  label = { shop = true, },
  catalogue = { '��ˮ��«#EM', '��', '����', '����', '����' }
},

['С����#MJ'] = {
  name = 'С����',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '����ɽ����',
  label = { shop = true, },
  catalogue = { 'ţƤ�ƴ�', '����', '���' }
},

['������'] = {
  name = '������',
  id = 'jiang laifu',
  alternate_id = { 'jiang', 'jianglaifu', 'laifu' },
  location = '��ѩɽ�����ӻ�',
  label = { shop = true, },
  catalogue = { '����', '���Ͳ�', '����̤����' }
},

['������'] = {
  name = '������',
  id = 'shen tiejiang',
  alternate_id = { 'shen', 'smith' },
  location = '��ɽ��������',
  label = { shop = true, },
  catalogue = { '�ٽ���', '����ذ', '��ʯ��', '������', 'ӥ�츫' }
},

['С��#FZ'] = {
  name = 'С��',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '���ݳǼ����ջ',
  label = { shop = true, },
  catalogue = { '����' }
},

['С��#XY'] = {
  name = 'С��',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '�����ǽ�����ջ',
  label = { shop = true, },
  catalogue = { '����' }
},

['���ϰ�'] = {
  name = '���ϰ�',
  id = 'zhu laoban',
  alternate_id = { 'zhu', 'laoban' },
  location = '���ݳ��鱦��',
  label = { shop = true, },
  catalogue = { '����' }
},

['�鱦��#CA'] = {
  name = '�鱦��',
  id = 'zhubao shang',
  alternate_id = { 'shang', 'laoban' },
  location = '�������鱦��',
  label = { shop = true, },
  catalogue = { '����' }
},

['���ϰ�'] = {
  name = '���ϰ�',
  id = 'xiao laoban',
  alternate_id = { 'xiao', 'laoban' },
  location = '���ݳ�������',
  label = { shop = true, },
  catalogue = { '��' }
},

['������'] = {
  name = '������',
  id = 'yu sanniang',
  alternate_id = { 'yu', 'sanniang' },
  location = '�����ǳ�����',
  label = { shop = true, },
  catalogue = { '��������' }
},

['С��#NY'] = {
  name = 'С��',
  id = 'xiao fan',
  alternate_id = { 'xiao', 'fan' },
  location = '�����ǳ�����',
  label = { shop = true, },
  catalogue = { 'ˮ��' }
},

['�ϲ÷�#CA'] = {
  name = '�ϲ÷�',
  id = 'lao caifeng',
  alternate_id = { 'caifeng' },
  location = '�����ǲ÷���',
  label = { shop = true, },
  catalogue = { '��������' }
},

['������'] = {
  name = '������',
  id = 'maimaiti',
  alternate_id = { 'seller' },
  location = '���������',
  label = { shop = true, },
  catalogue = { '����', '���«', '�����', 'ˮ��', '����', '��', '���', 'Ԣ���', '�������䵶', '���', '̳��' }
},

['��˹������'] = {
  name = '��˹������',
  id = 'shengyi ren',
  alternate_id = { 'dealer', 'ren' },
  location = '�ؽ�������С��',
  label = { shop = true, },
  catalogue = { '���ܹ�', '�����', 'ˮ��', '����', '��', '���', '�������䵶' }
},

--------------------------------------------------------------------------------
-- Food shops

['����#XY'] = {
  name = '����',
  id = 'pao tang',
  alternate_id = { 'waiter', 'pao', 'tang' },
  location = '������С�Ե�',
  label = { shop = true, },
  catalogue = { '����', '��ͷ', '�±�' }
},

['����#YZ'] = {
  name = '����',
  id = 'pao tang',
  alternate_id = { 'waiter', 'paotang' },
  location = '���ݳ�С�Ե�',
  label = { shop = true, },
  catalogue = { '������', '��Ѽ', '�±�', '����', 'ţƤ�ƴ�', '����ƴ�' }
},

['����#JX'] = {
  name = '����',
  id = 'paotang',
  alternate_id = { 'waiter' },
  location = '���˳�����¥#1',
  label = { shop = true, },
  catalogue = { '������', '��Ѽ', '�±�', '����', 'ţƤ�ƴ�', '����ƴ�' }
},

['����#FZ'] = {
  name = '����',
  id = 'pao tang',
  alternate_id = { 'waiter', 'pao' },
  location = '���ݳǾƹ�',
  label = { shop = true, },
  catalogue = { '��ͷ', '��Ѽ', '�±�', '����', 'ţƤ�ƴ�', '����ƴ�' }
},

['����#PDZ'] = {
  name = '����',
  id = 'paotang',
  alternate_id = { 'waiter' },
  location = '���ݳǾƹ�',
  label = { shop = true, },
  catalogue = { '������', '��Ѽ', '����', 'ţƤ�ƴ�', '����ƴ�' }
},

['����#TG'] = {
  name = '����',
  id = 'paotang',
  alternate_id = { 'waiter' },
  location = '������С�ƹ�',
  label = { shop = true, },
  catalogue = { '������', '��Ѽ', '����', '�±�', 'ţƤ�ƴ�', '����ƴ�' }
},

['�販ʿ#XY'] = {
  name = '�販ʿ',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '����������¥',
  label = { shop = true, },
  catalogue = { '���㻨��' }
},

['�販ʿ#YZ'] = {
  name = '�販ʿ',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '���ݳǲ��',
  label = { shop = true, },
  catalogue = { '���㻨��#YZ', '��䶹��' }
},

['�販ʿ#DL'] = {
  name = '�販ʿ',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '����ǲ��',
  label = { shop = true, },
  catalogue = { '���㻨��#YZ', '��䶹��' }
},

['�販ʿ#FZ'] = {
  name = '�販ʿ',
  id = 'cha boshi',
  alternate_id = { 'boshi' },
  location = '���ݳǲ�¥',
  label = { shop = true, },
  catalogue = { '���㻨��' }
},

['���С��'] = {
  name = '���С��',
  id = 'chaguan xiaoer',
  alternate_id = { 'xiaoer', 'waiter' },
  location = '�����ǲ��',
  label = { shop = true, },
  catalogue = { '���㻨��', '���' }
},

['��С��#HZTXL'] = {
  name = '��С��',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '���ݳ�����¥',
  label = { shop = true, },
  catalogue = { '���Ϻ��', 'ӣ�һ���', '��Ҷ������', '��Ѽ', '����ƴ�', '����#HZ' }
},

['��С��#SZ'] = {
  name = '��С��',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '���ݳǴ���¥',
  label = { shop = true, },
  catalogue = { '���Ϻ��', 'ӣ�һ���', '��Ҷ������', '��Ѽ', 'ţƤ�ƴ�', '����#HZ' }
},

['��С��#LZZ'] = {
  name = '��С��',
  id = 'xiao er',
  alternate_id = { 'xiao', 'waiter' },
  location = '�������ļ�С�Ե�',
  label = { shop = true, },
  catalogue = { '������', '��ͷ', '����', '����', 'ţƤ�ƴ�' }
},

['��ǧ'] = {
  name = '��ǧ',
  id = 'zhang qian',
  alternate_id = { 'zhang', 'qian' },
  location = '����Ƿ�ζС�Ե�',
  label = { shop = true, },
  catalogue = { '���������', '��ɽ��', '������', '��������' }
},

['������ʩ'] = {
  name = '������ʩ',
  id = 'doufu xishi',
  alternate_id = { 'xishi' },
  location = '����Ƕ�����',
  label = { shop = true, },
  catalogue = { '��䶹��#DL', '�嶹��', '������' }
},

['ŷ���ϰ�'] = {
  name = 'ŷ���ϰ�',
  id = 'ouyang laoban',
  alternate_id = { 'ouyang' },
  location = '����Ƕ�����',
  label = { shop = true, },
  catalogue = { '����ƴ�#DL', 'ɽ����', '��Ѽ#DL' }
},

['��Ů#SZ'] = {
  name = '��Ů',
  id = 'shi nv',
  alternate_id = { 'nv', 'waiter' },
  location = '���ݳǲ��',
  label = { shop = true, },
  catalogue = { 'ˮ����#SZ', '�ɲ���' }
},

['���Ϻ�'] = {
  name = '���Ϻ�',
  id = 'wang laohan',
  alternate_id = { 'wang' },
  location = '��ɽ���ձ�̯',
  label = { shop = true, },
  catalogue = { '�ձ�', '����', '�黨����' }
},

['���ϰ�'] = {
  name = '���ϰ�',
  id = 'wan laoban',
  alternate_id = { 'laoban' },
  location = '��ɽ��Ӣ��¥',
  label = { shop = true, },
  catalogue = { '�ؼ��', 'ţƤ�ƴ�' }
},

['���ϰ�'] = {
  name = '���ϰ�',
  id = 'sa laoban',
  alternate_id = { 'sa', 'laoban' },
  location = '���ݳ�С�ƹ�',
  label = { shop = true, },
  catalogue = { 'ţƤ�ƴ�', '����ƴ�', '������', '����#FZ', '��Ѽ��' }
},

['�ձ���'] = {
  name = '�ձ���',
  id = 'shaobing liu',
  alternate_id = { 'liu' },
  location = '�������ձ���',
  label = { shop = true, },
  catalogue = { '�ձ�' }
},

['������'] = {
  name = '������',
  id = 'baozi wang',
  alternate_id = { 'wang' },
  location = '�����ǰ�����',
  label = { shop = true, },
  catalogue = { '����' }
},

['����'] = {
  name = '����',
  id = 'hu gui',
  alternate_id = { 'hu', 'gui', 'hugui' },
  location = '��ѩɽ����¥',
  label = { shop = true, },
  catalogue = { '�վ�', '�������' }
},

['��ɩ'] = {
  name = '��ɩ',
  id = 'pang sao',
  alternate_id = { 'pangsao', 'sao' },
  location = '������ˮ����',
  label = { shop = true, },
  catalogue = { 'ƻ��', '����', 'â��', 'ˮ����', '��֦', '���۹�', '����' }
},

['����ľ��'] = {
  name = '����ľ��',
  id = 'alamuhan',
  alternate_id = { 'ala', 'muhan' },
  location = '����ǿ�ջ',
  label = { shop = true, },
  catalogue = { '���⴮', '��', '���ܹ�#XX' }
},

--------------------------------------------------------------------------------
-- Pharmacies

['����#FZ'] = {
  name = '����',
  id = 'lao zhe',
  alternate_id = { 'lao', 'zhe' },
  location = '���ݳ�ҩ��',
  label = { shop = true, },
  catalogue = { '��ҩ', '������', '�ٲݵ�' }
},

['ҩ�̻��#HZ'] = {
  name = 'ҩ�̻��',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '���ݳ����괺',
  label = { shop = true, },
  catalogue = { '������', '������' }
},

['ҩ�̻��#SZ'] = {
  name = 'ҩ�̻��',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '���ݳ�������',
  label = { shop = true, },
  catalogue = { '������', '������' }
},

['ҩ�̻��#YZ'] = {
  name = 'ҩ�̻��',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = '���ݳ�ҩ��',
  label = { shop = true, },
  catalogue = { '��ҩ', '������', '��Ԫɢ', '���ᱸ����' }
},

['ҩ�̻��#PDZ'] = {
  name = 'ҩ�̻��',
  id = 'yaopu huoji',
  alternate_id = { 'huoji' },
  location = 'ƽ����ҩ��',
  label = { shop = true, },
  catalogue = { '��ҩ', '������', '���ᱸ����' }
},

['���#LZ'] = {
  name = '���',
  id = 'huoji',
  location = '���ݳ�Ƥ��ҩ�ĵ�',
  label = { shop = true, },
  catalogue = { '��ҩ' }
},

['ƽһָ'] = {
  name = 'ƽһָ',
  id = 'ping yizhi',
  alternate_id = { 'ping' },
  location = '������ҩ����',
  label = { shop = true, },
  catalogue = { '��ҩ', '����������' }
},

['ѦĽ��'] = {
  name = 'ѦĽ��',
  id = 'xue muhua',
  alternate_id = { 'xue' },
  location = '����������#2',
  label = { shop = true, },
  catalogue = { '��ҩ', '����������' }
},

['ҩʦ#SS'] = {
  name = 'ҩʦ',
  id = 'yao shi',
  alternate_id = { 'yao', 'shi' },
  location = '��ɽҩ��',
  label = { shop = true, },
  catalogue = { '��ҩ', '����������' }
},

['ҩʦ#MJ'] = {
  name = 'ҩʦ',
  id = 'yao shi',
  alternate_id = { 'yao', 'shi' },
  location = '����ҩ��',
  label = { shop = true, },
  catalogue = { '��ҩ', '����������', '��ɱذ��', '�񶴺�ʯ��', '���Ʊ�����', '����ɢ', '����ʶ��' }
},

['����ţ'] = {
  name = '����ţ',
  id = 'hu qingniu',
  alternate_id = { 'hu' },
  location = '�������᷿#N',
  label = { shop = true, },
  catalogue = { '��ҩ', '����������', '�񶴺�ʯ��', '���Ʊ�����', '����ɢ', '��¶����ɢ', '�������ĵ�', '�ٲݵ�', '����ɢ' }
},

--------------------------------------------------------------------------------
-- Groceries

['ţ�ϰ�#XY'] = {
  name = 'ţ�ϰ�',
  id = 'niu laoban',
  alternate_id = { 'niu', 'laoban' },
  location = '�������ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { '����' }
},

['����ʵ'] = {
  name = '����ʵ',
  id = 'liu laoshi',
  alternate_id = { 'liu', 'laoshi' },
  location = '�������ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { '����', '�廨��' }
},

['�ӻ����ϰ�#JX'] = {
  name = '�ӻ����ϰ�',
  id = 'lao ban',
  alternate_id = { 'laoban' },
  location = '���˳��ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { '��ˮ��«', '��', '����', '���' }
},

['���ϰ�#HZ'] = {
  name = '���ϰ�',
  id = 'li laoban',
  alternate_id = { 'li' },
  location = '���ݳ��ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { '����', '�ֵ�', '����', '���' }
},

['�°���'] = {
  name = '�°���',
  id = 'chen apo',
  alternate_id = { 'chen', 'apo' },
  location = '���ݳ��ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { '�廨��' }
},

['�ӻ����ϰ�#YZ'] = {
  name = '�ӻ����ϰ�',
  id = 'lao ban',
  alternate_id = { 'laoban' },
  location = '���ݳ��ӻ���',
  label = { grocery = true, },
},

['���ϰ�#DL'] = {
  name = '���ϰ�',
  id = 'zhao laoban',
  alternate_id = { 'zhao', 'laoban' },
  location = '������ӻ���',
  label = { grocery = true, },
},

['С��#HS'] = {
  name = 'С��',
  id = 'xiao fan',
  location = '��ɽ���ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { 'ˮ��' }
},

['���#TG'] = {
  name = '���',
  id = 'huo ji',
  alternate_id = { 'huoji' },
  location = '�������ӻ���',
  label = { grocery = true, },
},

['���ϰ�#FS'] = {
  name = '���ϰ�',
  id = 'li',
  alternate_id = { 'laoban' },
  location = '��ɽ���ӻ���',
  label = { shop = true, grocery = true, },
  catalogue = { '����', '�굶' }
},

--------------------------------------------------------------------------------
-- Other

['�ٱ�'] = {
  name = '�ٱ�',
  id = 'guan bing',
  alternate_id = { 'bing', 'guanbing', 'soldier' },
  is_not_unique = true,
  location = '���˯��',
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
