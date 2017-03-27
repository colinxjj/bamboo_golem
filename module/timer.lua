
local timer = {}

--------------------------------------------------------------------------------
-- This module handles timers
--------------------------------------------------------------------------------

local timetable = {}

-- set up a new timer
--[[ usage: timer.new{
  duration = 10, -- duration of the timer in seconds (required)
  func = a_func, -- the function to call when the timer fires (required)
  id = 'identifier_string', -- a unique identifier of the timer (required)
  persistent = true, -- non-persistent timers will only fire once (optional, default: false) -- TODO
} ]]
function timer.new( t )
  assert( type( t ) == 'table', 'timer.new - parameter must be a table' )
  assert( type( t.duration ) == 'number', 'timer.new - the duration param must be a number' )
  assert( type( t.func ) == 'function', 'timer.new - the func param must be a function' )
  assert( type( t.id ) == 'string', 'timer.new - the id param must be a string' )

  timer.remove_by_id( t.id ) -- remove existing timer with same id, if there's one

  t.target_hbcount = get_heartbeat_count() + t.duration / HEARTBEAT_INTERVAL
  timetable[ t.target_hbcount ] = timetable[ t.target_hbcount ] or {}
  table.insert( timetable[ t.target_hbcount ], t )
end

-- called by heartbeat to check for and fire timers
function timer.refresh( hbcount )
  local list = timetable[ hbcount ]
  if list then
    for _, t in pairs( list ) do
      if t.task and ( t.task.status == 'running' or t.task.status == 'lurking' ) or not t.task then
        t.func( t.task )
      end
    end
    timetable[ hbcount ] = nil
  end
end

-- remove timer by id
function timer.remove_by_id( id )
  for time, list in pairs( timetable ) do
    for i , t in pairs( list ) do
      if t.id == id then list[ i ] = nil end
    end
    if not next( list ) then timetable[ time ] = nil end
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return timer
