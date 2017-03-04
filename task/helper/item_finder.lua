
local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

-- withdraw money (Í­Ç®¡¢°×Òø¡¢»Æ½ð) from bank
local function is_untried_bank( room )
  for name, person in pairs( npc.bank_list ) do
    -- if last try at a bank failed (banker is not present), then only retry that bank at least 200 seconds later
    if person.location == room.id and ( not person.last_fail_time or os.time() - person.last_fail_time > 200 ) then return true end
  end
end
local function get_banker( room )
  for name, person in pairs( npc.bank_list ) do
    if person.location == room.id then return person end
  end
end
function finder:money()
  local loc = map.get_current_location()[ 1 ]
  -- currently at an untried bank?
  local banker = get_banker( loc )
  if not is_untried_bank( loc ) then -- go to the nearest untried bank
    local bank = map.find_nearest( loc, is_untried_bank )
    self:newsub{ class = 'go' , to = bank }
  elseif not room.has_object( banker ) then -- banker is absent, try next bank
    banker.last_fail_time = os.time()
    self:resume()
  else -- draw money
    local it = player.inventory[ self.item ]
    local count = it and ( self.count - it.count ) or self.count
    count = count > 0 and count or 1
    self:listen{ event = 'inventory', func = self.resume, id = 'task.manage_inventory' }
    self:send{ 'qu ' .. count .. ' ' .. item.get_id( self.item ) }
  end
end

-- prepare a sharp weapon
-- TODO kill and loot
local function is_selling_sharp_weapon( room )
  for name, person in pairs( npc.shop_list ) do
    -- if last try at a shop failed (shop owner is not present), then only retry that shop at least 200 seconds later
    if person.location == room.id and ( not person.last_fail_time or os.time() - person.last_fail_time > 200 ) then
      for _, iname in pairs( person.catalogue ) do
        if item.is_sharp_weapon( iname ) then return true end
      end
    end
  end
end
function finder:sharp_weapon()
  if inventory.has_item{ type = 'sharp_weapon' } then
    self:complete()
  elseif player.cash < 3000 then
    self:newsub{ class = 'manage_inventory', action = 'prepare', item = '»Æ½ð', count = 1 }
  else
    local loc = map.get_current_location()[ 1 ]
    local shop = map.find_nearest( loc, is_selling_sharp_weapon )
    self:newsub{ class = 'go' , to = shop, complete_func = finder.purchase }
  end
end

-- purchase at a shop
local function is_untried_shop( room )
  for name, person in pairs( npc.shop_list ) do
    -- if last try at a shop failed (shop owner is not present), then only retry that shop at least 200 seconds later
    if person.location == room.id and ( not person.last_fail_time or os.time() - person.last_fail_time > 200 ) then return true end
  end
end
local function get_shop_owner( room )
  for name, person in pairs( npc.shop_list ) do
    if person.location == room.id then return person end
  end
end
function finder:purchase()
  local loc = map.get_current_location()[ 1 ]
  local shop_owner = get_shop_owner( loc )
  if not is_untried_shop( loc ) then -- go to the nearest untried shop
    self:resume()
  elseif not room.has_object( shop_owner ) then -- shop owner is absent, try next shop
    banker.last_fail_time = os.time()
    self:resume()
  else -- purchase item
    local id
    if self.item == 'sharp_weapon' then
      for _, iname in pairs( shop_owner.catalogue ) do
        if item.is_sharp_weapon( iname ) then id = item.get_id( iname ); break end
      end
    else
      id = get_id( self.item )
    end
    self:listen{ event = 'inventory', func = self.resume, id = 'task.manage_inventory' }
    self:send{ 'buy ' .. id }
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
