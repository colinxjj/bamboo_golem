
local item = {}

--------------------------------------------------------------------------------
-- This module handles items related stuff
--------------------------------------------------------------------------------

-- load the item list
local index = require 'data.item'

-- add item sources based on npc data
local stype, slist, source
for person_id, person in pairs( npc ) do
	if person.catalogue or person.loot then -- add shop or loot sources
		stype = person.catalogue and 'shop' or 'loot'
		for _, item_id in pairs( person.catalogue or person.loot ) do -- that means a npc can't be both a shop and a loot source
			if not index[ item_id ] then error( 'no data found for item ' .. item_id ) end
			index[ item_id ].source = index[ item_id ].source or {}
			slist = index[ item_id ].source
			source = { type = stype, location = person.location, npc = person_id }
			table.insert( slist, source )
		end
	end
	if person.provide then -- add npc_cmd sources
		for _, it in pairs( person.provide ) do
			if not index[ it.item ] then error( 'no data found for item ' .. it.item ) end
			index[ it.item ].source  = index[ it.item ].source or {}
			slist = index[ it.item ].source
			source = { type = 'npc_cmd', location = person.location, npc = person_id, cmd = it.cmd, cond = it.cond }
			table.insert( slist, source )
		end
	end
end

local weapon_type = {
	blade = 'µ¶', sword = '½£', dagger = 'Ø°Ê×', flute = 'óï', hook = '¹³', axe = '¸«', brush = '±Ê',
	staff = 'ÕÈ', club = '¹÷', stick = '°ô', hammer = '´¸', whip = '±Þ', throwing = '°µÆ÷' }

local armor_type = { cloth = 'ÒÂ·þ', armor = '»¤¼×', shoes = 'Ð¬×Ó', helm = 'Í·¿ø', mantle = 'Åû·ç' }

local sharp_weapon_type = { blade = true, sword = true, dagger = true, hook = true, axe = true, }

local stackable_item = {
  ['»Æ½ð'] = true,
  ['°×Òø'] = true,
  ['Í­Ç®'] = true,
  ['Ê¯×Ó'] = true,
  ['ÉñÁúïÚ'] = true,
  ['Ë¦¼ý'] = true,
}

local item_type_name_patt = {
	blade = lpeg.P 'µ¶',
	sword = lpeg.P '½£' + 'ÈÐ',
	dagger = lpeg.P 'Ø°Ê×' + 'Ø°',
	flute = lpeg.P 'µÑ' + 'óï',
	hook = lpeg.P '¹³',
	axe = lpeg.P '¸«' + '¸«Í·',
	brush = lpeg.P '±Ê',
	staff = lpeg.P 'ÕÈ' + 'èÆ',
	club = lpeg.P '¹÷',
	stick = lpeg.P '°ô',
	hammer = lpeg.P 'ÂÖ',
	whip = lpeg.P '±Þ' + 'Á´' + 'Ë÷',
	throwing = lpeg.P 'ïÚ',

	cloth = lpeg.P 'ôÂôÄ' + 'ÒÂ' + 'ÅÛ' + 'Æ¤' + 'ÉÑ' + 'ÉÀ',
	armor = lpeg.P '¼×' + '±³ÐÄ',
	shoes = lpeg.P 'Ð¬' + 'Ñ¥' + 'ÂÄ',
	helm = lpeg.P '¿ø' + 'Ã±',
	mantle = lpeg.P 'Åû·ç',
}

-- generate actual patterns
for type, patt in pairs( item_type_name_patt ) do
  item_type_name_patt[ type ] = any_but( patt )^0 * patt * -1
end

function item.get_item( object )
  object = type( object ) == 'string' and ( object:find( '^[a-z0-9 ,\'%-]+$' ) and { id = object } or { name = object } ) or object
  for _, it in pairs( index ) do
    if ( not object.name or it.name == object.name ) and ( not object.id or object.id == it.id ) then return it end -- only returns the first item matching the name and/or id
  end
end

function item.get_id( object )
  object = type( object ) == 'string' and { name = object } or object
	if object.id then return object.id end
  for _, it in pairs( index ) do
    if it.name == object.name then return it.id end -- only returns the id of the first item matching the name
  end
end

function item.get_type( object )
  object = type( object ) == 'string' and { name = object } or object
	local it, type = item.get_item( object )
	for type_name, patt in pairs( item_type_name_patt ) do
    if patt:match( object.name ) then type = type_name; break end
  end
  type = it and it.type or type
	return type
end

function item.is_weapon( object )
  local type = item.get_type( object ) or ''
  return weapon_type[ type ] and true or false
end

function item.is_sharp_weapon( object )
	local type = item.get_type( object ) or ''
  return sharp_weapon_type[ type ] and true or false
end

function item.is_stackable( name )
  return stackable_item[ name ] or false
end



--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return item
