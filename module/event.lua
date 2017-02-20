
local event = {}

--------------------------------------------------------------------------------
-- This module handles events
--------------------------------------------------------------------------------

local registry, is_dispatching = {}
local event_to_process, listener_to_add, id_to_remove = {}, {}, {}
local history, history_startpos, history_endpos, history_promptpos = {}, 0, 0, 0

-- add event to history
local function add_to_history( evt )
  evt.time_stamp = os.time()

  history_endpos = history_endpos + 1
  history[ history_endpos ] = evt

  if history_endpos - history_startpos > 1000 then -- store 1000 history entries
    history[ history_startpos ] = nil
    history_startpos = history_startpos + 1
  end
end

gag_event = {
  prompt = true,
  room = true,
  room_object = true,
  located = true,
}

-- fires a new event
--[[ usage: event.new 'hp', -- simply specify the name of the event
or event.new{ -- or pass more details with a table
  event = 'room', -- name of the event (required)
  data = table_with_room_data, -- any addtional data (specific to event type) to send with the event, note that the param name of 'data' here is just an example (optional)
} ]]
function event.new( evt )
  assert( type( evt ) == 'table' and type( evt.event ) == 'string' or type( evt ) == 'string', 'event.new -  parameter must be a string or a table with \'event\' string field' )

  evt = type( evt ) == 'string' and { event = evt } or evt
  add_to_history( evt )
  table.insert( event_to_process, evt )
  --if not gag_event[ evt.event ] then message.debug( '触发新事件：' .. evt.event ) end
  if not is_dispatching then event.dispatch() end -- delay processing events if is dispatching
end

-- listen to an event / add to registry
--[[ usage: event.listen{
  event = 'room', -- name of the event to listen (required)
  func = parser_func, -- a function to call when the event fires (required)
  id = 'identifer_string',  -- unique id of the listener. listeners are unique to id/task combination (required)
  persistent = true, -- non-persistent listeners will only fire once (optional, default: false)
  keep_eval = false, -- continue to evaluate other listeners for the same event? (optional, default: true)
  sequence = 99 -- listeners of lower sequence will be evaluated first (optional, default: 100),
  task = a_task_instance, -- the task instance this listener belongs to. listeners from dead tasks will not fire and will be removed. (optional)
} ]]
function event.listen( t )
  assert( type( t ) == 'table', 'event.listen - parameter must be a table' )
  assert( type( t.event ) == 'string', 'event.listen - the event param must be a string' )
  assert( type( t.func ) == 'function', 'event.listen - the func param must be a function' )
  assert( type( t.id ) == 'string', 'event.listen - the id param must be a string' )

  table.insert( listener_to_add, t )
  if not is_dispatching then event.dispatch() end -- delay adding listener if is dispatching
end

-- remove all listeners with the specified id
function event.remove_listener_by_id( id )
  assert( type( id ) == 'string', 'event.remove_listener_by_id - parameter must be a string' )

  table.insert( id_to_remove, id )
  if not is_dispatching then event.dispatch() end -- delay removing listener if is dispatching
end

-- a factory that produces iterators on all the events since last prompt event
function event.since_last_prompt()
  local pos = history_promptpos
  return function()
    pos = pos + 1
    return history[ pos ]
  end
end

-- update the prompt position pointer
function event.update_history_promptpos()
  history_promptpos = history_endpos
end

-- add listener to registry
local function add_listener()
  while next( listener_to_add ) do
    local listener = table.remove( listener_to_add, 1 )
    if not registry[ listener.event ] then -- if no current listener, add the new one directly
      registry[ listener.event ] = { listener }
    else
      local list, seq, i, listener_in_list, inserted = registry[ listener.event ], listener.sequence or 100, 1 -- default sequence for an event listener is 100
      while i <= #list do -- insert at appropriate position
        listener_in_list = list[ i ]
        if listener_in_list.id == listener.id
        and listener_in_list.task == listener.task then
          table.remove( list, i ) -- remove old listener with the same id and task
        else
          if not inserted and seq < ( listener_in_list.sequence or 100 ) then
            table.insert( list, i, listener )
            inserted = true
          end
          i = i + 1
        end
      end
      if not inserted then table.insert( registry[ listener.event ], listener ) end -- append to end
    end
  end
end

local function process_next_event()
  local evt = table.remove( event_to_process, 1 ) -- get next event from queue
  local list = registry[ evt.event ]
  if not list then return end -- no listener for this event

  local i, exec_list, listener = 1, {}
  while i <= #list do -- process the listeners
    listener = list[ i ]
    if listener.task and ( listener.task.status == 'running' or listener.task.status == 'lurking' ) or not listener.task then -- only process listeners from running or lurking tasks and those with no associated tasks
      table.insert( exec_list, listener ) -- copy listeners to execute to a seperate list first to avoid recursion
      if not listener.persistent then -- remove non-persistent listeners
        table.remove( list, i )
        i = i - 1
      end
    end
    i = i + 1
    if listener.keep_eval == false then break end -- if keep_eval is false then stop processing remaining listeners
  end
  for _, listener in pairs( exec_list ) do
    -- message.debug( evt.event .. ' > ' .. listener.id )
    if listener.task then
      listener.func( listener.task, evt ) -- pass the task and/or event data as argument(s)
    else
      listener.func( evt )
    end
  end
  if not next( list ) then registry[ evt.event ] = nil end -- remove an event from registry if nothing is listening to it
end

local function remove_listener_by_id()
  while next( id_to_remove ) do
    local id = table.remove( id_to_remove )
    for evt, list in pairs( registry ) do
      local i, listener = 1
      while i <= #list do
        listener = list[ i ]
        if listener.id == id then
          table.remove( list, i )
        else
          i = i + 1
        end
      end
      if #list == 0 then registry[ evt ] = nil end
    end
  end
end

-- remove listeners from dead tasks
local function remove_listener_by_dead_task()
  for evt, list in pairs( registry ) do
    local i, listener = 1
    while i <= #list do
      listener = list[ i ]
      if listener.task and listener.task.status == 'dead' then
        table.remove( list, i )
      else
        i = i + 1
      end
    end
    if #list == 0 then registry[ evt ] = nil end
  end
end

function event.dispatch()
  is_dispatching = true
  if next( event_to_process ) then process_next_event() end
  if next( listener_to_add ) then add_listener() end
  if next( id_to_remove ) then remove_listener_by_id() end
  remove_listener_by_dead_task()
  is_dispatching = false
  if next( event_to_process ) then event.dispatch() end -- process next event in queue if any
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return event
