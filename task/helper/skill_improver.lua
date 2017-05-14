
local improver = {}

--------------------------------------------------------------------------------
-- Skill improver for skill improvement
--------------------------------------------------------------------------------

function improver:look_again()
  self:send{ 'l'; complete_func = self.resume }
end

-- ��������㳡: strike, parry, throwing
function improver:yz_tree( source )
  if room.has_object '��Ѳ��' then
		self:newsub{ class = 'kill_time', complete_func = improver.look_again } -- look again since this man just disappears without any prompt
	else
		self:handle_cmd( source.cmd, source.cost )
	end
end

-- ���ݳǾ���: strike, stick
function improver:fz_rock( source )
  if player.jingli < 150 then
    self:recover( source.cost )
  else
    self:handle_cmd( source.cmd, source.cost )
  end
end

-- ����ׯ���䳡, �һ������䳡: dodge, leg
function improver:thd_practice( source )
  -- TODO exert to raise intelligence
end


-- End of module
--------------------------------------------------------------------------------

return improver
