
local session = {}

--------------------------------------------------------------------------------
-- This module handles sessions
--------------------------------------------------------------------------------

function session.initiate()
  player.temp_flag = {}
  task.getinfo:new{ title = 'forced', complete_func = session.initiate_follow_up, priority = 1 }
end

event.listen{ event = 'connected', func = session.initiate, id = 'session.initiate', persistent = true }

function session.initiate_follow_up()
  if not room.get() then
    task.getinfo:new{ room = true, complete_func = session.initiate_follow_up, priority = 1 }
  else
    task.getinfo:new{ hp = 'forced', inventory = 'forced', score = 'forced', enable = 'forced', skills = 'forced', time = 'forced', set = 'forced', complete_func = session.initiate_done, priority = 1 }
  end
end

function session.initiate_done()
  if not player.set.look then
    cmd.new{ 'set look'; complete_func = session.initiate_done }
  else
    player.is_initiated = true
  end
end

local old_id

function session.resume()
  old_id = player.id
  task.getinfo:new{ room = true, title = 'forced', complete_func = session.resume_follow_up, priority = 1 }
end

event.listen{ event = 'reconnected', func = session.resume, id = 'session.resume', persistent = true }

function session.resume_follow_up()
  if player.id ~= old_id then message.debug 'ID 已变，重置会话'; session.initiate() end
end

function session.terminate()
  -- body...
end

function session.login()
end

event.listen{ event = 'ready_to_login', func = session.login, id = 'session.login', persistent = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return session
