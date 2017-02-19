--------------------------------------------------------------------------------
-- This module parses score info
--------------------------------------------------------------------------------

local function parse_line_1( _, t )
  player.title = remove_space( t[ 1 ] )
  player.weight = cntonumber( t[ 2 ] )
  trigger.enable_group 'score'
end

local function parse_line_2( _, t )
  player.title2 = t[ 1 ]
  player.str = tonumber( t[ 2 ] )
  player.str_innate = tonumber( t[ 3 ] )
  player.con = tonumber( t[ 4 ] )
  player.con_innate = tonumber( t[ 5 ] )
end

local function parse_line_3( _, t )
  player.name, player.id = extract_name_id( t[ 1 ] )
  player.dex = tonumber( t[ 2 ] )
  player.dex_innate = tonumber( t[ 3 ] )
  player.int = tonumber( t[ 4 ] )
  player.int_innate = tonumber( t[ 5 ] )
end

local function parse_line_4( _, t )
  player.age = cntonumber( t[ 1 ] )
  player.age_month = cntonumber( t[ 3 ] )
end

local function parse_line_5( _, t )
  player.gender = extract_gender( t[ 1 ] )
  player.power_level_attack = POWER_LEVEL[ t[ 2 ] ]
  player.power_level_dodge = POWER_LEVEL[ t[ 3 ] ]
  player.power_level_parry = POWER_LEVEL[ t[ 4 ] ]
end

local function parse_line_6( _, t )
  player.bank_balance = ( t[ 1 ] == '����'  and 0 ) or cntonumber( t[ 2 ] )
  player.party = t[ 3 ]
  player.master = t[ 5 ] ~= '' and t[ 5 ] or nil
end

local function parse_line_7( _, t )
  player.sjtb = ( t[ 1 ] == '��'  and 0 ) or cntonumber( t[ 2 ] )
end

local function parse_line_8( _, t )
  player.is_married = t[ 1 ] ~= '����'
  if player.is_married then
    player.spouse, player.spouce_id = extract_name_id( t[ 2 ] )
  end
  player.shen = tonumber( ( t[ 3 ] == '��' and '-' or '' ) .. t[ 4 ] )
  player.rating = tonumber( t[ 5 ] )
end

local function parse_line_9( _, t )
  player.is_vip = t[ 1 ] == '���'
end

local function parse_line_10( _, t )
  player.kill_count = ( t[ 1 ] == '��'  and 0 ) or cntonumber( t[ 2 ] )
end

local function parse_line_11( _, t )
  player.death_count = ( t[ 1 ] == '��'  and 0 ) or cntonumber( t[ 2 ] )
  player.forge_chance_count = ( t[ 3 ] == '��'  and 0 ) or cntonumber( t[ 4 ] )
end

local bonze_patt = lpeg.P '��' + '��' + '��' + '��' + '��' + '��'

local function check_bonze()
  if player.party == '������' or player.party == '������' or
  ( ( player.party == '������' or player.party == '������' ) and bonze_patt:match( player.name ) ) then
    return true
  end
end

local function parse_line_12()
  player.is_bonze = check_bonze()
  player.score_update_time = os.time()
  SetTitle( GetAlphaOption( 'name' ) .. '-' .. player.id ) -- update window title to include player id
  trigger.disable_group 'score'
  event.new 'score'
end

trigger.new{ name = 'score1', text = '^����    ν����(.+)��\\s*����  �أ���(\\S+)�', func = parse_line_1, enabled = true }
trigger.new{ name = 'score2', text = '^��ͷ    �Σ�(\\S+)\\s*����  ������\\s*(\\d+)\\s*/\\s*(\\d+)\\s*��\\s*��  �ǣ���\\s*(\\d+)\\s*/\\s*(\\d+)', func = parse_line_2, group = 'score' }
trigger.new{ name = 'score3', text = '^����    ����(\\S+)\\s*����  ������\\s*(\\d+)\\s*/\\s*(\\d+)\\s*��\\s*��  �ԣ���\\s*(\\d+)\\s*/\\s*(\\d+)', func = parse_line_3, group = 'score' }
trigger.new{ name = 'score4', text = '^����    �䣺(\\S+)��(��(\\S+)����)?', func = parse_line_4, group = 'score' }
trigger.new{ name = 'score5', text = '^����    ��(\\S+)\\s+����(.{8}) �㣺(.{8}) �ܣ�(.{8})', func = parse_line_5, group = 'score' }
trigger.new{ name = 'score6', text = '^��Ǯׯ��(����|(\\S+)���ƽ�)\\s*ʦ    �У���(.{4,8})��(��(.+)��)?', func = parse_line_6, group = 'score' }
trigger.new{ name = 'score7', text = '^���齣ͨ����(��|(\\S+)��)', func = parse_line_7, group = 'score' }
trigger.new{ name = 'score8', text = '^��(����|���|����)��(\\S+)\\s*(��|��)����(\\d+)\\s*�ۺ����ۣ�(\\d+)', func = parse_line_8, group = 'score' }
trigger.new{ name = 'score9', text = '^��ע�᣺(���|��ͨ)���(\\S*)\\s*��ʦ��(\\S+)\\s*��    �棺(\\S+)', func = parse_line_9, group = 'score' }
trigger.new{ name = 'score10', text = '^��ɱ�ˣ�(��|(\\S+))\\s*��ң�(\\S+)\\s*����������(\\S+)', func = parse_line_10, group = 'score' }
trigger.new{ name = 'score11', text = '^��������(��|(\\S+)��)\\s*��Ч��(\\S+)\\s*������᣺(��|(\\S+)��)', func = parse_line_11, group = 'score' }
trigger.new{ name = 'score12', text = '^���ϴ�������', func = parse_line_12, group = 'score' }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
