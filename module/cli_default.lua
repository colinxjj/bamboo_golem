--------------------------------------------------------------------------------
-- This file sets up some default cli commands
--------------------------------------------------------------------------------

cli.register{ cmd = 'help', desc = '��ʾ����������', func = cli.help }
cli.register{ cmd = 'auto', desc = '�����Զ�ģʽ��auto start����ʼ�Զ�ģʽ��auto stop��ֹͣ�Զ�ģʽ', func = cli.help, no_prefix = true }

local function newsub_manual( t )
  local manual = taskmaster.current_manual_task
  t.fail_func =  manual.fail_catcher
  manual:newweaksub( t )
end

--------------------------------------------------------------------------------
-- g

local function display_arrival()
  message.verbose '�������'
end

local function start_go_task( dest )
  dest = dest and map.get_room_by_id( dest ) or dest
  if not dest then
    message.normal 'δ�ҵ���Ӧ��Ŀ�ĵأ�����'
  else
    message.verbose( 'ǰ����' .. dest.id .. '��' )
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
      local cli_tbl = { header = '��Ҫǰ���ĸ��ص㣿', default = 1, func = parse_g_response }
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

cli.register{ cmd = 'g', desc = 'ǰ��ָ���ص㡣���磺g ���ݳ�����㳡 �� g ����㳡', func = parse_g, no_prefix = true }

--------------------------------------------------------------------------------
-- loc

local function parse_loc()
  newsub_manual{ class = 'locate' }
end

cli.register{ cmd = 'loc', desc = '��λ��ǰλ�á�', func = parse_loc, no_prefix = true }

--------------------------------------------------------------------------------
-- dev

local function parse_dev()
  if dev_mode then
    dev_mode, message.level, log.level = false, 'verbose', 'verbose'
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
  message.verbose( '��ǰʱ��Ϊ��' .. ( time.get_current_hour() or 'δ֪' ) )
end

cli.register{ cmd = 'ct', desc = '��ʾ��ǰʱ�䡣', func = parse_ct, no_prefix = true }

--------------------------------------------------------------------------------
-- ll

local function parse_ll()
  newsub_manual{ class = 'get_info', room = 'surrounding' }
end

cli.register{ cmd = 'll', desc = '�鿴�����ܱ߷��䡣', func = parse_ll, no_prefix = true }

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

cli.register{ cmd = 'mm', desc = '���л���ǰ�������ݡ�', func = parse_mm, no_prefix = true }

--------------------------------------------------------------------------------
-- tv

local sp = lpeg.P ' '
local patt = lpeg.C( any_but( sp )^1 ) * sp^1 * ( ( any_but( sp )^1 ) / tonumber )
local function parse_tv( _, input )
  local loc, range = patt:match( input )
  newsub_manual{ class = 'go', to = loc or input, range = range or 2 }
end

cli.register{ cmd = 'tv', desc = '���Ա�����', func = parse_tv, no_prefix = true }

--------------------------------------------------------------------------------
-- f

local function parse_f_response( choice )
  newsub_manual{ class = 'find', object = choice }
end

local function parse_f( _, input )
  local list = npc.get_all( input )
  if #list == 0 then
    message.normal 'δ�ҵ���Ӧ�� NPC������'
  elseif #list == 1 then
    newsub_manual{ class = 'find', object = list[ 1 ].iname }
  else
    local t = { header = '��Ҫ�ҵ���˭��', default = 1, func = parse_f_response }
    for k, v in pairs( list ) do t[ k ] = v.iname end
    cli.new_interaction( t )
  end
end

cli.register{ cmd = 'f', desc = 'ǰ��ĳ��NPC���ڴ���֧���������� ID�����磺f ����� �� f banxian', func = parse_f, no_prefix = true }

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
    message.normal 'δ�ҵ���Ӧ����Ʒ������'
  elseif #list == 1 then
    newsub_manual{ class = 'get_item', item = list[ 1 ].iname, count = count }
  else
    interact_count = count
    local t = { header = '��Ҫȡ���ĸ���Ʒ��', default = 1, func = parse_gi_response }
    for k, v in pairs( list ) do t[ k ] = v.iname end
    cli.new_interaction( t )
  end
end

cli.register{ cmd = 'gi', desc = '��ȡָ������Ʒ��֧���������� ID�����磺gi 500 coin �� gi ľ������', func = parse_gi, no_prefix = true }

--------------------------------------------------------------------------------
-- full

local function parse_full( _, input )
  newsub_manual{ class = 'recover', all = 'full', neili = 'double' }
end

cli.register{ cmd = 'full', desc = '�ָ� HP��', func = parse_full, no_prefix = true }

--------------------------------------------------------------------------------
-- refill

local function parse_refill( _, input )
  newsub_manual{ class = 'recover', food = 'full', water = 'full' }
end

cli.register{ cmd = 'refill', desc = '����ʳ����ˮ��', func = parse_refill, no_prefix = true }

--------------------------------------------------------------------------------
-- pct

local function parse_pct( _, input )
  print( '��', trigger.get_count(), '����������' )
  for name, trg in pairs( trigger.get_all() ) do
    print( name .. ': ' .. trg.match )
  end
end

cli.register{ cmd = 'pct', desc = '�г���ǰ���д�������', func = parse_pct, no_prefix = true }

--------------------------------------------------------------------------------
-- test

local function parse_t( _, input )
  print( item.has_id( '����', 'changjian' ) )
end

cli.register{ cmd = 't', desc = '����', func = parse_t, no_prefix = true }

--------------------------------------------------------------------------------
-- test2

local function parse_tt()
  --newsub_manual{ class = 'improve', skill = '�����Ṧ', skill_target = 101 }
  newsub_manual{ class = 'manage_inventory', action = 'wield', item = 'weapon' }
end

cli.register{ cmd = 'tt', desc = '����', func = parse_tt, no_prefix = true }
