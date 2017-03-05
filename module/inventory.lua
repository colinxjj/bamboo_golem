
local inventory = {}

--------------------------------------------------------------------------------
-- This module handles inventory related stuff
--------------------------------------------------------------------------------

function inventory.has_item( name, count )
	assert( type( name ) == 'string', 'inventory.has_item - param must be a string' )
	assert( not count or type( count ) == 'number', 'inventory.has_item - the optional count param must be a number' )
	if not item.is_valid_type( name ) then
		return ( player.inventory[ name ] and ( player.inventory[ name ].count or 1 ) >= ( count or 1 ) ) and true or false
	else
		for iname in pairs( player.inventory ) do
			if item.is_type( iname, name ) then return true end
		end
	end
end

function inventory.add_item( object )
	assert( type( object ) == 'string' or type( object ) == 'table', 'inventory.add_item - param must be a string or table' )
	object = type( object ) == 'table' and object or { name = object }
	player.inventory[ object.name ] = object
end

function inventory.remove_item( name )
	assert( type( name ) == 'string', 'inventory.remove_item - param must be a string' )
	player.inventory[ name ] = nil
end

function inventory.get_item_count( name )
	assert( type( name ) == 'string', 'inventory.get_item_count - param must be a string' )
	return player.inventory[ name ] and player.inventory[ name ].count or 0
end


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return inventory
