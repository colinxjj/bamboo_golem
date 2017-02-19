--------------------------------------------------------------------------------
-- This module parses inventory info
--------------------------------------------------------------------------------

-- only moves data to player.inventory when info is fully parsed.
local cache

local function parse_prompt()
  if player.inventory then -- copy existing alternate id info
    for name, item in pairs( player.inventory ) do
      if cache[ name ] and type( item ) == 'table' then
        cache[ name ].alternate_id = item.alternate_id
      end
    end
  end
  player.inventory, cache = cache, false -- move cache data to player.inventory and clear cache
  player.inventory_update_time = os.time()
  trigger.disable 'inventory2'
  event.new 'inventory'
end

local function parse_header( _, t )
  cache = {}
  cache.count = cntonumber( t[ 3 ] )
  cache.burden = tonumber( t[ 4 ] )
  trigger.enable 'inventory2'
  event.listen{ event = 'prompt', func = parse_prompt, id = 'parser.inventory' }
end

local function parse_content( _, t )
  local name, count = extract_name_count( t[ 2 ] )
  cache[ name ] = {
    name = name,
    id = string.lower( t[ 3 ] ),
    count = count,
    is_equiped = t[ 1 ] == '□' or nil,
  }
end

trigger.new{ name = 'inventory1', text = '^(> )*你身上(带着(\\S+)件|带著下列这些)东西\\(负重\\s*(\\S+)%\\)：$', func = parse_header, enabled = true }
trigger.new{ name = 'inventory2', text = '^(□|  )([^ (]+)\\(([\\w\\s\\\'-]+)\\)$', func = parse_content }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
