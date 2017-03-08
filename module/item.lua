
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
	-- add npc_cmd sources
	if person.provide then
		for _, it in pairs( person.provide ) do
			if not index[ it.item ] then error( 'no data found for item ' .. it.item ) end
			index[ it.item ].source  = index[ it.item ].source or {}
			slist = index[ it.item ].source
			source = { type = 'cmd', location = person.location, npc = person_id, cmd = it.cmd, cond = it.cond }
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

local armor_type = { cloth = '“¬∑˛', armor = 'ª§º◊', shoes = '–¨◊”', helm = 'Õ∑ø¯', mantle = '≈˚∑Á', waist = '—¸¥¯', wrist = 'ª§ÕÛ' }

local sharp_weapon_type = { blade = true, sword = true, dagger = true, hook = true, axe = true, }

local valid_type = { weapon = 'Œ‰∆˜', armor = '∑¿æﬂ', sharp_weapon = '∑Ê¿˚Œ‰∆˜',
	blade = 'µ∂', sword = 'Ω£', dagger = 'ÿ∞ ◊', flute = 'ÛÔ', hook = 'π≥', axe = '∏´', brush = '± ',
	staff = '’»', club = 'π˜', stick = '∞Ù', hammer = '¥∏', whip = '±ﬁ', throwing = '∞µ∆˜',
	cloth = '“¬∑˛', armor = 'ª§º◊', shoes = '–¨◊”', helm = 'Õ∑ø¯', mantle = '≈˚∑Á', waist = '—¸¥¯', wrist = 'ª§ÕÛ',
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
local type_index = { weapon = {}, sharp_weapon = {}, armor = {} }
for iname, it in pairs( index ) do
	if it.type then
		type_index[ it.type ] = type_index[ it.type ] or {}
		type_index[ it.type ][ iname ] = it
		if weapon_type[ it.type ] then type_index.weapon[ iname ] = it end
		if sharp_weapon_type[ it.type ] then type_index.sharp_weapon[ iname ] = it end
		if armor_type[ it.type ] then type_index.armor[ iname ] = it end
	end
end

--------------------------------------------------------------------------------

function item.get( name )
	assert( type( name ) == 'string', 'item.get - param must be a string' )
  for iname, it in pairs( index ) do
    if it.name == name or iname == name then return it end -- only returns the first item matching the name
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
  for _, it in pairs( index ) do
    if it.name == name or iname == name then return it.id end -- only returns the id of the first item matching the name
  end
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

function item.get_all_source( name )
	assert( type( name ) == 'string', 'item.get_all_source - param must be a string' )
	if not item.is_valid_type( name ) then
		for iname, it in pairs( index ) do
			if it.name == name or iname == name then
				cleanup_temp_source( it.source )
				return it.source
			end
		end
	else
		local item_list = item.get_by_type( name )
		if not item_list then return end
		local slist = {}
		for iname, it in pairs( item_list ) do
			cleanup_temp_source( it.source )
			for _, source in pairs( it.source ) do
				slist[ #slist + 1 ] = source
			end
		end
		return slist
	end
end

local function calculate_source_score( source, is_quality_ignored )
	-- rank sources whose condition the player doesn't meet very low scores
	if source.cond and not cond_checker[ source.cond ]() then return -1000000 end
	--print( source.item, source.location )
	local score = 0
	-- distance score
	local loc = map.get_current_location()[ 1 ]
	local path_cost = map.getcost( loc, source.location )
	if not path_cost then return -1000000 end -- no path cost means that we can't get to this source
	score = score - path_cost * 0.5
	--print( 'distance score: -' .. path_cost * 0.5 )
	-- weight score
	local weight = item.get( source.item ).weight
	if weight then
		local encumbrance = weight / player.encumbrance_max * 100
		score = score - math.ceil( encumbrance * 50 ) / 10
		--print( 'weight score: -' .. math.ceil( encumbrance * 50 ) / 10 )
	end
	-- price score
	local value = item.get( source.item ).value
	if value and source.type == 'shop' then
		local silver = value / 100
		score = score - silver
		--print( 'price score: -' .. silver )
	end
	-- quality score
	local quality = item.get( source.item ).quality
	if quality and not is_quality_ignored then
		score = score + quality
		--print( 'quality score: +' .. quality )
	end
	--print( 'total score: ' .. score )
	return score
end

local function sort_by_score( a, b )
	return a.score > b.score
end

function item.get_sorted_source( name, is_quality_ignored )
	assert( type( name ) == 'string', 'item.get_sorted_source - param must be a string' )
	local slist = item.get_all_source( name )
	for _, source in pairs( slist ) do
		source.score = calculate_source_score( source, is_quality_ignored )
	end
	table.sort( slist, sort_by_score )
	--tprint( slist )
	return slist
end

function item.get_best_source( name, is_quality_ignored )
	assert( type( name ) == 'string', 'item.get_best_source - param must be a string' )
	local slist = item.get_sorted_source( name, is_quality_ignored )
	for _, source in ipairs( slist ) do
		if item.is_valid_source( source ) then return source end
	end
end

function item.is_valid_source( source )
	local is_valid = ( not source.last_fail_time or os.time() - source.last_fail_time > 200 ) -- if last try at a source failed, then only retry that source at least 200 seconds later
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
	assert( map.get_room_by_id( loc ), 'item.add_temp_item_source - invalid loc param' )
	assert( type( name ) == 'string', 'item.add_temp_item_source - the name param must be a string' )
	assert( not count or type( count ) == 'number', 'item.add_temp_item_source - the count param must be a string' )
	assert( not id or type( id ) == 'string', 'item.add_temp_item_source - the id param must be a string' )

	local it = item.get( name )
	-- igbore items not in database or with unmatched id's
	if name == 'Õ≠«Æ' or not it or ( id and id ~= it.id ) then return end

	it.source = it.source or {}
	-- ignore location already have a "get" source for the same item
	for _, source in pairs( it.source ) do
		if source.location == loc and source.type == 'get' then return end
	end
	-- add the new temp source
	it.source[ #it.source + 1 ] = { item = it.iname, type = 'get', location = loc, is_temp = true, add_time = os.time() }
	message.debug( 'ÃÌº”¡Ÿ ±ŒÔ∆∑¿¥‘¥£∫' .. name .. ' - ' .. loc )
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
