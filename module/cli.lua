
local cli = {}

--------------------------------------------------------------------------------
-- This module handles cli interaction with the user
--------------------------------------------------------------------------------

-- commands registered to root
local registry_root = {}
-- commands registered to prefix (bg)
local registry = {}
-- current immediate interaction
local immediate_interaction

function world.OnPluginCommandEntered( c )
  world.SetScroll( -1, true ) -- always scroll to bottom when new commands are entered

  if c == 'rl' or string.find( c, '^/') then return c end -- always let the world handle 'rl' to reload the plugin as well as scripts that start with /

  -- immediate interaction has higher priority than all else
  if immediate_interaction then
    world.Note( c ) -- print out the command in output
    c = tonumber( c ) or c -- to support numeric options
    c = not immediate_interaction[ c ] and immediate_interaction.default or c
    --message.debug( 'CLI 模块准备将用户输入的命令转发给即时互动处理程序：' .. c )
    world.SelectCommand() -- select the command in the command window
    immediate_interaction.func( immediate_interaction[ c ] )
    immediate_interaction = false -- end immediate interaction
    return '\t' -- let MC discard the command since it will be handled by the plugin
  end

  if c == '' then return c end -- directly pass blank commands to MC

  -- copy the current command window content to MC's command history
  world.PushCommand()
  world.SetCommand( c )
  world.SelectCommand() -- select the command in the command window

  local core = cmd.extract_core( c )
  if core == CLI_PREFIX then
    world.Note( c ) -- print out the command in output
    c = string.gsub( c, '^' .. CLI_PREFIX .. ' ', '' )
    core = cmd.extract_core( c )
    if registry[ core ] then
      --message.debug( 'CLI 模块检测到已注册的命令：' .. core )
      cli.parse( core, c )
    else
      message.normal( '输入的插件命令“' .. c .. '”似乎不正确，请检查' )
    end
  elseif registry_root[ core ] then
    world.Note( c ) -- print out the command in output
    --message.debug( 'CLI 模块检测到已注册的命令：' .. core )
    cli.parse( core, c )
  else
    -- message.debug( 'CLI 模块准备转发用户输入的命令：' .. c )
    taskmaster.current_manual_task:send{ c, ignore_result = true }
    cmd.dispatch 'manual'
  end
  return '\t' -- let MC discard the command since it will be handled by the plugin
end

-- register new cli commands
--[[ usage: cli.register{
  cmd = 'help', -- keyword of the command (required)
  func = cli.help, -- the function to call when user typed this command (required)
  desc = '显示插件命令帮助', -- a description of the command (optional)
  no_prefix = true, -- does the user need to type the standard prefix for this command to work? (optional, default: false)
} ]]
function cli.register( t )
  assert( type( t ) == 'table', 'cli.register - parameter must be a table' )
  assert( type( t.cmd ) == 'string', 'cli.register - the cmd param must be a string' )
  assert( type( t.func ) == 'function', 'cli.register - the func param must be a function' )

  registry[ t.cmd ] = t

  if t.no_prefix then -- if flag is set, register to root as well
    registry_root[ t.cmd ] = t
  end
end

-- unregister a cli command
function cli.unregister( c )
  assert( type( c ) == 'string', 'cli.unregister - parameter must be a string' )
  registry[ c ] = nil
  registry_root[ c ] = nil
  message.debug( 'CLI 模块已取消注册命令：' .. c )
end

local ii_reserved_param = {
  func = true,
  default = true,
  header = true,
  footer = true,
}

-- set up a new immediate interaction
--[[ usage: cli.new_interaction{
  y = '是', n = '否', -- a series of options (responses) the user can choose for the immmediate interaction (optional)
  func = parser_func, -- the function to call when user response is received (required)
  header = '确定吗？', -- the header text shown to the user (optional)
  footer = '请慎重选择', -- the footer text shown to the user (optional)
  default = 'y', -- default option if user response doesn't match any provided option (optional)
} ]]
function cli.new_interaction( t )
  assert( type( t ) == 'table', 'cli.new_interaction - parameter must be a table' )
  assert( type( t.func ) == 'function', 'cli.new_interaction - the func param must be a function' )

  -- print interaction guide
  world.ColourTell( 'white', 'black', '┌' )
  world.ColourTell( 'white', 'green', '※玉竹傀儡※' )
  world.ColourNote( 'white', 'black', '┐\n├──────┘' )
  if t.header then
    world.ColourTell( 'white', 'black', '│' )
    world.ColourNote( 'green', 'black', t.header )
  end
  for k, v in pairs( t ) do
    if not ii_reserved_param[ k ] then
      world.ColourTell( 'white', 'black', '│' )
      world.ColourNote( 'yellow', 'black', k .. ': ' .. v .. ( t.default == k and '（默认）' or '') )
    end
  end
  if t.footer then
    world.ColourTell( 'white', 'black', '│' )
    world.ColourNote( 'green', 'black', t.footer )
  end
  world.ColourNote( 'white', 'black', '└──────·' )

  world.AddTimer( 'cli_immediate_interaction_timeout', 0, 0, 20, '', 1025, 'cli.immediate_interaction_timeout' ) -- time out after 20 secs
  immediate_interaction = t
end

function cli.immediate_interaction_timeout()
  if immediate_interaction then
    message.normal '你未及时输入命令，互动取消'
    immediate_interaction = false
  end
end

-- parse registered commands and call the associated funcs
function cli.parse( core, full )
  local listener = registry_root[ core ] or registry[ core ]
  local param = string.gsub( full, '^' .. core .. ' ', '' )
  listener.func( listener.task or core, listener.task and core or param, listener.task and param or nil ) -- pass the task and/or response data as argument(s)
end

-- print help information
function cli.help( cmd, param )
  world.ColourTell( 'white', 'black', '┌' )
  world.ColourTell( 'white', 'green', '※玉竹傀儡·命令帮助※' )
  world.ColourNote( 'white', 'black', '┐\n├───────────┘' )
  for cmd, t in pairs( registry ) do
    world.ColourTell( 'white', 'black', '│' )
    world.ColourNote( 'green', 'black', ( t.no_prefix and '('  or '' ) .. CLI_PREFIX .. ( t.no_prefix and ') '  or ' ' ) .. cmd .. ': ' .. t.desc or '没有帮助信息' )
  end
  world.ColourNote( 'white', 'black', '└───────────·' )
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return cli
