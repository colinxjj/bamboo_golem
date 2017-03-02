--------------------------------------------------------------------------------
-- This file defines some misc functions of the plugin
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- prompt events

-- to avoid multiple prompt events when a line was updated multiple times
local prompt_fired_on_this_line

local PROMPT = '^' .. PROMPT

function world.OnPluginPartialLine( text )
	if string.find( text, '^Are you using BIG5 font' ) then
		trigger.enable_group 'connection'
		world.Send ''
	end
	gag.check( text ) -- check if the line should be gagged
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
	message.debug( sec .. ' 秒 busy 开始' )
	player.is_busy = true
	busy_expire_hbcount = heartbeat_count + sec / HEARTBEAT_INTERVAL
end

function busy_expire()
	if player.is_busy and heartbeat_count >= busy_expire_hbcount then
		message.debug 'busy 结束'
		player.is_busy = false
		busy_expire_hbcount = nil
	end
end

--------------------------------------------------------------------------------
-- other stuff

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

-- check if a person / an object is present in the current room
function is_present( object )
	object = type( object ) == 'string' and { name = object } or object
	local room = map.get_current_room()
	local room_object = room.object[ object.name ]
	return room_object and ( object.id and object.id == room_object.id or not object.id ) and true or false
end

-- add a new object to the current room
function new_room_object( object )
	object = type( object ) == 'string' and { name = object } or object
 	local room = map.get_current_room()
	room.object[ object.name ] = object
end

function remove_room_object( object )
	object = type( object ) == 'string' and { name = object } or object
	local room = map.get_current_room()
	room.object[ object.name ] = nil
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
