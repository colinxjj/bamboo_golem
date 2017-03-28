
local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

finder.data = {}

-- withdraw money (ͭǮ���������ƽ�) from bank
function finder:withdraw()
  local count = inventory.get_item_count( self.item )
  count = self.count - count
  count = count > 0 and count or 1
  self:send{ 'qu ' .. count .. ' ' .. item.get_id( self.item ); complete_func = self.check_source_result }
end

-- drink water from source
function finder:drink()
  self:send{ 'drink' }
end
function finder:drink_full()
  self.result = '��ˮ'
  self:complete()
end
trigger.new{ name = 'drink_succeed', group = 'item_finder.drink', match = '^(> )*��(����һ��|ſ��|����һ|Ҩ��һ��|�������|��������|��ˮưҨ��һ��)', func = finder.drink }
trigger.new{ name = 'drink_full', group = 'item_finder.drink', match = '^(> )*(���̫����|���Ѿ��ȵ�̫����|����Ҳ�Ȳ�����|����ô�����ˮ|��Ȼ�㻹���)', func = finder.drink_full }

-- ask for an item from npc and get it from ground
function finder:cmd_and_get( source )
  -- if item is not on ground already, send source cmd first
  if not room.has_object( source.item ) then self:send{ source.cmd } end
  -- always get item from ground, since it's sent to ground after cmd
  self:send{ 'get ' .. item.get_id( source.item ); complete_func = self.check_inventory }
end

-- ������ͨ������
function finder:sld_lingpai()
	self:send{ 'steal ͨ������'; complete_func = finder.sld_lingpai_check }
end
function finder:sld_lingpai_succeed()
  self:disable_trigger_group 'item_finder.sld_lingpai'
  inventory.add_item 'ͨ������'
end
trigger.new{ name = 'sld_lingpai_succeed', group = 'item_finder.sld_lingpai', match = '^(> )*��ɹ���͵���˿�ͨ������!$', func = finder.sld_lingpai_succeed }
function finder:sld_lingpai_check()
  if inventory.has_item 'ͨ������' then
    self:check_source_result()
  else
    self:resume()
  end
end

-- ��Դ�ؽ�����
function finder:ty_fish()
  if inventory.is_wielded() then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = finder.ty_fish }
  else
    self:send{ 'zhua yu' }
  end
end
function finder:ty_fish_retry()
  addbusy( 2 )
	self:send{ 'yun qi;zhua yu' }
end
function finder:ty_fish_done()
  inventory.add_item '������'
  self:check_source_result()
end
trigger.new{ name = 'ty_fish_missed', group = 'item_finder.ty_fish', match = '^(> )*����������ȥ׽�ǶԽ����ޣ�һ��һ������ס�˽����޵�β����������������', func = finder.ty_fish_retry }
trigger.new{ name = 'ty_fish_caught', group = 'item_finder.ty_fish', match = '^(> )*�����ֵ����������Ǵ�ʯ��������һ̧��ֻ����ʯ΢΢ҡ����˫�������;٣�', func = finder.ty_fish_done }

-- ��Դ������
function finder:ty_boat()
  if not inventory.has_item '������' then
    self:newsub{ class = 'get_item', item = '������' }
  elseif room.has_object '����' then
    inventory.remove_item '������'
    self:send{ 'give jin wawa to yu ren' }
  else
    self:fail()
  end
end
function finder:ty_boat_succeed()
  self:disable_trigger_group 'item_finder.ty_boat'
  inventory.add_item '����'
  self:check_source_result()
end
trigger.new{ name = 'ty_boat_succeed', group = 'item_finder.ty_boat', match = '^(> )*���˸�����һ�����ۡ�', func = finder.ty_boat_succeed }

-- ��ɽ����
function finder:hs_shuteng()
  self:send{ 'zhe shuteng' }
end
function finder:hs_shuteng_succeed()
  inventory.add_item '����'
  self:check_source_result()
end
function finder:hs_shuteng_fail()
  self:fail()
end
trigger.new{ name = 'hs_shuteng_succeed', group = 'item_finder.hs_shuteng', match = '^(> )*������������۶���һЩ���١�', func = finder.hs_shuteng_succeed }
trigger.new{ name = 'hs_shuteng_fail', group = 'item_finder.hs_shuteng', match = '^(> )*�����Ѿ������۹��ˡ�', func = finder.hs_shuteng_fail }

-- ��ɽ�ٿ�
function finder:hs_kuang()
  if not inventory.has_item '����' then
    self:newsub{ class = 'get_item', item = '����' }
  else
    self:send{ 'weave kuang' }
    inventory.add_item '�ٿ�'
    self:check_source_result()
  end
end

-- ��ľ�º�Կ��
-- TODO kill the guy who might appear when open shu
function finder:hmy_key()
  finder.data.hmy_key = 1
  self:send{ 'l shujia;l shuji;na shu 1 from jia;fankan shu' }
end
function finder:hmy_key_fail()
  finder.data.hmy_key = finder.data.hmy_key < 5 and finder.data.hmy_key + 1 or 1
  self:send{ ( 'na shu %d from jia;fankan shu' ):format( finder.data.hmy_key ) }
end
function finder:hmy_key_succeed()
  self:send{ '#wb 1500;open shu' }
end
function finder:hmy_key_done()
  inventory.add_item '��Կ��'
  self:check_source_result()
end
trigger.new{ name = 'hmy_key_fail', group = 'item_finder.hmy_key', match = '^�㷭���˼�ҳ����û��ʲô�ر�֮���������ַ��˻�ȥ��', func = finder.hmy_key_fail }
trigger.new{ name = 'hmy_key_succeed', group = 'item_finder.hmy_key', match = '^��ͻȻ�����Ȿ�ż��ƺ������ͱ����Щ��ͬ��������ʲô���������Ȿ���С�', func = finder.hmy_key_succeed }
trigger.new{ name = 'hmy_key_done', group = 'item_finder.hmy_key', match = '^�㻺�������йż��ļв㣬ȡ����Կ�ס�', func = finder.hmy_key_done }

-- get ������ or ���Ʊ� from ������
function mark_source_as_invalid()  -- mark ������ as invalid source for both weapons
  for _, iname in pairs{ '������', '���Ʊ�' } do
    for _, source in pairs( item.get( iname ).source ) do
      if source.location == '��Դ��������' then source.is_invalid = true end
    end
  end
end
function finder:ty_jia( source )
  local c = ( 'na %s from jia' ):format( source.item == '������' and 'duo' or 'bi' )
  self:send{ c; complete_func = self.check_inventory }
end
trigger.new{ name = 'ty_jia_mark_source', group = 'item_finder.ty_jia', match = '^(> )*��(�ӱ��������ó�һ��|�Ѿ��ù���)', func = mark_source_as_invalid }

-- get food from ������Сͯ and ��ɽ��������
function finder:auto_get()
  self:newweaksub{ class = 'kill_time', duration = 3, complete_func = self.check_inventory }
end

-- get tea at �һ����跿, ����ׯ�跿 and ����������ͤ, and get food at �һ������� and ����ׯ����
function finder:sit_and_wait( source )
  self:send{ 'sit chair' }
end
function finder:sit_and_wait_succeed( _, t )
  -- TODO mark all 3 sources as invalid for 120 seconds
  if t[ 4 ] == 'һ����' then self:send{ 'get moli huacha' } end
  self:send{ 'stand'; complete_func = self.check_inventory }
end
function finder:sit_and_wait_fail()
  self:check_source_result()
end
trigger.new{ name = 'sit_and_wait_succeed', group = 'item_finder.sit_and_wait', match = '^(> )*(Ѿ��|����|����|Сɳ��)�߹���������(����|��)��(һ�����򻨲�|һ����|һ���׷�)��', func = finder.sit_and_wait_succeed }
trigger.new{ name = 'sit_and_wait_fail', group = 'item_finder.sit_and_wait', match = '^(> )*(Ѿ���߹�������˵|�����߹�������˵|Сɳ���߹�������˵|�����߹������������)', func = finder.sit_and_wait_fail }

-- get �����˲� books
function finder:tlbb_book( source )
  -- a temp flag is needed to get the item
  if not player.temp_flag.dlhg_bookshelf then self:newsub{ class = 'get_flag', flag = 'dlhg_bookshelf' } return end
  -- if previously failed to get a book, no more chance in this session
  if player.temp_flag.dlhg_bookshelf_failed then self:fail() end
  if type( source ) == 'table' then finder.data.tlbb_book = source.item end
  self:send{ 'fan jia' }
end
function finder:tlbb_book_got_book()
  self:newsub{ class = 'get_info', inventory = true, complete_func = finder.tlbb_book_check_inventory }
end
function finder:tlbb_book_check_inventory()
  if inventory.has_item( finder.data.tlbb_book ) then
    self:check_source_result()
  else
    self:send{ 'fan jia' }
  end
end
function finder:tlbb_book_no_more_book()
  player.temp_flag.dlhg_bookshelf_failed = true
  self:fail()
end
trigger.new{ name = 'tlbb_book_got_book', group = 'item_finder.tlbb_book', match = '^(> )*��Ѿ����ۣ����ڴ�������ҵ�һ���飡$', func = finder.tlbb_book_got_book }
trigger.new{ name = 'tlbb_book_no_book', group = 'item_finder.tlbb_book', match = '^(> )*�㷭�˰��죬���ʲôҲû�ҵ���$', func = finder.tlbb_book }
trigger.new{ name = 'tlbb_book_no_more_book', group = 'item_finder.tlbb_book', match = '^(> )*���Ѿ��ù����ˣ���ô�����ã�$', func = finder.tlbb_book_no_more_book }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
