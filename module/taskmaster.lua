
local taskmaster = {}

--------------------------------------------------------------------------------
-- This module handles task manipulation
--------------------------------------------------------------------------------

-- where all the tasks reside
local grid = {
	{}, -- 1, highest
	{}, -- 2, survival-high
	{}, -- 3, survival-normal
	{}, -- 4, survival-low
	{}, -- 5, normal
	{}, -- 6, wellbeing-high
	{}, -- 7, wellbeing-normal
	{}, -- 8, wellbeing-low
	{} -- 9, lowest
}

local queue = {}

local is_dispatching

local function add_to_history( task )
	-- print( 'taskmaster.add_to_history: ' .. task:get_id() .. ( task.is_successful and ' (succeeded)' or ' (failed)' ) )
end

local function get_stack( task )
	for _, list in ipairs( grid ) do
		for _, stack in ipairs( list ) do
			for _, t in ipairs( stack ) do
				if t == task then return stack end
			end
		end
	end
end

local function get_parent( task )
	for _, list in ipairs( grid ) do
		for _, stack in ipairs( list ) do
			for i, t in ipairs( stack ) do
				if t == task then return stack[ i - 1 ] end
			end
		end
	end
end

local function get_top( stack )
	for _, list in ipairs( grid ) do
		for _, s in ipairs( list ) do
			if s == stack then
				local t = stack[ #stack ]
				if t.status == 'dead' then error( 'taskmaster.get_top - top task in stack is dead: ' .. t.id ) end
				return t
			end
		end
	end
end

local function get_running()
	local ctask, cstack
	for _, list in ipairs( grid ) do
		for _, stack in ipairs( list ) do
			for i, task in ipairs( stack ) do
				if task.status == 'running' then
					if ctask then error( 'taskmaster.get_running: multiple running tasks: ' .. task.id .. ', ' .. ctask.id ) end
					ctask, cstack = task, stack
				end
			end
		end
	end
	return ctask, cstack
end

local function clear_dead()
	for _, list in ipairs( grid ) do
		local i, stack = 1
		while i <= #list do
			stack = list[ i ]
			local i2, task, found_dead = 1
			while i2 <= #stack do
				task = stack[ i2 ]
				if task.status == 'dead' then
					if task.is_successful ~=nil then add_to_history( task ) end
					found_dead = true -- also remove dead task's all subtasks
					table.remove( stack, i2 )
				elseif found_dead then
					task.status = 'dead'
					table.remove( stack, i2 )
				else
					i2 = i2 + 1
				end
			end
			if #stack == 0 then
				table.remove( list, i ) -- remove empty stack
			else
				i = i + 1 -- move on to next stack
			end
		end
	end
end

local function clear_sub( task )
	local stack = get_stack( task )
	assert( stack, 'taskmaster.clear_sub - can\'t find stack for task: ' .. task.id )
	local i, t, found = 1
	while i <= #stack do
		 t = stack[ i ]
		 if not found and t.status ~= 'waiting' and t.status ~= 'lurking' and t ~= task then error ( 'taskmaster.clear_sub - wrong task status in the lower stack: ' .. t.id .. ' - ' .. t.status ) end
		 if found then
			 t.status = 'dead'
			 table.remove( stack, i )
		 else
			 i = i + 1
		 end
		 if t == task then found = true end
	end
end

local function find_next_task()
	for _, list in ipairs( grid ) do
		for _, stack in ipairs( list ) do
			return get_top( stack )
		end
	end
end

local function has_higher_priority_than_ctask( task )
	local ctask = get_running() -- get current running task
	if not ctask then return true end
	if task.priority < ctask.priority then return true end
end

-- take over control from the current running task, if there's one
local function takeover( task )
	local ctask, cstack = get_running() -- get current running task
	if ctask and ctask ~= task then
		message.debug( 'TASKMASTER 模块：任务“' .. task.id .. '”获得控制权' )
		if ctask._suspend then ctask:_suspend() end
		ctask.status = 'suspended'
	end
	clear_sub( task )
	task.status = 'running'
	if task._resume then task:_resume() end -- call the task's own resume func
end

-- the parent task hands over control to its subtask
local function handover( parent, task )
	local ctask = get_running()
	if ctask == parent then -- if the parent is the current running task
		parent.status = 'waiting'
		task.status = 'running'
		if task._resume then task:_resume() end
	else -- if the parent isn't the current running task
		message.debug( 'TASKMASTER 模块：由于任务“' .. parent.id .. '”未处于运行状态，其创建的子任务“' .. task.id .. '”未能获得控制权' )
	end
end

-- the parent task hands over control to its subtask but keep lurking in the background
local function weakhandover( parent, task )
	local ctask = get_running()
	if ctask == parent then -- if the parent is the current running task
		parent.status = 'lurking'
		task.status = 'running'
		if task._resume then task:_resume() end
	else -- if the parent isn't the current running task
		message.debug( 'TASKMASTER 模块：由于任务“' .. parent.id .. '”未处于运行状态，其创建的弱子任务“' .. task.id .. '”未能获得控制权' )
	end
end

-- a subtask hands over control back to its parent
local function handback( task, action, parent )
	local func = task[ action .. '_func' ]
	local stack = get_stack( task )
	table.remove( stack )
	parent.status = 'running'
	if func then
		func( parent, task.result )
	else
		if parent._resume then parent:_resume() end
	end
end

local dispatch
dispatch = function()
	is_dispatching = true
	local item = table.remove( queue, 1 ) -- get next item from queue
	local ctask, cstack = get_running() -- get current running task
	local task, action, parent = item.task, item.action, item.parent
	local stack = action == 'new' and { task; priority = task.priority } or get_stack( item.parent or item.task )
	if task.status ~= 'dead' then -- only take actions on non-dead tasks
		assert( stack, 'taskmaster.dispatch - can\'t find stack for task: ' .. task.id )

		if action == 'new' then
			local list = grid[ stack.priority ]
			table.insert( list, stack )
			if has_higher_priority_than_ctask( task ) then takeover( task ) end
		elseif action == 'newsub' then
			table.insert( stack, task )
			handover( parent, task )
		elseif action == 'newweaksub' then
			table.insert( stack, task )
			weakhandover( parent, task )
		elseif action == 'resume' then
			if has_higher_priority_than_ctask( task ) or cstack == stack then
				takeover( task )
			else
				message.debug( 'TASKMASTER 模块：忽略恢复任务“' .. task.id .. '”的请求，因为其优先级 ' .. task.priority .. ' 不高于当前任务“' .. ctask.id .. '”的 ' .. ctask.priority )
			end
		elseif action == 'complete' or action == 'fail' then
			if action == 'complete' then
				if task._complete then task:_complete() end
				task.is_successful = true
			elseif action == 'fail' then
				if task._fail then task:_fail() end
				task.is_successful = false
			end
			task.status = 'dead'
			local parent = get_parent( task )
			if parent then
				handback( task, action, parent )
			else
				clear_dead()
				local ntask
				if task == ctask then ntask = find_next_task() end
				if ntask then takeover( ntask ) end
			end
		else
			if action == 'suspend' then
				if task._suspend then task:_suspend() end
				task.status = 'suspended'
			elseif action == 'kill' then
				task.status = 'dead'
			else
				error( 'taskmaster.dispatch - invalid task action: ' .. action )
			end
			clear_dead()
			local ntask
			if task == ctask then ntask = find_next_task() end
			if ntask then takeover( ntask ) end
		end
	end

	is_dispatching = false
	if next( queue ) then dispatch() end -- process next event in queue if any
end

-- insert a new task
function taskmaster.new( task )
	-- message.debug( 'TASKMASTER 模块：收到新增任务“' .. task.id .. '”的请求，其优先级为 ' .. task.priority )
	local item = { task = task, action = 'new' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

-- insert a new subtask
function taskmaster.newsub( task, subtask )
	-- message.debug( 'TASKMASTER 模块：收到任务“' .. task.id .. '”新建子任务“' .. subtask.id .. '”的请求' )
	local item = { task = subtask, parent = task, action = 'newsub' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

-- insert a new subtask and keep its parent lurking in the background
function taskmaster.newweaksub( task, subtask )
	-- message.debug( 'TASKMASTER 模块：收到任务“' .. task.id .. '”新建弱子任务“' .. subtask.id .. '”的请求' )
	local item = { task = subtask, parent = task, action = 'newweaksub' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

function taskmaster.resume( task )
	-- message.debug( 'TASKMASTER 模块：收到恢复任务“' .. task.id .. '”的请求' )
	local item = { task = task, action = 'resume' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

function taskmaster.suspend( task )
	-- message.debug( 'TASKMASTER 模块：收到暂停任务“' .. task.id .. '”的请求' )
	local item = { task = task, action = 'suspend' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

function taskmaster.complete( task )
	-- message.debug( 'TASKMASTER 模块：收到完成任务“' .. task.id .. '”的请求' )
	local item = { task = task, action = 'complete' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

function taskmaster.fail( task )
	-- message.debug( 'TASKMASTER 模块：收到任务“' .. task.id .. '”失败的请求' )
	local item = { task = task, action = 'fail' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

function taskmaster.kill( task )
	-- message.debug( 'TASKMASTER 模块：收到终止任务“' .. task.id .. '”的请求' )
	local item = { task = task, action = 'kill' }
	table.insert( queue, item )
	if not is_dispatching then dispatch() end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return taskmaster
