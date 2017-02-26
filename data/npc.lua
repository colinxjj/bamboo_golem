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
  id = 'zhang suanpan',
  alternate_id = { 'zhang', 'suanpan', 'pan' },
  location = '���ݳǴ��ի',
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
-- Other

['�ٱ�'] = {
  name = '�ٱ�',
  id = 'guan bing',
  alternate_id = { 'bing', 'guanbing', 'soldier' },
  is_not_unique = true,
  location = '���˯��',
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
