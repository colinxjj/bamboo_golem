
local inventory = {}

--------------------------------------------------------------------------------
-- This module handles inventory related stuff
--------------------------------------------------------------------------------

function inventory.has_item( name, count )
	assert( type( name ) == 'string', 'inventory.has_item - param must be a string' )
	assert( not count or type( count ) == 'number', 'inventory.has_item - the optional count param must be a number' )
	if not item.is_valid_type( name ) then
		local it = item.get( name )
		name = it and it.name or name
		return ( player.inventory[ name ] and ( player.inventory[ name ].count or 1 ) >= ( count or 1 ) ) and true or false
	else
		-- TODO also check for item count of the specified type
		for iname in pairs( player.inventory ) do
			if item.is_type( iname, name ) then return true end
		end
	end
end

function inventory.add_item( object )
	assert( type( object ) == 'string' or type( object ) == 'table', 'inventory.add_item - param must be a string or table' )
	if type( object ) == 'string' then object = { name = object, id = item.get_id( object ) } end
	player.inventory[ object.name ] = object
end

function inventory.remove_item( name )
	assert( type( name ) == 'string', 'inventory.remove_item - param must be a string' )
	local it = item.get( name )
	name = it and it.name or name
	player.inventory[ name ] = nil
end

function inventory.get_item_count( name )
	assert( type( name ) == 'string', 'inventory.get_item_count - param must be a string' )
	local it = item.get( name )
	name = it and it.name or name
	return player.inventory[ name ] and player.inventory[ name ].count or 0
end

function inventory.get_item_id ( name )
	assert( type( name ) == 'string', 'inventory.get_item_id - param must be a string' )
	for iname, it in pairs( player.inventory ) do
		if iname == name then return it.id end
	end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return inventory
