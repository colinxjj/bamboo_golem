
local gag = {}

--------------------------------------------------------------------------------
-- This module handles gagging (for predefined groups only)
--------------------------------------------------------------------------------

local pending_gag, active_gag, excessive_count = {}, {}, {}

local gag_def = {
  score = {
    startp = '^╭━━【书剑个人资料卡】',
    endp = 1 - lpeg.S '┃┠╰ ',
    exclude_endp = true },
  skills = {
    startp = '^(> )*【你的技能表】',
    endp = 1 - lpeg.S '┌│├└',
    exclude_endp = true },
  hp = {
    startp = '^·精血·',
    endp = lpeg.P '·饮水·' },
  cond = {
    startp = '^┌────────────────────────┐',
    endp = lpeg.P '└────────────────────────┘' },
  time = {
    startp = '^(> )*现在是书剑',
    endp = lpeg.P '鬼谷算术状态：' },
  inventory = {
    startp = '^(> )*你身上带着',
    endp = 1 - lpeg.S '□ ',
    exclude_endp = true },
  enable = {
    startp = '^(> )*以下是你目前使用中的特殊技能。',
    endp = 1 - lpeg.P ' ',
    exclude_endp = true },
  set = {
    startp = '^(> )*你目前设定的环境变量有：$',
    endp = lpeg.P '> ',
    exclude_endp = true },

  title = { linep = '^(> )*【(.+)】\\S+( |「)\\S+\\(\\w+\\)$' }
}

local always_gag_def = {
  lone_prompt = '^> $'
}

local excessive_gag_def = {
  enter_and_leave = '^(> )*\\S+(从|往)\\S+(走了过来|离开)。$',
  fly = '^(> )*(\\S+紧了紧随身物品，|只见\\S+长袖飘飘从)',
  exert = '^(> )*[^你]\\S+(深深吸了几口气|长长地舒了一口气)',
}

function gag.once( group )
  assert( type( group ) == 'string', 'gag.once - parameter must be a string' )
  if not gag_def[ group ] then message.debug( '未找到 gag 组定义：' .. group ); return end
  pending_gag[ #pending_gag + 1 ] = { group = group, add_time = os.time() }
  trigger.enable( 'gag_' .. group )
end

function gag.start( name )
  local group, i, count, entry = string.gsub( name, 'gag_', '' ), 1, 0
  -- remove the gag entry from pending list
  while pending_gag[ i ] do
    if pending_gag[ i ].group == group then
      count = count + 1
      if count == 1 then
        entry = table.remove( pending_gag, i )
      else
        i = i + 1
      end
    else
      i = i + 1
    end
  end
  -- if no further gag with the same group, disable the startp trigger
  if count == 1 then trigger.disable( name ) end
  -- add the gag entry to active list if it's a multiline gag
  if gag_def[ group ].endp then
    active_gag[ #active_gag + 1 ] = entry
    trigger.enable 'gag'
  end
end

local function remove_expired_gag( list, timeout )
  local i = 1
  while list[ i ] do -- check for
    if os.time() - list[ i ].add_time > timeout then
      table.remove( list, i )
    else
      i = i + 1
    end
  end
end

-- check if an endp pattern is matched
-- this function is called by OnPluginPartialLine so it's fired (one or more times) before any trigger will be fired on the line
function gag.check( text )
  if not next( pending_gag ) and not next( active_gag ) then return end
  remove_expired_gag( pending_gag, 1 )
  local i = 1
  while active_gag[ i ] do
    local entry = active_gag[ i ]
    local def = gag_def[ entry.group ]
    -- remove active gag that is pending stop
    if entry.is_pending_removal then
      table.remove( active_gag, i )
    -- stop active gag whose endp has matched
    elseif def.endp:match( text ) then
      if def.exclude_endp then
        table.remove( active_gag, i )
      else -- if exclude_endp is not set, then removal is delayed so that current line will fire the gag trigger and be omitted
        entry.is_pending_removal = true
        i = i + 1
      end
    else
      i = i + 1
    end
  end
  remove_expired_gag( active_gag, 2 )
  if not next( active_gag ) then trigger.disable 'gag' end
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

event.listen{ event = 'located', func = reset_excessive, persistent = true, id = 'gag.excessive' }

function gag.blackhole()
end

trigger.new{ name = 'gag', match = '.', func = gag.blackhole, sequence = 50, keep_eval = true, omit = true }

for group, t in pairs( gag_def ) do
  trigger.new{ name = 'gag_' .. group, match = t.startp or t.linep, func = gag.start, sequence = 50, keep_eval = true, omit = true }
end

for name, patt in pairs( always_gag_def ) do
  trigger.new{ name = 'gag_always_' .. name, match = patt, func = gag.blackhole, sequence = 50, omit = true, enabled = true }
end

for name, patt in pairs( excessive_gag_def ) do
  trigger.new{ name = 'gag_excessive_' .. name, group = 'gag_excessive', match = patt, func = gag.excessive, sequence = 50, enabled = true }
end


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return gag
