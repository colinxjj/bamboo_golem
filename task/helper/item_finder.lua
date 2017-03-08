
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
  inventory.add_item '通行令牌'
end
trigger.new{ name = 'sld_lingpai_succeed', group = 'item_finder.sld_lingpai', match = '^(> )*你成功地偷到了块通行令牌!$', func = finder.sld_lingpai_succeed }
function finder:sld_lingpai_check()
  if inventory.has_item '通行令牌' then
    self:disable_trigger_group 'item_finder.sld_lingpai'
    self:complete()
  else
    self:resume()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
