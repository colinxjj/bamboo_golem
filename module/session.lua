
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
  player.is_initiated = true
end

function session.resume()
  -- body...
end

function session.terminate()
  -- body...
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return session
