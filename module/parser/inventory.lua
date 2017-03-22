--------------------------------------------------------------------------------
-- This module parses inventory info
--------------------------------------------------------------------------------

-- only moves data to player.inventory when info is fully parsed.
local cache

local function parse_prompt()
  -- copy existing alternate id info
  for name, it in pairs( player.inventory ) do
    if cache[ name ] then
      cache[ name ].alternate_id = it.alternate_id
    end
  end

  player.cash = item.get_cash_by_money( cache )
  player.inventory, cache = cache, false -- move cache data to player.inventory and clear cache
  player.inventory_update_time = os.time()
  trigger.disable 'inventory2'
  event.new 'inventory'
end

local function parse_header( _, t )
  cache = {}
  player.wielded = nil -- reset wielded info
  player.inv_count = cntonumber( t[ 3 ] )
  player.encumbrance = tonumber( t[ 4 ] )
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
    type = item.get_type( name ),
  }
  local it = cache[ name ]
  if it.is_equiped and item.is_type( name, 'weapon' ) then player.wielded = it end
end

local function parse_withdraw( _, t )
  local currency, amount = extract_name_count( t[ 2 ] )
  local it = player.inventory[ currency ]
  if it then
    it.count = it.count + amount
  else
    player.inventory[ currency ] = { name = currency, id = item.get_id( currency ), count = amount }
  end
  trigger.enable 'inventory_balance'
end

local function parse_balance( _, t )
  trigger.disable 'inventory_balance'
  player.bank_balance = cn_amount_to_cash( t[ 1 ] )
  event.new 'inventory'
end

local drop_patt = lpeg.P 'drop ' * lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )

-- TODO update player.wielded if it's a weapon dropped
local function parse_drop( _, t )
  local name, count = extract_name_count( t[ 2 ] )
  local it = player.inventory[ name ]
  if not it then return end
  -- drop amount unclear?
  if string.find( t[ 2 ], '^一些' ) then -- try to get drop amount by parsing last cmd sent
    local c, id = cmd.get_last()
    if not c then return end
    count, id = drop_patt:match( c.cmd )
    if not count or it.id ~= id then it.count_is = 'max'; return end -- mark item's current count as a upper limit
  end
  it.count = it.count and it.count - count or 0
  -- remove item if all is dropped
  if it.count < 1 then player.inventory[ name ] = nil end
  event.new 'inventory'
end

local get_patt = lpeg.P 'get ' * lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )

local function parse_get( _, t )
  local name, count = extract_name_count( t[ 2 ] )
  player.inventory[ name ] = player.inventory[ name ] or { name = name, id = item.get_id( name ), count = 0, type = item.get_type( name ) }
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
  player.inventory[ name ] = player.inventory[ name ] or { name = name, id = item.get_id( name ), count = 0, type = item.get_type( name ) }
  player.inventory[ name ].count = player.inventory[ name ].count + 1
  if player.cash then
    player.cash = player.cash - cn_amount_to_cash( price )
    local new_money = item.get_money_by_cash( player.cash )
    for k, v in pairs( new_money ) do -- update inventory money amount
			player.inventory[ k ] = player.inventory[ k ] or { name = k, id = item.get_id( k ), type = 'money' }
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
    player.cash = player.cash + cn_amount_to_cash( price )
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
  player.inventory[ name ] = player.inventory[ name ] or { name = name, id = item.get_id( name ), count = 0, type = item.get_type( name ) }
  player.inventory[ name ].count = player.inventory[ name ].count + count
  event.new 'inventory'
end

local function parse_wield( _, t )
	for name, it in pairs( player.inventory ) do
		if t[ 2 ] == name then player.wielded = it; break end
	end
  event.new 'inventory'
end

local function parse_unwield()
	player.wielded = nil
  event.new 'inventory'
end

local function parse_ferry_pay()
  local it = player.inventory[ '白银' ]
  if not it then return end
  it.count = it.count - 5
  it.count_is = 'max'
end

trigger.new{ name = 'inventory1', match = '^(> )*你身上(带着(\\S+)件|带著下列这些)东西\\(负重\\s*(\\S+)%\\)：$', func = parse_header, enabled = true }
trigger.new{ name = 'inventory2', match = '^(□|  )([^ (]+)\\(([\\w\\s\\\'-]+)\\)$', func = parse_content }

trigger.new{ name = 'inventory_withdraw', match = '^(> )*你从银号里取出(\\S+)。$', func = parse_withdraw, enabled = true }
trigger.new{ name = 'inventory_balance', match = '^\\S+记完帐，告诉你：“扣除\\S+手续费，您在弊商号现还有(\\S+)。”$', func = parse_balance }

trigger.new{ name = 'inventory_drop', match = '^(> )*你丢下(\\S+)。$', func = parse_drop, enabled = true }
trigger.new{ name = 'inventory_get', match = '^(> )*你捡起(\\S+)。$', func = parse_get, enabled = true }

trigger.new{ name = 'inventory_lost', match = '^(> )*你突然发现(?:身上的)?(\\S+)不见了！', func = parse_lost, enabled = true }
trigger.new{ name = 'inventory_lost2', match = '^(> )*你一时想不起(\\S+)有什么用处，就随手把它丢掉了。', func = parse_lost, enabled = true }
-- 月饼整个腐烂掉了。
-- 你将剩下的烤鸭吃得干干净净。

trigger.new{ name = 'inventory_buy', match = '^(> )*你以(\\S+)的价格从(\\S+)那里买下了一\\S\\S(\\S+)。', func = parse_buy, enabled = true }
trigger.new{ name = 'inventory_sell', match = '^(> )*你以(\\S+)的价格卖掉了一\\S\\S(\\S+)给(\\S+)。', func = parse_sell, enabled = true }

trigger.new{ name = 'inventory_give', match = '^(> )*你给(\\S+)。', func = parse_give, enabled = true }
trigger.new{ name = 'inventory_give2', match = '^(> )*你拿出(\\S+)\\(\\w+\\)给(\\S+)。', func = parse_lost, enabled = true }
trigger.new{ name = 'inventory_accept', match = '^(> )*([^、，]+)给你(\\S+)。', func = parse_accept, enabled = true }

trigger.new{ name = 'inventory_dazao_wield', match = '^(> )*你将手一挥，一柄(\\S+)从身后飞出，电光一闪，已经握在了你手中。', func = parse_wield, enabled = true }
trigger.new{ name = 'inventory_normal_wield', match = '^(> )*你「唰」的一声\\S\\S出一柄(\\S+)握在手中。', func = parse_wield, enabled = true }
trigger.new{ name = 'inventory_zhujian_wield', match = '^(> )*你拿出一把(\\S+)，握在手中。', func = parse_wield, enabled = true }
trigger.new{ name = 'inventory_zhen_wield', match = '^(> )*你用右手大拇指和食指捻起一枚(\\S+)。', func = parse_wield, enabled = true }
-- 操起$n握在手里。
-- 「唰」的一声将$n抽出握在手中。

trigger.new{ name = 'inventory_dazao_unwield', match = '^(> )*你将手中的\\S+一弹，电光闪耀中，已不见了\\S+的踪迹。', func = parse_unwield, enabled = true }
trigger.new{ name = 'inventory_normal_unwield', match = '^(> )*你将手中的\\S+插回\\S\\S鞘。', func = parse_unwield, enabled = true }
trigger.new{ name = 'inventory_zhujian_unwield', match = '^(> )*你放下手中的\\S+。', func = parse_unwield, enabled = true }
trigger.new{ name = 'inventory_zhen_unwield', match = '^(> )*你将绣花针插回绣花绷架。', func = parse_unwield, enabled = true }

trigger.new{ name = 'inventory_ferry_pay', match = '^(> )*你把钱交给船家', func = parse_ferry_pay, enabled = true }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
