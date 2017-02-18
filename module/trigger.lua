
local trigger = {}

--------------------------------------------------------------------------------
-- This module manipulates triggers
--------------------------------------------------------------------------------

-- a list of valid trigger params
local valid_param = {
  name = true,
  text = true,
  func = true,
  group = true,
  task = true,
  enabled = true,
  omit = true,
  keep_eval = true,
  oneshot = true,
  sequence = true,
}

-- a table to associate a trigger name with its details
local list = {}
-- a table contains trigger group info
local group = {}

-- add a new trigger
--[[ usage: trigger.new{
  name = 'unique_id', -- unique id of the trigger, need to follow MC's rules on trigger names, most notably, it can't contain dots (.) (required)
  text = 'text to trigger on', -- text to trigger on, in regex (required)
  func = a_func_to_call,-- a function to call when the trigger fires (required)
  task = a_task_instance, -- the task instance the trigger belongs to. triggers for dead tasks won't be fired and will be removed (optional)
  group = 'group_name', -- the trigger group this trigger belongs to (optional)
  sequence = 99, -- trigger of lower sequence will be evaluated first (optional, default: 100)
  keep_eval = false, -- continue to evaluate other triggers for the same line? (optional, default: true)
  enabled = true, -- is the trigger enabled by default? (optional, default: false)
  omit = true, -- omit the line from output? (optional, default: false)
  oneshot = true, -- will the trigger only be fired once? (optional, default: false)
} ]]
function trigger.new( t )
  assert( type( t ) == 'table', 'trigger.new - parameter must be a table' )
  assert( type( t.name ) == 'string', 'trigger.new - the name param must be a string' )
  assert( type( t.text ) == 'string', 'trigger.new - the text param must be a string' )
  assert( type( t.func ) == 'function', 'trigger.new - the func param must be a function' )
  for k in pairs( t ) do -- check for invalid params
    assert( valid_param[ k ], 'trigger.new - invalid trigger parameter: ' .. k )
  end

  -- check for name conflicts
  if list[ t.name ] then trigger.remove( t.name ) end -- delete current trigger with same name

  -- evaluate flags
  local flags = t.enabled == true and 33 or 32 -- always use regular expression triggers, triggers are disabled by default
    + ( t.omit and 6 or 0 ) --omit from both the log and the output
    + ( t.keep_eval and 8 or 0 )
    + ( t.oneshot and 32768 or 0 )

  local result = world.AddTriggerEx( t.name, t.text, '', flags, t.color or -1, 0, '', 'trigger.parse', 0, t.sequence or 100 )

  if result == 0 then -- 0 = error_code.eOK
    list[ t.name ] = t
    if t.group then -- add to trigger group
      group[ t.group ] = group[ t.group ] or {}
      group[ t.group ][ t.name ] = true
    end
  else
    error( 'trigger.new - AddTriggerEx returned the following error: ' .. translate_errorcode( result ) )
  end
end

-- a central parser for all triggers, calls the function associated with the trigger
function trigger.parse( name, line, ... )
  assert( list[ name ], 'trigger.parse - missing trigger details in list')
  local t = list[ name ]
  if t.oneshot or ( t.task and t.task.status == 'dead' ) then -- remove trigger that is oneshot or from a dead task
    list[ name ] = nil
    trigger.disable( t.name ) -- disable the trigger in MC
    if t.group then -- remove from trigger group
      group[ t.group ][ t.name ] = nil
      if not next( group[ t.group ] ) then group[ t.group ] = nil end -- remove trigger group if empty
    end
  end
  if t.task then
    if ( t.task.status == 'running' or t.task.status == 'lurking' ) then
      t.func( t.task, t.name, ... )
    end
  else
    t.func( t.name, ... )
  end
end

function trigger.enable( name ) -- the boolean here is actually 0 or 1
  assert( type( name ) == 'string', 'trigger.enable - parameter must be a string' )
  world.EnableTrigger( name )
end

function trigger.disable( name ) -- the boolean here is actually 0 or 1
  assert( type( name ) == 'string', 'trigger.disable - parameter must be a string' )
  world.EnableTrigger( name, 0 )
end

function trigger.enable_group( g )
  assert( type( g ) == 'string', 'trigger.enable_group - parameter must be a string' )
  if not group[ g ] then return end

  for k in pairs( group[ g ] ) do
    trigger.enable( k )
  end
end

function trigger.disable_group( g )
  assert( type( g ) == 'string', 'trigger.disable_group - parameter must be a string' )
  if not group[ g ] then return end

  for k in pairs( group[ g ] ) do
    trigger.disable( k )
  end
end

function trigger.remove( name ) -- the boolean here is actually 0 or 1
  assert( type( name ) == 'string', 'trigger.remove - parameter must be a string' )
  local result = world.DeleteTrigger( name )
  if result == 0 then -- 0 = error_code.eOK
    list[ name ] = nil
  else
    error( 'trigger.remove - DeleteTrigger returned the following error: ' .. translate_errorcode( result ) )
  end
end

function trigger.remove_group( g )
  assert( type( g ) == 'string', 'trigger.remove_group - parameter must be a string' )
  if not group[ g ] then return end

  for k in pairs( group[ g ] ) do
    trigger.remove( k )
  end
  group[ g ] = nil
end

-- update a trigger
-- TODO update triger in MC if relevant, e.g. for properties like omit, oneshot
function trigger.update( t )
  assert( type( t ) == 'table', 'trigger.update - parameter must be a table' )
  assert( type( t.name ) == 'string', 'trigger.update - the name param must be a string' )

  local original = list[ t.name ]
  for k, v in pairs( t ) do
    original[ k ] = v
  end
end

-- update triggers in a group
-- TODO update triger in MC if relevant, e.g. for properties like omit, oneshot
function trigger.update_group( t )
  assert( type( t ) == 'table', 'trigger.update_group - parameter must be a table' )
  assert( type( t.group ) == 'string', 'trigger.update_group - the group param must be a string' )
  if not group[ t.group ] then return end

  local group_list = group[ t.group ]
  if not group_list then error 'trigger.update_group - can\'t find specified group' end
  for name in pairs( group_list ) do
    local original = list[ name ]
    for k, v in pairs( t ) do
      original[ k ] = v
    end
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return trigger
