--------------------------------------------------------------------------------
-- This module parses room info
--------------------------------------------------------------------------------

local cache

-- a blacklist with rooms for which we should not process look info. The reason is that they contain 'left' and 'right' directions and the symbol for the latter '〉' can cause troubles with room names like 小岛边 and result in locating failure.
local look_blacklist = {
  ['华山山洞'] = true,
  ['华山密洞'] = true,
  ['华山密道'] = true,
  ['华山山洞'] = true,
  ['蝴蝶谷山壁'] = true,
}

local sp = lpeg.P ' '^0
local nondash = lpeg.C( any_but( ' ', '-', '→', '←' )^1 )
local dash = lpeg.C( lpeg.P '-' + '→' + '←' ) * lpeg.P '-'^0
local patt = ( sp * ( dash + nondash ) )^1
local look_dir_upper = { ['↖'] = 'nw', ['↗'] = 'ne', ['↓'] = 'nd', ['↑'] = 'nu', ['｜'] = 'n', ['〓'] = 'u', ['∧'] = 'enter', ['←'] = 'wu', ['→'] = 'wd', ['-'] = 'w', }
local look_dir_lower = { ['←'] = 'ed', ['→'] = 'eu', ['-'] = 'e', ['↘'] = 'se', ['↙'] = 'sw', ['↓'] = 'su', ['↑'] = 'sd', ['｜'] = 's', ['〓'] = 'd', ['∨'] = 'out', }

local function parse_look_header( _, t )
  cache = { look = {}, area = t[ 2 ], exit = {} }
  trigger.enable 'room_look_content'
end

local function parse_look_content( _, t )
  table.insert( cache.look, t[ 0 ] )
end

local function process_look()
  if cache and cache.name and look_blacklist[ cache.name ] then return end -- ignore rooms in blacklist
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
  cache.name, cache.desc = t[ 2 ], ''
  if cache.look then process_look() end
  trigger.disable 'room_look_content'
  trigger.enable_group 'room'
end

local function parse_desc( _, t )
  cache.desc = cache.desc .. t[ 0 ]
end

local function parse_nature()
end

local dir = lpeg.C( lpeg.R 'az'^1 )
local seperator = lpeg.P '、' + ' 和 '
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
  -- tprint( cache )
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
  cache.exit = t[ 2 ] ~= '没有' and t[ 2 ] ~= '看不见' and extract_exit( t[ 4 ] ) or cache.exit or {}
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
  if room.name ~= '藤筐'
  and room.name ~= '竹篓'
  and not string.find( room.name, '舟' )
  and not string.find( room.name, '船' ) then
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
  if room.name == '藤筐'
  or room.name == '竹篓'
  or string.find( room.name, '舟' )
  or string.find( room.name, '船' ) then
    room.exit.out = nil
    event.new 'ferry_departed'
  end
end

trigger.new{ name = 'room_header', match = '^(> )*(\\S+) - $', func = parse_header, enabled = true }
trigger.new{ name = 'room_desc', match = '^.+$', func = parse_desc, group = 'room' }
trigger.new{ name = 'room_nature', match = '^　　这是一个\\S{4}(\\S{4})?的', func = parse_nature, group = 'room', sequence = 99 } -- higher sequence to block desc trigger
trigger.new{ name = 'room_exit', match = '^    这里((没有|看不见)任何明显的出路|(明显的|唯一的|看得见的唯一|看得清的)出口是 (.+))。', func = parse_exit, group = 'room', sequence = 99 }
trigger.new{ name = 'room_object', match = '^  ([^(]+)\\(([\\w\\s\\\'-]+)\\)(\\<\\S+\\>)?', func = parse_object }
trigger.new{ name = 'room_end', match = '^\\S', func = parse_end, sequence = 99, keep_eval = true }

trigger.new{ name = 'room_brief', match = '^(> )*(\\S+) - (\\S+)$', func = parse_brief, enabled = true }

trigger.new{ name = 'room_look_header', match = '^(> )*【你现在正处于(\\S+)】$', func = parse_look_header, enabled = true }
trigger.new{ name = 'room_look_content', match = '^.+$', func = parse_look_content, sequence  = 101 }

trigger.new{ name = 'room_ferry_came', match = '^(> )*(一叶扁舟缓缓地驶了过来|一艘渡船缓缓地驶了过来|番僧把麻绳理顺|一条粗大的绳索坠着个大藤筐|一个大竹篓缓缓地降了下来)', func = parse_ferry_came, enabled = true }
trigger.new{ name = 'room_ferry_left', match = '^(> )*(艄公们把踏脚板收|艄公把踏脚板收|日月教众喊了一声“坐稳喽”|绳索一紧，藤筐左右摇晃振动了几下|番僧用力一推，将藤筐推离平台)', func = parse_ferry_left, enabled = true, keep_eval = true }
trigger.new{ name = 'room_ferry_arrived', match = '^(> )*(艄公说“到啦，上岸吧”|艄公将一块踏脚板搭上堤岸|渡船猛地一震|竹篓晃了几下|又划出三四里|藤筐离地面越来越近|一个番僧用沙哑的声音道|终于到了小岛边|终于到了岸边|船夫把小舟靠在岸边)', func = parse_ferry_arrived, enabled = true }
trigger.new{ name = 'room_ferry_departed', match = '^(> )*(艄公们把踏脚板收|艄公把踏脚板收|铜锣三响，崖顶的绞盘开始转动|绳索一紧，藤筐左右摇晃振动了几下|番僧用力一推，将藤筐推离平台)', func = parse_ferry_departed, enabled = true, keep_eval = true }

-- add triggers for rooms that have no exits sometimes, resulting in no trailing dash after the room name
local no_exit_room_list = map.list_all_potentially_no_exit()
local i = 1
for roomname in pairs( no_exit_room_list ) do
  trigger.new{ name = 'room_ne' .. i, match = '^(> )*(' .. roomname .. ')$', group = 'room_ne',func = parse_brief, enabled = true }
  i = i + 1
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
