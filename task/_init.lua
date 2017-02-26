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
  'manual', -- �ֶ�
  'go', -- ����
  'locate', -- ��λ
  'getinfo', -- ��ȡ��Ϣ
  'killtime', -- ��ʱ��
  'find', -- ����
  'traverse', -- ����
  'manage_inventory', -- ������Ʒ

  'job.wuguan', -- �������
}

-- load all task classes
for _, class in pairs( task_class ) do
  task[ class ] = require( 'task.' .. class )
  local t = task[ class ]
  t.prototype = task.prototype -- let it know what its prototype is
  setmetatable( t, task.prototype ) -- inherit from prototype
  t.__index = t -- prepare it for instance inheritance
end
