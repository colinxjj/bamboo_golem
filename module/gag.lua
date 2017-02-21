
local gag = {}

--------------------------------------------------------------------------------
-- This module handles gagging (for predefined groups only)
--------------------------------------------------------------------------------

local list = {}
local in_gag

local gag_def = {
  score = {
    startp = '^�q�������齣�������Ͽ���',
    endp = 1 - lpeg.S '���Ĩt ' },
  skills = {
    startp = '^(> )*����ļ��ܱ�',
    endp = lpeg.P '����������' },
  hp = {
    startp = '^����Ѫ��',
    endp = lpeg.P '����ˮ��' },
  cond = {
    startp = '^����������������������������������������������������',
    endp = lpeg.P '����������������������������������������������������' },
  time = {
    startp = '^(> )*�������齣',
    endp = lpeg.P '�������״̬��' },
  inventory = {
    startp = '^(> )*�����ϴ���',
    endp = 1 - lpeg.S '�� ',
    exclude_endp = true },
  enable = {
    startp = '^(> )*��������Ŀǰʹ���е����⼼�ܡ�',
    endp = 1 - lpeg.P ' ',
    exclude_endp = true },
}

function gag.once( group )
  assert( type( group ) == 'string', 'gag.once - parameter must be a string' )
  local t = gag_def[ group ]
  if not t then message.debug( 'δ�ҵ� gag �鶨�壺' .. group ); return end
  list[ group ] = 'not_started'
  trigger.new{ name = 'gag_start_' .. group, match = t.startp, func = gag.start, sequence = 50, enabled = true, keep_eval = true, omit = true, one_shot = true }
end

function gag.start( name )
  local group = string.gsub( name, 'gag_start_', '' )
  list[ group ] = 'started'
  in_gag = true
  trigger.enable 'gag'
end

function gag.check( text )
  if not in_gag then return end
  for group in pairs( list ) do
    local t = gag_def[ group ]
    if list[ group ] == 'pending_stop' then list[ group ] = nil end
    if list[ group ] == 'started' and t.endp:match( text ) then
      list[ group ] = not t.exclude_endp and 'pending_stop' or nil
    end
  end
  if not next( list ) then
    trigger.disable 'gag'
    in_gag = false
  end
end

function gag.blackhole()
end

trigger.new{ name = 'gag', match = '.', func = gag.blackhole, sequence = 50, keep_eval = true, omit = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return gag
