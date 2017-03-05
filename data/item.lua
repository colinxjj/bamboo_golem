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
-- normal weapon

['����'] = {
  name = '����',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
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

['�ֵ�'] = {
  name = '�ֵ�',
  id = 'blade',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 5000,
  value = 1000,
  quality = 20,
  source = {
    { type = 'cmd', location = '��ɽ������', cmd = 'na dao', }
  }
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
  alternate_id = { 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 5,
},

['���'] = {
  name = '���',
  id = 'zhubang',
  type = 'stick',
  weight = 3000,
  value = 200,
  quality = 25,
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
-- vendor drinks

['��ˮ��«'] = {
  name = '��ˮ��«',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'bottle',
  weight = 700,
  value = 100,
  capacity = 15,
},

--------------------------------------------------------------------------------
-- vendor misc goods

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

--------------------------------------------------------------------------------
-- treasure armor

['ľ������'] = {
  name = 'ľ������',
  id = 'mumian jiasha',
  alternate_id = { 'mimian', 'jiasha' },
  type = 'cloth',
  weight = 5000,
  quality = 150,
},




}

return item
