
local inventory = {}

--------------------------------------------------------------------------------
-- This module handles inventory related stuff
--------------------------------------------------------------------------------

function inventory.has_item( object )
	object = type( object ) == 'string' and { name = object } or object
	if object.name then
		return ( player.inventory[ object.name ] and ( player.inventory[ object.name ].count or 1 ) >= ( object.count or 1 ) ) and true or false
	elseif object.type == 'sharp_weapon' then
		for _, it in pairs( player.inventory ) do
			if item.is_sharp_weapon( it ) then return true end
		end
	end
end

function inventory.add_item( object )
	object = type( object ) == 'string' and { name = object } or object
	player.inventory[ object.name ] = object
end

function inventory.remove_item( object )
	object = type( object ) == 'string' and { name = object } or object
	player.inventory[ object.name ] = nil
end


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return inventory
