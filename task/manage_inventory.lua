
local task = {}

--------------------------------------------------------------------------------
-- Manage inventory items
--[[----------------------------------------------------------------------------
Params:
action = 'wield': action to perform, see below for a list valid actions (required)
item = 'sharp_weapon': Chinese name of the item or a table containing item names (required or optional, depends on action)
----------------------------------------------------------------------------]]--

task.class = 'manage_inventory'

local valid_action = { wield = true, unwield = true, consume = true, drop = true }

local function get_id_string( self )
  local s = self.action
  if self.count then s = s .. ' ' .. self.count end
  if type( self.item ) == 'string' then
    s = s .. ' ' .. self.item
  elseif type( self.item ) == 'table' then
    for _, item in pairs( self.item ) do
      s = s .. ' ' .. item
    end
  end
  return s
end

function task:get_id()
  return 'manage_inventory: ' .. get_id_string( self )
end

function task:_resume()
  -- update inventory info as needed
  if not self.has_updated_info then
    self.has_updated_info = true
    self:newsub{ class = 'get_info', inventory = true }
    return
  end
  assert( valid_action[ self.action ], 'task.manage_inventory - invalid action param' )
  task[ self.action ]( self ) -- call handler for the specified action
end

function task:_complete()
  message.debug( '成功完成物品任务：' .. get_id_string( self ) )
end

function task:_fail()
  message.debug( '物品任务失败：' .. get_id_string( self ) )
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

function task:consume()
  -- only try consumption once
  if not self.has_tried_consume and inventory.has_item( self.item ) then
    self.has_tried_consume, self.has_updated_info = true, false
    local it = item.get( self.item )
    local count, id = it.consume_count or 1, it.id
    local action = it.type == 'food' and 'eat' or 'drink'
    self:send{ ( '#%d %s %s' ):format( count, action, id ); complete_func = self.resume } -- check inventory again after
  else
    self:complete()
  end
end

function task:drop()
  if type( self.item ) == 'string' then self.item = { self.item } end
  local c = ''
  for _, iname in pairs( self.item ) do
    if inventory.has_item( iname ) then
      local id = item.get_id( iname ) or inventory.get_item_id( iname )
      if id then c = c .. ';drop ' .. id end
    end
  end
  if #c > 0 then
    self:send{ c; complete_func = self.complete }
  else
    self:complete()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
