--------------------------------------------------------------------------------
-- This module parses id info
--------------------------------------------------------------------------------

local function parse_prompt()
  local inv_count = 0
  for name, cache_item in pairs( cache ) do
    inv_count = inv_count + 1
    cache_item.count = not STACKABLE_ITEM[ name ] and cache_item.count or nil
    local item = player.inventory and player.inventory[ name ]
    if item then -- copy count from existing player.inventory data, because id doesn't produce this info for stackable items like 铜钱
      cache_item.count = cache_item.count or item.count
      cache_item.is_equiped = item.is_equiped
    end
  end
  cache.count, cache.burden = inv_count, player.inventory and player.inventory.burden
  player.inventory, cache = cache, false -- move cache data to player.inventory and clear cache
  trigger.disable 'id2'
  event.new 'id'
end

local function parse_header()
  cache = {}
  trigger.enable 'id2'
  event.listen{ event = 'prompt', func = parse_prompt, id ='parser.id' }
end

local idchar = lpeg.R 'az' + lpeg.S ' _-\''
local seperator = lpeg.P ', ' + -1
local patt = ( lpeg.C( idchar^1 ) * seperator )^1

local function parse_content( _, t )
  local name, ids = t[ 1 ], { patt:match( t[ 2 ] ) }
  cache[ name ] = cache[ name ] or {}
  local item = cache[ name ]
  item.count = item.count and item.count + 1 or 1
  item.sequence = tonumber( t[ 1 ] )
  item.id = item.id or ids[ 1 ]
  item.alternate_id = ids
end

trigger.new{ name = 'id1', match = '^(> )*你身上携带物品的别称如下\\(右方\\)：$', func = parse_header, enabled = true }
trigger.new{ name = 'id2', match = '^\\d+: (\\S+) = ([\\w\\s\',-]+)$', func = parse_content }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
