
local task = {}

--------------------------------------------------------------------------------
-- Go from one place to another
--[[----------------------------------------------------------------------------
Params:
to = '扬州城北大街#1': id of the destination or a table representing it (required)
----------------------------------------------------------------------------]]--

task.class = 'go'

function task:get_id()
  local dest = type( self.to ) == 'table' and self.to.id or self.to
  return 'go to ' .. dest
end

function task:_resume()
  if not self.getinfo then
    self.getinfo = true
    self:newsub{ class = 'getinfo', hp = true, inventory = true, score = true, enable = true, skills = true, time = true }
    return
  end

  if not self.from then
    local from = map.get_current_location()
    if not from then self:newsub{ class = 'locate' }; return end

    self.from = from[ 1 ] -- if there're multiple possible current locations, then just assume the first one, any error will be corrected during the walkinbg process
    self.to = map.get_room_by_id( self.to ) or self.to -- convert 'to' to a room table if it's a room id

    -- convert the 'to' field to the corresponding map room
    self.to = type( self.to ) == 'table' and self.to or map.get_room_by_id( self.to )

    message.normal( '从“' .. self.from.id .. '”前往“' .. self.to.id .. '”' )

    self.path = map.getpath( self.from, self.to )
    if not self.path then self:fail(); return end

    self:listen{ event = 'located', func = self.resume, id = 'task.go', persistent = true }
    self.step_num, self.error_count = 1, 0
    self:next_step()
    return
  end

  self:check_step()
end

function task:_complete()
  message.normal( '到达目的地：' .. self.to.id .. '，耗时 ' .. os.time() - self.added .. ' 秒' )
end

function task:check_step()
  -- if the step handler needs room desc to work
  if self.step_need_desc and not map.get_current_room().desc then self:send{ 'l' }; return end

  local step_room, prev_room = self.path[ self.step_num ], self.path[ self.step_num - 1 ]
  local step_ok, still_in_prev_room = map.is_current_location( step_room ), map.is_current_location( prev_room )

  if not step_ok then -- step not ok?
    if self.step_handler and still_in_prev_room then -- give control to step handler to solve the step
      self:step_handler( self.step )
    else -- step failed, retry
      self.error_count = self.error_count + 1
      self.from = nil
      self:resume()
    end
  else -- move on to next step
    self:next_step()
  end
end

function task:next_step()
  local step_room, next_room = self.path[ self.step_num ], self.path[ self.step_num + 1 ]
  self:disable_trigger_group( self.step_trigger_group )
  self.step_num, self.step_handler, self.step_trigger_group, self.step, self.step_need_desc = self.step_num + 1
  if next_room then
    local cmd, door, handler, handler_tg = map.get_step_cmd( step_room, next_room )
    if not handler then
      self:send{ door or cmd, door and cmd or nil }
    else -- got step handler function
      self.step_handler, self.step_trigger_group, self.step = handler, handler_tg, { from = step_room, to = next_room, cmd = cmd }
      self:enable_trigger_group( self.step_trigger_group )
      self:step_handler( self.step )
    end
  else
    self:complete()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
