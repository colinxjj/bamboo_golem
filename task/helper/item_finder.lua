
local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

-- withdraw money (Í­Ç®¡¢°×Òø¡¢»Æ½ð) from bank
function finder:withdraw()
  local count = inventory.get_item_count( self.item )
  count = self.count - count
  count = count > 0 and count or 1
  self:send{ 'qu ' .. count .. ' ' .. item.get_id( self.item ); complete_func = self.check_source_result }
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
