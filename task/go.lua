
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
  if not self.from then
    local from = map.get_current_location()
    if not from then self:newsub{ class = 'locate' }; return end

    self.from = from[ 1 ] -- if there're multiple possible current locations, then just assume the first one, any error will be corrected during the walkinbg process
    self.to = map.get_room_by_id( self.to ) or self.to -- convert 'to' to a room table if it's a room id

    message.verbose( '从“' .. self.from.id .. '”前往“' .. self.to.id .. '”' )

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
  message.verbose( '到达目的地“' .. self.to.id .. '”，共 ' .. #self.path - 1 .. ' 步，耗时 ' .. os.time() - self.add_time .. ' 秒' )
end

function task:_fail()
  message.verbose( '前往“' .. self.to.id .. '”失败' )
end

function task:check_step()
  -- if the step handler needs room desc to work
  local room = map.get_current_room()
  if self.is_step_need_desc and not room.desc then self:send{ 'l' }; return end

  local expected_room, prev_room = self.path[ self.step_num ], self.path[ self.step_num - 1 ]
  -- step ok?
  if map.is_current_location( expected_room ) and ( not self.is_still_in_step or ( room.name == expected_room.name and room.name ~= prev_room.name ) ) then -- move on to next step
    if self.batch_step_num and self.step_num < self.batch_step_num then
      self.step_num = self.step_num + 1
    elseif not self.batch_step_num or self.step_num >= self.batch_step_num then
      self.batch_step_num = nil
      self:next_step()
    end
  else
    -- current step has a step handler and we're still in the same location?
    if self.step_handler and map.is_current_location( prev_room ) then -- hand over control to the step handler to solve the step
      self:step_handler( self.step )
    else -- otherwise, step failed, retry
      self.error_count = self.error_count + 1
      self.from = nil
      message.verbose '路径行走需要调整路线'
      self:resume()
    end
  end
end

function task:next_step()
  local cmd_list, i = {}, self.step_num
  local from, to, cmd, door, handler, is_special_cmd
  -- generate command list
  repeat
    from, to = self.path[ i ], self.path[ i + 1 ]
    if not to then self:complete() return end -- complete task if no further steps
    cmd, door, handler = map.get_step_cmd( from, to )

    if handler and i ~= self.step_num then handler = nil; break end -- if processed more than one step then ignore the new handler

    is_special_cmd = cmd and ( string.find( cmd, '#wa' ) or string.find( cmd, 'ask' ) ) or nil
    if not handler and ( not is_special_cmd or i == self.step_num ) then -- add commands to list
      cmd_list[ #cmd_list + 1 ] = door
      cmd_list[ #cmd_list + 1 ] = cmd
    end

    if i == self.step_num or ( not handler and not is_special_cmd ) then i = i + 1 end

    -- got a special command or handler?
    if handler or is_special_cmd then break end
    -- already have 15 commands?
    if i - self.step_num >= 15 then break end -- up to 15 commands per batch
  until not self.path[ i + 1 ]
  local count = i - self.step_num
  if count > 4 then cmd_list[ #cmd_list + 1 ] = '#wa ' .. 40 * count end -- wait a bit after each batch
  self.step_num = self.step_num + 1
  self.batch_step_num = i
  --disable trigger group used by last step
  self:disable_trigger_group( self.step_trigger_group )
  -- clear vars from previous step
  self.step_handler, self.step_trigger_group, self.step, self.is_step_need_desc, self.is_still_in_step = nil
  -- got new handler?
  if not handler then -- send commands
    self:send( cmd_list )
  else -- hand over control to handler
    self.step_handler, self.step_trigger_group, self.step = _G.task.helper.step_handler[ handler ], 'step_handler.' .. handler, { from = from, to = to, cmd = cmd }
    self:enable_trigger_group( self.step_trigger_group )
    self:step_handler( self.step )
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
