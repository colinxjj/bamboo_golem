--------------------------------------------------------------------------------
-- This file sets up some default cli commands
--------------------------------------------------------------------------------

cli.register{ cmd = 'help', desc = '显示插件命令帮助', func = cli.help }
cli.register{ cmd = 'auto', desc = '控制自动模式。auto start：开始自动模式，auto stop：停止自动模式', func = cli.help, no_prefix = true }

--------------------------------------------------------------------------------
-- g

local function start_go_task( dest )
  dest = dest and map.get_room_by_id( dest ) or dest
  if not dest then
    message.normal '未找到对应的目的地，请检查'
  else
    taskmaster.current_manual_task:newweaksub{ class = 'go', to = dest }
  end
end

local function parse_g_response( choice )
  start_go_task( choice )
end

local function parse_g( _, input )
  if map.get_room_by_id( input ) then
    start_go_task( input )
  else
    local list = map.get_room_by_longname( input ) or map.get_room_by_name( input ) or nil
    if list and #list > 1 then
      local cli_tbl = { header = '你要前往哪个地点？', default = 1, func = parse_g_response }
      for index, room in pairs( list ) do
        cli_tbl[ index ] = room.id
      end
      cli.new_interaction( cli_tbl )
      return
    else
      start_go_task( list and list[ 1 ] or nil )
    end
  end
end

cli.register{ cmd = 'g', desc = '前往指定地点。例如：g 扬州城中央广场', func = parse_g, no_prefix = true }

--------------------------------------------------------------------------------
-- loc

local function parse_loc()
  taskmaster.current_manual_task:newsub{ class = 'locate' }
end

cli.register{ cmd = 'loc', desc = '定位当前位置。', func = parse_loc, no_prefix = true }

--------------------------------------------------------------------------------
-- dev

local function parse_dev()
  if dev_mode then
    dev_mode, message.level, log.level = false, 'verbose', 'verbose'
    message.normal '开发模式已关闭'
  else
    dev_mode, message.level, log.level = true, 'debug', 'debug'
    message.normal '开发模式已开启'
  end
end

cli.register{ cmd = 'dev', desc = '切换开发模式。', func = parse_dev, no_prefix = true }

--------------------------------------------------------------------------------
-- ct

local function parse_ct()
  print( time.get_current_hour() or '时间未知' )
end

cli.register{ cmd = 'ct', desc = '显示当前时辰。', func = parse_ct, no_prefix = true }

--------------------------------------------------------------------------------
-- ll

local function parse_ll()
  taskmaster.current_manual_task:newsub{ class = 'getinfo', room = 'surrounding' }
end

cli.register{ cmd = 'll', desc = '查看所有周边房间。', func = parse_ll, no_prefix = true }

--------------------------------------------------------------------------------
-- mm

local parse_mm
parse_mm = function()
  local room = room.get()
  if not room or not room.desc then
    event.listen{ event = 'room', func = parse_mm, id = 'mm' }
    cmd.new{ 'l' }
    return
  end
  local content = map.serialize_room( room )
  print( content )
end

cli.register{ cmd = 'mm', desc = '序列化当前房间数据。', func = parse_mm, no_prefix = true }

--------------------------------------------------------------------------------
-- tv

local sp = lpeg.P ' '
local patt = lpeg.C( any_but( sp )^1 ) * sp^1 * ( ( any_but( sp )^1 ) / tonumber )
local function parse_tv( _, input )
  local loc, range = patt:match( input )
  taskmaster.current_manual_task:newweaksub{ class = 'traverse', loc = loc or input, range = range or 2 }
end

cli.register{ cmd = 'tv', desc = '测试遍历。', func = parse_tv, no_prefix = true }

--------------------------------------------------------------------------------
-- f

local function parse_f_response( choice )
  taskmaster.current_manual_task:newweaksub{ class = 'find', object = choice }
end

local function parse_f( _, input )
  if not npc[ input ] then
    local list = {}
    for name, person in pairs( npc ) do
      if name == input or person.id == input then
        list[ #list + 1] = name
      elseif person.alternate_id then
        for _, id in pairs( person.alternate_id ) do
          if id == input then list[ #list + 1] = name; break end
        end
      end
    end
    if #list == 0 then message.normal '未找到对应的 NPC，请检查'; return end
    if #list == 1 then
      input = list[ 1 ]
    else
      list.header, list.default, list.func = '你要找的是谁？', 1, parse_f_response
      cli.new_interaction( list )
      return
    end
  end
  taskmaster.current_manual_task:newweaksub{ class = 'find', object = input }
end

cli.register{ cmd = 'f', desc = '前往某个NPC所在处。支持中文名和 ID。例如：f 李半仙 或 f banxian', func = parse_f, no_prefix = true }

--------------------------------------------------------------------------------
-- pp

local type_list = { sharp_weapon = true }
local patt = lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )
local function parse_pp( _, input )
  local count, name = patt:match( input )
  count, name = tonumber( count ), name or input
  local it = item.get( name ) or item.get_by_id( name )
  if it then
    taskmaster.current_manual_task:newweaksub{ class = 'manage_inventory', action = 'prepare', item = it.name, count = count }
  elseif item.is_valid_type( name ) then
    taskmaster.current_manual_task:newweaksub{ class = 'manage_inventory', action = 'prepare', item = name, count = count }
  else
    message.normal '未找到对应的物品，请检查'
  end
end


cli.register{ cmd = 'pp', desc = '获取指定的物品。支持中文名和 ID。例如：pp 500 coin 或 pp 木棉袈裟', func = parse_pp, no_prefix = true }

--------------------------------------------------------------------------------
-- tt

local function parse_tt( _, input )
  local path = map.getpath( '襄阳城山间空地', '襄阳郊外剑冢' )
  local list = map.get_path_req( path )
  tprint( list )
end


cli.register{ cmd = 'tt', desc = '测试', func = parse_tt, no_prefix = true }
