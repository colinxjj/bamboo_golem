--------------------------------------------------------------------------------
-- This module parses room info
--------------------------------------------------------------------------------

local cache

local sp = lpeg.P ' '^0
local nondash = lpeg.C( any_but( ' ', '-', '��', '��', '��', '��' )^1 )
local dash = lpeg.C( lpeg.P '-' + '��' + '��' + '��' + '��' ) * lpeg.P '-'^0
local patt = ( sp * ( dash + nondash ) )^1
local look_dir_upper = { ['�I'] = 'nw', ['�J'] = 'ne', ['��'] = 'nd', ['��'] = 'nu', ['��'] = 'n', ['��'] = 'u', ['��'] = 'enter', ['��'] = 'wu', ['��'] = 'wd', ['-'] = 'w', ['��'] = 'left' }
local look_dir_lower = { ['��'] = 'ed', ['��'] = 'eu', ['-'] = 'e', ['�K'] = 'se', ['�L'] = 'sw', ['��'] = 'su', ['��'] = 'sd', ['��'] = 's', ['��'] = 'd', ['��'] = 'out', ['��'] = 'right' }

local function parse_look_header( _, t )
  cache = { look = {}, area = t[ 2 ], exit = {} }
  trigger.enable 'room_look_content'
end

local function parse_look_content( _, t )
  table.insert( cache.look, t[ 0 ] )
end

local function process_look()
  local dir, room, upperhalf, t = {}, {}, true
  for ln, line in ipairs( cache.look ) do
    t = { patt:match( line ) }
    if #t > 0 then
      for i, v in ipairs( t ) do
        table.insert( ( ln % 2 == 0 or ( ln == 3 and i % 2 == 0 ) ) and dir or room, v )
        if ln == 3 and i == ( sp:match( line ) < 24 and 3 or 1 ) then table.insert( dir, '+' ) end
      end
    end
  end
  cache.look = true
  for i, d in ipairs( dir ) do
    if d == '+' then
      upperhalf = false
    else
      cache.exit[ upperhalf and look_dir_upper[ d ] or look_dir_lower[ d ] ] = room[ i ]
    end
  end
end

local function parse_header( _, t )
  cache = cache or {}
  if cache.look then process_look() end
  cache.name, cache.desc = t[ 2 ], ''
  trigger.disable 'room_look_content'
  trigger.enable_group 'room'
end

local function parse_desc( _, t )
  cache.desc = cache.desc .. t[ 0 ]
end

local function parse_nature()
end

local dir = lpeg.C( lpeg.R 'az'^1 )
local seperator = lpeg.P '��' + ' �� '
local exit_patt =  ( seperator^-1 * dir )^1

local function extract_exit( text )
  local t, result = { exit_patt:match( text ) }, cache.exit or {}
  if t then
    for _, dir in pairs( t ) do
      dir = DIR_ABBRE[ dir ] or dir
      result[ dir ] = result[ dir ] or true
    end
  end
  return result
end

local function parse_end()
  trigger.disable 'room_object' -- stop parsing objects
  trigger.disable 'room_end'
  event.remove_listener_by_id 'parser.room'
  timer.remove_by_id 'parser.room'
  event.new{ event = 'room', data = cache }
  for name, object in pairs( cache.object ) do
    event.new{ event = 'room_object', name = name, object = object }
  end
  --tprint( cache )
  cache = nil
end

local function prepare_to_parse_object()
  trigger.enable 'room_object'
  trigger.enable 'room_end' -- get ready for room end
  event.listen{ event = 'prompt', func = parse_end, id = 'parser.room' }
  timer.new{ duration = 2, func = parse_end, id = 'parser.room' } -- see room as complete if no object info is received in 2 seconds
end

local function parse_exit( _, t )
  cache.desc, cache.object = string.gsub( cache.desc, '^    ', '' ), {}
  cache.exit = t[ 2 ] ~= 'û��' and t[ 2 ] ~= '������' and extract_exit( t[ 4 ] ) or cache.exit or {}
  trigger.disable_group 'room' -- stop parsing name, desc, and exit
  prepare_to_parse_object()
end

local function parse_object( _, t )
  local name = extract_name( t[ 1 ] )
  local name, count = extract_name_count( name )
  cache.object[ name ] = {
    name = name,
    id = string.lower( t[ 2 ] ),
    count = count,
  }
end

local function parse_brief( _, t )
  cache = {}
  cache.name, cache.brief, cache.object = t[ 2 ], true, {}
  cache.exit = t[ 3 ] and extract_exit( t[ 3 ] ) or {}
  prepare_to_parse_object()
end

local function parse_ferry_came()
  local room = map.get_current_room()
  if room then room.exit.enter = true end
  event.new 'ferry_came'
end

local function parse_ferry_left()
  local room = map.get_current_room()
  if not room then return end
  if room.name ~= '�ٿ�'
  and room.name ~= '��¨'
  and not string.find( room.name, '��' )
  and not string.find( room.name, '��' ) then
    room.exit.enter = nil
    event.new 'ferry_left'
  end
end

local function parse_ferry_arrived()
  local room = map.get_current_room()
  if room then room.exit.out = true end
  event.new 'ferry_arrived'
end

local function parse_ferry_departed()
  local room = map.get_current_room()
  if not room then return end
  if room.name == '�ٿ�'
  or room.name == '��¨'
  or string.find( room.name, '��' )
  or string.find( room.name, '��' ) then
    room.exit.out = nil
    event.new 'ferry_departed'
  end
end

trigger.new{ name = 'room_header', text = '^(> )*(\\S+) - $', func = parse_header, enabled = true }
trigger.new{ name = 'room_desc', text = '^.+$', func = parse_desc, group = 'room' }
trigger.new{ name = 'room_nature', text = '^��������һ��\\S{4}(\\S{4})?��', func = parse_nature, group = 'room', sequence = 99 } -- higher sequence to block desc trigger
trigger.new{ name = 'room_exit', text = '^    ����((û��|������)�κ����Եĳ�·|(���Ե�|Ψһ��|���ü���Ψһ|�������)������ (.+))��', func = parse_exit, group = 'room', sequence = 99 }
trigger.new{ name = 'room_object', text = '^  ([^(]+)\\(([\\w\\s\\\'-]+)\\)(\\<\\S+\\>)?', func = parse_object }
trigger.new{ name = 'room_end', text = '^\\S', func = parse_end, sequence = 99, keep_eval = true }

trigger.new{ name = 'room_brief', text = '^(> )*(\\S+) - (\\S+)$', func = parse_brief, enabled = true }

trigger.new{ name = 'room_look_header', text = '^(> )*��������������(\\S+)��$', func = parse_look_header, enabled = true }
trigger.new{ name = 'room_look_content', text = '^.+$', func = parse_look_content, sequence  = 101 }

trigger.new{ name = 'room_ferry_came', text = '^(> )*(һҶ���ۻ�����ʻ�˹���|һ�Ҷɴ�������ʻ�˹���|��ɮ��������˳|һ���ִ������׹�Ÿ����ٿ�|һ������¨�����ؽ�������)', func = parse_ferry_came, enabled = true }
trigger.new{ name = 'room_ferry_left', text = '^(> )*(�����ǰ�̤�Ű���|������̤�Ű���|���½��ں���һ��������ඡ�|����һ�����ٿ�����ҡ�����˼���|��ɮ����һ�ƣ����ٿ�����ƽ̨)', func = parse_ferry_left, enabled = true, keep_eval = true }
trigger.new{ name = 'room_ferry_arrived', text = '^(> )*(����˵���������ϰ��ɡ�|������һ��̤�Ű���ϵ̰�|�ɴ��͵�һ��|��¨���˼���|�ֻ���������|�ٿ������Խ��Խ��|һ����ɮ��ɳ�Ƶ�������|���ڵ���С����|���ڵ��˰���|�����С�ۿ��ڰ���)', func = parse_ferry_arrived, enabled = true }
trigger.new{ name = 'room_ferry_departed', text = '^(> )*(�����ǰ�̤�Ű���|������̤�Ű���|ͭ�����죬�¶��Ľ��̿�ʼת��|����һ�����ٿ�����ҡ�����˼���|��ɮ����һ�ƣ����ٿ�����ƽ̨)', func = parse_ferry_departed, enabled = true, keep_eval = true }

-- add triggers for rooms that have no exits sometimes, resulting in no trailing dash after the room name
local no_exit_room_list = map.list_all_potentially_no_exit()
local i = 1
for roomname in pairs( no_exit_room_list ) do
  trigger.new{ name = 'room_ne' .. i, text = '^(> )*(' .. roomname .. ')$', group = 'room_ne',func = parse_brief, enabled = true }
  i = i + 1
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------