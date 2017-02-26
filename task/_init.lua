--------------------------------------------------------------------------------
-- This file initializes the task classes (not a real module or a task)
--------------------------------------------------------------------------------

-- container for all task classes
task = {}

-- load the helpers
task.helper = {}
task.helper.step_handler = require 'task.helper.step_handler'
task.helper.item_finder = require 'task.helper.item_finder'

-- load the prototype
task.prototype = require 'task._prototype'
task.prototype.__index = task.prototype -- prepare it for inheritance

-- a list of all task classes
local task_class = {
  'manual', -- 手动
  'go', -- 行走
  'locate', -- 定位
  'getinfo', -- 获取信息
  'killtime', -- 混时间
  'find', -- 找人
  'traverse', -- 遍历
  'manage_inventory', -- 管理物品

  'job.wuguan', -- 襄阳武馆
}

-- load all task classes
for _, class in pairs( task_class ) do
  task[ class ] = require( 'task.' .. class )
  local t = task[ class ]
  t.prototype = task.prototype -- let it know what its prototype is
  setmetatable( t, task.prototype ) -- inherit from prototype
  t.__index = t -- prepare it for instance inheritance
end
