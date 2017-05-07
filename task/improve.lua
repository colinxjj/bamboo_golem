
local task = {}

--------------------------------------------------------------------------------
-- Improve skills, or raise max neili / jingli through dazuo / tuna
--[[----------------------------------------------------------------------------
Params:
skill = '碧海潮生功', 'all': the skill to improve
skill_target = 'full', 100: the target skill level
neili = 'full', 100: set to raise neili and specify the target neili value
jingli = 'full', 100: set to raise jingli and specify the target jingli value
----------------------------------------------------------------------------]]--

task.class = 'improve'

local skill_improver = require 'task.helper.skill_improver'

function task:get_id()
  local s = self.skill and ( 'improve skill %s to %s, ' ):format( self.skill, tostring( self.skill_target ) ) or 'improve '
  s = s .. ( self.neili and 'max neili to ' .. self.neili .. ', ' or '' )
  s = s .. ( self.jingli and 'max jingli to ' .. self.jingli .. ', ' or '' )
  s = string.gsub( s, ', $', '' )
  return s
end

local function has_reached_target( self, item )
  if not self[ item ] then return true end
  if item == 'skill' then
    local sk = player.skill[ self.skill ]
    local lvl = sk and sk.level or 0
    local tgt = self.skill_target == 'full' and player.level or self.skill_target
    return lvl >= tgt
  else
    local val = player[ item .. '_max' ]
    local tgt = self[ item ] == 'full' and player[ item .. '_limit' ] or self[ item ]
    return val >= tgt
  end
end

function task:_resume()
  -- update hp as needed
  if not self.has_updated_hp then
    self.has_updated_hp = true
    self:newsub{ class = 'get_info', hp = true }
    return
  end
  if not has_reached_target( self, 'skill' ) then -- improve skill
    -- get skill source
    if not self.current_source or not kungfu.is_valid_source( self.skill, self.current_source ) then self.current_source = kungfu.get_best_source( self.skill ) end
    -- task fails if no available source
    if not self.current_source then self:fail() return end
    -- handle the source
    self:handle_skill_source( self.current_source )
  elseif not has_reached_target( self, 'neili' ) or not has_reached_target( self, 'jingli' ) then -- raise neili and/or jingli
    self:raise_neili_jingli()
  else
    self:complete()
  end
end

function task:_complete()
  message.debug( '顺利完成提升任务：' .. self:get_id() )
end

function task:_fail()
  message.debug( '未能完成提升任务：' .. self:get_id() )
end

function task:handle_skill_source( source )
  if source.location then -- location based source
    local loc = map.get_current_location()[ 1 ]
    if loc.id ~= source.location then
      self:newsub{ class = 'go', to = source.location }
      return
    elseif source.npc and not room.has_object( source.npc ) then
      message.debug( ( '未能从来源“%s@%s”提升武功“%s”' ):format( source.npc, source.location, self.skill ) )
      kungfu.mark_invalid_source( source )
      self:resume()
      return
    end
  elseif source.item then -- item based source
    if not inventory.has_item( source.item ) then self:newsub{ class = 'get_item', item = source.item } return end
  end
  if source.item then
    self:read_book( source.item, source.cost )
  elseif source.handler then
    self:enable_trigger_group( 'skill_improver.' .. source.handler )
    skill_improver[ source.handler ]( self, source )
  elseif source.cmd then
    self:handle_cmd( source.cmd, source.cost )
  end
end

function task:handle_cmd( cmd, cost )
  -- send how many cmds?
  local min_count, count = math.huge
  for attr, cost in pairs( cost ) do
    count = player[ attr ] / cost
    min_count = count < min_count and count or min_count
  end
  min_count = min_count - 1
  count = min_count > 10 and 10 or math.floor( min_count )

  if count <= 1 then -- recover
    self:newsub{ class = 'recover', maximize_organic_recovery = true, jing = cost.jing and 'half', jingli = cost.jingli and 'half', qi = ( kungfu.is_dazuo_positive_loop() and has_recently_slept() or cost.qi ) and 'half', neili = cost.neili and 'half' or 'best_effort' }
  else -- send cmds
    local c = { complete_func = self.resume }
    for i = 1, count do c[ i ] = cmd end
    c[ #c + 1 ] = '#wa ' .. 30 * count
    self.has_updated_hp = false
    self:send( c )
  end
end

function task:read_book( book, cost )
  local it = item.get( book )
  local cmd = it.read.cmd or 'read ' .. it.id
  self:handle_cmd( cmd, cost )
end

function task:raise_neili_jingli()
  -- body...
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
