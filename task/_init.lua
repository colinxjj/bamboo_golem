--------------------------------------------------------------------------------
-- This file initializes the task classes (not a real module or a task)
--------------------------------------------------------------------------------

-- container for all task classes
task = {}

-- load the prototype
task.prototype = require 'task._prototype'
task.prototype.__index = task.prototype -- prepare it for inheritance

-- a list of all task classes
local task_class = {
  'manual', -- 手动
  'go', -- 行走
  'locate', -- 定位
  'get_info', -- 获取信息
  'killtime', -- 混时间
  'find', -- 找人
  'manage_inventory', -- 管理随身物品
  'get_flag', -- 取得标记
  'get_item', -- 取得物品
  'recover', -- 恢复HP

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
