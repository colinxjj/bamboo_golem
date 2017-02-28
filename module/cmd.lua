
local cmd = {}

--------------------------------------------------------------------------------
-- This module handles command queueing and sending
--------------------------------------------------------------------------------

-- a list to store all commands (queue and history)
local list, list_startpos, list_endpos, list_curpos = {}, 0, 0, 1

-- a list of messages for parsing command results
local cmd_busy_message = {
  busy = '你正忙着',
  move_busy = '你的动作还没有完成，不能移动。',
  move_combat_busy = '你逃跑失败。',
  ask_busy = '您先歇口气再说话吧。',
  quit_busy = '你现在正忙着做其他事，不能退出游戏！',
  transact_busy = '\\S*哟，抱歉啊，我这儿正忙着呢……您请稍候。',
  yun_busy = '( 你上一个动作还没有完成，不能施用内功。)',

  asked = '你向\\S+打听有关『.+』的消息。',

  halt_busy = '你现在很忙，停不下来。',
  halt_ok = '你现在不忙。',
}

-- extract the core command. e.g. the core command for 'ask di about 神照经' is 'ask'
local core_patt = lpeg.C( ( lpeg.R 'az' + '#' )^1 ) * ( lpeg.P ' ' + -1 )

function cmd.extract_core( s )
  return core_patt:match( s ) or s
end

--------------------------------------------------------------------------------
-- convert commands such as 'w;#3 n;#wa 2000;jump down' to units like 'w|n|n|n', '#wa 2000', 'jump down' that work with ado

-- pattern used to replace repeating ';' such as ';;' to a single ';'
local sep = lpeg.P ';'
local dup_patt = lpeg.Cs( ( ( sep ^ 2 / ';' ) + 1 )^1 )

-- pattern used to expand repetitions like '#5 w' to 'w;w;w;w;w'
local num = lpeg.C( lpeg.R '09'^1 )
local c = lpeg.C( any_but( sep )^1 )
local endp = lpeg.P( -1 ) + sep
local patt = lpeg.P '#' * num * ' ' * c * endp
local repl = function ( num, c )
  return string.rep( c .. ';', num )
end
local rep_patt = lpeg.Cs( ( patt / repl + 1 )^0 )

-- pattern used to remove leading ';' and substitute ';' with '|'
local nonsep = 1 - sep
local sep_patt = sep^0 * lpeg.Cs( ( nonsep^1 * ( sep / '|' + -1 ) )^1 )

-- pattern used to split commands into units, #wa and ask commands get their standalone units because they cause delay to subsequent commands
local nsep = lpeg.P '|'
local waitp = lpeg.C( lpeg.P '#wa' * ' ' * lpeg.R '09'^1 * ( nsep + -1 ) )
local askp = lpeg.C( lpeg.P 'ask ' * any_but( nsep )^1 * ( nsep + -1 ) )
local cmdp = lpeg.C( ( 1 - lpeg.P '#wa' - 'ask' )^1 )
local unit_patt = ( waitp + askp + cmdp )^1

-- pattern used to remove leading and trailing '|'
local extra_sep_patt = lpeg.Cs( nsep^-1 / '' * ( ( ( nsep * -1 ) / '' ) + 1 )^1 )

-- pattern used to determine if a string contains '|' or not
local has_sep = ( 1 - nsep )^0 * nsep

local function convert_to_unit( t )
  t.__index = t -- prepare the orignal table for inheritance
  local s = table.concat( t, ';' ) -- first concat all commands into a single string
  s = dup_patt:match( s ) -- correct repeating ';' such as ';;'
  s = rep_patt:match( s ) -- expand repetitions like '#5 w' to 'w;w;w;w;w'
  s = sep_patt:match( s ) -- remove leading ';' and substitute ';' with '|'
  if not s then return end
  local result = { unit_patt:match( s ) } -- split commands into units
  for i, unit in pairs( result ) do
    unit = extra_sep_patt:match( unit ) -- remove leading and trailing '|'
    local type = has_sep:match( unit ) and 'batch' or cmd.extract_core( unit )
    unit = type == 'batch' and ( 'ado ' .. unit ) or unit
    result[ i ] = { cmd = unit, status = 'pending', type = type }
    setmetatable( result[ i ], t ) -- units inherit values from the original table, .e.g add_time, ignore_result
  end
  return result
end
--------------------------------------------------------------------------------

-- add command to list
local function add_to_list( c )
  list_endpos = list_endpos + 1
  list[ list_endpos ] = c

  if list_endpos - list_startpos > 1000 then -- store 1000 list entries
    list[ list_startpos ] = nil
    list_startpos = list_startpos + 1
  end
end

-- add new commands, don't execute them right away (that'll be handled by the heartbeats)
--[[ usage: cmd.new{
  'kiss;#2 kick;kill', 'haha;#wa 2000;hehe'; -- a series of commands to send. can be distributed across multiple varargs in the array part, and seperated by colons (;) in each arg. zmud style #wa are also supported. (required)
  task = a_task_instance, -- the task instance the commands belongs to. commands from dead tasks will be discarded (optional)
} ]]
function cmd.new( c )
  assert( type( c ) == 'table', 'cmd.new - parameter must be a table' )
  assert( type( c[ 1 ] ) == 'string', 'cmd.new - table must contain at least one cmd string' )

  c.add_time = os.time()

  c = convert_to_unit( c ) -- convert command(s) to unit(s)

  if not c then return end

  for _, v in pairs( c ) do
    add_to_list( v )
  end
end

-- get the last command from history
function cmd.get_last()
  return list[ list_curpos ] or list[ list_curpos - 1 ]
end

local is_possibly_still_busy

-- send a command
local function send( c )
  if c.type == '#wa' then
    c.duration = tonumber( ( string.gsub( c.cmd, '#wa ', '' ) ) )
    c.hbcount = c.duration / ( HEARTBEAT_INTERVAL * 1000 ) -- convert duration to number of heartbeats
    -- message.debug( 'CMD 模块按照 #wa 命令等待 ' .. c.duration .. ' 毫秒 / ' .. c.hbcount .. ' 次心跳' )
    c.target_hbcount = get_heartbeat_count() + c.hbcount
    c.status = 'waiting'
  elseif is_possibly_still_busy and c.type == 'batch' and not c.ignore_result then -- try halting first if might still be in busy and next command is a batch
    if is_possibly_still_busy == true then
      is_possibly_still_busy = 'halt_sent'
      world.Send( 'halt' )
    end
  else
    is_possibly_still_busy = nil
    trigger.enable_group 'cmd'
    c.status = c.ignore_result and 'completed' or 'sent'
    if c.no_echo then
      world.SendNoEcho( c.cmd )
    else
      world.Send( c.cmd )
    end
  end
end

-- dispatch next command, called by the heartbeat
function cmd.dispatch( source )
  local c = list[ list_curpos ]
  if not c then return end -- return if no command at current position

  -- first check if current cmd's task if still active, if not, discard it and subsequent commands from the same task and end this dispatch session
  if c.task and c.task.status ~= 'running' and c.task.status ~= 'lurking' and c.status ~= 'sent' then
    message.debug( 'CMD 模块：舍弃任务“' .. c.task.id .. '”的命令：' .. c.cmd )
    c.status = 'discarded'
    list_curpos = list_curpos + 1
    cmd.dispatch( source ) -- immediately dispatch again
  else
    -- if we're waiting, then wait until the target heartbeat count is reached
    if c.target_hbcount and c.target_hbcount > get_heartbeat_count() then return end

    event.update_history_promptpos()

    -- commands encountered busy?
    if c.status == 'encountered_busy' and not c.ignore_result then -- reset status and wait for next dispatch (which will not immediately resend the commands because of the set busy)
      c.status = 'pending'
    else
      if c.status == 'sent' and source ~= 'prompt' then return end -- ignore other sources when waiting for prompt

      -- move on to next command
      if c.status ~= 'pending' then
        c.status = 'completed'
        list_curpos = list_curpos + 1
      end

      if player.is_busy then is_possibly_still_busy = true; return end -- wait if player is busy

      c = list[ list_curpos ]
      if not c then return end -- return if no further commands

      send( c )
      return true -- let heartbeat know that a cmd was processed
    end
  end
end

-- parse cmd results
function cmd.parse_busy( name )
  local c = list[ list_curpos ]
  if not c then return end

  if name == 'cmd_asked' then addbusy( 2 ) end -- add 2 seconds of busy after successful 'ask' command
  if name == 'cmd_halt_ok' then is_possibly_still_busy = nil end -- halt ok, no longer need to try halting
  if string.find( name, 'busy' ) then
    c.status = 'encountered_busy'
    addbusy( 2 )
  end
end

-- add command parsing triggers
for name, msg in pairs( cmd_busy_message ) do
  trigger.new{ name = 'cmd_' .. name, match = '^(> )*' .. msg, func = cmd.parse_busy, group = 'cmd', enabled = false, keep_eval = true, sequence = 90 }
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return cmd
