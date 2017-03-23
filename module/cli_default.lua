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
    local manual = taskmaster.current_manual_task
    manual:newweaksub{ class = 'go', to = dest, fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'locate', fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newsub{ class = 'get_info', room = 'surrounding', fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'go', to = loc or input, range = range or 2, fail_func = manual.fail_catcher }
end

cli.register{ cmd = 'tv', desc = '测试遍历。', func = parse_tv, no_prefix = true }

--------------------------------------------------------------------------------
-- f

local function parse_f_response( choice )
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'find', object = choice, fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'find', object = input, fail_func = manual.fail_catcher }
end

cli.register{ cmd = 'f', desc = '前往某个NPC所在处。支持中文名和 ID。例如：f 李半仙 或 f banxian', func = parse_f, no_prefix = true }

--------------------------------------------------------------------------------
-- gi

local type_list = { sharp_weapon = true }
local patt = lpeg.C( lpeg.R '09'^1 ) * ' ' * lpeg.C( lpeg.P( 1 )^1 )
local function parse_gi( _, input )
  local manual = taskmaster.current_manual_task
  local count, name = patt:match( input )
  count, name = tonumber( count ), name or input
  local it = item.get( name ) or item.get_by_id( name )
  if it then
    manual:newweaksub{ class = 'get_item', item = it.name, count = count, fail_func = manual.fail_catcher }
  elseif item.is_valid_type( name ) then
    manual:newweaksub{ class = 'get_item', item = name, count = count, fail_func = manual.fail_catcher }
  else
    message.normal '未找到对应的物品，请检查'
  end
end

cli.register{ cmd = 'gi', desc = '获取指定的物品。支持中文名和 ID。例如：gi 500 coin 或 gi 木棉袈裟', func = parse_gi, no_prefix = true }

--------------------------------------------------------------------------------
-- full

local function parse_full( _, input )
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'recover', all = 'full', neili = 'double', fail_func = manual.fail_catcher }
end

cli.register{ cmd = 'full', desc = '恢复 HP。', func = parse_full, no_prefix = true }
--------------------------------------------------------------------------------
-- refill

local function parse_refill( _, input )
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'recover', food = 'full', water = 'full', fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'manage_inventory', action = 'wield', item = 'sword', fail_func = manual.fail_catcher }
end

cli.register{ cmd = 't', desc = '测试', func = parse_t, no_prefix = true }
