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

['����'] = {
  name = '����',
  id = 'shang ren',
  alternate_id = { 'shang', 'ren' },
  location = '��������̲',
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
  catalogue = { '��ˮ��«', '��', '����', '���' }
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
  label = { grocery = true, },
},

['���#TG'] = {
  name = '���',
  id = 'huo ji',
  alternate_id = { 'huoji' },
  location = '�������ӻ���',
  label = { grocery = true, },
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
