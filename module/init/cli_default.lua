--------------------------------------------------------------------------------
-- This file sets up some default cli commands
--------------------------------------------------------------------------------

cli.register{ cmd = 'help', desc = '显示插件命令帮助', func = cli.help }
cli.register{ cmd = 'auto', desc = '控制自动模式。auto start：开始自动模式，auto stop：停止自动模式', func = cli.help, no_prefix = true }

local option

local function start_go_task( dest )
  dest = dest and map.get_room_by_id( dest ) or dest
  if not dest then
    message.normal( '未找到对应的目的地，请检查' )
  else
    taskmaster.current_manual_task:newweaksub{ class = 'go', to = dest }
  end
end

local function parse_g_response( choice )
  local dest = option[ tonumber( choice ) or choice ]
  start_go_task( dest )
end

local function parse_g( _, input )
  if map.get_room_by_id( input ) then
    start_go_task( input )
  else
    option = map.get_room_by_longname( input ) or map.get_room_by_name( input ) or nil
    if option and #option > 1 then
      local cli_tbl = { header = '你要前往哪个地点？', default = 1, func = parse_g_response }
      for index, room in pairs( option ) do
        cli_tbl[ index ] = room.id
      end
      cli.new_interaction( cli_tbl )
      return
    else
      start_go_task( option and option[ 1 ] or nil )
    end
  end
end

cli.register{ cmd = 'g', desc = '前往指定地点。例如：g 扬州城中央广场', func = parse_g, no_prefix = true }

local function parse_loc()
  taskmaster.current_manual_task:newsub{ class = 'locate' }
end

cli.register{ cmd = 'loc', desc = '定位当前位置。', func = parse_loc, no_prefix = true }

local function parse_dev()
  if dev_mode then
    dev_mode, message.level, log.level = false, 'normal', 'normal'
    message.normal '开发模式已关闭'
  else
    dev_mode, message.level, log.level = true, 'debug', 'debug'
    message.normal '开发模式已开启'
  end
end

cli.register{ cmd = 'dev', desc = '切换开发模式。', func = parse_dev, no_prefix = true }

local function parse_ct()
  print( time.get_current_hour() or '时间未知' )
end

cli.register{ cmd = 'ct', desc = '显示当前时辰。', func = parse_ct, no_prefix = true }

local function parse_ll()
  taskmaster.current_manual_task:newsub{ class = 'getinfo', room = 'surrounding' }
end

cli.register{ cmd = 'll', desc = '查看所有周边房间。', func = parse_ll, no_prefix = true }

local parse_mm
parse_mm = function()
  local room = map.get_current_room()
  if not room or not room.desc then
    event.listen{ event = 'room', func = parse_mm, id = 'mm' }
    cmd.new{ 'l' }
    return
  end
  local content = map.serialize_room( room )
  print( content )
end

cli.register{ cmd = 'mm', desc = '序列化当前房间数据。', func = parse_mm, no_prefix = true }
