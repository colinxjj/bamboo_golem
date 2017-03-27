
local trigger = {}

--------------------------------------------------------------------------------
-- This module manipulates triggers
--------------------------------------------------------------------------------

-- a list of valid trigger params, followed by their MC counterparts, if any
local valid_param = {
  name = true,
  match = 'match',
  func = true,
  group = true,
  task = true,
  enabled = 'enabled',
  omit = 'omit_from_output',
  keep_eval = 'keep_evaluating',
  one_shot = 'one_shot',
  sequence = 'sequence',
  penetrate = true,
}

-- a table to associate a trigger name with its details
local list = {}
local lpeg_list = {}
-- a table contains trigger group info
local group = {}

-- add a new trigger
--[[ usage: trigger.new{
  name = 'unique_id', -- unique id of the trigger, need to follow MC's rules on trigger names, most notably, it can't contain dots (.) (required)
  match = 'text to trigger on', -- text to trigger on, in regex or lpeg (required)
  func = a_func_to_call,-- a function to call when the trigger fires (required)
  task = a_task_instance, -- the task instance the trigger belongs to. triggers for dead tasks won't be fired and will be removed (optional)
  group = 'group_name', -- the trigger group this trigger belongs to (optional)
  enabled = true, -- is the trigger enabled by default? (optional, default: false)
  one_shot = true, -- will the trigger only be fired once? (optional, default: false)
  penetrate = 'waiting', -- the trigger fires even when the task's in 'waiting' or 'suspended' status (optional, default: nil)
  sequence = 99, -- trigger of lower sequence will be evaluated first (regex only, optional, default: 100)
  keep_eval = true, -- continue to evaluate other triggers for the same line? (regex only, optional, default: false)
  omit = true, -- omit the line from output? (regex only, optional, default: false)
} ]]
function trigger.new( t )
  assert( type( t ) == 'table', 'trigger.new - parameter must be a table' )
  assert( type( t.name ) == 'string', 'trigger.new - the name param must be a string' )
  assert( type( t.match ) == 'userdata' or type( t.match ) == 'string', 'trigger.new - the match param must be a string or a lpeg pattern' )
  assert( type( t.func ) == 'function', 'trigger.new - the func param must be a function' )
  for k in pairs( t ) do -- check for invalid params
    assert( valid_param[ k ], 'trigger.new - invalid trigger parameter: ' .. k )
  end

  -- check for name conflicts
  if list[ t.name ] then trigger.remove( t.name ) end -- delete current trigger with same name

  if type( t.match ) == 'userdata' then -- for lpeg triggers
    if t.sequence or t.keep_eval or t.omit then message.warning 'LPEG 触发器不支持 sequence、keep_eval 和 omit 参数，指定的这些参数将被忽略' end
    lpeg_list[ t.name ] = t
  else -- for regex triggers, use MC's trigger mechanism
    -- evaluate flags
    local flags = ( t.enabled == true and 33 or 32 ) -- always use regular expression triggers, triggers are disabled by default
      + ( t.omit and 6 or 0 ) --omit from both the log and the output
      + ( t.keep_eval and 8 or 0 )
      + ( t.one_shot and 32768 or 0 )

    local result = world.AddTriggerEx( t.name, t.match, '', flags, t.color or -1, 0, '', 'trigger.parse', 0, t.sequence or 100 )

    assert( result == 0, 'trigger.new - AddTriggerEx returned the following error: ' .. translate_errorcode( result ) )
  end
  -- add trigger to list and group list
  list[ t.name ] = t
  if t.group then -- add to trigger group
    group[ t.group ] = group[ t.group ] or {}
    group[ t.group ][ t.name ] = true
  end
end

-- match lpeg triggers, called by OnPluginPartialLine
function trigger.lpeg_match( line )
  if not next( lpeg_list ) then return end
  for name, t in pairs( lpeg_list ) do
    if t.enabled ~= false and t.match:match( line ) then trigger.parse( name, line ) end
  end
end

-- a central parser for all triggers, calls the function associated with the trigger
function trigger.parse( name, line, ... )
  assert( list[ name ], 'trigger.parse - missing trigger details in list')
  local t = list[ name ]
  if t.one_shot or ( t.task and t.task.status == 'dead' ) then -- remove trigger that is one shot or from a dead task
    list[ name ], lpeg_list[ name ] = nil
    trigger.disable( t.name ) -- disable the trigger in MC
    if t.group then -- remove from trigger group
      group[ t.group ][ t.name ] = nil
      if not next( group[ t.group ] ) then group[ t.group ] = nil end -- remove trigger group if empty
    end
  end
  if t.task then
    if t.task.status == 'running' or t.task.status == 'lurking'
    or ( t.task.status == 'waiting' and t.penetrate )
    or ( t.task.status == 'suspended' and t.penetrate == 'suspended' ) then
      t.func( t.task, t.name, ... )
    end
  else
    t.func( t.name, ... )
  end
end

-- enable one or more triggers, whose name are passed as varargs
function trigger.enable( ... )
  local t = { ... }
  for _, name in pairs( t ) do
    assert( type( name ) == 'string', 'trigger.enable - parameter must be a string' )
    local trg = list[ name ]
    if trg then
      if type( trg.match == 'string' ) then
        local result = world.EnableTrigger( name )
        assert( result == 0, 'trigger.enable - EnableTrigger returned the following error: ' .. translate_errorcode( result ) )
      end
      trg.enabled = true
    end
  end
end

-- disable one or more triggers, whose name are passed as varargs
function trigger.disable( ... )
  local t = { ... }
  for _, name in pairs( t ) do
    assert( type( name ) == 'string', 'trigger.disable - parameter must be a string' )
    local trg = list[ name ]
    if trg then
      if type( trg.match == 'string' ) then
        local result = world.EnableTrigger( name, 0 )
        assert( result == 0, 'trigger.disable - EnableTrigger returned the following error: ' .. translate_errorcode( result ) )
      end
      trg.enabled = false
    end
  end
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
  local trg = list[ name ]
  if not trg then return end
  if type( trg.match == 'string' ) then
    local result = world.DeleteTrigger( name )
    assert( result == 0, 'trigger.remove - DeleteTrigger returned the following error: ' .. translate_errorcode( result ) )
  end
  list[ name ], lpeg_list[ name ] = nil
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
function trigger.update( t )
  assert( type( t ) == 'table', 'trigger.update - parameter must be a table' )
  assert( type( t.name ) == 'string', 'trigger.update - the name param must be a string' )

  local original, option = list[ t.name ]
  for k, v in pairs( t ) do
    -- update the original table of the trigger
    original[ k ] = v
    -- also update the trigger in MC
    option = valid_param[ k ]
    if type( original.match ) == 'string' and type( option ) == 'string' then
      v = ( option == 'sequence' or option == 'match' ) and v or ( v and 'y' or 'n' )
      local result = world.SetTriggerOption( t.name, option, v )
      assert( result == 0, 'trigger.update -  - SetTriggerOption returned the following error: ' .. translate_errorcode( result ) )
    end
  end
end

-- update triggers in a group
function trigger.update_group( t )
  assert( type( t ) == 'table', 'trigger.update_group - parameter must be a table' )
  assert( type( t.group ) == 'string', 'trigger.update_group - the group param must be a string' )
  if not group[ t.group ] then return end

  local group_list, original, option = group[ t.group ]
  for name in pairs( group_list ) do
    original = list[ name ]
    for k, v in pairs( t ) do
      -- update the original table of the trigger
      original[ k ] = v
      -- also update the trigger in MC
      option = valid_param[ k ]
      if type( original.match ) == 'string' and type( option ) == 'string' then
        v = ( option == 'sequence' or option == 'match' ) and v or ( v and 'y' or 'n' )
        local result = world.SetTriggerOption( name, option, v )
        assert( result == 0, 'trigger.update_group -  - SetTriggerOption returned the following error: ' .. translate_errorcode( result ) )
      end
    end
  end
end

function trigger.get_count()
  local count = 0
  for _ in pairs( list ) do
    count = count + 1
  end
  return count
end

function trigger.get_all()
  return list
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return trigger
