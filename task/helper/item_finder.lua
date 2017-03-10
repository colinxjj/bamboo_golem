
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
    self:complete()
  else
    self:resume()
  end
end

-- ��Դ�ؽ�����
function finder:ty_fish()
  if player.wielded then
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
  self:complete()
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
  self:complete()
end
trigger.new{ name = 'ty_boat_succeed', group = 'item_finder.ty_boat', match = '^(> )*���˸�����һ�����ۡ�', func = finder.ty_boat_succeed }

-- ��ɽ����
function finder:hs_shuteng()
  self:send{ 'zhe shuteng' }
end
function finder:hs_shuteng_succeed()
  inventory.add_item '����'
  self:complete()
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
    self:complete()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
