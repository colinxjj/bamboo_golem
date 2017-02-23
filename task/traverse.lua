
local task = {}

--------------------------------------------------------------------------------
-- Traverse all rooms within a range from the base location
--[[----------------------------------------------------------------------------
Params:
loc = '扬州城北大街': long name or id of the location (required)
range = 2: traverse all roms with this range from the base location (optional, default: 0)
----------------------------------------------------------------------------]]--

task.class = 'traverse'

function task:get_id()
  local id = 'traverse ' .. self.loc
  id = self.range and ( id .. ' for range of ' .. self.range ) or id
  return id
end

function task:_resume()
  if not self.getinfo then
    self.getinfo = true
    self:newsub{ class = 'getinfo', hp = true, inventory = true, score = true, enable = true, skills = true, time = true }
    return
  end

  -- get a list of rooms with range from the base location
  self.room_list = self.room_list or map.expand_loc( self.loc, self.range or 0 )

  -- create a closure to be used with map.find_nearest to let it know if it's found a valid dest or not
  self.is_dest = self.is_dest or function( dest )
    for room in pairs( self.room_list ) do
      if room == dest then return true end
    end
  end

  -- first we need to go to the traverse area
  if not self.ready_to_start then
    -- get current location
    local from = map.get_current_location()
    if not from then self:newsub{ class = 'locate' }; return end
    from = from[ 1 ]

    -- find the nearest room in the list
    local dest = map.find_nearest( from, self.is_dest )

    message.verbose( '开始遍历“' .. self.loc .. '”，范围：' .. ( self.range or 0 ) )

    -- go to that room, then start traversing
    self.ready_to_start = true
    if dest ~= from then self:newsub{ class = 'go', to = dest }; return end
  end

  if not self.from then
    local from = map.get_current_location()
    if not from then self:newsub{ class = 'locate' }; return end
    self.from = from[ 1 ] -- if there're multiple possible current locations, then just assume the first one, any error will be corrected during the walkinbg process

    self.path = map.getpath( self.from, self.is_dest )
    if not self.path then self:fail(); return end

    self:listen{ event = 'located', func = self.resume, id = 'task.traverse', persistent = true }
    self.step_num, self.error_count = 1, 0
    self:next_step()
    return
   end

  -- traverse the rooms
    self:check_step()
end

function task:_complete()
  message.verbose( '完成遍历“' .. self.loc .. '”，范围：' .. ( self.range or 0 ) .. '，步数：' .. self.step_count .. '，耗时：' .. os.time() - self.add_time .. ' 秒' )
end

-- check each step
function task:check_step()
  -- if the step handler needs room desc to work
  if self.is_step_need_desc and not map.get_current_room().desc then self:send{ 'l' }; return end

  local expected_room, prev_room = self.path[ self.step_num ], self.path[ self.step_num - 1 ]

  -- step ok?
  if map.is_current_location( expected_room ) and not self.is_still_in_step then
    self:next_step()
  else -- move on to next step
    if self.step_handler and map.is_current_location( prev_room ) then -- give control to step handler to solve the step
      self:step_handler( self.step )
    else -- step failed, retry
      self.error_count = self.error_count + 1
      self.from = nil
      self:resume()
    end
  end
end

function task:next_step()
  local curr_room, next_room = self.path[ self.step_num ], self.path[ self.step_num + 1 ]
  self.room_list[ curr_room ] = nil -- no longer need to traverse current location
  self.step_num = self.step_num + 1
  self:disable_trigger_group( self.step_trigger_group )
  self.step_handler, self.step_trigger_group, self.step, self.is_step_need_desc, self.is_still_in_step = nil
  if not next_room then
    self:next_dest()
  else
    self.step_count = self.step_count or 0
    self.step_count = self.step_count + 1
    local cmd, door, handler, handler_tg = map.get_step_cmd( curr_room, next_room )
    if not handler then
      self:send{ door or cmd, door and cmd or nil }
    else -- got step handler function
      self.step_handler, self.step_trigger_group, self.step = handler, handler_tg, { from = curr_room, to = next_room, cmd = cmd }
      self:enable_trigger_group( self.step_trigger_group )
      self:step_handler( self.step )
    end
  end
end

function task:next_dest()
  if next( self.room_list ) then
    self.from, self.path, self.step_num = nil
    self:resume()
  else
    self:complete()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
