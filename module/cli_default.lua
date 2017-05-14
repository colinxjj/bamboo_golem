--------------------------------------------------------------------------------
-- This file sets up some default cli commands
--------------------------------------------------------------------------------

cli.register{ cmd = 'help', desc = '显示插件命令帮助', func = cli.help }
cli.register{ cmd = 'auto', desc = '控制自动模式。auto start：开始自动模式，auto stop：停止自动模式', func = cli.help, no_prefix = true }

local function newsub_manual( t )
  local manual = taskmaster.current_manual_task
  t.fail_func =  manual.fail_catcher
  manual:newweaksub( t )
end

--------------------------------------------------------------------------------
-- g

local function display_arrival()
  message.verbose '行走完成'
end

local function start_go_task( dest )
  dest = dest and map.get_room_by_id( dest ) or dest
  if not dest then
    message.normal '未找到对应的目的地，请检查'
  else
    message.verbose( '前往“' .. dest.id .. '”' )
    newsub_manual{ class = 'go', to = dest, complete_func = display_arrival }
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

cli.register{ cmd = 'g', desc = '前往指定地点。例如：g 扬州城中央广场 或 g 中央广场', func = parse_g, no_prefix = true }

--------------------------------------------------------------------------------
-- loc

local function parse_loc()
  newsub_manual{ class = 'locate' }
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
  message.verbose( '当前时刻为：' .. ( time.get_current_hour() or '未知' ) )
end

cli.register{ cmd = 'ct', desc = '显示当前时间。', func = parse_ct, no_prefix = true }

--------------------------------------------------------------------------------
-- ll

local function parse_ll()
  newsub_manual{ class = 'get_info', room = 'surrounding' }
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
  newsub_manual{ class = 'go', to = loc or input, range = range or 2 }
end

cli.register{ cmd = 'tv', desc = '测试遍历。', func = parse_tv, no_prefix = true }

--------------------------------------------------------------------------------
-- f

local function parse_f_response( choice )
  newsub_manual{ class = 'find', object = choice }
end

local function parse_f( _, input )
  local list = npc.get_all( input )
  if #list == 0 then
    message.normal '未找到对应的 NPC，请检查'
  elseif #list == 1 then
    newsub_manual{ class = 'find', object = list[ 1 ].iname }
  else
    local t = { header = '你要找的是谁？', default = 1, func = parse_f_response }
    for k, v in pairs( list ) do t[ k ] = v.iname end
    cli.new_interaction( t )
  end
end

cli.register{ cmd = 'f', desc = '前往某个NPC所在处。支持中文名和 ID。例如：f 李半仙 或 f banxian', func = parse_f, no_prefix = true }

--------------------------------------------------------------------------------
-- gi

local gi_patt = lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )
local interact_count

local function parse_gi_response( choice )
  newsub_manual{ class = 'get_item', item = choice, count = interact_count }
end

local function parse_gi( _, input )
  local count, key = gi_patt:match( input )
  count, key = tonumber( count ), key or input
  local list = item.get_all( key )
  if #list == 0 then
    message.normal '未找到对应的物品，请检查'
  elseif #list == 1 then
    newsub_manual{ class = 'get_item', item = list[ 1 ].iname, count = count }
  else
    interact_count = count
    local t = { header = '你要取得哪个物品？', default = 1, func = parse_gi_response }
    for k, v in pairs( list ) do t[ k ] = v.iname end
    cli.new_interaction( t )
  end
end

cli.register{ cmd = 'gi', desc = '获取指定的物品。支持中文名和 ID。例如：gi 500 coin 或 gi 木棉袈裟', func = parse_gi, no_prefix = true }

--------------------------------------------------------------------------------
-- full

local function parse_full( _, input )
  newsub_manual{ class = 'recover', all = 'full', neili = 'double' }
end

cli.register{ cmd = 'full', desc = '恢复 HP。', func = parse_full, no_prefix = true }

--------------------------------------------------------------------------------
-- refill

local function parse_refill( _, input )
  newsub_manual{ class = 'recover', food = 'full', water = 'full' }
end

cli.register{ cmd = 'refill', desc = '补充食物饮水。', func = parse_refill, no_prefix = true }

--------------------------------------------------------------------------------
-- pct

local function parse_pct( _, input )
  print( '共', trigger.get_count(), '个触发器：' )
  for name, trg in pairs( trigger.get_all() ) do
    print( name .. ': ' .. trg.match )
  end
end

cli.register{ cmd = 'pct', desc = '列出当前所有触发器。', func = parse_pct, no_prefix = true }

--------------------------------------------------------------------------------
-- test

local function parse_t( _, input )
  print( item.has_id( '长剑', 'changjian' ) )
end

cli.register{ cmd = 't', desc = '测试', func = parse_t, no_prefix = true }

--------------------------------------------------------------------------------
-- test2

local function parse_tt()
  --newsub_manual{ class = 'improve', skill = '基本轻功', skill_target = 101 }
  newsub_manual{ class = 'manage_inventory', action = 'wield', item = 'weapon' }
end

cli.register{ cmd = 'tt', desc = '测试', func = parse_tt, no_prefix = true }
