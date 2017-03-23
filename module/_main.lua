--------------------------------------------------------------------------------
-- This file defines some misc functions of the plugin
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- partial line

local is_line_processed

local PROMPT = '^' .. PROMPT

function world.OnPluginPartialLine( text )
	if string.find( text, '^Are you using BIG5 font' ) then
		trigger.enable_group 'connection'
		world.Send ''
	else
		gag.check( text ) -- check if the line should be gagged
		if is_line_processed then return end -- to avoid raising multiple prompt / headline events for the same line if it has been updated multiple times
		is_line_processed = true
		if string.find( text, PROMPT ) then
			event.new 'prompt'
			cmd.dispatch()
		end
	end
end

function world.OnPluginLineReceived()
	is_line_processed = false
end

--------------------------------------------------------------------------------
-- heartbeat

local heartbeat_count = 0
local idle_hbcount = 0
local cmd_processed

function OnPluginTick()
	heartbeat_count = heartbeat_count + 1

	busy_expire() -- check if player busy should expire now

	timer.refresh( heartbeat_count ) -- all high level timers are based on heartbeats

	cmd_processed = cmd.dispatch()

	-- check idle
	idle_hbcount = cmd_processed and 0 or idle_hbcount + 1
	if idle_hbcount * HEARTBEAT_INTERVAL > IDLE_THRESHOLD then
		idle_hbcount = idle_hbcount - 60 / HEARTBEAT_INTERVAL -- don't fire idle event more than once per min
		event.new 'idle'
	end
end

function get_heartbeat_count()
	return heartbeat_count
end

--------------------------------------------------------------------------------
-- busy

local busy_expire_hbcount

function addbusy( sec )
	--message.debug( sec .. ' 秒 busy 开始' )
	player.is_busy = true
	busy_expire_hbcount = heartbeat_count + sec / HEARTBEAT_INTERVAL
end

function busy_expire()
	if player.is_busy and heartbeat_count >= busy_expire_hbcount then
		--message.debug 'busy 结束'
		player.is_busy = false
		busy_expire_hbcount = nil
	end
end

--------------------------------------------------------------------------------
-- other stuff

function play_sound( name )
	world.PlaySound( 1, PPATH .. 'data/sound/' .. name .. '.wav', false, 0, 0 )
end

-- calculate current time in game based on info in the 'time' table
function time.get_current_hour()
  if not time.update_time or not time.hour then return end
  local hour_passed = math.floor( ( os.time() - time.update_time ) / 60 * 10 ) / 10
  local new_hour = ( time.hour + hour_passed ) % 24
  -- message.debug( '距离上次更新时间信息已过 ' .. os.time() - time.update_time .. ' 秒，游戏时间应当已过 ' .. hour_passed .. ' 小时，估计当前时刻为 ' .. new_hour .. ' 时' )
  return new_hour
end

function time.get_uptime()
	if not time.uptime then return end
	return time.uptime + os.time() - time.uptime_timestamp
end

function get_npc( name )
	for iname, person in pairs( npc ) do
		if iname == name or person.name == name then return person end
	end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
