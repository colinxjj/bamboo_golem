--------------------------------------------------------------------------------
-- This module parses time info
--------------------------------------------------------------------------------

local function get_hour_diff( a, b )
  local diff = a - b
  diff = diff < -12 and 24 + diff or diff > 12 and diff - 24 or diff
  return diff
end

local function parse_line_1( _, t )
  time.year = t[ 2 ]
  time.month = cntonumber( t[ 3 ] )
  time.day = cntonumber( t[ 4 ] )
  local new_hour = ( CN_HOUR[ t[ 5 ] ] + ( CN_QUARTER[ t[ 6 ] ] or 0 ) ) % 24
  time.hour = time.get_current_hour()
  time.hour = ( not time.calibrate_time or math.abs( get_hour_diff( time.hour, new_hour ) ) > 0.5 ) and new_hour or time.hour
  time.update_time, player.time_update_time = os.time(), os.time()
  trigger.enable_group 'time'
end

local function parse_line_2( _, t )
  if t[ 1 ] == '���ϵͳ��ʾ' then
    player.vip_time = 0
  else
    player.vip_time = cn_timelen_to_sec( t [2] )
  end
end

local patt1 = lpeg.P '�Ѿ�ʹ��' * upto ','
local patt2 = upto '���ܻ�����ʹ��' * upto '��'

local function parse_line_3( _, t )
  t = t[ 1 ]
  if string.find( t, '�㲻�ǹ��' ) then
    player.is_vip = false
    player.guigu_time = 0
  else
    player.is_vip = true
  end

  local c = patt1:match( t )
  player.guigu_is_active = c and true or false
  player.guigu_active_duration =  c and cn_timelen_to_sec( c ) or nil
  player.guigu_active_start_time = player.guigu_active_duration and ( os.time() - player.guigu_active_duration ) or nil
  local _, c = patt2:match( t )
  player.guigu_time = c and cn_timelen_to_sec( c ) or 0

  trigger.disable_group 'time'
  event.new 'time'
end

local function parse_calibration( _, t )
  local new_hour = t[ 2 ] == '����' and 9 or t[ 2 ] == '��ҹ' and 20 -- incorrect message in mud..
  if not time.hour then -- no existing hour info
    message.debug( 'ʱ��У������ǰû��ʱ�����ݣ�У��Ϊ ' .. new_hour .. ' ʱ' )
  else
    local old_hour = time.get_current_hour()

    message.debug( 'ʱ��У����' .. ( time.calibrate_time and '�ϴ�У��ʱ��Ϊ ' .. os.time() - time.calibrate_time .. ' ��ǰ' or '���ǵ�һ��У��ʱ��' ) .. '����ǰʱ������ƫ�� ' .. get_hour_diff( old_hour, new_hour ) .. ' ��Сʱ��У��Ϊ ' .. new_hour .. ' ʱ' )
  end
  time.hour, time.calibrate_time, time.update_time, player.time_update_time = new_hour, os.time(), os.time(), os.time()
end

trigger.new{ name = 'time1', match = '^(> )*�������齣(\\S+)��(\\S+)��(\\S+)��(\\S+)ʱ(\\S*)��', func = parse_line_1, enabled = true }
trigger.new{ name = 'time2', match = '^(���ʣ��ʱ��|���ϵͳ��ʾ)��(\\S+)��', func = parse_line_2, group = 'time' }
trigger.new{ name = 'time3', match = '^�������״̬��(\\S+)', func = parse_line_3, group = 'time' }

trigger.new{ name = 'timec', match = '^(> )*�Ѿ���(����|��ҹ)��', func = parse_calibration, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
