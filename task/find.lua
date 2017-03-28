
local task = {}

--------------------------------------------------------------------------------
-- Find an object / a person in the world
--[[----------------------------------------------------------------------------
Params:
object = '���': name of the object/person to find (required)
person = '���': an alias for the 'object' param (alias)
item = 'С��֦': an alias for the 'object' param (alias)
at = '�ƺ�����Ĺ��': long name or id of the location of the object, if not specified, predefined npc/item data will be used to locate it (optional)
range = 2: the range of steps in number that the object might wander off the specified / predefined location (optional, default: 0)
is_not_unique = true: if true, the object will only be deemed as found when they're seen within the speicied range from the location (optional, default: false)
action = 'ask %id about sth': a commmand to send when the object is found, %id will be replaced by the id of the object (optional)
----------------------------------------------------------------------------]]--

task.class = 'find'

function task:get_id()
  local id = 'find ' .. self.object
  id = self.at and ( id .. ' at ' .. self.at ) or id
  id = self.range and ( id .. ' within range of ' .. self.range ) or id
  return id
end

function task:_resume()
  self.object = self.object or self.person or self.item

  if not self.at then
    local object = npc[ self.object ] or item.get( self.object )
    if not object then
      message.warning( 'δ�ҵ���' .. self.object '����Ӧ�� NPC ����Ʒ' )
      self:fail()
      return
    end
    self.at, self.range, self.is_not_unique = object.location, object.range, object.is_not_unique
  end

  message.verbose( '��ʼѰ��' .. self.object )

  self:listen{ event = 'room_object', id = 'task.find', func = task.check, persistent = true }

  self:newweaksub{ class = 'go', to = self.at, range = self.range, complete_func = self.last_check }
end

function task:_complete()
  message.verbose( '˳���ҵ�' .. self.object )
end

function task:_fail()
  message.verbose( 'δ���ҵ�' .. self.object )
end

function task:check( obj )
  if obj.name ~= self.object then return end
  if not self.is_not_unique then self:check_for_action( obj.object ); return end

  for _, loc in pairs( map.get_current_location() ) do
    if string.find( loc.id, self.at ) then self:check_for_action( obj.object ); return end
  end
end

function task:check_for_action( obj )
  if self.is_found then return end
  self.is_found = true
  if self.action then
    local action = string.gsub( self.action, '%%id', obj.id )
    self:send{ action; complete_func = self.complete }
  else
    self:complete()
  end
end

function task:last_check()
  if room.has_object( self.object ) then
    self:check_for_action( room.get_object( self.object) )
  else
    self:fail()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
