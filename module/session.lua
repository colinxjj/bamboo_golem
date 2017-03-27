
local session = {}

--------------------------------------------------------------------------------
-- This module handles sessions
--------------------------------------------------------------------------------

function session.initiate()
  session.reset()
  task.get_info:new{ room = not room.get(), hp = true, inventory = true, score = true, enable = true, skills = true, time = true, set = true, complete_func = session.initiate_done, priority = 1 }
end

event.listen{ event = 'connected', func = session.initiate, id = 'session.initiate', persistent = true }

function session.initiate_done()
  if not player.set.look then cmd.new{ 'set look' } end
  kungfu.initialize( player.skill )
  player.is_initiated = true
end

local old_id

function session.resume()
  old_id = player.id
  task.get_info:new{ room = true, title = true, complete_func = session.resume_follow_up, priority = 1 }
end

event.listen{ event = 'reconnected', func = session.resume, id = 'session.resume', persistent = true }

function session.resume_follow_up()
  if player.id ~= old_id then session.initiate() end
end

function session.reset()
  player.temp_flag = {}
  item.reset_all_invalid_source()
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
