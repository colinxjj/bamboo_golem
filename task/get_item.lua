
local task = {}

--------------------------------------------------------------------------------
-- Get items
--[[----------------------------------------------------------------------------
Params:
item = '铜钱': Chinese name of the item (required)
count = 500: Number of items to get (optional, default: 1)
count_min = 200: if player has this number of items, then no need to get more (optional)
item_filter = a_func, a function used to filter items to get, i.e. it can be used to avoid getting certain items (optional)
source_evaluator = a_func: a function used to evaluate item sources, passed to the item module (optional)
is_distance_ignored = true: whether distance is ignored when evaluate an item source (optional, default: nil)
is_weight_ignored = true: whether weight is ignored when evaluate an item source (optional, default: nil)
is_price_ignored = true: whether price is ignored when evaluate an item source (optional, default: nil)
is_quality_ignored = true: whether quality is ignored when evaluate an item source (optional, default: nil)
----------------------------------------------------------------------------]]--

task.class = 'get_item'

local item_finder = require 'task.helper.item_finder'

function task:get_id()
  return 'get_item: ' ..  ' ' .. ( self.count or 1 ) .. ' ' .. self.item
end

function task:_resume()
  -- update inventory info as needed
  if not self.has_updated_info then
    self.has_updated_info = true
    self:newsub{ class = 'get_info', inventory = true }
    return
  end
  self.count = self.count or 1
  -- already have the required item(s)?
  local has_item = inventory.has_item( self.item, self.count_min or self.count )
  -- update inventory info if no count data or current count data can be higher than the actual count TODO inventory.has_item currently doesn't return 'unsure'
  if has_item == 'unsure' then self:newsub{ class = 'get_info', inventory = true } return end
  -- complete the task if have enough item
  if has_item then self.result = has_item; self:complete() return end
  -- otherwise, try the best source available
  local source = item.get_best_source{ item = self.item, item_filter = self.item_filter, source_evaluator = self.source_evaluator, is_distance_ignored = self.is_distance_ignored, is_weight_ignored = self.is_weight_ignored, is_price_ignored = self.is_price_ignored, is_quality_ignored = ( self.item == 'sharp_weapon' and true or self.is_quality_ignored ) }
  -- if no available item source, task failed
  if not source then self:fail() return end
  -- handle the best source
  self:handle_source( source )
end

function task:_complete()
  message.verbose( '成功取得物品：'  ..  ' ' .. self.count .. ' ' .. self.item )
end

function task:_fail()
  message.verbose( '未能取得物品：'  ..  ' ' .. self.count .. ' ' .. self.item )
end

function task:handle_source( source )
  self.current_source = source
  if source.type == 'shop' and not inventory.has_cash( item.get_value( source.item ) ) then -- prepare money first for shop sources
    local money, count = item.get_approx_money_by_cash( value * 5 )
    self:newsub{ class = 'get_item', item = money, count = count, fail_func = self.switch_source }
  elseif source.location and not map.is_at_location( source.location ) then -- go to the location
    self:newsub{ class = 'go', to = source.location, fail_func = self.switch_source }
  elseif source.npc and self.has_tried_to_find_npc ~= source.npc then -- find the npc
    self.has_tried_to_find_npc = source.npc
    self:newsub{ class = 'find', object = source.npc, fail_func = self.switch_source }
  elseif source.type == 'get' then
    self:get( source )
  elseif source.type == 'cmd' then
    self:send{ source.cmd; complete_func = self.check_inventory }
  elseif source.type == 'handler' then
    self:enable_trigger_group( 'item_finder.' .. source.handler )
    item_finder[ source.handler ]( self, source )
  elseif source.type == 'shop' then
    self:purchase( source )
  elseif source.type == 'loot' then
    -- TODO
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
    self:switch_source()
  end
end

-- purchase item from shop
function task:purchase( source )
  local id = item.get_id( source.item )
  self:send{ 'buy ' .. id; complete_func = self.check_inventory }
end

function task:check_inventory()
  self:newsub{ class = 'get_info', inventory = true, complete_func = task.check_source_result }
end

function task:check_source_result()
  local source = self.current_source
  if inventory.has_item( self.item, self.count_min or self.count ) then
    self.result = source.item
    -- if a source is available only once per session, mark it as invalid until session reset
    if source.is_once_per_session then item.mark_invalid_source( source ) end
    -- complete the task
    self:complete()
  else
    self:switch_source()
  end
end

function task:switch_source()
  local source = self.current_source
  -- disable triggers for the source
  if source.handler then self:disable_trigger_group( 'item_finder.' .. source.handler ) end
  message.debug( ( '未能从来源“%s”取得物品“%s”' ):format( source.npc or source.location or source.handler, source.item ) )
  item.mark_failed_source( source )
  self:resume()
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
