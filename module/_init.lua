--------------------------------------------------------------------------------
-- Initialize the plugin
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- initial set up

-- dev mode?
dev_mode = true

-- get the MC install path and add worlds\BambooGolem as a package path
do
	local _, _, path = string.find( package.path, ';([^;]+);' )
	MCPATH = string.sub( path, 1, string.find( path, '\\lua' ) )
	PPATH = MCPATH
	package.path = package.path .. ';' .. PPATH .. '?.lua'
end

--------------------------------------------------------------------------------
-- load data and modules

-- load data
dofile( CWD .. 'data/constant.lua' )

-- load default config
dofile( CWD .. 'data/default_config.txt' )

-- setup necessary tables
player, time = {}, {}
player.flag, player.temp_flag, player.inventory, player.skill, player.set = {}, {}, {}, {}, {}

-- load message module
message = require 'module.message'

-- set up useful helper functions
dofile( CWD .. 'module/_helper.lua' )

-- load modules
event = require 'module.event'
trigger = require 'module.trigger'
cmd = require 'module.cmd'
cli = require 'module.cli'
log = require 'module.log'
timer = require 'module.timer'
map = require 'module.map'
taskmaster = require 'module.taskmaster'
bigword = require 'module.bigword'
gag = require 'module.gag'
session = require 'module.session'
npc = require 'module.npc'
item = require 'module.item'
room = require 'module.room'
inventory = require 'module.inventory'
kungfu = require 'module.kungfu'

-- load parsers
require 'module.parser.hp'
require 'module.parser.skills'
require 'module.parser.score'
require 'module.parser.inventory'
require 'module.parser.time'
require 'module.parser.cond'
require 'module.parser.room'
require 'module.parser.id'
require 'module.parser.enable'
require 'module.parser.place'
require 'module.parser.connection'
require 'module.parser.uptime'
require 'module.parser.set'
require 'module.parser.title'
require 'module.parser.recover'

-- load task classes
dofile( CWD .. 'task/_init.lua' )

-- load the core
dofile( CWD .. 'module/_main.lua' )

--------------------------------------------------------------------------------
-- initial task set up

-- set automode to inactive after plugin is first loaded
automode = 'inactive'

-- set up a new manual task, there should always be one and only one manual task instance
taskmaster.current_manual_task = task.manual:new()

-- set up default cli commands (must be done after the maunal task is set up)
dofile( CWD .. 'module/cli_default.lua' )

--------------------------------------------------------------------------------
-- set up some saner-than-default world options, just in case

world.SetOption( 'auto_pause', 1 )
world.SetOption( 'unpause_on_send', 1 )
world.SetOption( 'enable_command_stack', 1 )
world.SetOption( 'auto_repeat', 1 )
world.SetOption( 'arrow_recalls_partial', 1 )
world.SetOption( 'arrows_change_history', 1 )
world.SetOption( 'confirm_before_replacing_typing', 0 )
world.SetOption( 'escape_deletes_input', 1 )
world.SetOption( 'keep_commands_on_same_line', 1 )
world.SetOption( 'enable_speed_walk', 0 )
world.SetOption( 'enable_timers', 1 )
world.SetOption( 'log_notes', 1 )
world.SetOption( 'log_input', 1 )
world.SetOption( 'log_output', 1 )
world.SetOption( 'log_html', 1 )
world.SetOption( 'log_in_colour', 1 )
world.SetOption( 'script_errors_to_output_window', 1 )
world.SetOption( 'play_sounds_in_background', 1 )
world.SetOption( 'send_echo', 1 )
world.SetOption( 'show_bold', 0 )
world.SetOption( 'save_world_automatically', 1 )

--------------------------------------------------------------------------------
-- some tweaks to the MC GUI

-- make the MC window a little bit transparent
world.Transparency( -1, 245 )

-- set command window height
SetCommandWindowHeight( 36 )

--------------------------------------------------------------------------------
-- welcome

-- initializes the info bar
world.ShowInfoBar( true )
world.InfoClear()
world.InfoFont( '新宋体', 9, 0 )
world.InfoBackground 'green'
world.InfoColour 'white'
world.Info '欢迎使用玉竹傀儡！开发者：emptyair@SJCQ'
world.SetStatus '玉竹傀儡载入完成！'

if not dev_mode then world.ColourNote( 'white', 'green', [[

┌──────────────────────────────┐
│   ___  ___  _    ___  ____ ____ ____ ____ __   ____ _      │
│   | .\ |  \ |\/\ | .\ |   ||   ||  _\|   || |  | __\|\/\   │
│   | .<_| . \|   \| .<_| . || . || [ \| . || |__|  ]_|   \  │
│   |___/|/\_/|/v\/|___/|___/|___/|___/|___/|___/|___/|/v\/  │
│                                                            │
└──  欢迎使用玉竹傀儡(v.alpha)！开发者：emptyair@SJCQ  ──┘

请输入 bg help 了解使用方法，或直接输入 auto start 开始自动运行!

]] )
end

--------------------------------------------------------------------------------
-- initiate player session

if world.IsConnected() then session.initiate() end
