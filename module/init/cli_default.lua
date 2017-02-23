--------------------------------------------------------------------------------
-- This file sets up some default cli commands
--------------------------------------------------------------------------------

cli.register{ cmd = 'help', desc = '��ʾ����������', func = cli.help }
cli.register{ cmd = 'auto', desc = '�����Զ�ģʽ��auto start����ʼ�Զ�ģʽ��auto stop��ֹͣ�Զ�ģʽ', func = cli.help, no_prefix = true }

--------------------------------------------------------------------------------
-- g

local option

local function start_go_task( dest )
  dest = dest and map.get_room_by_id( dest ) or dest
  if not dest then
    message.normal( 'δ�ҵ���Ӧ��Ŀ�ĵأ�����' )
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
      local cli_tbl = { header = '��Ҫǰ���ĸ��ص㣿', default = 1, func = parse_g_response }
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

cli.register{ cmd = 'g', desc = 'ǰ��ָ���ص㡣���磺g ���ݳ�����㳡', func = parse_g, no_prefix = true }

--------------------------------------------------------------------------------
-- loc

local function parse_loc()
  taskmaster.current_manual_task:newsub{ class = 'locate' }
end

cli.register{ cmd = 'loc', desc = '��λ��ǰλ�á�', func = parse_loc, no_prefix = true }

--------------------------------------------------------------------------------
-- dev

local function parse_dev()
  if dev_mode then
    dev_mode, message.level, log.level = false, 'normal', 'normal'
    message.normal '����ģʽ�ѹر�'
  else
    dev_mode, message.level, log.level = true, 'debug', 'debug'
    message.normal '����ģʽ�ѿ���'
  end
end

cli.register{ cmd = 'dev', desc = '�л�����ģʽ��', func = parse_dev, no_prefix = true }

--------------------------------------------------------------------------------
-- ct

local function parse_ct()
  print( time.get_current_hour() or 'ʱ��δ֪' )
end

cli.register{ cmd = 'ct', desc = '��ʾ��ǰʱ����', func = parse_ct, no_prefix = true }

--------------------------------------------------------------------------------
-- ll

local function parse_ll()
  taskmaster.current_manual_task:newsub{ class = 'getinfo', room = 'surrounding' }
end

cli.register{ cmd = 'll', desc = '�鿴�����ܱ߷��䡣', func = parse_ll, no_prefix = true }

--------------------------------------------------------------------------------
-- mm

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

cli.register{ cmd = 'mm', desc = '���л���ǰ�������ݡ�', func = parse_mm, no_prefix = true }

--------------------------------------------------------------------------------
-- tv

local sp = lpeg.P ' '
local patt = lpeg.C( any_but( sp )^1 ) * sp^1 * ( ( any_but( sp )^1 ) / tonumber )
local function parse_tv( _, input )
  local loc, range = patt:match( input )
  taskmaster.current_manual_task:newsub{ class = 'traverse', loc = loc or input, range = range or 2 }
end

cli.register{ cmd = 'tv', desc = '���Ա�����', func = parse_tv, no_prefix = true }
