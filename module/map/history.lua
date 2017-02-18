
local history = {}

--------------------------------------------------------------------------------
-- This module handles location history
--------------------------------------------------------------------------------

-- player location history
local lochistory, startpos, endpos = {}, 0, 0

-- add an entry to location history
function history.insert( entry )
  endpos = endpos + 1
  lochistory[ endpos ] = entry

  if endpos - startpos > 100 then -- store 100 history entries
    lochistory[ startpos ] = nil
    startpos = startpos + 1
  end

  return entry
end

-- fetch entry from history
function history.query_last()
  return lochistory[ endpos - 1 ]
end

function history.query_current()
  return lochistory[ endpos ]
end
--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return history
