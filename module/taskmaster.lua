
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

local queue, is_dispatching, dispatch, current_task = {}

local function add_to_history( task )
	-- print( 'taskmaster.add_to_history: ' .. task:get_id() .. ( task.is_successful and ' (succeeded)' or ' (failed)' ) )
end

local function clear_sub( task )
	if not task.stack then return end
	local i, t, is_found = 1
	while i <= #task.stack do
		 t = task.stack[ i ]
		 if is_found then
			 t.status = 'dead'
			 table.remove( task.stack, i )
		 else
			 i = i + 1
		 end
		 if t == task then is_found = true end
	end
end

local function parse_grid()
	local task_to_run
	for priority, list in ipairs( grid ) do
		local sequence = 1
		while list[ sequence ] do
			local stack, i, has_found_dead, last_non_dead = list[ sequence ], 1
			while stack[ i ] do
				local task = stack[ i ]
				if task.status == 'dead' then has_found_dead = true else last_non_dead = task end
				if has_found_dead then
					task.status = 'dead' -- kill dead task's subtasks
					table.remove( stack, i ) -- remove them all from the stack
				else
					if ( task.status == 'suspended' or task.status == 'running' ) and not task_to_run then task_to_run = task end
					i = i + 1
				end
			end
			if not next( stack ) then
				table.remove( list, sequence )
			else
				task_to_run = task_to_run or last_non_dead
				sequence = sequence + 1
			end
		end
	end
	if current_task and current_task ~= task_to_run then
		local func = current_task[ current_task.is_successful and 'complete_func' or 'fail_func' ]
		if func and current_task.parent == task_to_run then
			task_to_run.status = 'running'
			func( task_to_run )
			return
		elseif current_task.status == 'dead' then
			if func then func( current_task ) end
		elseif task_to_run.parent ~= current_task then
			current_task.status = 'suspended'
			if current_task._suspend then current_task:_suspend() end
		end
	end
	current_task, task_to_run.status = task_to_run, 'running'
	if task_to_run._resume then task_to_run:_resume() end
end

dispatch = function()
	is_dispatching = true
	local item = table.remove( queue, 1 ) -- get next item from queue
	local task, action = item.task, item.action
	if task.status == 'dead' then return end -- ignore action on dead tasks

	clear_sub( task ) -- acting on a task always clears its subtasks

	if action == 'new' then
		local stack = { task; priority = task.priority }
		task.stack = stack
		table.insert( grid[ stack.priority ], stack )
	elseif action == 'newsub' or action == 'newweaksub' then
		table.insert( item.parent.stack, task )
		item.parent.status = action == 'newsub' and 'waiting' or 'lurking'
	elseif action == 'complete' or action == 'fail' then
		task.is_successful = action == 'complete'
	end

	if action ~= 'resume' and task[ '_' .. action ] then task[ '_' .. action ]( task ) end

	task.status = ( action == 'suspend' and 'suspended' )
					 	 or ( ( action == 'complete' or action == 'fail' or action == 'kill' ) and 'dead' )
						 or task.status

	if next( queue ) then -- process next event in queue if any
		dispatch()
	else
		is_dispatching = false
		parse_grid()
	end
end

function taskmaster.operate( t )
	assert( type( t ) == 'table', 'taskmaster.operate - the param must be a table' )
	assert( type( t.task ) == 'table', 'taskmaster.operate - the task param must be a table' )
	assert( type( t.action ) == 'string', 'taskmaster.operate - the action param must be a string' )
	table.insert( queue, t )
	if not is_dispatching then dispatch() end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return taskmaster
