
local cmd = {}

--------------------------------------------------------------------------------
-- This module handles command queueing and sending
--------------------------------------------------------------------------------

-- a list to store all commands (queue and history)
local list, list_startpos, list_endpos, list_curpos = {}, 0, 0, 1

--------------------------------------------------------------------------------

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
local waitp = lpeg.C( lpeg.P '#w' * lpeg.S 'ab' * ' ' * lpeg.R '09'^1 * ( nsep + -1 ) )
local askp = lpeg.C( lpeg.P 'ask ' * any_but( nsep )^1 * ( nsep + -1 ) )
local cmdp = lpeg.C( ( 1 - lpeg.P '#wa' - lpeg.P '#wb' - 'ask' )^1 )
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
  for i, unit in ipairs( result ) do
    unit = extra_sep_patt:match( unit ) -- remove leading and trailing '|'
    local type = has_sep:match( unit ) and 'batch' or cmd.extract_core( unit )
    unit = type == 'batch' and ( 'ado ' .. unit ) or unit
    result[ i ] = { cmd = unit, status = 'pending', type = type, complete_func = ( i == #result and t.complete_func or false ) } -- make sure only the last unit in a batch triggers the complete_func
    setmetatable( result[ i ], t ) -- units inherit values from the original table, .e.g add_time, ignore_result
  end
  return result
end
--------------------------------------------------------------------------------

-- add command to list
local function add_to_list( c )
  list_endpos = list_endpos + 1
  list[ list_endpos ] = c

  if list_endpos - list_startpos > 100 then -- store 100 list entries
    list[ list_startpos ] = nil
    list_startpos = list_startpos + 1
  end
end

-- add new commands, don't execute them right away (that'll be handled by the heartbeats)
--[[ usage: cmd.new{
  'kiss;#2 kick;kill', 'haha;#wa 2000;hehe'; -- a series of commands to send. can be distributed across multiple varargs in the array part, and seperated by colons (;) in each arg. zmud style #wa are also supported. (required)
  task = a_task_instance, -- the task instance the commands belongs to. commands from dead tasks will be discarded (optional)
  complete_func = a_func, -- a function to run when a command has been successfully (optional)
  fail_msg = 'Some text', text to trigger on to indicate the command failed and the fail_func should be called (optional)
  fail_func = a_func, -- a function to run when the fail_msg has been triggered (optional)
  retry_msg = 'Some other text', -- text to trigger on to indicate the command failed and should be retried (optional)
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

--------------------------------------------------------------------------------

local is_possibly_still_busy, is_waiting_for_cmd_result, cmd_timeout_hbc

local function start_waiting_for_cmd_result()
  is_waiting_for_cmd_result = true
  cmd_timeout_hbc = get_heartbeat_count() + 0.6 / HEARTBEAT_INTERVAL -- set cmd time out as 0.6 seconds, if we haven't received prompt after this period of time, then will move forward regardless
end

local function stop_waiting_for_cmd_result()
  is_waiting_for_cmd_result, cmd_timeout_hbc = false
end

event.listen{ event = 'prompt', func = stop_waiting_for_cmd_result, id = 'cmd.stop_waiting_for_cmd_result', persistent = true }

-- send a command
local function send( c )
  if c.type == '#wa' or c.type == '#wb' then
    c.duration = tonumber( ( string.gsub( c.cmd, '#w[ab] ', '' ) ) )
    c.hbcount = c.duration / ( HEARTBEAT_INTERVAL * 1000 ) -- convert duration to number of heartbeats
    -- message.debug( 'CMD 模块按照 #wa 命令等待 ' .. c.duration .. ' 毫秒 / ' .. c.hbcount .. ' 次心跳' )
    c.target_hbcount = get_heartbeat_count() + c.hbcount
    c.status = 'waiting'
    if c.type == '#wb' then -- mark player as busy for the same period for #wb
      addbusy( c.duration / 1000 )
      is_possibly_still_busy = true
    end
  elseif is_possibly_still_busy and c.type == 'batch' and not c.ignore_result then -- try halting first if might still be in busy and next command is a batch
    if is_possibly_still_busy == true then
      is_possibly_still_busy = 'halt_sent'
      world.Send( 'halt' )
    end
  else
    is_possibly_still_busy = false
    trigger.enable_group 'cmd'
    if c.ignore_result then
      c.status = 'completed'
    else
      c.status = 'sent'
      if c.retry_msg then trigger.update{ name = 'cmd_retry', match = c.retry_msg, enabled = true } end
      if c.retry_until_msg then trigger.update{ name = 'cmd_retry_until', match = c.retry_until_msg, enabled = true } end
      if c.fail_msg then trigger.update{ name = 'cmd_fail', match = c.fail_msg, enabled = true } end
      start_waiting_for_cmd_result()
    end
    if c.no_echo then
      world.SendNoEcho( c.cmd )
    else
      world.Send( c.cmd )
    end
  end
end

-- dispatch next command, called by the heartbeat
function cmd.dispatch()
  local c = list[ list_curpos ]
  if not c then return end -- return if no command at current position

  -- first check if current cmd's task if still active, if not, discard it and subsequent commands from the same task and end this dispatch session
  if c.task and c.task.status ~= 'running' and c.task.status ~= 'lurking' and c.status ~= 'sent' and c.status ~= 'completed' then
    message.debug( 'CMD 模块：舍弃任务“' .. c.task.id .. '”的命令：' .. c.cmd )
    c.status = 'discarded'
    list_curpos = list_curpos + 1
    cmd.dispatch() -- immediately dispatch again
  else
    -- if we're waiting, then wait until the target heartbeat count is reached
    if c.target_hbcount and c.target_hbcount > get_heartbeat_count() then return end

    event.update_history_promptpos()

    -- commands encountered busy?
    if c.status == 'encountered_busy' and not c.ignore_result then -- reset status and wait for next dispatch (which will not immediately resend the commands because of the set busy)
      c.status = 'pending'
    else
      if c.status == 'sent' and ( is_waiting_for_cmd_result and get_heartbeat_count() < cmd_timeout_hbc ) then return end -- ignore other sources when waiting for prompt and time out has not expired

      stop_waiting_for_cmd_result()

      if c.status ~= 'pending' then
        if c.is_retry_needed or ( c.retry_until_msg and c.is_retry_needed ~= false ) then -- retry the command
          c.status, c.is_retry_needed = 'pending'
        else -- move on to next command
          c.status = 'completed'
          if c.retry_msg or c.retry_until_msg or c.fail_msg then trigger.disable( 'cmd_retry', 'cmd_retry_until', 'cmd_fail' ) end
          local func = c.is_successful ~= false and c.complete_func or c.fail_func
          if func then func( c.task ) end -- run the command's binded function
          list_curpos = list_curpos + 1
        end
      end

      if player.is_busy then is_possibly_still_busy = true; return end -- wait if player is busy

      c = list[ list_curpos ]
      if not c then return end -- return if no further commands

      send( c )
      return true -- let heartbeat know that a cmd was processed
    end
  end
end

--------------------------------------------------------------------------------

local function parse_busy()
  local c = list[ list_curpos ]
  if not c then return end
  c.status = 'encountered_busy'
  addbusy( 2 )
end

trigger.new{ name = 'cmd_busy', match = '^(> )*(你正忙着|你的动作还没有完成|你逃跑失败|您先歇口气再说话吧|你现在正忙着做其他事|\\S*哟，抱歉啊，我这儿正忙着呢……您请稍候。|\\( 你上一个动作还没有完成，不能施用内功。\\)|你现在很忙，停不下来)', func = parse_busy, group = 'cmd' }

-- add 2 seconds of busy after successful 'ask' command
local function ask_start_busy()
  addbusy( 2 )
end

trigger.new{ name = 'cmd_ask_start_busy', match = '^(> )*你向\\S+打听有关『.+』的消息。$', func = ask_start_busy, group = 'cmd' }

-- halt ok, no longer need to try halting
local function halt_ok()
  is_possibly_still_busy = false
end

trigger.new{ name = 'cmd_halt_ok', match = '^(> )*你现在不忙。$', func = halt_ok, group = 'cmd' }

local function parse_cmd_fail()
  local c = list[ list_curpos ]
  if not c then return end
  if c.fail_msg then c.has_failed = true end
end

trigger.new{ name = 'cmd_fail', match = '^XXXXX$', func = parse_cmd_fail, sequence = 90, keep_eval = true }

local function parse_cmd_retry()
  local c = list[ list_curpos ]
  if not c then return end
  if c.retry_msg then c.is_retry_needed = true end
end

trigger.new{ name = 'cmd_retry', match = '^YYYYY$', func = parse_cmd_retry, sequence = 90, keep_eval = true }

local function parse_cmd_retry_until()
  local c = list[ list_curpos ]
  if not c then return end
  if c.retry_until_msg then c.is_retry_needed = false end
end

trigger.new{ name = 'cmd_retry_until', match = '^ZZZZZ$', func = parse_cmd_retry_until, sequence = 90, keep_eval = true }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return cmd
