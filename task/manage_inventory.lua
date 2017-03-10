
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
  if player.wielded then
    self:send{ 'unwield ' .. player.wielded.id; complete_func = self.resume }
    player.wielded = nil
  else
    self:complete()
  end
end

function task:wield()
  if player.wielded then
    if item.is_valid_type( self.item ) and item.is_type( player.wielded.name, self.item ) or self.item == player.wielded.name then self:complete() return end
    self:send{ 'unwield ' .. player.wielded.id; complete_func = self.resume }
  else
    local id
    if item.is_valid_type( self.item ) then
      for iname in pairs( player.inventory ) do
        if item.is_type( iname, self.item ) then id = inventory.get_item_id( iname ) or item.get_id( iname ); break end
      end
    else
      id = item.get_id( self.item )
    end
    self:send{ 'wield ' .. id; complete_func = self.resume }
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
