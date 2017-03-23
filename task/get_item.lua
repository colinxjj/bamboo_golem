
local task = {}

--------------------------------------------------------------------------------
-- Get items
--[[----------------------------------------------------------------------------
Params:
item = '铜钱': Chinese name of the item (required)
count = 500: Number of items to get (optional, default: 1)
count_min = 200: if player has this number of items, then no need to get more (optional)
----------------------------------------------------------------------------]]--

task.class = 'get_item'

local item_finder = require 'task.helper.item_finder'

function task:get_id()
  return 'get_item: ' ..  ' ' .. ( self.count or 1 ) .. ' ' .. self.item
end

function task:_resume()
  self.count = self.count or 1
  -- already have the required item(s)?
  local has_item = inventory.has_item( self.item, self.count_min or self.count )
  -- update inventory info if no count data or current count data can be higher than the actual count TODO inventory.has_item currently doesn't return 'unsure'
  if has_item == 'unsure' then self:newsub{ class = 'get_info', inventory = 'forced' } return end
  -- complete the task if have enough item
  if has_item then self.result = has_item; self:complete() return end
  -- otherwise, try the best source available
  local source = item.get_best_source{ item = self.item }
  if not source then self:fail() return end
  self:handle_source( source )
end

function task:_complete()
  message.verbose( '成功取得物品：'  ..  ' ' .. self.count .. ' ' .. self.item )
end

function task:_fail()
  message.verbose( '未能取得物品：'  ..  ' ' .. self.count .. ' ' .. self.item )
end

local current_source

function task:handle_source( source )
  current_source = source
  -- first go to the source location if we're not already there
  local loc = map.get_current_location()[ 1 ]
  if loc.id ~= source.location then
    -- prepare money first for shop sources
    if source.type == 'shop' then
      local value = item.get_value( source.item )
      if not inventory.has_cash( value ) then
        local money, count = item.get_approx_money_by_cash( value * 5 )
        self:newsub{ class = 'get_item', item = money, count = count }
        return
      end
    end
    -- go to source location
    self:newsub{ class = 'go' , to = source.location }
  elseif source.npc and not room.has_object( source.npc ) then
    item.mark_invalid_source( source )
    self:resume()
  elseif source.type == 'get' then
    self:get( source )
  elseif source.type == 'cmd' then
    self:send{ source.cmd; complete_func = self.check_inventory }
  elseif source.type == 'local_handler' then
    self:enable_trigger_group( 'item_finder.' .. source.handler )
    item_finder[ source.handler ]( self )
  elseif source.type == 'shop' then
    self:purchase( source )
  elseif source.type == 'loot' then
  end
end

-- get item from ground
function task:get( source )
  if room.has_object( source.item ) then
    local count = room.get_object_count( source.item )
    count = count > self.count and self.count or count
    local c = count ~= 1 and ( count .. ' ' ) or ''
    self:send{ 'get ' .. c .. item.get_id( source.item ); complete_func = self.check_source_result }
  else
    item.mark_invalid_source( source )
    self:resume()
  end
end

-- purchase item from shop
function task:purchase( source )
  local id = item.get_id( source.item )
  self:send{ 'buy ' .. id; complete_func = self.check_inventory }
end

function task:check_inventory()
  self:newsub{ class = 'get_info', inventory = 'forced', complete_func = task.check_source_result }
end

function task:check_source_result()
  if inventory.has_item( self.item, self.count_min or self.count ) then
    self.result = current_source.item
    self:complete()
  else
    item.mark_invalid_source( current_source )
    self:resume()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
