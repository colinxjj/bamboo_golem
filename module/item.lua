
local item = {}

--------------------------------------------------------------------------------
-- This module handles items related stuff
--------------------------------------------------------------------------------

-- load the item list
local index = require 'data.item'

local money_list = { 'ª∆Ω', '∞◊“¯', 'Õ≠«Æ' }

-- add item sources based on npc data
local stype, slist, source
for person_id, person in pairs( npc ) do
	-- add shop or loot sources
	if person.catalogue or person.loot then
		stype = person.catalogue and 'shop' or 'loot'
		for _, iname in pairs( person.catalogue or person.loot ) do -- that means a npc can't be both a shop and a loot source
			if not index[ iname ] then error( 'no data found for item ' .. iname ) end
			index[ iname ].source = index[ iname ].source or {}
			slist = index[ iname ].source
			source = { type = stype, location = person.location, npc = person_id }
			slist[ #slist + 1 ] = source
		end
	end
	-- add banks as local_handler sources
	if person.label and person.label.bank then
		for _, money in pairs( money_list ) do
			index[ money ].source = index[ money ].source or {}
			slist = index[ money ].source
			source = { type = 'local_handler', handler = 'withdraw', cond = 'player.bank_gold_balance > 0', location = person.location, npc = person_id }
			slist[ #slist + 1 ] = source
		end
	end
	-- add npc cmd or local_handler sources
	if person.provide then
		for _, it in pairs( person.provide ) do
			if not index[ it.item ] then error( 'no data found for item ' .. it.item ) end
			index[ it.item ].source  = index[ it.item ].source or {}
			slist = index[ it.item ].source
			source = { type = it.handler and 'local_handler' or 'cmd', location = person.location, npc = person_id, handler = it.handler, cmd = it.cmd, cond = it.cond }
			slist[ #slist + 1 ] = source
		end
	end
end

-- add iname to each item source and compile source conditions to functions
local cond_checker = {}
for iname, it in pairs( index ) do
	if it.source then
		for _, source in pairs( it.source ) do
			source.item = iname
			if source.cond then cond_checker[ source.cond ] = loadstring( 'return ' .. source.cond ) end
		end
	end
end

local weapon_type = {
	blade = 'µ∂', sword = 'Ω£', dagger = 'ÿ∞ ◊', flute = 'ÛÔ', hook = 'π≥', axe = '∏´', brush = '± ',
	staff = '’»', club = 'π˜', stick = '∞Ù', hammer = '¥∏', whip = '±ﬁ', throwing = '∞µ∆˜' }

local armor_type = { cloth = '“¬∑˛', armor = 'ª§º◊', shoes = '–¨◊”', helm = 'Õ∑ø¯', mantle = '≈˚∑Á', waist = '—¸¥¯', wrist = 'ª§ÕÛ', neck = 'œÓ¡¥' }

local sharp_weapon_type = { blade = true, sword = true, dagger = true, hook = true, axe = true, }

local valid_type = { food = ' ≥ŒÔ', drink = '“˚ÀÆ', drink_container = ' ¢ÀÆ»›∆˜', drug = '“©ŒÔ', weapon = 'Œ‰∆˜', armor = '∑¿æﬂ', sharp_weapon = '∑Ê¿˚Œ‰∆˜',
	blade = 'µ∂', sword = 'Ω£', dagger = 'ÿ∞ ◊', flute = 'ÛÔ', hook = 'π≥', axe = '∏´', brush = '± ',
	staff = '’»', club = 'π˜', stick = '∞Ù', hammer = '¥∏', whip = '±ﬁ', throwing = '∞µ∆˜',
	cloth = '“¬∑˛', armor = 'ª§º◊', shoes = '–¨◊”', helm = 'Õ∑ø¯', mantle = '≈˚∑Á', waist = '—¸¥¯', wrist = 'ª§ÕÛ', neck = 'œÓ¡¥'
}

local stackable_item = {
  ['ª∆Ω'] = true,
  ['∞◊“¯'] = true,
  ['Õ≠«Æ'] = true,
  [' Ø◊”'] = true,
  ['…Ò¡˙Ô⁄'] = true,
  ['À¶º˝'] = true,
}

local item_type_name_patt = {
	blade = lpeg.P 'µ∂',
	sword = lpeg.P 'Ω£' + '»–',
	dagger = lpeg.P 'ÿ∞ ◊' + 'ÿ∞',
	flute = lpeg.P 'µ—' + 'ÛÔ',
	hook = lpeg.P 'π≥',
	axe = lpeg.P '∏´' + '∏´Õ∑',
	brush = lpeg.P '± ',
	staff = lpeg.P '’»' + 'Ë∆',
	club = lpeg.P 'π˜',
	stick = lpeg.P '∞Ù',
	hammer = lpeg.P '¬÷',
	whip = lpeg.P '±ﬁ' + '¡¥' + 'À˜',
	throwing = lpeg.P 'Ô⁄',

	cloth = lpeg.P 'Ù¬Ùƒ' + '“¬' + '≈€' + '∆§' + '…—' + '…¿',
	armor = lpeg.P 'º◊' + '±≥–ƒ',
	shoes = lpeg.P '–¨' + '—•' + '¬ƒ',
	helm = lpeg.P 'ø¯' + '√±',
	mantle = lpeg.P '≈˚∑Á',
}

-- generate actual patterns
for type, patt in pairs( item_type_name_patt ) do
  item_type_name_patt[ type ] = any_but( patt )^0 * patt * -1
end

-- generate type indices
local type_index = { weapon = {}, sharp_weapon = {}, armor = {}, drink = {} }
for iname, it in pairs( index ) do
	if it.type then
		-- add to type indeces
		type_index[ it.type ] = type_index[ it.type ] or {}
		type_index[ it.type ][ iname ] = it
		-- add to special type indices
		if it.type == 'drink_container' then type_index.drink[ iname ] = it end
		if weapon_type[ it.type ] then type_index.weapon[ iname ] = it end
		if sharp_weapon_type[ it.type ] then type_index.sharp_weapon[ iname ] = it end
		if armor_type[ it.type ] then type_index.armor[ iname ] = it end
	end
end

--------------------------------------------------------------------------------

local function is_name_match( name, index_name )
	if name == index_name then return true end
	if type( index_name ) == 'table' then
		for _, possible_name in pairs( index_name ) do
			if name == possible_name then return true end
		end
	end
end

function item.get( name, id )
	assert( type( name ) == 'string', 'item.get - param must be a string' )
	assert( not id or type( id ) == 'string', 'item.get - the optional id param must be a string' )
	if index[ name ] and ( not id or index[ name ].id == id ) then return index[ name ] end
  for iname, it in pairs( index ) do
    if ( is_name_match( name, it.name ) or name == iname ) and ( not id or id == it.id ) then return it end
  end
end

function item.get_by_id ( id )
	assert( type( id ) == 'string', 'item.get_by_id - param must be a string' )
	for _, it in pairs( index ) do
    if it.id == id then return it end -- only returns the first item matching the id
		if it.alternate_id then
			for _, alt_id in pairs( it.alternate_id ) do
				if alt_id == id then return it end
			end
		end
  end
end

function item.get_by_type( name )
	assert( type( name ) == 'string', 'item.get_by_type - param must be a string' )
	return type_index[ name ]
end

function item.get_id( name )
	assert( type( name ) == 'string', 'item.get_id - param must be a string' )
	local it = item.get( name )
	return it and it.id
end

function item.get_type( name )
	assert( type( name ) == 'string', 'item.get_type - param must be a string' )
	local it, type = item.get( name )
	for type_name, patt in pairs( item_type_name_patt ) do
    if patt:match( name ) then type = type_name; break end
  end
  type = it and it.type or type
	return type
end

function item.is_type( name, stype )
	assert( type( name ) == 'string', 'item.is_type - the name param must be a string' )
	assert( type( stype ) == 'string', 'item.is_type - the type param must be a string' )
	local itype = item.get_type( name ) or ''
	if stype == 'sharp_weapon' then
		return sharp_weapon_type[ itype ] and true or false
	elseif stype == 'weapon' then
		return weapon_type[ itype ] and true or false
	elseif stype == 'armor' then
		return armor_type[ itype ] and true or false
	else
		return stype == itype
	end
end

function item.is_stackable( name )
	assert( type( name ) == 'string', 'item.is_stackable - param must be a string' )
  return stackable_item[ name ] or false
end

function item.is_valid_type( name )
	assert( type( name ) == 'string', 'item.is_valid_type - param must be a string' )
	return valid_type[ name ]
end

function item.get_value( name )
	assert( type( name ) == 'string', 'item.get_value - param must be a string' )
	local it = item.get( name )
	return it.value
end

-- convert a table of amount of gold, silver and coin (mostly player.inventory) to cash value
function item.get_cash_by_money( t )
	local cash = 0
  if t[ 'ª∆Ω' ] and t[ 'ª∆Ω' ].count then cash = cash + t[ 'ª∆Ω' ].count * 10000 end
  if t[ '∞◊“¯' ] and t[ '∞◊“¯' ].count then cash = cash + t[ '∞◊“¯' ].count * 100 end
  if t[ 'Õ≠«Æ' ] and t[ 'Õ≠«Æ' ].count then cash = cash + t[ 'Õ≠«Æ' ].count end
  return cash
end

-- convert a cash value to a table of amount of gold, silver and coin
function item.get_money_by_cash( cash )
	local t = {}
  t[ 'ª∆Ω' ] = math.modf( cash / 10000 )
  cash = cash - t[ 'ª∆Ω' ] * 10000
  t[ '∞◊“¯' ] = math.modf( cash / 100 )
  cash = cash - t[ '∞◊“¯' ] * 100
  t[ 'Õ≠«Æ' ] = cash
  return t
end

function item.get_approx_money_by_cash( cash )
	local money = item.get_money_by_cash( cash )
	for _, m in pairs( money_list ) do
		if money[ m ] > 0 then return m, money[ m ] + 1 end
	end
end

--------------------------------------------------------------------------------
-- item sources related stuff

function item.reset_all_invalid_source()
	for _, it in pairs( index ) do
		if it.source then
			for _, source in pairs( it.source ) do
				source.is_invalid = nil
			end
		end
	end
end

local function cleanup_temp_source( slist )
	local i, source = 1
	while slist[ i ] do
		source = slist[ i ]
		-- remove temp source that is over 15 minutes old
		if source.is_temp and os.time() - source.add_time >= 900 then
			table.remove( slist, i )
			print( 'remove temp item source: ' .. source.item .. ' at ' .. source.location )
		else
			i = i + 1
		end
	end
end

function item.get_all_source( name, item_filter )
	assert( type( name ) == 'string', 'item.get_all_source - param must be a string' )
	if not item.is_valid_type( name ) then -- get sources for a specific item
		local it = item.get( name )
		cleanup_temp_source( it.source )
		return it.source
	else -- get sources for a type of items
		local item_list = item.get_by_type( name )
		if not item_list then return end
		local slist = {}
		for iname, it in pairs( item_list ) do
			if it.source and not it.source.is_invalid and ( not item_filter or item_filter( iname ) ) then
				cleanup_temp_source( it.source )
				for _, source in pairs( it.source ) do
					slist[ #slist + 1 ] = source
				end
			end
		end
		return slist
	end
end

local function calculate_item_quality_score( it )
	-- if item has quality value, just return it
	if it.quality then return it.quality end
	-- for food and drinks, quality is based its total supply
	if it.food_supply or it.water_supply then return ( it.consume_count or 1 ) * ( ( it.food_supply or 0 ) + ( it.water_supply or 0 ) ) * 0.2 end
	-- for drink containers, quality is based its initial drink supply
	if it.drink then return it.drink.consume_count * 6 end
	-- default is 0
	return 0
end

local function calculate_source_score( source, t )
	-- if source has been marked as invalid, then return a very low score
	if source.is_invalid then return -1000000 end
	-- rank sources whose condition the player doesn't meet very low scores
	if source.cond and not cond_checker[ source.cond ]() then return -1000000 end
	--print( source.item, source.location )
	local score = 0
	-- distance score
	if not t.is_distance_ignored then
		local loc = map.get_current_location()[ 1 ]
		local path_cost = map.get_cost( loc, source.location )
		if not path_cost then return -1000000 end -- no path cost means that we can't get to this source
		score = score - path_cost * 0.8
		--print( 'distance score: -' .. path_cost * 0.8 )
	end
	-- weight score
	local weight = item.get( source.item ).weight
	if not t.is_weight_ignored and weight then
		local encumbrance = weight / player.encumbrance_max * 100
		score = score - math.ceil( encumbrance * 50 ) / 10
		--print( 'weight score: -' .. math.ceil( encumbrance * 50 ) / 10 )
	end
	-- price score
	local value = item.get( source.item ).value
	if not t.is_price_ignored and value and source.type == 'shop' then
		local silver = value / 100
		score = score - silver
		--print( 'price score: -' .. silver )
	end
	-- quality score
	local quality = calculate_item_quality_score( item.get( source.item ) )
	if not t.is_quality_ignored and quality then
		score = score + quality
		--print( 'quality score: +' .. quality )
	end
	-- give 'get' sources a little bit higher score, so that among multiple sources at a same location, get sources are tried first
	if source.type == 'get' then score = score + 0.1 end
	--print( 'total score: ' .. score )
	return score
end

local function sort_by_score( a, b )
	return a.score > b.score
end

function item.get_sorted_source( t )
	assert( type( t ) == 'table', 'item.get_sorted_source - param must be a string' )
	assert( type( t.item ) == 'string', 'item.get_sorted_source - the item param must be a string' )
	local slist = item.get_all_source( t.item, t.item_filter ) or {}
	for _, source in pairs( slist ) do
		source.score = calculate_source_score( source, t )
		-- if a custom source evaluator is specified, then use it to adjust the score
		source.score = t.source_evaluator and ( source.score + ( t.source_evaluator( source ) or 0 ) ) or source.score
	end
	table.sort( slist, sort_by_score )
	--tprint( slist )
	return slist
end

function item.get_best_source( t )
	assert( type( t ) == 'table', 'item.get_best_source - param must be a string' )
	assert( type( t.item ) == 'string', 'item.get_best_source - the item param must be a string' )
	local slist = item.get_sorted_source( t )
	for _, source in ipairs( slist ) do
		if item.is_valid_source( source ) then return source end
	end
end

function item.is_valid_source( source )
	local is_valid = not source.is_invalid
							 and ( not source.last_fail_time or os.time() - source.last_fail_time > 200 ) -- if last try at a source failed, then only retry that source at least 200 seconds later
							 and ( not source.cond or cond_checker[ source.cond ]() ) -- always check source cond in case player status changed, e.g. bank balance update could result in all bank sources not being valid any more
							 and source.score > -1000 -- ignore soure with very low scores
	return is_valid
end

function item.mark_invalid_source( source )
	source.first_fail_time = source.first_fail_time or os.time()
	source.last_fail_time = os.time()
	source.fail_count = source.fail_count and source.fail_count + 1 or 1
end

function item.add_temp_item_source ( loc, name, id )
	loc = type( loc ) == 'table' and loc.id or loc
	if not map.get_room_by_id( loc ) then return end
	--assert( map.get_room_by_id( loc ), 'item.add_temp_item_source - invalid loc param' )
	assert( type( name ) == 'string', 'item.add_temp_item_source - the name param must be a string' )
	assert( not count or type( count ) == 'number', 'item.add_temp_item_source - the count param must be a string' )
	assert( not id or type( id ) == 'string', 'item.add_temp_item_source - the id param must be a string' )

	local it = item.get( name, id )
	-- igbore items not in database or with unmatched id's
	if name == 'Õ≠«Æ' or not it or ( id and id ~= it.id ) then return end

	it.source = it.source or {}
	-- ignore location already have a "get" source for the same item
	for _, source in pairs( it.source ) do
		if source.location == loc and source.type == 'get' then return end
	end
	-- add the new temp source
	it.source[ #it.source + 1 ] = { item = it.iname, type = 'get', location = loc, is_temp = true, add_time = os.time() }
	message.debug( 'ÃÌº”¡Ÿ ±ŒÔ∆∑¿¥‘¥£∫' .. it.iname .. ' - ' .. loc )
end

function item.remove_temp_item_source( loc, name )
	loc = type( loc ) == 'table' and loc.id or loc
	assert( map.get_room_by_id( loc ), 'item.remove_temp_item_source - invalid loc param' )
	assert( type( name ) == 'string', 'item.remove_temp_item_source - the name param must be a string' )

	local it = item.get( name )
	if not it or not it.source then return end

	for i, source in pairs( it.source ) do
		if source.location == loc and source.type == 'get' and source.is_temp then
			table.remove( it.source, i )
			return -- there shouldn't be more than one temp source for each item / loc pair so this should be fine
		end
	end
end

-- automatically add rooms with appropriate items on ground as temporary item sources
local function parse_potential_temp_item_source( evt )
	for name, object in pairs( room.get().object ) do
		item.add_temp_item_source( evt.location[ 1 ], name, object.id )
	end
end

event.listen{ event = 'located', func = parse_potential_temp_item_source, id = 'item.parse_potential_temp_item_source', persistent = true, sequence = 99 }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return item
