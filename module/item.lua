
local item = {}

--------------------------------------------------------------------------------
-- This module handles items related stuff
--------------------------------------------------------------------------------

-- load the item list
local index = require 'data.item'

local weapon_type = {
	blade = '��', sword = '��', dagger = 'ذ��', flute = '��', hook = '��', axe = '��', brush = '��',
	staff = '��', club = '��', stick = '��', hammer = '��', whip = '��', throwing = '����' }

local armor_type = { cloth = '�·�', armor = '����', shoes = 'Ь��', helm = 'ͷ��', mantle = '����' }

local sharp_weapon_type = { blade = true, sword = true, dagger = true, hook = true, axe = true, }

local stackable_item = {
  ['�ƽ�'] = true,
  ['����'] = true,
  ['ͭǮ'] = true,
  ['ʯ��'] = true,
  ['������'] = true,
  ['˦��'] = true,
}

local item_type_name_patt = {
	blade = lpeg.P '��',
	sword = lpeg.P '��' + '��',
	dagger = lpeg.P 'ذ��' + 'ذ',
	flute = lpeg.P '��' + '��',
	hook = lpeg.P '��',
	axe = lpeg.P '��' + '��ͷ',
	brush = lpeg.P '��',
	staff = lpeg.P '��' + '��',
	club = lpeg.P '��',
	stick = lpeg.P '��',
	hammer = lpeg.P '��',
	whip = lpeg.P '��' + '��' + '��',
	throwing = lpeg.P '��',

	cloth = lpeg.P '����' + '��' + '��' + 'Ƥ' + '��' + '��',
	armor = lpeg.P '��' + '����',
	shoes = lpeg.P 'Ь' + 'ѥ' + '��',
	helm = lpeg.P '��' + 'ñ',
	mantle = lpeg.P '����',
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

function item.is_carrying( object )
	object = type( object ) == 'string' and { name = object } or object
	if object.name then
		return ( player.inventory[ object.name ] and player.inventory[ object.name ].count >= ( object.count or 1 ) ) and true or false
	elseif object.type == 'sharp_weapon' then
		for _, it in pairs( player.inventory ) do
			if item.is_sharp_weapon( it ) then return true end
		end
	end
end



--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return item
