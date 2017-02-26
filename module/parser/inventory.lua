--------------------------------------------------------------------------------
-- This module parses inventory info
--------------------------------------------------------------------------------

-- only moves data to player.inventory when info is fully parsed.
local cache

local function parse_prompt()
  -- copy existing alternate id info
  for name, item in pairs( player.inventory ) do
    if cache[ name ] and type( item ) == 'table' then
      cache[ name ].alternate_id = item.alternate_id
    end
  end

  player.cash = money_to_coin( cache )
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

local function parse_withdraw( _, t )
  local currency, amount = extract_name_count( t[ 2 ] )
  local it = player.inventory[ currency ]
  if it then
    it.count = it.count + amount
  else
    player.inventory[ currency ] = { name = currency, id = item[ currency ].id, count = amount }
  end
  trigger.enable 'inventory_balance'
end

local function parse_balance( _, t )
  trigger.disable 'inventory_balance'
  player.bank_balance = cn_amount_to_coin( t[ 1 ] )
  event.new 'inventory'
end

local drop_patt = lpeg.P 'drop ' * lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )

local function parse_drop( _, t )
  local name, count = extract_name_count( t[ 2 ] )
  local it = player.inventory[ name ]
  if not it or not it.count then return end
  -- drop amount unclear?
  if string.find( t[ 2 ], '^一些' ) then -- try to get drop amount by parsing last cmd sent
    local c, id = cmd.get_last()
    if not c then return end
    count, id = drop_patt:match( c.cmd )
    if not count or it.id ~= id then it.count_is = 'max'; return end -- mark item's current count as a upper limit
  end
  it.count = it.count - count
  -- remove item if all is dropped
  if it.count < 1 then player.inventory[ name ] = nil end
  event.new 'inventory'
end

local get_patt = lpeg.P 'get ' * lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )

local function parse_get( _, t )
  local name, count = extract_name_count( t[ 2 ] )
  player.inventory[ name ] = player.inventory[ name ] or { name = name, id = item[ name ] and item[ name ].id or nil, count = 0 }
  local it = player.inventory[ name ]
  -- get amount unclear?
  if string.find( t[ 2 ], '^一些' ) then -- try to get get amount by parsing last cmd sent
    local c, id = cmd.get_last()
    if not c then return end
    count, id = get_patt:match( c.cmd )
    if not count or it.id ~= id then it.count_is = 'min'; return end -- mark item's current count as a lower limit
  end
  it.count = it.count + count
  event.new 'inventory'
end

local function parse_lost( _, t )
  local name, count = extract_name_count( t[ 2 ] )
  local it = player.inventory[ name ]
  if not it or not it.count then return end
  it.count = it.count - count
  -- remove item if all is lost
  if it.count < 1 then player.inventory[ name ] = nil end
  event.new 'inventory'
end

local function parse_buy( _, t )
  local price, name = t[ 2 ], t[ 4 ]
  player.inventory[ name ] = player.inventory[ name ] or { name = name, id = item[ name ] and item[ name ].id or nil, count = 0 }
  player.inventory[ name ].count = player.inventory[ name ].count + 1
  if player.cash then
    player.cash = player.cash - cn_amount_to_coin( price )
    local new_money = coin_to_money( player.cash )
    for k, v in pairs( new_money ) do -- update inventory money amount
      player.inventory[ k ].count = v
    end
  end
  event.new 'inventory'
end

local function parse_sell( _, t )
  local price, name = t[ 2 ], t[ 3 ]
  local it = player.inventory[ name ]
  if it and it.count then
    it.count = it.count - 1
    -- remove item if all is dropped
    if it.count < 1 then player.inventory[ name ] = nil end
  end
  if player.cash then
    player.cash = player.cash + cn_amount_to_coin( price )
    local added_money = cn_amount_to_money( price )
    for k, v in pairs( added_money ) do -- update inventory money amount
      player.inventory[ k ].count = player.inventory[ k ].count + v
    end
  end
  event.new 'inventory'
end

local num = ( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九' + '十' + '百' + '千' + '万' + '亿' + '零')^1
local patt = lpeg.C( num *  any_but( num )^1 ) * -1
local wpatt = any_but( patt )^0 * patt

local function parse_give( _, t )
  local s = wpatt:match( t[ 2 ] ) -- TODO make it work with id like '钓鱼二' which would result in '你给钓鱼二十文铜钱', which is hard to properly determine the boundary
  local name, count = extract_name_count( s )
  local it = player.inventory[ name ]
  if not it or not it.count then return end
  it.count = it.count - count
  -- remove item if all is dropped
  if it.count < 1 then player.inventory[ name ] = nil end
  event.new 'inventory'
end

local function parse_accept( _, t )
  local name, count = extract_name_count( t[ 3 ] )
  player.inventory[ name ] = player.inventory[ name ] or { name = name, id = item[ name ] and item[ name ].id or nil, count = 0 }
  player.inventory[ name ].count = player.inventory[ name ].count + count
  event.new 'inventory'
end

trigger.new{ name = 'inventory1', match = '^(> )*你身上(带着(\\S+)件|带著下列这些)东西\\(负重\\s*(\\S+)%\\)：$', func = parse_header, enabled = true }
trigger.new{ name = 'inventory2', match = '^(□|  )([^ (]+)\\(([\\w\\s\\\'-]+)\\)$', func = parse_content }

trigger.new{ name = 'inventory_withdraw', match = '^(> )*你从银号里取出(\\S+)。$', func = parse_withdraw, enabled = true }
trigger.new{ name = 'inventory_balance', match = '^\\S+记完帐，告诉你：“扣除一分半手续费，您在弊商号现还有(\\S+)。”$', func = parse_balance }

trigger.new{ name = 'inventory_drop', match = '^(> )*你丢下(\\S+)。$', func = parse_drop, enabled = true }
trigger.new{ name = 'inventory_get', match = '^(> )*你捡起(\\S+)。$', func = parse_get, enabled = true }

trigger.new{ name = 'inventory_lost', match = '^(> )*你突然发现(?:身上的)?(\\S+)不见了！', func = parse_lost, enabled = true }

trigger.new{ name = 'inventory_buy', match = '^(> )*你以(\\S+)的价格从(\\S+)那里买下了一\\S\\S(\\S+)。', func = parse_buy, enabled = true }
trigger.new{ name = 'inventory_sell', match = '^(> )*你以(\\S+)的价格卖掉了一\\S\\S(\\S+)给(\\S+)。', func = parse_sell, enabled = true }

trigger.new{ name = 'inventory_give', match = '^(> )*你给(\\S+)。', func = parse_give, enabled = true }
trigger.new{ name = 'inventory_give2', match = '^(> )*你拿出(\\S+)\\(\\w+\\)给(\\S+)。', func = parse_lost, enabled = true }
trigger.new{ name = 'inventory_accept', match = '^(> )*(\\S+)给你(\\S+)。', func = parse_accept, enabled = true }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
