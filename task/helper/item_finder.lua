
local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

-- withdraw money (Í­Ç®¡¢°×Òø¡¢»Æ½ğ) from bank
function finder:withdraw()
  local count = inventory.get_item_count( self.item )
  count = self.count - count
  count = count > 0 and count or 1
  self:listen{ event = 'inventory', func = self.check_source_result, id = 'task.manage_inventory' }
  self:send{ 'qu ' .. count .. ' ' .. item.get_id( self.item ) }
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
