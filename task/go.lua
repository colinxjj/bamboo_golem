
local task = {}

--------------------------------------------------------------------------------
-- Go from one place to another
--[[----------------------------------------------------------------------------
Params:
to = '扬州城北大街#1': id of the destination or a table representing it (required)
through =
----------------------------------------------------------------------------]]--

task.class = 'go'

local step_handler = require 'task.helper.step_handler'

function task:get_id()
  local dest = type( self.to ) == 'table' and self.to.id or self.to
  return 'go to ' .. dest
end

function task:_resume()
  if not self.dest then
    local loc = map.get_current_location()
    if not loc then self:newsub{ class = 'locate' } return end
    if #loc > 1 then self.be_cautious = true end -- be cautious if current loc is not exact

    -- generate a list of dests based on the "to" and the optional "range" param, and a list requirements for traversing these dests
    self.dest, self.req = map.expand_loc( self.to, self.range or 0 )

    local s = '前往“' .. ( type( self.to ) == 'table' and self.to.id or self.to ) .. '”'
    s = self.range and ( s .. '，遍历方圆 ' .. self.range .. ' 步' ) or s
    message.verbose( s )

    -- make a func used in path generation to decide if a room is a dest or not
    self.is_dest = function( room )
      for dest in pairs( self.dest ) do
        if room == dest then return true end
      end
    end

    self.path = map.getpath( loc[ 1 ], self.is_dest )
    if not self.path then self:fail(); return end

    -- get a list of items / flags required to complete the path (in addition to those needed for traversing )
    self.req = map.get_path_req( self.path, self.req )

    self:listen{ event = 'located', func = self.resume, id = 'task.go', persistent = true }
    self.step_num, self.error_count = 1, self.error_count or 0
  end

  self:check_step()
end

function task:_fail()
  message.verbose '行走失败'
end

function task:check_step()
  -- if the step handler needs room desc to work
  local room = room.get()
  if self.is_step_need_desc and not room.desc then self:send{ 'l' }; return end

  -- stop being cautious if current location is exact
  if self.be_cautious and #map.get_current_location() == 1 then self.be_cautious = nil end

  local expected_room, prev_room = self.path[ self.step_num ], self.path[ self.step_num - 1 ]
  -- step ok?
  if map.is_current_location( expected_room ) and ( not self.is_still_in_step or ( room.name == expected_room.name and room.name ~= prev_room.name ) ) then -- move on to next step
    if self.req and next( self.req ) then
      self:prepare()
    elseif self.batch_step_num and self.step_num < self.batch_step_num then
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
      self:reset()
    end
  end
end

-- prepare the items / get the flags required to complete the path
function task:prepare()
  -- get next entry from the req list and remove it from the list
  local req, subtask
  for k, v in pairs( self.req ) do
    req = v
    self.req[ k ] = nil
    break
  end
  message.debug( '行走准备：' .. ( req.item or req.flag ) )
  if req.item then -- an item req
    if inventory.has_item( req.item, req.count ) then self:resume() return end
    subtask = self:newsub{ class = 'get_item', item = req.item, count = req.count }
  else -- a flag req
    if player.temp_flag[ req.flag ] then self:resume() return end
    subtask = self:newsub{ class = 'get_flag', flag = req.flag }
  end
  -- block all exits related to this req until the item / flag is acquired
  for _, pair in ipairs( req ) do
    map.block_exit( pair.from, pair.to, subtask )
  end
end

function task:reset()
  self.error_count, self.step_num, self.batch_step_num = self.error_count + 1, 1

  local loc = map.get_current_location()
  if #loc > 1 then self.be_cautious = true end -- be cautious if current loc is not exact

  self.path = map.getpath( loc[ 1 ], self.is_dest ) -- get path to next dest
  if not self.path then self:fail() return end -- if dests are unreachable, task fails

  message.debug '路径行走需要调整路线'
  self:check_step()
end

function task:next_step()
  local cmd_list, i = {}, self.step_num
  local from, to, cmd, door, handler, is_special_cmd
  -- generate command list for the next step(s)
  repeat
    from, to = self.path[ i ], self.path[ i + 1 ]
    -- if is traversing, mark current room as traversed
    --if self.is_traversing then self.dest[ from ] = nil end
    -- move on to next dest if no further steps
    if not to then self:next_dest( from ) return end

    cmd, door, handler = map.get_step_cmd( from, to )

    if handler and i ~= self.step_num then handler = nil; break end -- if processed more than one step then ignore the new handler

    is_special_cmd = cmd and ( string.find( cmd, '#w[ab] ' ) or string.find( cmd, '^ask ' ) or string.find( cmd, ';ask ' ) ) or nil
    if not handler and ( not is_special_cmd or i == self.step_num ) then -- add commands to list
      cmd_list[ #cmd_list + 1 ] = door
      cmd_list[ #cmd_list + 1 ] = cmd
    end

    if i == self.step_num or ( not handler and not is_special_cmd ) then i = i + 1 end

    -- got a special command or handler?
    if handler or is_special_cmd then break end
    -- already have 15 commands?
    if i - self.step_num >= 15 then break end -- up to 15 commands per batch
  until not self.path[ i + 1 ] or self.be_cautious or self.is_traversing
  local count = i - self.step_num
  if count > 4 then cmd_list[ #cmd_list + 1 ] = '#wa ' .. 40 * count end -- wait a bit after each batch
  self.step_num = self.step_num + 1
  self.batch_step_num = count > 1 and i or nil
  --disable trigger group used by last step
  self:disable_trigger_group( self.step_trigger_group )
  -- clear vars from previous step
  self.step_handler, self.step_trigger_group, self.step, self.is_step_need_desc, self.is_still_in_step = nil
  -- got new handler?
  if not handler then -- send commands
    self:send( cmd_list )
  else -- hand over control to handler
    self.step_handler, self.step_trigger_group, self.step = step_handler[ handler ], 'step_handler.' .. handler, { from = from, to = to, cmd = cmd }
    self:enable_trigger_group( self.step_trigger_group )
    self:step_handler( self.step )
  end
end

function task:next_dest( loc )
  self.dest[ loc ] = nil -- mark current loc as traversed
  if not next( self.dest ) then
    self:complete()
  else
    self.step_num, self.batch_step_num = 1
    self.path = map.getpath( loc, self.is_dest ) -- get path to next dest
    if not self.path then self:complete() return end -- if other dests are unreachable, complete task
    self.is_traversing = true -- for subsequent dests, switch to traverse mode
    self:check_step()
  end
end


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
