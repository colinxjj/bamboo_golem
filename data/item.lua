local item = {

--------------------------------------------------------------------------------
-- money

['Í­Ç®'] = {
  name = 'Í­Ç®',
  id = 'coin',
  type = 'money',
},

['°×Òø'] = {
  name = '°×Òø',
  id = 'silver',
  type = 'money',
},

['»Æ½ð'] = {
  name = '»Æ½ð',
  id = 'gold',
  type = 'money',
},

--------------------------------------------------------------------------------
-- normal weapon

['³¤½£'] = {
  name = '³¤½£',
  id = 'chang jian',
  alternate_id = { 'changjian', 'jian' },
  type = 'sword',
  weight = 5000,
  value = 1500,
  quality = 20,
},

['¸Ö½£'] = {
  name = '¸Ö½£',
  id = 'jian',
  alternate_id = { 'sword' },
  type = 'sword',
  weight = 6000,
  value = 2000,
  quality = 30,
},

['¸Öµ¶'] = {
  name = '¸Öµ¶',
  id = 'blade',
  alternate_id = { 'dao' },
  type = 'blade',
  weight = 5000,
  value = 1000,
  quality = 20,
  source = {
    { type = 'cmd', location = 'ÌìÉ½±øÆ÷ÊÒ', cmd = 'na dao', }
  }
},

['Ä¾½£'] = {
  name = 'Ä¾½£',
  id = 'mu jian',
  alternate_id = { 'jian' },
  type = 'sword',
  weight = 300,
  value = 1270,
  quality = 5,
},

['Öñ½£'] = {
  name = 'Öñ½£',
  id = 'zhu jian',
  alternate_id = { 'jian', 'sword' },
  type = 'sword',
  weight = 1000,
  value = 100,
  quality = 5,
},

['Öñ°ô'] = {
  name = 'Öñ°ô',
  id = 'zhubang',
  type = 'stick',
  weight = 3000,
  value = 200,
  quality = 25,
},

['Ðå»¨Õë'] = {
  name = 'Ðå»¨Õë',
  id = 'xiuhua zhen',
  alternate_id = { 'zhen', 'needle' },
  type = 'sword',
  weight = 500,
  value = 200,
  quality = 10,
},

--------------------------------------------------------------------------------
-- vendor drinks

['ÇåË®ºùÂ«'] = {
  name = 'ÇåË®ºùÂ«',
  id = 'qingshui hulu',
  alternate_id = { 'hulu' },
  type = 'bottle',
  weight = 700,
  value = 100,
  capacity = 15,
},

--------------------------------------------------------------------------------
-- vendor misc goods

['´ÖÉþ×Ó'] = {
  name = '´ÖÉþ×Ó',
  id = 'cu shengzi',
  value = 1000,
},

['»ðÕÛ'] = {
  name = '»ðÕÛ',
  id = 'fire',
  weight = 80,
  value = 100,
},

--------------------------------------------------------------------------------
-- normal armor

['Ìú¼×'] = {
  name = 'Ìú¼×',
  id = 'tie jia',
  alternate_id = { 'tiejia', 'armor', 'jia' },
  type = 'cloth',
  weight = 20000,
  value = 2000,
  quality = 50,
},

['ôä´ä»¤Íó'] = {
  name = 'ôä´ä»¤Íó',
  id = 'feicui huwan',
  alternate_id = { 'huwan' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['Ì´Ä¾»¤ÐØ'] = {
  name = 'Ì´Ä¾»¤ÐØ',
  id = 'tanmu huxiong',
  alternate_id = { 'huxiong' },
  type = 'wrist',
  weight = 500,
  quality = 4,
},

['µ¤·ï»¤Ñü'] = {
  name = 'µ¤·ï»¤Ñü',
  id = 'danfeng huyao',
  alternate_id = { 'huyao' },
  type = 'waist',
  weight = 500,
  quality = 4,
},

--------------------------------------------------------------------------------
-- treasure armor

['Ä¾ÃÞôÂôÄ'] = {
  name = 'Ä¾ÃÞôÂôÄ',
  id = 'mumian jiasha',
  alternate_id = { 'mimian', 'jiasha' },
  type = 'cloth',
  weight = 5000,
  quality = 150,
},




}

return item
