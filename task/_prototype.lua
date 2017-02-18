
local task = {}

--------------------------------------------------------------------------------
-- This is the prototype of all tasks
--------------------------------------------------------------------------------

task.class = 'prototype'

local function initialize_instance( class, instance )
  instance = instance or {}
  instance.priority = instance.priority or class.priority or 5
  instance.added = os.time()
  instance.status = 'suspended'
  instance.class = class.class
  setmetatable( instance, class )
  instance.id = instance:get_id()
  return instance
end

-- set up a new task
--[[ usage: task.go:new{
  to = '扬州城中央广场', -- one or many task specific params
} ]]
function task:new( t )
  t = initialize_instance( self, t )
  taskmaster.new( t )
  return t
end

-- set up a new sub task
--[[ usage: task:newsub{
  class = 'go', -- the class of the new subtask (required)
  to = '扬州城中央广场', -- task specific params
  complete_func = a_func,
  fail_func = another_func, -- if no complete / fail function is defined, then the parent task will resume / fail when the subtask completes / fails
} ]]
function task:newsub( subtask )
  subtask.priority = self.priority
  subtask = initialize_instance( _G.task[ subtask.class ], subtask )
  taskmaster.newsub( self, subtask )
  return subtask
end
-- set up a new sub task and keep the parent lurking in the background
function task:newweaksub( subtask )
  subtask.priority = self.priority
  subtask = initialize_instance( _G.task[ subtask.class ], subtask )
  taskmaster.newweaksub( self, subtask )
  return subtask
end

-- generate an id string of a task. default is task's class string, for tasks like go, it should be something like 'go from 扬州城中央广场 to 归云庄前厅'
function task:get_id()
  return self.class
end

function task:send( t )
  t.task = self
  cmd.new( t )
end

function task:listen( t )
  t.task = self
  event.listen( t )
end

function task:timer( t )
  t.task = self
  timer.new( t )
end

function task:enable_trigger( s )
  trigger.update{ name = s, task = self }
  trigger.enable( s )
end

function task:disable_trigger( s )
  if not s then return end
  trigger.update{ name = s, task = false }
  trigger.disable( s )
end

function task:enable_trigger_group( s )
  trigger.update_group{ group = s, task = self }
  trigger.enable_group( s )
end

function task:disable_trigger_group( s )
  if not s then return end
  trigger.update_group{ group = s, task = false }
  trigger.disable_group( s )
end

function task:resume( ... )
  taskmaster.resume( self, ... )
end

function task:suspend( ... )
  taskmaster.suspend( self, ... )
end

function task:complete( ... )
  taskmaster.complete( self, ... )
end

function task:fail( ... )
  taskmaster.fail( self, ... )
end

function task:kill()
  taskmaster.kill( self )
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
