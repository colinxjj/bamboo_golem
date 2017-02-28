
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
  self.count = self.count or 1

  if self.action == 'prepare' then
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
  elseif self.action == 'unwield' then
    if player.wielded then
      self:listen{ event = 'prompt', func = self.resume, id = 'task.manage_inventory' }
      self:send{ 'unwield ' .. player.wielded.id }
      player.wielded = nil
    else
      self:complete()
    end
  end
end

function task:_complete()
  message.verbose( '成功完成物品任务' )
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
