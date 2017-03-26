
local task = {}

--------------------------------------------------------------------------------
-- Manage inventory items
--[[----------------------------------------------------------------------------
Params:
action = 'wield': action to perform, see below for a list valid actions (required)
item = 'sharp_weapon': Chinese name of the item (required or optional, depends on action)
----------------------------------------------------------------------------]]--

task.class = 'manage_inventory'

function task:get_id()
  local s = 'manage_inventory: ' .. self.action
  s = self.count and ( s .. ' ' .. self.count ) or s
  s = self.item and ( s .. ' ' .. self.item ) or s
  return s
end

function task:_resume()
  -- update inventory info as needed
  if not self.has_updated_info then
    self.has_updated_info = true
    self:newsub{ class = 'get_info', inventory = true }
    return
  end
  task[ self.action ]( self ) -- call handler for the specified action
end

function task:_complete()
  local s = '成功完成物品任务：' .. self.action
  s = self.count and ( s .. ' ' .. self.count ) or s
  s = self.item and ( s .. ' ' .. self.item ) or s
  message.verbose( s )
end

function task:_fail()
  local s = '物品任务失败：' .. self.action
  s = self.count and ( s .. ' ' .. self.count ) or s
  s = self.item and ( s .. ' ' .. self.item ) or s
  message.verbose( s )
end

--------------------------------------------------------------------------------
-- wield and unwield

function task:unwield()
  if inventory.is_wielded() then
    self.has_updated_info = false
    self:send{ 'unwield ' .. inventory.get_wielded().id; complete_func = self.resume }
  else
    self:complete()
  end
end

function task:wield()
  if inventory.is_wielded() then
    local wielded_item = inventory.get_wielded()
    -- complete task if the wanted item is already equipped
    if item.is_valid_type( self.item ) and item.is_type( wielded_item.name, self.item ) or self.item == wielded_item.name then self:complete() return end
    self.has_updated_info = false
    -- otherwise, unwield the currently wielded item first
    self:send{ 'unwield ' .. wielded_item.id; complete_func = self.resume }
  else
    local id
    if item.is_valid_type( self.item ) then -- equip any inventory item of the wanted type
      for iname in pairs( player.inventory ) do
        if item.is_type( iname, self.item ) then id = inventory.get_item_id( iname ) or item.get_id( iname ); break end
      end
    else
      id = item.get_id( self.item )
    end
    if not id then
      message.warning( '物品任务失败，找不到“' .. self.item .. '”对应的物品' )
      self:fail()
    else
      self.has_updated_info = false
      self:send{ 'wield ' .. id; complete_func = self.resume }
    end
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
