
local gag = {}

--------------------------------------------------------------------------------
-- This module handles gagging (for predefined groups only)
--------------------------------------------------------------------------------

local list, excessive_count = {}, {}

local sp = lpeg.P ' '
local nonsp = any_but( sp )
local prompt = lpeg.P '> '

local gag_def = {
  score = {
    startp = lpeg.P '�q�������齣�������Ͽ���',
    endp = any_but( lpeg.S '���Ĩt ' ),
    exclude_endp = true },
  skills = {
    startp = prompt^-1 * '����ļ��ܱ�',
    endp = any_but( lpeg.S '��������' ),
    exclude_endp = true },
  hp = {
    startp = lpeg.P '����Ѫ��',
    endp = lpeg.P '����ˮ��' },
  cond = {
    startp = lpeg.P '����������������������������������������������������',
    endp = lpeg.P '����������������������������������������������������' },
  time = {
    startp = prompt^-1 * '�������齣',
    endp = lpeg.P '�������״̬��' },
  inventory = {
    startp = prompt^-1 * '�����ϴ���',
    endp = any_but( lpeg.P '��' + '  ' ),
    exclude_endp = true },
  enable = {
    startp = prompt^-1 * '��������Ŀǰʹ���е����⼼�ܡ�',
    endp = any_but( sp * sp * nonsp^4 * ' (' * lpeg.R 'az'^1 * ')' * sp^1 * '��' ),
    exclude_endp = true },
  set = {
    startp = prompt^-1 * '��Ŀǰ�趨�Ļ��������У�',
    endp = any_but( nonsp^1 * sp^1 * ( lpeg.R '09'^1 + ( lpeg.P '"' * upto( '"' ) ) ) * -lpeg.P( 1 ) ),
    exclude_endp = true },

  title = { startp = prompt^-1 * '��' * upto '��' * nonsp^1 * lpeg.S' ��' }
}

local always_gag_def = {
  lone_prompt = '^> $'
}

local excessive_gag_def = {
  enter_and_leave = '^(> )*\\S+(��|��)\\S+(���˹���|�뿪)��$',
  fly = '^(> )*(\\S+���˽�������Ʒ��|ֻ��\\S+����ƮƮ��)',
  exert = '^(> )*[^��]\\S+(�������˼�����|����������һ����)',
  dazuo_halt = '^(> )*[^��]\\S+(����һ����������Ϣ�������˻�ȥ|��ɫһ����Ѹ������|��Ϣһת��Ѹ������|�Ҵҽ���Ϣ���˻�ȥ|����΢΢��������������|˫�ۻ����պϣ�Ƭ���͵�����|˫��һ��|���������е�����ǿ��ѹ�ص���|΢һ��ü������Ϣѹ�ص���|�е��������ͣ�ֻ��и����Ϣ|�е��������ң�ȫ�����ȣ�ֻ���չ�|�͵�����˫�ۣ�˫��Ѹ�ٻظ����|üͷһ�壬�������������ַ�������|˫��һ�֣�������ȭ|˫��һ�֣�ƽ̯����|����һ��������Ϣѹ�ص���)',
  practice = '^(> )*\\S+����ר����ϰ'
}

function gag.once( group )
  assert( type( group ) == 'string', 'gag.once - parameter must be a string' )
  if not gag_def[ group ] then message.debug( 'δ�ҵ� gag �鶨�壺' .. group ); return end
  list[ #list + 1 ] = { group = group, status = 'pending', add_time = os.time() }
  --print( 'gag.once: ' .. group )
end

-- this function is called by OnPluginLineReceived
function gag.check( text )
  if not next( list ) then return true end
  local i, is_gag_needed = 1
  while list[ i ] do
    local entry, is_item_removed = list[ i ]
    local def = gag_def[ entry.group ]
    if os.time() - entry.add_time > 4 then
      is_item_removed = table.remove( list, i )
    elseif entry.status == 'pending' then
      if def.startp:match( text ) then
        entry.status, is_gag_needed = 'active', true
        --print( 'gag.start: ' .. entry.group .. ' - ' .. text )
        if not def.endp then is_item_removed = table.remove( list, i ) end
      end
    elseif entry.status == 'active' then
      if def.endp:match( text ) then
        is_item_removed = table.remove( list, i )
        --print( 'gag.end: ' .. entry.group .. ' - ' .. text )
        if not def.exclude_endp then is_gag_needed = true end
      else
        is_gag_needed = true
      end
    end
    if not is_item_removed then i = i + 1 end
  end
  return not is_gag_needed
end

function gag.excessive( name )
  local group = string.gsub( name, 'gag_excessive_', '' )
  excessive_count[ group ] = ( excessive_count[ group ] or 0 ) + 1
  if excessive_count[ group ] > 1 then
    trigger.update{ name = name, omit = true }
  end
end

-- reset excessive gag count whenever a new located event is fired
local function reset_excessive()
  -- only update trigger group if it has fired since last reset
  if next( excessive_count ) then
    trigger.update_group{ group = 'gag_excessive', omit = false }
  end
  excessive_count = {}
end

local function blackhole() end

event.listen{ event = 'located', func = reset_excessive, persistent = true, id = 'gag.excessive' }

for name, patt in pairs( always_gag_def ) do
  trigger.new{ name = 'gag_always_' .. name, match = patt, func = blackhole, sequence = 50, omit = true, keep_eval = true, enabled = true }
end

for name, patt in pairs( excessive_gag_def ) do
  trigger.new{ name = 'gag_excessive_' .. name, group = 'gag_excessive', match = patt, func = gag.excessive, sequence = 50, keep_eval = true, enabled = true }
end


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return gag
