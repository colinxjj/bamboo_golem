
local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

finder.data = {}

-- withdraw money (铜钱、白银、黄金) from bank
function finder:withdraw()
  local count = inventory.get_item_count( self.item )
  count = self.count - count
  count = count > 0 and count or 1
  self:send{ 'qu ' .. count .. ' ' .. item.get_id( self.item ); complete_func = self.check_source_result }
end

-- 神龙岛通行令牌
function finder:sld_lingpai()
	self:send{ 'steal 通行令牌'; complete_func = finder.sld_lingpai_check }
end
function finder:sld_lingpai_succeed()
  self:disable_trigger_group 'item_finder.sld_lingpai'
  inventory.add_item '通行令牌'
end
trigger.new{ name = 'sld_lingpai_succeed', group = 'item_finder.sld_lingpai', match = '^(> )*你成功地偷到了块通行令牌!$', func = finder.sld_lingpai_succeed }
function finder:sld_lingpai_check()
  if inventory.has_item '通行令牌' then
    self:complete()
  else
    self:resume()
  end
end

-- 桃源县金娃娃
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
  inventory.add_item '金娃娃'
  self:complete()
end
trigger.new{ name = 'ty_fish_missed', group = 'item_finder.ty_fish', match = '^(> )*你慢慢弯腰去捉那对金娃娃，一手一条，握住了金娃娃的尾巴轻轻向外拉扯，', func = finder.ty_fish_retry }
trigger.new{ name = 'ty_fish_caught', group = 'item_finder.ty_fish', match = '^(> )*你伸手到怪鱼遁入的那大石底下用力一抬，只感那石微微摇动，双掌向上猛举，', func = finder.ty_fish_done }

-- 桃源县铁舟
function finder:ty_boat()
  if not inventory.has_item '金娃娃' then
    self:newsub{ class = 'get_item', item = '金娃娃' }
  elseif room.has_object '渔人' then
    inventory.remove_item '金娃娃'
    self:send{ 'give jin wawa to yu ren' }
  else
    self:fail()
  end
end
function finder:ty_boat_succeed()
  self:disable_trigger_group 'item_finder.ty_boat'
  inventory.add_item '铁舟'
  self:complete()
end
trigger.new{ name = 'ty_boat_succeed', group = 'item_finder.ty_boat', match = '^(> )*渔人给了你一艘铁舟。', func = finder.ty_boat_succeed }

-- 华山树藤
function finder:hs_shuteng()
  self:send{ 'zhe shuteng' }
end
function finder:hs_shuteng_succeed()
  inventory.add_item '树藤'
  self:complete()
end
function finder:hs_shuteng_fail()
  self:fail()
end
trigger.new{ name = 'hs_shuteng_succeed', group = 'item_finder.hs_shuteng', match = '^(> )*你从树干上面折断了一些树藤。', func = finder.hs_shuteng_succeed }
trigger.new{ name = 'hs_shuteng_fail', group = 'item_finder.hs_shuteng', match = '^(> )*树藤已经被你折光了。', func = finder.hs_shuteng_fail }

-- 华山藤筐
function finder:hs_kuang()
  if not inventory.has_item '树藤' then
    self:newsub{ class = 'get_item', item = '树藤' }
  else
    self:send{ 'weave kuang' }
    inventory.add_item '藤筐'
    self:complete()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
