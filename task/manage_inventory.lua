
local task = {}

--------------------------------------------------------------------------------
-- Manage inventory and items
--[[----------------------------------------------------------------------------
Params:
action = 'perpare': action to perform, see below for a list valid actions (required)
item = '铜钱': Chinese name of the item (required or optional, depends on action)
count = 500: Number of items (required or optional, depends on action)
----------------------------------------------------------------------------]]--

task.class = 'manage_inventory'

function task:get_id()
  local s = 'manage_inventory: ' .. self.action
  s = self.count and ( s .. ' ' .. self.count ) or s
  s = self.item and ( s .. ' ' .. self.item ) or s
  return s
end

local finder_tbl = {
  -- special types
  sharp_weapon = 'sharp_weapon',

  ['铜钱'] = 'money',   ['白银'] = 'money',   ['黄金'] = 'money',
  ['木棉袈裟'] = 'mumian',
}

function task:_resume()
  task[ self.action ]( self )
end

function task:_complete()
  local s = '成功完成物品任务：' .. self.action
  s = self.count and ( s .. ' ' .. self.count ) or s
  s = self.item and ( s .. ' ' .. self.item ) or s
  message.verbose( s )
end

function task:prepare()
  self.count = self.count or 1
  local it = player.inventory[ self.item ]
  if it then
    if it.count_is == 'max' then self:newsub{ class = 'getinfo', inventory = 'forced' }; return end -- update inventory info if current count data can be higher than the actual count
    if it.count >= self.count then self:complete(); return end -- complete the task if have enough item
  end
  self.item_finder = self.item_finder or _G.task.helper.item_finder[ finder_tbl[ self.item ] ]
  if self.item_finder then
    self:item_finder()
  else
    -- simply buy at shop or pick up from ground
  end
end

function task:unwield()
  if player.wielded then
    self:listen{ event = 'prompt', func = self.resume, id = 'task.manage_inventory' }
    self:send{ 'unwield ' .. player.wielded.id }
    player.wielded = nil
  else
    self:complete()
  end
end

function task:wield()
  if player.wielded then
    if self.item == 'sharp_weapon' and item.is_sharp_weapon( player.wielded ) or self.item == player.wielded.name then self:complete(); return end
    self:listen{ event = 'inventory', func = self.resume, id = 'task.manage_inventory' }
    self:send{ 'unwield ' .. player.wielded.id }
  else
    local id
    if self.item == 'sharp_weapon' then
      for _, it in pairs( player.inventory ) do
        if item.is_sharp_weapon( it ) then id = item.get_id( it ); break end
      end
    else
      id = item.get_id( self.item )
    end
    self:listen{ event = 'inventory', func = self.resume, id = 'task.manage_inventory' }
    self:send{ 'wield ' .. id }
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
