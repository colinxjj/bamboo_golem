
local session = {}

--------------------------------------------------------------------------------
-- This module handles sessions
--------------------------------------------------------------------------------

function session.initiate()
  player.temp_flag = {}
  cmd.new{ 'set look' }
  task.getinfo:new{ hp = 'forced', inventory = 'forced', score = 'forced', enable = 'forced', skills = 'forced', time = 'forced', complete_func = session.setup_done, priority = 1 }
end

event.listen{ event = 'connected', func = session.initiate, id = 'session.initiate', persistent = true }

function session.setup_done()
  if not map.get_current_room() then
    task.getinfo:new{ room = true, complete_func = session.setup_done, priority = 1 }
  else
    player.is_initiated = true
  end
end

function session.resume()
end

event.listen{ event = 'reconnected', func = session.resume, id = 'session.resume', persistent = true }

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
