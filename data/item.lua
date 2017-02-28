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
-- vendor weapon

['����'] = {
  name = '����',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  power = 20,
},

['�ֽ�'] = {
  name = '�ֽ�',
  id = 'jian',
  alternate_id = { 'sword' },
  type = 'sword',
  weight = 6000,
  value = 2000,
  power = 30,
},

['�ֵ�'] = {
  name = '�ֵ�',
  id = 'blade',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 5000,
  value = 1000,
  power = 20,
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
-- vendor armor

['����'] = {
  name = '����',
  id = 'tie jia',
  alternate_id = { 'tiejia', 'armor', 'jia' },
  type = 'armor',
  weight = 20000,
  value = 2000,
  power = 50,
},

}

return item
