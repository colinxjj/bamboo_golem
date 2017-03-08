
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
  inventory.add_item 'ͨ������'
end
trigger.new{ name = 'sld_lingpai_succeed', group = 'item_finder.sld_lingpai', match = '^(> )*��ɹ���͵���˿�ͨ������!$', func = finder.sld_lingpai_succeed }
function finder:sld_lingpai_check()
  if inventory.has_item 'ͨ������' then
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
