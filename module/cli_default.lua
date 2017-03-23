--------------------------------------------------------------------------------
-- This file sets up some default cli commands
--------------------------------------------------------------------------------

cli.register{ cmd = 'help', desc = '��ʾ����������', func = cli.help }
cli.register{ cmd = 'auto', desc = '�����Զ�ģʽ��auto start����ʼ�Զ�ģʽ��auto stop��ֹͣ�Զ�ģʽ', func = cli.help, no_prefix = true }

--------------------------------------------------------------------------------
-- g

local function start_go_task( dest )
  dest = dest and map.get_room_by_id( dest ) or dest
  if not dest then
    message.normal 'δ�ҵ���Ӧ��Ŀ�ĵأ�����'
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'locate', fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newsub{ class = 'get_info', room = 'surrounding', fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'go', to = loc or input, range = range or 2, fail_func = manual.fail_catcher }
end

cli.register{ cmd = 'tv', desc = '���Ա�����', func = parse_tv, no_prefix = true }

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
    if #list == 0 then message.normal 'δ�ҵ���Ӧ�� NPC������'; return end
    if #list == 1 then
      input = list[ 1 ]
    else
      list.header, list.default, list.func = '��Ҫ�ҵ���˭��', 1, parse_f_response
      cli.new_interaction( list )
      return
    end
  end
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'find', object = input, fail_func = manual.fail_catcher }
end

cli.register{ cmd = 'f', desc = 'ǰ��ĳ��NPC���ڴ���֧���������� ID�����磺f ����� �� f banxian', func = parse_f, no_prefix = true }

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
    message.normal 'δ�ҵ���Ӧ����Ʒ������'
  end
end

cli.register{ cmd = 'gi', desc = '��ȡָ������Ʒ��֧���������� ID�����磺gi 500 coin �� gi ľ������', func = parse_gi, no_prefix = true }

--------------------------------------------------------------------------------
-- full

local function parse_full( _, input )
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'recover', all = 'full', neili = 'double', fail_func = manual.fail_catcher }
end

cli.register{ cmd = 'full', desc = '�ָ� HP��', func = parse_full, no_prefix = true }
--------------------------------------------------------------------------------
-- refill

local function parse_refill( _, input )
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'recover', food = 'full', water = 'full', fail_func = manual.fail_catcher }
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
  local manual = taskmaster.current_manual_task
  manual:newweaksub{ class = 'manage_inventory', action = 'wield', item = 'sword', fail_func = manual.fail_catcher }
end

cli.register{ cmd = 't', desc = '����', func = parse_t, no_prefix = true }
