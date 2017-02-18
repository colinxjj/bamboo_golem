
local cmd = {}

--------------------------------------------------------------------------------
-- This module handles command queueing and sending
--------------------------------------------------------------------------------

-- a list to store all commands (queue and history)
local list, list_startpos, list_endpos, list_curpos = {}, 0, 0, 1

-- commands that fire a event if succeeded
local cmd_success_event = {
  hp = 'hp', score = 'score', skills = 'skills', enable = 'enable',
  inventory = 'inventory', i = 'inventory',
  place = 'place',  time = 'time',
  l = 'room', look = 'room',
  w = 'room', e = 'room', n = 'room', s = 'room',
  nw = 'room', ne = 'room', sw = 'room', se = 'room',
  nu = 'room', nd = 'room', su = 'room', sd = 'room',
  wu = 'room', wd = 'room', eu = 'room', ed = 'room',
  enter = 'room', out = 'room', u = 'room', d = 'room',
}

-- a list of messages for parsing command results
local cmd_result_message = {
  failure_busy = '你正忙着',
  failure_move_busy = '你的动作还没有完成，不能移动。',
  failure_move_combat_busy = '你逃跑失败。',
  failure_no_jingli = '你太累了，休息一下再走吧。',
  failure_no_exit = '这个方向没有出路。',
  failure_halt_busy = '你现在很忙，停不下来。',
  failure_ask_busy = '您先歇口气再说话吧。',
  failure_quit_busy = '你现在正忙着做其他事，不能退出游戏！',
  failure_transact_busy = '哟，抱歉啊，我这儿正忙着呢……您请稍候。',
  failure_yun_busy = '( 你上一个动作还没有完成，不能施用内功。)',

  success_not_busy = '你现在不忙。',
  success_not_hurt = '你并没有受伤！',
  success_ask = '你向\\S+打听有关『.+』的消息。',
  success_drop = '你丢下\\S+。',
}

-- extract the core command. e.g. the core command for 'ask di about 神照经' is 'ask'
do
  local core_patt = lpeg.C( ( lpeg.R 'az' + '#' )^1 ) * ( lpeg.P ' ' + -1 )

  function cmd.extract_core( s )
    return core_patt:match( s ) or s
  end
end

-- split command tables and command strings such as 'w;#3 n;#wa 2000;jump down' to individual tables that the plugin can work with
local sc_patt = upto ';'^0 * lpeg.C( any_but ';'^1 )
local rep_patt = lpeg.P '#' * lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 ) * -1

local function split_cmd( t )
  local result = {}
  for _, c in ipairs( t ) do -- handle each seperate piece in the array part
    if type( c ) == 'string' then -- only accepts string values
      local temp = { sc_patt:match( c ) }
      t.__index = t -- prepare the orignal table for inheritance
      for _, c1 in pairs( temp ) do
        local times, c2 = rep_patt:match( c1 )
        times, c2 = times or 1, c2 or c1
        for i = 1, times do
          local nt = { cmd = c2, core = cmd.extract_core( c2 ), status = 'pending' } -- every command get its own table
          setmetatable( nt, t ) -- new tables inherit values from the original table
          table.insert( result, nt )
        end
      end
    end
  end
  return result
end

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
  'kiss;#2 kick;kill', 'haha;#wa 2000;hehe'; -- a series of commands to send. can be distributed across multiple varargs in the array part, and seperated by colons (;) in each arg. zmud style #wa / #wait are also supported. (required)
  task = a_task_instance, -- the task instance the commands belongs to. commands from dead tasks will be discarded (optional)
} ]]
function cmd.new( c )
  assert( type( c ) == 'table', 'cmd.new - parameter must be a table' )
  assert( type( c[ 1 ] ) == 'string', 'cmd.new - table must contain at least one cmd string' )

  c.added = os.time()

  c = split_cmd( c ) -- split the table, one table for each command

  for _, v in pairs( c ) do
    add_to_list( v )
  end
end

-- get the last command from history
function cmd.get_last()
  return list[ list_curpos ] and list[ list_curpos ].cmd or list[ list_curpos - 1 ] and list[ list_curpos - 1 ].cmd
end

-- check if last command succeeded or failed
local function is_last_cmd_successful()
  local c = list[ list_curpos ]

  if c.ignore_result then c.is_successful = true end

  if c.is_successful == nil and cmd_success_event[ c.core ] then -- evaluate based on events since last prompt if is_successful field is not populated TODO if cmd has a special 'event' field, then check this event for success state
    for e in event.since_last_prompt() do
      if cmd_success_event[ c.core ] == e.event then c.is_successful = true; break end
    end
  end

  event.update_history_promptpos()
  --message.debug( 'CMD 模块判断命令' .. ( ( c.is_successful == true and '成功：' ) or ( is_successful == false and '失败：' ) or '”结果不明确：' ) .. c.cmd )
  return c.is_successful ~= false -- default to success TODO different cmds should have different defaults
end

-- send a command
local function send( c )
  if c.core == '#wa' or c.core == '#wait' then
    c.duration = tonumber( ( string.gsub( c.cmd, '#wai?t? ', '' ) ) )
    c.hbcount = c.duration / ( HEARTBEAT_INTERVAL * 1000 ) -- convert duration to number of heartbeats
    message.debug( 'CMD 模块按照 #wa/#wait 命令等待 ' .. c.duration .. ' 毫秒 / ' .. c.hbcount .. ' 次心跳' )
    c.target_hbcount = get_heartbeat_count() + c.hbcount
    c.status = 'waiting'
  else
    trigger.enable_group 'cmd'
    c.status = 'sent'
    world.Send( c.cmd )
  end
end

-- handle failed commands
local function handle_failed_cmd( c )
  message.debug( '命令失败，原因: ' .. ( c.fail_reason or '未知' ) )
  if string.find( c.fail_reason, 'busy' ) then
    c.status, c.is_successful = 'pending', nil
    c.target_hbcount = get_heartbeat_count() + 10 -- wait for 10 heartbeats
  elseif c.fail_reason == 'no_jingli' then
    -- TODO add a new task to restore jingli
  elseif c.fail_reason == 'no_exit' then
    -- TODO mark the task as failed
  elseif c.fail_reason == 'in_lasting_action' then
    -- TODO try halting
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

    local moveon = true -- move on to next command by default
    if c.status == 'sent' then -- check result of last command and decide if move on
      -- ignore other sources when waiting for prompt
      if source ~= 'prompt' and not c.ignore_result then return end

      moveon = is_last_cmd_successful() -- move on to next command?
      c.status = moveon and 'completed' or 'pending'
      list_curpos = moveon and list_curpos + 1 or list_curpos
    elseif c.status == 'waiting' then -- move on from a #wait session
      c.status = 'completed'
      list_curpos = list_curpos + 1
    end

    if player.is_busy then return end -- if player is busy then return

    if moveon then
      c = list[ list_curpos ]
      if not c then return end -- return if no further commands
      send( c )
      return true -- let heartbeat know that a cmd was processed
    else
      handle_failed_cmd( c )
    end
  end
end

-- parse cmd results
function cmd.parse_result( name )
  local c = list[ list_curpos ]
  if not c then return end

  if name == 'cmd_success_ask' then addbusy( 2 ) end

  if string.find( name, 'cmd_success_' ) then
    c.is_successful = true
  else
    name = string.gsub( name, 'cmd_failure_', '' )
    c.is_successful, c.fail_count, c.fail_reason = false, c.fail_count and c.fail_count + 1 or 1, name
  end
end

-- add command parsing triggers
for name, msg in pairs( cmd_result_message ) do
  trigger.new{ name = 'cmd_' .. name, text = '^(> )*' .. msg, func = cmd.parse_result, group = 'cmd', enabled = false, keep_eval = true, sequence = 50 }
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return cmd
