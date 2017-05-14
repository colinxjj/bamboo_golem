
local npc = {}

--------------------------------------------------------------------------------
-- This module handles NPC related stuff
--------------------------------------------------------------------------------

-- load npc list
local index = require 'data.npc'

-- add iname to each npc and generate special npc list
local bank_index, pawnshop_index, grocery_index  = {}, {}, {}
for iname, person in pairs( index ) do
  person.iname = iname
  if person.label and person.label.bank then bank_index[ iname ] = person end
  if person.label and person.label.pawnshop then pawnshop_index[ iname ] = person end
  if person.label and person.label.grocery then grocery_index[ iname ] = person end
end

--------------------------------------------------------------------------------

function npc.get_index()
  return index
end

-- get a npc whose name or id matches the clue
function npc.get( clue )
  assert( type( clue ) == 'string', 'npc.get - param must be a string' )
  if index[ clue ] then
    return index[ clue ]
  else
  	for iname, person in pairs( index ) do
  		if iname == clue or person.name == clue or person.id == clue then
        return person
      elseif person.alternate_id then
        for _, id in pairs( person.alternate_id ) do
          if id == clue then return person end
        end
      end
  	end
  end
end

-- get a list of all npc's whoes name or id matches the clue
function npc.get_all( clue )
  assert( type( clue ) == 'string', 'npc.get_all - param must be a string' )
  local list = {}
  for iname, person in pairs( index ) do
    if iname == clue or person.name == clue or person.id == clue then
      list[ #list + 1 ] = person
    elseif person.alternate_id then
      for _, id in pairs( person.alternate_id ) do
        if id == clue then list[ #list + 1 ] = person; break end
      end
    end
  end
  return list
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return npc
