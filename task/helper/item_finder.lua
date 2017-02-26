
local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

-- get money (Í­Ç®¡¢°×Òø¡¢»Æ½ğ) from bank
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
  local loc = map.get_current_location()
  if not loc then self:newsub{ class= 'locate' }; return end
  loc = loc[ 1 ]
  -- currently at an untried bank?
  local banker = get_banker( loc )
  if not is_untried_bank( loc ) then -- go to the nearest untried bank
    local dest = map.find_nearest( loc, is_untried_bank )
    self:newsub{ class = 'go' , to = dest }
  elseif not is_present( banker ) then -- banker is absent, try next bank
    banker.last_fail_time = os.time()
    self:resume()
  else -- draw money
    local it = player.inventory[ self.item ]
    local count = it and ( self.count - it.count ) or self.count
    count = count > 0 and count or 1
    self:listen{ event = 'inventory', func = self.resume, id = 'task.manage_inventory' }
    self:send{ 'withdraw ' .. count .. ' ' .. item[ self.item ].id }
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder
