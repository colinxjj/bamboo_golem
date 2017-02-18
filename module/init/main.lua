--------------------------------------------------------------------------------
-- This file defines some misc functions of the plugin
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- prompt events

-- to avoid multiple prompt events when a line was updated multiple times
local prompt_fired_on_this_line

local PROMPT = '^' .. PROMPT

function world.OnPluginPartialLine( text )
	if string.find( text, PROMPT ) and not prompt_fired_on_this_line then
		prompt_fired_on_this_line = true
		event.new 'prompt'
		heartbeat 'prompt'
	end
end

function world.OnPluginLineReceived( line )
	prompt_fired_on_this_line = false
end

--------------------------------------------------------------------------------
-- heartbeat related stuff

local heartbeat_count = 0
local idle_hbcount = 0
local cmd_processed

function heartbeat( source )
	heartbeat_count = heartbeat_count + 1
	-- PlaySound( 1, PPATH .. 'data/sound/ding.wav', false, 0, 0 )

	busy_expire() -- check if player busy should expire now

	timer.refresh( heartbeat_count ) -- all high level timers are based on heartbeats

	cmd_processed = cmd.dispatch( source )

	-- check idle
	idle_hbcount = cmd_processed and 0 or idle_hbcount + 1
	if idle_hbcount * HEARTBEAT_INTERVAL > IDLE_THRESHOLD then
		idle_hbcount = idle_hbcount - 60 / HEARTBEAT_INTERVAL -- don't fire idle event more than once per min
		event.new 'idle'
	end
end

-- add the heartbeat timer
world.AddTimer( 'heartbeat_timer', 0, 0, HEARTBEAT_INTERVAL, '', 1025, 'heartbeat' ) -- replace existing heartbeat timer

function get_heartbeat_count()
	return heartbeat_count
end

--------------------------------------------------------------------------------
-- busy related stuff

local busy_expire_hbcount

function addbusy( sec )
	message.debug( sec .. ' Ãë busy ¿ªÊ¼' )
	player.is_busy = true
	busy_expire_hbcount = heartbeat_count + sec / HEARTBEAT_INTERVAL
end

function busy_expire()
	if player.is_busy and heartbeat_count >= busy_expire_hbcount then
		message.debug 'busy ½áÊø'
		player.is_busy = false
		busy_expire_hbcount = nil
	end
end



--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
