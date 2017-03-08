
local getter = {}

--------------------------------------------------------------------------------
-- Flag getters for acquiring various temp player flags
--------------------------------------------------------------------------------

getter.data = {}

-- ask 裘千丈 about 闹鬼
function getter:tz_ghost()
	self:newsub{ class = 'find', object = '裘千丈', action = 'ask %id about 闹鬼' }
end
function getter:tz_ghost_succeed()
  self:disable_trigger_group 'flag_getter.tz_ghost'
  player.temp_flag.tz_ghost = true
end
trigger.new{ name = 'tz_ghost_succeed', group = 'flag_getter.tz_ghost', match = '^听一些帮众说，经常听见无名峰上的坟墓中，传出响声！嘿嘿！一定有什么蹊跷在里面！$', func = getter.tz_ghost_succeed, penetrate = 'waiting' }

-- ask 上官剑南 about 宝物
function getter:tz_treasure()
  self:newsub{ class = 'find', object = '上官剑南', action = 'ask %id about 宝物' }
end
function getter:tz_treasure_succeed()
  self:disable_trigger_group 'flag_getter.tz_treasure'
  player.temp_flag.tz_treasure = true
end
trigger.new{ name = 'tz_treasure_succeed', group = 'flag_getter.tz_treasure', match = '^宝物在第二指节的洞穴里。$', func = getter.tz_treasure_succeed, penetrate = 'waiting' }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return getter
