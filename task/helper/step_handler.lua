
local handler = {}

--------------------------------------------------------------------------------
-- Special step handlers for walking and traversing
--------------------------------------------------------------------------------

-- a table to store persistent path variables
handler.data = {}

--------------------------------------------------------------------------------
-- Special step handlers

-- �ȴ�
function handler:wait()
end

-- check if the player can fly across rivers
local function is_able_to_fly( cmd )
	if cmd == 'duhe' then return player.enable.dodge and player.enable.dodge.level >= 250 and player.neili_max >= 3000
	elseif cmd == 'dujiang' then return player.enable.dodge and player.enable.dodge.level >= 270 and player.neili_max >= 3500
	elseif cmd == 'zong' then return player.enable.dodge and player.enable.dodge.level >= 300 and player.neili_max >= 4000
	end
end

-- ����
-- TODO make sure have silver
local cj_layout = {
	['��������'] = { w = '���ݳǳ�������#W', c = '���ݳǳ�������#C', e = '���ݳǳ�������#E' },
	['�����ϰ�'] = { w = '���ݳǳ����ϰ�#W', c = '���ݳǳ����ϰ�#C', e = '���ݳǳ����ϰ�#E' },
}
function handler:cross_cj( t )
	t = self.step
	t.loc = t.loc or cj_layout[ t.from.name ]
	t.curr_loc = map.get_current_location()[ 1 ].id
	if is_able_to_fly( t.cmd ) then
		-- in order to fly first go to the center
		if t.curr_loc ~= t.loc.c then
			local c = t.curr_loc == t.loc.w and 'e'
						 or t.curr_loc == t.loc.e and 'w'
		  self:listen{ event = 'located', func = handler.cross_cj, id = 'step_handler.cross_cj', sequence = 99, keep_eval = false }
			self:send{ c }
			return
		end
		-- then hand over to fly handler
		handler.fly( self )
	else -- try to embark across all 3 positions
		if room.get().exit.enter then self:send{ 'enter' } return end -- if boat is here, enter it
		t.to_yell = t.to_yell or { [ t.loc.w ] = true, [ t.loc.c ] = true, [ t.loc.e ] = true }
		if t.to_yell[ t.curr_loc ] then -- yell at current location
			self:send{ 'yell boat' }
			t.to_yell[ t.curr_loc ] = nil
			self:newweaksub{ class = 'killtime', duration = 1, complete_func = handler.cross_cj }
		elseif next( t.to_yell ) then -- go to next location and yell
			local c = t.curr_loc == t.loc.w and 'e'
						 or t.curr_loc == t.loc.e and 'w'
						 or t.to_yell[ t.loc.e ] and 'e'
						 or 'w'
			self:listen{ event = 'located', func = handler.cross_cj, id = 'step_handler.cross_cj', sequence = 99, keep_eval = false }
 			self:send{ c }
		else -- kill time and do another round of yell
			t.to_yell = nil
			self:newweaksub{ class = 'killtime', complete_func = handler.cross_cj }
		end
	end
end

-- �ƺӡ���ľ�¡����׽�
-- TODO make sure have silver
local yell_tbl = {
	['��ľ������ƺ'] = 'yell xiaya',
	['��ľ���¶�'] = 'yell shangya',
}
function handler:fly_across( t )
	t.yell_cmd = yell_tbl[ t.to.id ]
	if not is_able_to_fly( t.cmd ) then -- can't fly, hand over to embark handler
		t.cmd = t.yell_cmd
		handler.embark( self )
	else handler.fly( self ) end -- hand over to fly handler
end

-- ��Խ���ӡ��������ƺӡ���ľ�¡����׽��ȡ�
function handler:fly()
	-- since this handler is always called by other handlers, it needs to take care of trigger enabling itself
	self:enable_trigger_group 'step_handler.fly'
	if room.get().exit.enter then
		self:newsub{ class = 'killtime', complete_func = handler.fly }
	else
		self:send{ self.step.yell_cmd or 'yell boat', self.step.cmd }
	end
end
function handler:fly_wait()
	self:newsub{ class = 'killtime', complete_func = handler.fly }
end
function handler:fly_done()
	self:disable_trigger_group 'step_handler.fly'
	addbusy( 6 )
end
trigger.new{ name = 'fly_wait', group = 'step_handler.fly', match = '^(> )*(�ͱ�ʵ��̫����|����̫����|����̫����|����¨������ȥ��|�д�����)', func = handler.fly_wait }
trigger.new{ name = 'fly_done', group = 'step_handler.fly', match = '^(> )*����(���жɴ�|�ƺ��жɴ�|���жɴ�|�¼���¨)������һ��', func = handler.fly_done }

-- �����ɴ����ƺӡ���������ˮ����ľ������̲����ѩɽ���̵�
-- TODO make sure have silver
function handler:embark()
	if room.get().exit.enter then self:send{ 'enter' } return end
	self:send{ self.step.cmd ~= 'enter' and self.step.cmd or 'yell boat' }
	self:newweaksub{ class = 'killtime', complete_func = handler.embark }
end

-- �´����ɴ�����¨���ٿ��
function handler:disembark()
	self:listen{ event = 'ferry_arrived', func = handler.getout, id = 'disembark' }
	self:newweaksub{ class = 'killtime', complete_func = handler.disembark }
end
function handler:getout()
	self:send{ 'out' }
end

-- ����Ľ��
-- TODO make sure have silver
function handler:mr_embark( t )
	self:send{ t.cmd }
end

-- ����ɽ��ɽС·
function handler:emei_move_stone( name )
	if name == 'emei_move_stone_succeed' then self:send{ 'nd' }
	else self:send{ 'move stone' } end
end
trigger.new{ name = 'emei_move_stone_fail', group = 'step_handler.emei_move_stone', match = '^(> )*��ʹ���˳��̵�������Ҳû�Ὺ��ʯͷ��', func = handler.emei_move_stone }
trigger.new{ name = 'emei_move_stone_succeed', group = 'step_handler.emei_move_stone', match = '^(> )*��˫��Ͼ����Ὺ�˴�ʯͷ��', func = handler.emei_move_stone }

-- ��ľ��ʯ��
hmy_shimen_tbl = {
	'�����ĳ���£�һͳ����', '����ǧ�����أ�һͳ����', '��������Ϊ������������', '������ּӢ���������Ų�',
	'�����������£��츣����', '����ս�޲�ʤ�����޲���', '��������ĳ���¡�����Ӣ��', '��������ʥ�̣��󱻲���',
}
function handler:hmy_shimen( name )
	if room.get().exit.wu then self:send{ 'wu' } return end
	local t = self.step
	t.count = t.count or 0
	if name == 'hmy_shimen_succeed' then
		self:send{ 'wu' }
	else
		t.count = t.count < 8 and t.count + 1 or 1
		local c = 'whisper jia ' .. hmy_shimen_tbl[ t.count ]
		self:send{ c }
	end
end
trigger.new{ name = 'hmy_shimen_fail', group = 'step_handler.hmy_shimen', match = '^�ֲ�����üͷ������û��˵����$', func = handler.hmy_shimen }
trigger.new{ name = 'hmy_shimen_succeed', group = 'step_handler.hmy_shimen', match = '^ֻ���ֲ�˵�������š����Ǳ����ֵܰɣ�������ɡ�$', func = handler.hmy_shimen }

-- ��ɽ����ʥɮ��
local sl_fota_tbl = {
	['��ɽ������ɫ̨'] = 'say ���մ�ϲ����ȴΣ����;sheshen',
	['��ɽ����������'] = 'fushi pai',
	['��ɽ����������̨'] = 'say ���ò���ɢ������ʵ�಻;shenru',
	['��ɽ���ֿ��ƺ'] = 'say ����������;taotuo',
	['��ɽ���ֻ���ʥ��'] = 'canchan zuo',
}
function handler:sl_fota()
	local t = self.step
	if t.to.id ~= '��ɽ����������' and t.to.id ~= '��ɽ���ֻ���ʥ��' then
		self:send{ sl_fota_tbl[ t.to.id ] }
	elseif t.is_successful then
		local c = t.to.id == '��ɽ����������' and 'chuzhang pai' or 'enter'
		self:send{ c }
	else
		self:listen{ event = 'prompt', func = handler.sl_fota, id = 'step_handler.sl_fota' }
		self:send{ sl_fota_tbl[ t.to.id ] }
	end
end
function handler:step_cmd_succeed()
	self.step.is_successful = true
end
trigger.new{ name = 'sl_fota_fushi', group = 'step_handler.sl_fota', match = '^��ͻȻ��һ�ֳ��Ƶĳ嶯������һ�ƻ�����$', func = handler.step_cmd_succeed }
trigger.new{ name = 'sl_fota_canchan', group = 'step_handler.sl_fota', match = '^��������У��о���ʦ���´���һ��С�š�$', func = handler.step_cmd_succeed }

-- ����ׯС��
function handler:gyz_river( t )
	if room.has_object{ name = '����', id = 'lao zhe' } then
		self:send{ t.cmd }
	else -- leave and reenter to reset the room
		local room = room.get()
		self:send{ room.exit.w and 'w' or 'e' }
	end
end

-- ţ�Ҵ�С��������
-- TODO prepare money
-- TODO handle special price under age 16
function handler:thd_onboard()
	local loc = map.get_current_location()[ 1 ]
	if not handler.data.thd_sail then
		if loc.id ~= 'ţ�Ҵ�����' then
			self:newsub{ class = 'go', to = 'ţ�Ҵ�����', complete_func = handler.thd_onboard }
		else
			self:send{ 'open xiang' }
		end
	elseif loc.id ~= 'ţ�Ҵ�С���' then
		self:newsub{ class = 'go', to = 'ţ�Ҵ�С���', complete_func = handler.thd_onboard }
	else
		self:send{ 'ask lao da about �һ���;ask lao da about ��Ǯ;give 3 gold to lao da' }
	end
end
function handler:thd_onboard_got_cord( _, t )
	handler.data.thd_sail = { x = tonumber( t[ 2 ] ), y = tonumber( t[ 3 ] ) }
	handler.thd_onboard( self )
end
trigger.new{ name = 'thd_onboard_got_cord', group = 'step_handler.thd_onboard', match = '^(> )*���þ��������ӣ��������澹�����������Ĵ����ܱ��������鱦�����棬��һ�ŷ��Ƶĺ�ͼ���м��һ���ط��ôֱʻ��˸�ԲȦ���Ա����ʲݵ��ּ�д��\\((\\d+),(\\d+)\\)��������$', func = handler.thd_onboard_got_cord }

-- �������һ���
function handler:thd_sail( t )
	t.x, t.y = 1, 1
	self:send{ 'turn e' }
end
function handler:thd_sail_progress( _, tbl )
	local t = self.step
	local dir = tbl[ 2 ]
	t.x = dir == '��' and t.x - 1 or dir == '��' and t.x + 1 or t.x
	t.y = dir == '��' and t.y - 1 or dir == '��' and t.y + 1 or t.y
	if not handler.data.thd_sail then
		handler.data.thd_sail = { x = 0, y = 0 }
		self:send{ 'ask gong about location' }
		return
 	end
	local dest = handler.data.thd_sail
	if dest.x > t.x then
		if dir ~= '��' then self:send{ 'turn e' } end
	elseif dest.x < t.x then
		if dir ~= '��' then self:send{ 'turn w' } end
	elseif dest.y > t.y then
		if dir ~= '��' then self:send{ 'turn s' } end
	elseif dest.y < t.y then
		if dir ~= '��' then self:send{ 'turn n' } end
	end
end
function handler:thd_sail_cord( _, t )
	self.step.x = tonumber( t[ 1 ] )
	self.step.y = tonumber( t[ 2 ] )
end
trigger.new{ name = 'thd_sail_progress', group = 'step_handler.thd_sail', match = '^(> )*С��������(\\S+)��ǰ����$', func = handler.thd_sail_progress }
trigger.new{ name = 'thd_sail_cord', group = 'step_handler.thd_sail', match = '^�������˿���ͼ��˵�����������ڵ�λ����\\((\\d+)\\,(\\d+)\\)��$', func = handler.thd_sail_cord }

-- �����СϪ
function handler:jqg_river( t )
	t = self.step
	if player.wielded then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = handler.jqg_river }
	elseif t.from.id == '�����СϪ��' then
		local room = room.get()
		if not room.desc then self:send{ 'l' } return end
		if not string.find( room.desc, '���ذ��ػ����Σ�����Ϫ�к�������С�ۡ�' ) then
			self:newsub{ class = 'killtime', complete_func = handler.look_again }
		else
			self:send{ t.cmd }
		end
	else
		self:send{ t.cmd }
	end
end

-- ����ȴ���
function handler:jqg_enter( t )
	if player.temp_flag.gsz_agree then
		self:send{ 'xian hua;zuan dao' }
	elseif room.has_object '����ֹ' then
		player.temp_flag.gsz_agree = true -- only need to ask once per session
		self:send{ t.cmd }
	else -- wait 1 min for respawn
		self:newsub{ class = 'killtime', duration = 60, can_move = true, complete_func = handler.look_again }
	end
end
function handler:look_again()
	self:send{ 'l' }
end

-- ���������̶
-- TODO kill ���� first and then ta corpse

-- ����ȹȵ�ˮ̶
-- TODO ensure encumbrance > 50% for qian down, < 30% for qian up, and < 40% for qian zuoshang

-- from ����ɽʯ�� to ����ɽʯ��#3D
-- TODO make sure have fire

-- ��ɽ���ɽ�
function handler:ts_bzjian()
	if not inventory.has_item 'sharp_weapon' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = 'sharp_weapon' }
	elseif not player.wielded or not item.is_type( player.wielded.name, 'sharp_weapon' ) then
		self:newsub{ class = 'manage_inventory', action = 'wield', item = 'sharp_weapon', complete_func = handler.ts_bzjian }
	else
		self:send{ self.step.cmd }
	end
end

-- ������
-- TODO ask lingpai instead of steal for sld id
-- from ��̲ to Сľ��
function handler:sld_enter()
	if room.has_object 'ľ��' then
		self:send{ 'zuo mufa' }
	elseif ( inventory.has_item '������' or room.has_object '������' ) and room.has_object '��ľͷ' then
		self:send{ 'bang mu tou;#wa 1000;zuo mufa' }
	elseif not inventory.has_item '������' and not room.has_object '������' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = '������' }
	elseif not inventory.has_item 'sharp_weapon' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = 'sharp_weapon' }
	elseif not player.wielded or not item.is_type( player.wielded.name, 'sharp_weapon' ) then
		self:newsub{ class = 'manage_inventory', action = 'wield', item = 'sharp_weapon', complete_func = handler.sld_enter }
	else
		self:send{ 'chop tree' }
	end
end
function handler:sld_chop()
	room.add_object '��ľͷ'
	handler.sld_enter( self )
end
trigger.new{ name = 'sld_chop', group = 'step_handler.sld_enter', match = '^ֻ�������ꡱһ������Χ�ļ��ô����ѱ�����\\S+���ɼ��ء�$', func = handler.sld_chop }
-- from Сľ�� to �ɿ�
function handler:sld_mufa()
	self:send{ 'hua mufa' }
end
trigger.new{ name = 'sld_mufa', group = 'step_handler.sld_mufa', match = '^(> )*Сľ��˳�ź��磬һֱ��Ʈȥ��$', func = handler.sld_mufa }
-- from �ɿ� to С����
function handler:sld_leave()
	local loc = map.get_current_location()[ 1 ]
	if inventory.has_item 'ͨ������' then
		if loc.id == '�������ɿ�' then
			self:send{ 'give ling pai to chuan fu' }
			inventory.remove_item 'ͨ������'
		else
			self:newsub{ class = 'go', to = '�������ɿ�', complete_func = handler.sld_leave }
		end
	elseif loc.id ~= '������½������' then
		self:newsub{ class = 'go', to = '������½������', complete_func = handler.sld_leave }
	else
		local c = player.party == '������' and 'ask lu gaoxuan about ͨ������' or 'steal ͨ������'
		self:send{ c }
	end
end
function handler:sld_got_lingpai()
	inventory.add_item{ name = 'ͨ������', id = 'ling pai' }
	handler.sld_leave( self )
end
trigger.new{ name = 'sld_got_lingpai', group = 'step_handler.sld_leave', match = '^(> )*(��ɹ���͵���˿�ͨ������!|��Ȼ��Ҫ�������Ҿ͸�������ưɡ�)$', func = handler.sld_got_lingpai }
-- pre-steal lingpai
function handler:sld_preget_lingpai( t )
	local loc = map.get_current_location()[ 1 ]
	if not inventory.has_item 'ͨ������' and self.to.area ~= '������' then
		if loc.id ~= '������½������' then
			self:newsub{ class = 'go', to = '������½������', complete_func = handler.sld_preget_lingpai }
		else
			self:enable_trigger 'sld_got_lingpai'
			local c = player.party == '������' and 'ask lu gaoxuan about ͨ������' or 'steal ͨ������'
			self:send{ c }
		end
	else
		self:send{ t.cmd }
	end
end

-- �������߿�
-- from ɽ�� to �߿�
function handler:sld_sheku()
	if self.step.is_successful then
		self:send{ 'climb ɽ��' }
	else
		self:listen{ event = 'prompt', func = handler.sld_sheku, id = 'step_handler.sld_sheku' }
		self:send{ 'kan �µ�' }
	end
end
trigger.new{ name = 'sld_sheku_look', group = 'step_handler.sld_sheku', match = '^(> )*�µ������������У���һ��ɽ���ƺ�ͦ�⻬������������\\(climb\\)��ȥ��$', func = handler.step_cmd_succeed }
-- from �߿� to ����
function handler:sld_sheku_leave()
	if not self.step.is_successful then
		self:listen{ event = 'prompt', func = handler.sld_sheku_leave, id = 'step_handler.sld_sheku_leave' }
		self:send{ 'go south' }
	end
end
trigger.new{ name = 'sld_sheku_leave', group = 'step_handler.sld_sheku_leave', match = '^(> )*���� - ', sequence = 90, keep_eval = true, func = handler.step_cmd_succeed }

-- ����ɽʯ�ң��Ϲٽ��ϣ�
function handler:pre_ask_ghost( t )
	if self.class == 'go' and self.to.id == '����ɽʯ��' and not player.temp_flag.tz_ghost then
		self:enable_trigger 'tz_ask_ghost'
		self:newsub{ class = 'find', object = '��ǧ��', action = 'ask %id about �ֹ�' }
	else
		self:send{ t.cmd }
	end
end
function handler:tz_cave( t )
	if player.temp_flag.tz_ghost then
		local loc = map.get_current_location()[ 1 ]
		if loc.id ~= '����ɽ������' then
			self:newsub{ class = 'go', to = '����ɽ������', complete_func = handler.tz_cave }
		else
			self:send{ 'move bei', t.cmd }
		end
	else
		self:newsub{ class = 'find', object = '��ǧ��', action = 'ask %id about �ֹ�' }
	end
end
function handler:tz_ask_ghost()
	player.temp_flag.tz_ghost = true
end
trigger.new{ name = 'tz_ask_ghost', group = 'step_handler.tz_cave', match = '^��һЩ����˵�����������������ϵķ�Ĺ�У������������ٺ٣�һ����ʲô���������棡$', func = handler.tz_ask_ghost, penetrate = 'waiting' }

-- from ������Ժ to ��������

-- ����ʹ���

-- ��������
-- TODO ������ɲ��������£���ô��8�㵽��5��֮����Ҫɱ��npc

-- ����ɽ���츣��
-- TODO hide �����澭 before leave

-- ��������
-- TODO make sure wielded axe

-- from ��ɽɽ��#SE to ��ɽ������
-- TODO get sheng zi first and encumbrance < 50%

-- ��ɽ˼���¶���
-- TODO get fire and sword

-- from ����ɽ��ɽС· to ����ɽ��ľ��
-- TODO prepare sharp weapon

-- �䵱��ɽé��

-- �䵱��ɽ�ŵ�
function handler:wdhs_gudao()
	if not inventory.has_item 'ë̺#WD' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = 'ë̺#WD', complete_func = handler.wdhs_gudao }
	elseif not inventory.has_item 'ҩ��' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = 'ҩ��', complete_func = handler.wdhs_gudao }
	elseif not map.is_current_location '�䵱ɽɽ·#2' then
		self:newsub{ class = 'go', to = '�䵱ɽɽ·#2', complete_func = handler.wdhs_gudao }
	elseif room.has_object '��ҩ����' then
		self:send{ 'give yao chu to caiyao daozhang' }
		inventory.add_item '����#WD'
	else
		self:newsub{ class = 'killtime', duration = 60, can_move = true, complete_func = handler.look_again }
	end
end

-- �䵱��ɽ�����
function handler:wdhs_husun()
	if not inventory.has_item '����#WD' then self:fail() return end
	self:send{ 'tie song;climb down' }
end

-- �䵱��ɽɽ��
function handler:wdhs_shanya()
	self.is_step_need_desc = true
	self:send{ 'pa down' }
end
function handler:wdhs_jump( t )
	if not inventory.has_item 'ë̺#WD' then self:fail() return end
	inventory.remove_item( t.to.id == '�䵱��ɽ������' and '����#WD' or 'ë̺#WD' )
	self:send{ 'jump down' }
end

-- �䵱��ɽˮ̶
function handler:wdhs_shuitan()
	if not inventory.has_item '����ʯ' then self:fail() return end
	self:send{ 'dive down' }
end

-- ���������ɽ��
function handler:xy_cave()
	if not inventory.has_item '����' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = '����', complete_func = handler.xy_cave }
	elseif not inventory.has_item 'С��֦' then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = 'С��֦', complete_func = handler.xy_cave }
	elseif not map.is_current_location '���������ɽ��' then
		self:newsub{ class = 'go', to = '���������ɽ��', complete_func = handler.xy_cave }
	else
		self:send{ 'dian shuzhi;l qingtai;#wa 1500;clean qingtai;l zi;l mu;#wa 1500;kneel mu;#wa 1500;zuan dong;#wa 1500' }
		inventory.remove_item 'С��֦'
	end
end

-- ���������ͱ�
function handler:xyjw_cliff()
	if self.step.is_successful then
		self:send{ '#wa 3500;mo qingtai;cuan up;#wa 3500' }
	else
		self:listen{ event = 'prompt', func = handler.xyjw_cliff, id = 'step_handler.xyjw_cliff' }
		self:send{ 'l shibi' }
	end
end
trigger.new{ name = 'xyjw_cliff_look', group = 'step_handler.xyjw_cliff', match = '^(> )*����������һ��ͻ���ͱ���ÿ�����߱�����һ����̦����ʮ�Ա�ֱ���ж��ϡ�$', func = handler.step_cmd_succeed }

-- ����ɽϴ���


-- ��ɽ����ӭ��ͤ���������⽣ڣ
function handler:unwield_weapon()
	if player.wielded then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = handler.unwield_weapon }
	else
		self:send{ self.step.cmd }
	end
end

-- ����ɽ��Ȼ��Ѩ

-- ���޺�ɽ��

-- ��ѩɽ����

--------------------------------------------------------------------------------
-- Maze handlers

-- ��ɽ�������֡���ɽ�������֡���ɽ���������֡����ݳǳ��ȡ�������֡��һ��������֡�����ɽ�����֡������ܵ������ݳ������֡����޺��Ͻ�ɳĮ
local simple_path_pos_tbl = { ['��ɽ��������#N'] = 10, ['��ɽ����������#2'] = 8, ['����ɽ������#2'] = 4 }
	function handler:simple_path_set_pos( t )
		handler.data[ t.to.id ] = simple_path_pos_tbl[ t.from.id ] or 0
		self:send{ t.cmd }
	end
local simple_path_tbl = {
	['��ɽ��������#S'] = { 'se', 's', 'se', 'ne', 'e', 'sw', 'e', 'n', 'se'; is_reverse = true },
	['��ɽ��������#N'] = { 'n', 'nw', 'sw', 'w', 'ne', 'w', 's', 'nw', 'sw'; has_reverse = true },
	['��ɽ����������#1'] = { 'w', 'e', 'n', 's', 'e', 'n', 'e'; is_reverse = true },
	['��ɽ����������#2'] = { 'e', 's', 'e', 'n', 'n', 'e', 'w'; has_reverse = true },
	['����ɽ������#1'] = { 'w', 's', 'e'; is_reverse = true },
	['����ɽ������#2'] = { 'n', 'w', 'n'; has_reverse = true },

	['��ɽ��������#4'] = { 'n', 's', 'w', 'e', 'w', 'e', 'e', 's', 'w', 'n' },
	['���ݳǳ���#E'] = { 'n', 's', 'e' },
	['�������#E'] = { 'e', 'n', 'n' },
	['�һ�������ͤ'] = { 'n', 's', 'w', 'e', 'n', 'n', 's', 'e', 'w', 'n', 's' }, -- TODO split exit room?
	['�һ����ݵ�'] = { 's', 's', 'w', 'n', 's' }, -- TODO split exit room?
	['�����ص�����'] = { 'w', 's', 'e', 's', 'w', 'n' }, -- TODO split exit room?
	['ؤ��������#2'] = { 'e', 'n', 'w', 'n', 'e', 'w', 'n' },
	['���޺��Ͻ�ɳĮ#2'] = { 'sw', 'se' },
}
function handler:simple_path( t )
	t.path = t.path or simple_path_tbl[ t.to.id ]
	local pos = handler.data[ t.from.id ]
	if pos then
		pos = t.path.is_reverse and pos - 1 or pos + 1
	  local cmd = t.path[ pos ]
		-- if this isn't the last step, tell self.check_step that we're not yet out of the maze
		if ( t.path.is_reverse and pos == 1 ) or ( not t.path.is_reverse and pos == #t.path ) then
			self.is_still_in_step, handler.data[ t.from.id ] = nil
		else
			handler.data[ t.from.id ] = pos
			self.is_still_in_step = true
		end
	  self:send{ cmd }
	else -- handle situation where we don't have pos info (resort to random walk)
		self:send{ t.path[ math.random( #t.path ) ] }
	end
end

-- ����Ƕ�ɽ��С·�������ǳ��֡������ǰ����֡����޺������ݳ�ɳĮ�����޺���ɳĮ���ؽ���ԭ��Ե������ׯ����С·�����ݳ����֡���ɽ�˵�
function handler:go_straight( t )
	self:send{ t.cmd }
end

-- �����������֡�����ɽ���֡�Ľ�ݵ����Թ�
function handler:reset_data( t )
	handler.data[ t.to.id ] = nil
	self:send{ t.cmd }
end
local cord_tbl = {
	['������С����'] = { x = 6, y = 7 }, -- ��Ҫ���������������20
	['����������Ժ'] = { x = -5, y = 6 },
	['������ʯ��·#NE'] = { x = 0, y = -50 },
	['����Ľ�ݿⷿ'] = { x = 6, y = 7 }, -- ��Ҫ���������������20
	['����Ľ������'] = { x = -5, y = 6 },
	['����Ľ�ݵص�#3'] = { x = 0, y = -50 },
	['����ɽ��ľ��'] = { x = 6, y = 4 },
	['����ɽ����'] = { x = -6, y = 4 },
}
function handler:cord( t )
	t.dest = t.dest or cord_tbl[ t.to.id ]
	handler.data[ t.from.id ] = handler.data[ t.from.id ] or {}
	local d = handler.data[ t.from.id ]
	d.x, d.y = d.x or 0, d.y or 0
	if t.dest.y > d.y then self:send{ 'n' }; d.y = d.y + 1 return end
	if t.dest.y < d.y then self:send{ 's' }; d.y = d.y - 1 return end
	-- handle x only after y is done, to avoid premature exit in ����ɽ����
	if t.dest.x > d.x then self:send{ 'e' }; d.x = d.x + 1 return end
	if t.dest.x < d.x then self:send{ 'w' }; d.x = d.x - 1 return end
	self:send{ 'e' }; d.x = d.x + 1
end

-- from ������������#2 to ������������#M������ɽ�ŵ���
local alt_step_tbl = {
	['����ɽ�ŵ���#2'] = { 'n', 's' },
	['������������#M'] = { 'n', 'w' },
}
function handler:alternate_step( t )
	self.is_step_need_desc = true -- with this approach we can get room desc before step_ok is checked, but when the handler is called for the 1st time, it won't try to get room desc for the current room
	handler.data[ t.to.id ] = nil -- a workaround to reset cord data for ������������#M
	local step = alt_step_tbl[ t.to.id ]
	t.cmd = t.cmd == step[ 1 ] and step[ 2 ] or step[ 1 ]
	self:send{ t.cmd }
end

-- �ؽ����ڡ�����ɽС����
local twisted_cord_tbl = {
	['����ɽ����ɽ'] = { x = 6, y = -5 },
	['�ؽ���Ҷ��#M'] = { x = 0, y = -12 },
	['�ؽ�����'] = { x = 0, y = 11 },
	['����ɽ��ɼ��#1'] = { x = 6, y = -5, z = 'n' },
	['����ɽ���϶���'] = { x = 6, y = 5, z = 's' },
	['����ɽ���'] = { x = -6, y = -5, z = 'e' },
	['����ɽ��ʮ����#3'] = { x = -6, y = 5, z = 'w' },
}
function handler:twisted_cord( t )
	t.dest = t.dest or twisted_cord_tbl[ t.to.id ]
	handler.data[ t.from.id ] = handler.data[ t.from.id ] or {}
	handler.data[ t.to.id ] = nil -- a workaround to reset data for �ؽ���Ҷ��#M
	local d = handler.data[ t.from.id ]
	d.x, d.y = d.x or 0, d.y or 0
	if t.dest.x > d.x then self:send{ 'n' }; d.x = d.x + 1 return end
	if t.dest.x < d.x then self:send{ 'e' }; d.x = d.x - 1 return end
	if t.dest.y > d.y then self:send{ 's' }; d.y = d.y + 1 return end
	if t.dest.y < d.y then self:send{ 'w' }; d.y = d.y - 1 return end
	if t.dest.z then self:send{ t.dest.z } return end
end

-- �ؽ���Ҷ�֡��ؽ����ڣ��ؽ����޷��򣩡�����ɽ��ľ�ԡ�����ɽʯ��
local fixed_step_tbl = {
	['�ؽ���Ҷ��#E'] = { 'n:10', 's:10', 'e:10', 'w:10' },
	['�ؽ��ؽ�����'] = { 'n:11', 'w:7', 's:7', 'e:7', 'n:7' },
	['����ɽʯ��#2D'] = { 'n:6', 'w:6', 's:6', 'e:6' },
	['����ɽ��ľ��#2'] = { 'ed:4', 'sw:1', 'ne:5', 'ne:5', 'ne:5', 'ne:5', 'ne:5' },
}
local patt = lpeg.C( lpeg.R 'az'^1 ) * ':' * ( lpeg.R'09'^1 / tonumber )
function handler:fixed_step( t )
	handler.data[ t.from.id ] = handler.data[ t.from.id ] or {}
	local d = handler.data[ t.from.id ]
	d.step, d.phase = d.step and d.step + 1 or 1, d.phase or 1
	t.path = t.path or fixed_step_tbl[ t.to.id ]
	if d.phase > #t.path then self:fail() end
	local c, n = patt:match( t.path[ d.phase ] )
	if d.step > n then
		d.phase, d.step = d.phase + 1, 0
		self:send{ 'yun jingli' } -- TODO a temp workaround to avoid dying in ����ɽ��ľ��
		self:step_handler( t )
	else
		self:send{ c }
	end
end

-- ÷ׯ÷��
function handler:plum_entry( t )
	handler.data.plum = { entry_point = t.from.id }
	self:send{ t.cmd }
end
function handler:plum( t )
	handler.data.plum = handler.data.plum or {}
	local list = handler.data.plum
	t.forward = list.entry_point ~= t.to.id and ( t.forward == nil and true or t.forward ) or false
	if t.forward and not room.get().desc then self:send{ 'l' } return end
	if t.forward then table.insert( list, room.get().exit ) end
	local node, revdir = list[ #list ], DIR_REVERSE[ t.cmd ]
	node[ revdir ] = node[ revdir ] and 0 or nil
	for dir, v in pairs( node ) do
		if v ~= 0 and v ~= nil then t.cmd, t.forward = dir, true; break end
		if v ~= nil then t.cmd, t.forward = dir, false end
	end
	node[ t.cmd ] = nil
	if not next( node ) then table.remove( list ) end
	self:send{ t.cmd }
end

-- ������������
local xy_shulin_path = { 'n', 'e', 'n', 'e', 'w', 's', 'n', 's', 's', 'n' }
function handler:xy_shulin( t )
	local room, pos = room.get(), handler.data[ t.from.id ]
	if not room.desc and not pos then self:send{ 'l' } return end
	pos = ( room.exit.s == 'ɽ·' and 1 )
		 or ( room.exit.n == 'ɽ·' and 8 )
		 or ( pos and pos < 10 and pos + 1 )
		 or ( pos and 1 )
	handler.data[ t.from.id ] = pos
	self:send{ ( pos == 1 and t.to.id == '��������ɽ·#1' and 's' )
					or ( pos == 8 and t.to.id == '��������ɽ·#2' and 'n' )
					or ( pos and xy_shulin_path[ pos ] )
					or xy_shulin_path[ math.random( 10 ) ] }
end

-- ���������
local jqg_zhulin_path = { 'n', 'w', 's', 'e', 'w' }
function handler:jqg_zhulin( t )
	local room, pos = room.get(), handler.data[ t.from.id ]
	pos = ( room.exit.su and 1 )
				or ( pos and pos < 5 and pos + 1 )
				or ( room.exit.wd and nil )
	handler.data[ t.from.id ] = pos
	self:send{ ( room.exit.su and t.to.id == '�����ɽ��ƽ��' and 'su' )
					or ( room.exit.wd and t.to.id == '�����ˮ��' and 'wd' )
					or ( pos and jqg_zhulin_path[ pos ] )
					or jqg_zhulin_path[ math.random( 4 ) ] }
end

-- from ������ɼ��#9 to X���ţ���������
function handler:look_self_dir( t )
	if not room.get().desc then self:send{ 'l' } return end
	for dir, roomname in pairs( room.get().exit ) do
		if roomname == t.to.name then self:send{ dir } return end
	end
end

-- ������ɼ�֣���ɽ�����֣�from ���ݳ�С�� to ���ݳ�ɳ̲#1
local look_around_cond_tbl = {
	['������ɼ��#5'] = { exit = function( exit ) return exit.e == '������' end },
	['������ɼ��#1'] = { exit = function( exit ) return string.find( exit.e, '��' ) or string.find( exit.w, '��' ) end },
	['������ɼ��#9'] = {	exit = function( exit ) return string.find( exit.e, "����" ) end,
											alt_exit = function( exit ) return string.find( exit.e, '��' ) or string.find( exit.w, '��' ) end,
											look = function( roomname ) return roomname == '��ɼ��' end	},
	['���ݳ�ɳ̲#1'] = { exit = function( exit ) return exit.w == 'С��' and exit.n end,
											alt_exit = function( exit ) return true end,
											look = function( roomname ) return roomname == 'ɳ̲' end },
	['��ɽ������#E'] = { exit = function( exit ) return exit.e == 'ʯ��' end,
											alt_exit = function( exit ) return exit.s ~= '�յ�' end, },
}
function handler:look_around( t )
	if not room.get().desc then self:send{ 'l' } return end
	self.is_step_need_desc = true
	local cond = look_around_cond_tbl[ t.to.id ]
	t.is_look_ok = cond.look or function() return true end
	t.is_exit = cond.exit
	t.is_alt_exit = cond.alt_exit or function() return false end
	t.look = coroutine.wrap( handler.look )
	t.look( self, t )
end
function handler:look( t )
	local exit, dir_list = room.get().exit, {}
	for dir, roomname in pairs( exit ) do
		table.insert( dir_list, dir )
		if t.is_look_ok( roomname ) then
			self:newsub{ class = 'getinfo', room = dir, complete_func = handler.look_around_result }
			coroutine.yield()
		end
	end
	if t.alt_exit or t.cmd then -- go alternate exit or back to XX��
		self:send{ t.alt_exit or t.cmd }
		t.alt_exit = nil
	else -- go random direction
		self:send{ dir_list[ math.random( #dir_list ) ] }
	end
end
function handler:look_around_result( result )
	local t = self.step
	for dir, room in pairs( result ) do
		if t.is_exit( room.exit ) then self:send{ dir } return end
		if t.is_alt_exit( room.exit ) then t.alt_exit = dir end
	end
	t.look( self, t )
end

-- �䵱��ɽ����
local fingerprint = {
	'aaaaaAAaA', 'aaAaaAAaa', 'aaaaaAAAa', 'abbaAaAAa',
	'bBBAAabaa', 'bBBbbBBBB', 'bBBBBbBBb', 'bBBccBbbc',
	'cbbbCCCcC', 'cCbCccCCb', 'cbCcCbCCc', 'cdcCcCcCC',
	'dcCCDdDDD', 'dDDDDDDdd', 'ddDdDeDDD', 'ddDeDDDDD',
}
local fp_match_tbl = { a = 'aAB', b = 'bABC', c = 'cBCD', d = 'dCD', e = 'e' }
local wdhs_layout = { ['�䵱��ɽ�һ����'] = 1, ['�䵱��ɽ��Ҷ����'] = 2, ['�䵱��ɽ��ѩ����'] = 3, ['�䵱��ɽ��Ҷ����'] = 4, ['�䵱��ɽ���ֱ�Ե#2'] = 5 }
local wdhs_fpath = { 'w', 'n', 'n', 'w', 'nw', 'n', 'sw', 'n', 'se', 'ne', 's', 'e', 'ne', 'se', 'e' }
local wdhs_bpath = { 'e', 's', 'sw', 'e', 'n', 'sw', 'n', 'w', 'se', 'ne', 's', 'se', 'ne', nil, 'se' }
local function wdhs_conglin_locate( room ) -- return room no. that matches given exits
	local e, result = room.exit, {}
	local f = room.name == '�һ����' and 'a'
				 or room.name == '��Ҷ����' and 'b'
				 or room.name == '��ѩ����' and 'c'
				 or room.name == '��Ҷ����' and 'd'
	for _, dir in ipairs( DIR8 ) do
		f = f .. ( e[ dir ] == '�һ����' and 'a'
						or e[ dir ] == '��Ҷ����' and 'b'
						or e[ dir ] == '��ѩ����' and 'c'
						or e[ dir ] == '��Ҷ����' and 'd'
						or e[ dir ] == '���ֱ�Ե' and 'e' )
	end
	for roomno, fp in pairs( fingerprint ) do
		local diff
		for pos = 1, 9 do
			local a, b = string.sub( f, pos, pos ), string.sub( fp, pos, pos )
			if not string.find( fp_match_tbl[ a ], b ) then diff = true; break end
		end
		if not diff then table.insert( result, roomno ) end
	end
	if #result == 1 then return result[ 1 ] else return end
end
function handler:wdhs_conglin( t )
	local pos, room = handler.data.wdhs_conglin_pos, room.get()
	if not room.desc and not pos then self:send{ 'l' } return end
	if pos then -- if exact position is known, then just walk the path
		-- go to �䵱��ɽ���ֱ�Ե#2 if in correct position
		if pos > 14 and t.to.id == '�䵱��ɽ���ֱ�Ե#2' then
			handler.data.wdhs_conglin_pos = nil
			self:send{ pos == 15 and 'ne' or 's' }
			return
		end
		-- otherwise, walk the forward or backward path
		local forward = wdhs_layout[ t.from.id ] < wdhs_layout[ t.to.id ]
		local cmd = forward and wdhs_fpath[ pos ] or wdhs_bpath[ 17 - pos ]
		if cmd then
			self:send{ cmd  .. ( room.name == '��ѩ����' and ';#wa 3000' or '' ) } -- wait 3 seconds after leaving a ��ѩ���� room because of busy
			handler.data.wdhs_conglin_pos = pos + ( forward and 1 or -1 )
		else -- lost path, clear position and re-evaluate
			handler.data.wdhs_conglin_pos = nil
			self:step_handler( t )
		end
	else -- if exact position is unknown
		local cur_pos = wdhs_conglin_locate( room )
		if cur_pos then -- if current room can be uniquely identified
			handler.data.wdhs_conglin_pos = cur_pos
			self:step_handler( t )
		else
			-- check for exit leading to dest
			for dir, roomname in pairs( room.exit ) do
				if roomname == t.to.name then
					handler.data.wdhs_conglin_pos = nil
					self:send{ dir  .. ( room.name == '��ѩ����' and ';#wa 3000' or '' ) }
					return
				end
			end
			-- look around
			t.look_around = coroutine.wrap( handler.wdhs_conglin_look )
			t.look_around( self, t )
		end
	end
end
-- look around
function handler:wdhs_conglin_look( t )
	local room = room.get()
	for dir, roomname in pairs( room.exit ) do
		if roomname == room.name then
			self:newsub{ class = 'getinfo', room = dir, complete_func = handler.wdhs_conglin_look_result }
			coroutine.yield()
		end
	end
	if t.alt_exit then -- go alternate exit (exit leading to room with same name)
		self:send{ t.alt_exit .. ( room.name == '��ѩ����' and ';#wa 3000' or '' ) }
		t.alt_exit = nil
	else -- go random direction
		self:send{ DIR8[ math.random( 8 ) ] .. ( room.name == '��ѩ����' and ';#wa 3000' or '' )  }
	end
end
-- parse look result
function handler:wdhs_conglin_look_result( result )
	local t = self.step
	for dir, room in pairs( result ) do
		if wdhs_conglin_locate( room ) then self:send{ dir } return end -- go to room that can be uniquely identified
		t.alt_exit = dir
	end
	t.look_around( self, t )
end

-- �䵱ɽ��ԺС��
function handler:wd_xiaojing( t )
	t = self.step
	if t.to.id == '�䵱ɽС��#2' then
		self:send{ 'n' }
	elseif handler.data.wd_xiaojing_dir then
		self:send{ handler.data.wd_xiaojing_dir }
		t.waited, handler.data.wd_xiaojing_dir = nil
	elseif not t.waited then
		t.waited = true
		self:newweaksub{ class = 'killtime', complete_func = handler.wd_xiaojing }
	else
		t.waited = nil
		self:send{ DIR4[ math.random( 4 ) ] }
	end
end
function handler:wd_xiaojing_prompt( _, t )
	handler.data.wd_xiaojing_dir = CN_DIR[ t[ 2 ] ]
	-- interrupt killtime subtask when got direction prompt
	if self.status == 'running' or self.status == 'lurking' then self:resume() end
end
trigger.new{ name = 'wd_xiaojing_prompt', group = 'step_handler.wd_xiaojing', match = '^(> )*��վ��С���ϣ����ܴ������·𿴼�(\\S+)����Щ���⡣$', func = handler.wd_xiaojing_prompt, penetrate = 'suspended' } -- this trigger works even when the task is suspended, to get the prompt whenever possible

-- ����ׯ�Ź��һ���
local num = lpeg.C( ( lpeg.P 'һ' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + 'ʮ' )^1 )
local patt = lpeg.P '��' * num * '���һ�('
local spatt = any_but( patt )^0 * patt
local gyz_jiugong_path = { 'e', 'e', 's', 'w', 'w', 's', 'e', 'e', 'w', 'w', 'n', 'e', 'e', 'n', 'w', 'w' }
local gyz_jiugong_tbl = {
	xoxo = 1, xxxo = 2, oxxo = 3,
	xoxx = 6, xxxx = 5, oxxx = 4,
	xoox = 7, xxox = 8, oxox = 9,
}
local function get_taohua_count( room )
	local n = spatt:match( room.desc )
	n = n and cntonumber( n ) or 0
	return n
end
local function get_pos( room )
	local f = ''
	for _, dir in pairs( DIR4 ) do
		f = f .. ( room.exit[ dir ] and 'x' or 'o' )
	end
	return gyz_jiugong_tbl[ f ]
end
function handler:gyz_jiugong()
	handler.data.jiugong = handler.data.jiugong or {}
	local room, t = room.get(), handler.data.jiugong
	if t.has_exited then handler.data.jiugong = nil return end
	t.inv_count, t.pos = t.inv_count or 0, get_pos( room )
	if not room.desc and not t[ t.pos ] then self:send{ 'l' } return end
	local taohua_count = t[ t.pos ] or get_taohua_count( room )
	if not t.taohua_adjusted and taohua_count ~= 5 and t.inv_count >= 5 - taohua_count then
		t.taohua_adjusted = true
		t.inv_count = t.inv_count + taohua_count - 5
		if taohua_count > 5 then
			self:send{ 'get ' .. taohua_count - 5 .. ' taohua' }
		elseif taohua_count < 5 then
			self:send{ 'drop ' .. 5 - taohua_count .. ' taohua' }
		end
		t[ t.pos ] = 5
		self:listen{ event = 'prompt', func = handler.gyz_jiugong, id = 'step_handler.gyz_jiugong' }
	else
		t[ t.pos ] = t[ t.pos ] or taohua_count
		t.taohua_adjusted = false
		t.step_num = t.step_num or t.pos - 1
		t.step_num = t.step_num < 16 and t.step_num + 1 or 1
		self:send{ gyz_jiugong_path[ t.step_num ] }
	end
end
function handler:gyz_jiugong_exited()
	handler.data.jiugong = handler.data.jiugong or {}
	handler.data.jiugong.has_exited = true
end
trigger.new{ name = 'gyz_jiugong_exited', group = 'step_handler.gyz_jiugong', match = '^�һ����к�Ȼ����һ��������������������ֳ�һ����·�����æ���˳�ȥ��$', func = handler.gyz_jiugong_exited }

-- �һ����һ���, from �һ��������� to �һ�������
-- TODO 1. support combinations of multiple types of items as identifiers of rooms (no more simple coin count as id) 2. switch between multiple types of items as necessary (based on factors like inventory item count)
function handler:prepare_coin( t )
	if string.find( self.to.id, '�һ���' )
	and ( player.party == "�һ���" and ( not player.skill["���Ű���"] or player.skill["���Ű���"].level <= 80 )
	 or ( player.party ~= "�һ���" and ( not player.skill["���Ű���"] or player.skill["���Ű���"].level <= 150 ) ) )
	and not inventory.has_item( 'ͭǮ', 200 ) then
		self:newsub{ class = 'manage_inventory', action = 'prepare', item = 'ͭǮ', count = 500 }
	else
		self:send{ t.cmd }
	end
end
local item, cn_item = 'coin', 'ͭǮ'
-- return number of items on the ground
local function get_item_count( room )
	return not room.object[ cn_item ] and 0 or room.object[ cn_item ].count
end
-- check if a room has empty exit
local function has_empty_exit( room, t )
	local room, i  = t.map[ room ], 0
	for _, dir in pairs( DIR4 ) do
		if room[ dir ] then i = i + 1 end
	end
	if i < 4 then return true end
end
-- check if a room is completely unknown
local function is_unknown( room, t )
	for _, dir in pairs( DIR4 ) do
		if t.map[ room ][ dir ] then return end
	end
	return true
end
-- find a new unique numeric id for a room
local function get_new_unique_id( t )
	for i = 1, 100 do
		if not t.map[ i ] then return i end
	end
	error 'step_handler.breadcrumb - failed to find available id under 100'
end
-- return a clean-slate map
local function get_clean_map( t )
	return t.from.id == '�һ����һ���' and { { id = 1 } } -- a single blank room
				 or { { id = 1, w = 2, is_reliable = true },
							{ id = 2, n = 3, is_reliable = true },
							{ id = 3, s = 4, is_reliable = true },
							{ id = 4, s = 5, is_reliable = true },
							{ id = 5, is_reliable = true } } -- predefined partial structure for �һ���������#2
end
-- find path to nearest room with empty exit or is unreliable, or to maze exit
local function findpath_to( target, t )
	message.debug( '��ʼ����·����Ŀ��Ϊ ' .. target )
	local list, list_pos, processed, prev, cpath, path, rev_path, to, dest = { t.curr }, 1, { [ t.curr ] = true }, {}, {}, {}, {}
  while list[ list_pos ] do
    from = list[ list_pos ]
		-- found dest?
    if ( target == 'exit' and t.map[ from ].id == 'x' )
		or ( target == 'unknown' and is_unknown( from, t ) )
		or ( target == 'unsure' and not t.map[ from ].is_bad and ( has_empty_exit( from, t ) or t.map[ from ].is_reliable == false ) )
		or ( target == 'bad' and t.map[ from ].is_bad ) then dest = from; break end
		-- evaluate rooms linked from this one
    for _, dir in pairs( DIR4 ) do
			to = t.map[ from ][ dir ]
      if to and to ~= 'a' and from ~= to -- ignore exit to alt maze exits (to ����ͤ or �ݵ�) or to the same room
			and not processed[ to ] -- only add per room once
			and ( t.map[ to ].is_reliable ~= false or target == 'unsure' ) -- ignore unreliable room if target isn't 'unsure'
			and ( not t.map[ to ].is_bad or target == 'bad' or target == 'exit' ) then -- ignore bad room if target isn't 'bad' or 'exit'
      	prev[ to ], list[ #list + 1 ], processed[ to ] =  from, to, true
      end
    end
    list_pos = list_pos + 1 -- move to next node
  end
	if not dest then return end -- path generation failed
	while dest do -- generate reverse path
		rev_path[ #rev_path + 1 ] = dest
		dest = prev[ dest ]
	end
	for i = #rev_path, 1, -1 do -- generate path
		path[ #path + 1 ] = rev_path[ i ]
	end
	message.debug( '���ɵķ���·��Ϊ ' .. table.concat( path, '> ') )
	for i, from in ipairs( path ) do -- generate cmd list
		local room, to = t.map[ from ], path[ i + 1 ]
		if not to then break end -- reached last node in path?
		for _, dir in pairs( DIR4 ) do
			if room[ dir ] == to then cpath[ #cpath + 1 ] = dir; break end
		end
	end
	if target == 'exit' then cpath[ #cpath + 1 ] = 'n' end
	message.debug( '���ɵ�����·��Ϊ ' .. table.concat( cpath, '; ') )
	return cpath
end
-- move to a direction
local function move( self, dir )
	local t = self.step
	t.prev, t.prev_dir = t.curr, dir
	t.expected = t.map[ t.curr ][ dir ] or 0
	self:send{ dir }
end
-- the main handler
function handler:breadcrumb( t )
	local item_count = get_item_count( room.get() )

	if not t.map then -- initialze the map
		-- try to reuse previous map
		t.map = handler.data[ t.from.id ]
		-- no previous map, map is complete but non-reusable, or older than 15 minutes?
		if not t.map or ( t.map.is_complete and not t.map.is_reusable ) or os.time() - t.map.update_time > 900 then
			t.map = get_clean_map( t ) -- use a clean-slate map
		end
 	end

	-- if map is complete and reusable, try to walk to exit directly
	if t.map.is_complete and t.map.is_reusable then
		if not t.path_to_exit then
			t.curr = 1
			t.path_to_exit = findpath_to( 'exit', t )
			-- path generation failed?
			if not t.path_to_exit and item_count ~= 0 then
				t.curr = item_count -- try path generation again based the assumption that current room == item count on ground
				t.path_to_exit = findpath_to( 'exit', t )
			end
			t.map.update_time = os.time() -- everytime the map is reused, update the time
		end
		-- has path to exit?
		if t.path_to_exit and next( t.path_to_exit ) then -- start or keep on walking
			local dir = table.remove( t.path_to_exit, 1 )
			self:send{ dir }
			return -- skip all subsequent evaluation
		elseif t.path_to_exit then -- no more steps but didn't exit the maze, have to start from scratch
			message.debug '֮ǰ��·����Ч����ͷ��ʼ'
			t.path_to_exit = nil
			t.map = { { id = 1 }; is_reusable = false } -- use a blank map and mark the map as non-reusable since we're not starting from the entry point
		else -- path generation failed, have to start from scratch
			t.map = get_clean_map( t ) -- use a clean-slate map
		end
	end

	-- if expected to arrive at (alt) maze exit
	if type( t.expected ) == 'string' then
		t.map[ t.expected ] = t.map[ t.expected ] or { id = t.expected }
		-- at real maze exit?
		if t.expected == 'x' then -- final touches to the map
			t.map.is_complete = true
			t.map.is_reusable = t.map.is_reusable ~= false
			message.debug( '��ǰ��ͼ�Ŀɸ�����Ϊ ' .. tostring( t.map.is_reusable ) )
		end
		t.map.update_time = os.time()
		handler.data[ t.from.id ] = t.map
		self:send{ t.expected == 'x' and 'n' or 's' }
		return
	end

	-- item count evaluation
	t.expected, t.prev = t.expected or 1, t.prev or 1
	local expected_room, action = t.map[ t.expected ], {}
	-- after a reliable step?
	if t.map[ t.prev ].is_reliable and t.expected > 0 and expected_room.is_reliable then
		if t.prev ~= t.expected then t.map[ t.prev ].is_reliable = nil end -- remove prev room's reliable tag since after initial set up it could cause problems (e.g. other rooms with same item count). This would result in a single room still has the tag but that should be no problem.
		action.adjust_item_to_expected = true
	-- item count match expectation?
	elseif item_count == t.expected then
		if t.expected == 0 or expected_room.is_reliable == false then
			action.adjust_item_to_new_unique = true
		end
	elseif t.map[ t.prev ].is_reliable and t.expected > 0 and expected_room.is_reliable then
		if t.prev ~= t.expected then t.map[ t.prev ].is_reliable = nil end -- remove prev room's reliable tag since after initial set up it could cause problems (e.g. other rooms with same item count). This would result in a single room still has the tag but that should be no problem.
		action.adjust_item_to_expected = true
	elseif item_count == 0 then
		if not expected_room.drop_time or os.time() - expected_room.drop_time > 60 then
			action.adjust_item_to_expected = true
		else
			action.adjust_item_to_new_unique = true
			action.mark_prev_unreliable = true
		end
	elseif t.expected ~= 0 then
	 	if expected_room.is_reliable ~= false or not expected_room.alternate or not expected_room.alternate[ item_count ] then
			action.mark_prev_unreliable = true
			if t.map[ item_count ] and t.map[ item_count ].is_reliable == false then
				action.adjust_item_to_new_unique = true
			end
		end
	end

	-- mark prev room as unreliable if necessary
	if action.mark_prev_unreliable then
		message.debug '��֮ǰ��������ݱ�Ϊ���ɿ�'
		t.map[ t.prev ].is_reliable = false
		t.path = nil -- delete existing path since there's map error
	end

	-- adjust item count if necessary (when at exit, skip this step)
	if action.adjust_item_to_new_unique or action.adjust_item_to_expected then
		local new_count = t.expected
		if action.adjust_item_to_new_unique then
			new_count = get_new_unique_id( t )
			if t.expected ~= 0 then -- add the new count as an alternate to the old unreliable count
				t.map[ t.expected ].alternate = t.map[ t.expected ].alternate or {}
				t.map[ t.expected ].alternate[ new_count ] = true
			end
		end
		if new_count ~= item_count then
			local cmd = new_count > item_count and 'drop' or 'get'
			local num = math.abs( new_count - item_count )
			self:send{ ( '%s %d %s' ):format( cmd, num, item ) }
			item_count = new_count
			t.map[ item_count ] = t.map[ item_count ] or { id = item_count }
			t.map[ item_count ].drop_time = os.time()
		end
	end

	-- use number of items on ground as identifier of the room
	t.curr = item_count
	t.map[ t.curr ] = t.map[ t.curr ] or { id = t.curr }
	-- update exit info of prev node
	if t.prev_dir then t.map[ t.prev ][ t.prev_dir ] = t.curr end
	-- reset obsolete vars
	t.prev, t.prev_dir, t.expected = nil

	if t.path and next( t.path ) then -- is walking a path, continue walking
		local dir = table.remove( t.path, 1 )
		move( self, dir )
	else
		-- if this reliable room has a reliable neighbor, walk to it
		local reliable_dir, to
		if t.map[ t.curr ].is_reliable then
			for _, dir in pairs( DIR4 ) do
				to = t.map[ t.curr ][ dir ]
				if type( to ) == 'number' and to ~= t.curr and t.map[ to ].is_reliable then reliable_dir = dir; break end
			end
		end
		if reliable_dir then
			move( self, reliable_dir )
		else -- otherwise, look around
			t.look_around = coroutine.wrap( handler.breadcrumb_look )
			t.look_around( self, t )
		end
	end
end
-- look around
function handler:breadcrumb_look( t )
	for _, dir in pairs( DIR4 ) do -- check 4 directions
		local d = t.map[ t.curr ][ dir ]
		if t.map[ t.curr ].is_reliable == false or not d or ( type( d ) == 'number' and t.map[ d ].is_reliable == false ) then -- if this room is unreliable, or we don't have data for a dir or the room in that dir is marked as unreliable, then look at it, but avoid exits with string labels
			self:newsub{ class = 'getinfo', room = dir, complete_func = handler.breadcrumb_look_result }
			coroutine.yield()
		end
	end
	if t.preferred_exit then -- if got preferred exit, then go this dir
		move( self, t.preferred_exit )
		t.preferred_exit, t.alt_exit = nil
	elseif t.alt_exit then -- then, if got alternate exit, then go this dir
		move( self, t.alt_exit )
		t.alt_exit = nil
	else -- otherwise, walk to a room that has an exit leading to an unknown or empty room, or is marked unreliable, or is marked as bad
		t.path = findpath_to( 'unknown', t ) or findpath_to( 'unsure', t ) or findpath_to( 'bad', t )
		if t.path then
			local dir = table.remove( t.path, 1 )
			move( self, dir )
		else -- if no path, then mark all rooms as unreliable and start over
			for _, room in ipairs( t.map ) do
				room.is_reliable = false
			end
			t.map.is_reusable = false -- mark current map as non-reusable because of poor quality
			self:send{ 'l' }
		end
	end
end
-- parse look result
function handler:breadcrumb_look_result( result )
	local t = self.step
	for dir, room in pairs( result ) do
		-- already at room exit?
		if room.name ~= t.from.name then -- if we have to look around at maze exit to know that we're at one, then things are seriously wrong
			handler.data[ t.from.id ] = nil -- clear all data
			self:send{ dir } -- exit maze
			return
		end

		-- next room is maze exit?
		if room.exit.n ~= t.from.name then
			t.map[ t.curr ][ dir ] = 'x'
			move( self, dir )
			return
		-- next room is alt maze exit?
		elseif room.exit.s ~= t.from.name then
			t.map[ t.curr ][ dir ] = 'a'
			-- only take alt maze exit to ����ͤ if it's to the north of this room (because that's when we're probably at ������ pos 10)
			if room.exit.s == '�ݵ�' or dir == 'n' then
				t.map[ t.curr ].is_bad = true -- mark current room as bad so that we try to avoid it whenever possible
				move( self, dir )
				return
			end
		else
			local item_count = get_item_count( room )
			t.map[ t.curr ][ dir ] = item_count > 0 and item_count or nil -- only update info for dir with items
			t.map[ item_count ] = item_count > 0 and ( t.map[ item_count ] or { id = item_count } ) or nil  -- add an map entry for first-time seen non-empty room
			if item_count > 0 and is_unknown( item_count, t ) then t.preferred_exit = dir end -- prefer exit to completely unknown room
			if item_count == 0 or ( t.map[ item_count ].is_reliable == false and not t.map[ item_count ].is_bad ) then t.alt_exit = dir end -- then, prefer exit to an empty room or unreliable room (so that we can fix it first)
		end
	end
	t.look_around( self, t )
end

-- �һ��������һ���
function handler:prelook_bagua( t )
	if self.class == 'go' and self.to.id == '�һ����Ҷ�'
	and ( not player.skill["���Ű���"] or player.skill["���Ű���"].level < 200 ) then
		self:enable_trigger 'thd_bagua'
		self:send{ 'l bagua' }
	else
		self:send{ t.cmd }
	end
end
function handler:thd_bagua( t )
	local loc = map.get_current_location()[ 1 ]
	if not handler.data.thd_bagua then
		if loc.id ~= '�һ�������' then
			self:newsub{ class = 'go', to = '�һ�������', complete_func = handler.thd_bagua }
		else
			self:send{ 'l bagua' }
		end
		return
	end
	if loc.id == '�һ���ɽ��' or loc.id == '�һ���СԺ' then
		local c = string.sub( handler.data.thd_bagua, 1, 1 ) == '1' and 'e' or 'w'
		self:send{ c }
	elseif loc.id == '�һ��������һ���' then
		t.step_num = t.step_num or 1
		local prev = string.sub( handler.data.thd_bagua, t.step_num, t.step_num )
		t.step_num = t.step_num + 1
		local c = string.sub( handler.data.thd_bagua, t.step_num, t.step_num )
		c = prev == c and 's' or 'e'
		self:send{ c }
	else
		self:newsub{ class = 'go', to = '�һ���ɽ��', complete_func = handler.thd_bagua }
	end
end
local thd_bagua_tbl = {
	['Ǭ'] = '111', ['��'] = '011', ['��'] = '101', ['��'] = '001',
	['��'] = '110', ['��'] = '010', ['��'] = '100', ['��'] = '000',
}
function handler:thd_bagua_parse( _, t )
	local s = ''
	for i = 1, 8 do
		local char = string.sub( t[ 1 ], i * 2 - 1, i * 2 )
		s = s .. thd_bagua_tbl[ char ]
	end
	handler.data.thd_bagua = s
	handler.thd_bagua( self, self.step )
end
function handler:thd_bagua_blocked()
	handler.data.thd_bagua = nil
	handler.thd_bagua( self, self.step )
end
trigger.new{ name = 'thd_bagua', group = 'step_handler.thd_bagua', match = '^һ����ֵ������ԣ����水˳ʱ��˳�������ţ�(\\S+)��$', func = handler.thd_bagua_parse }
trigger.new{ name = 'thd_bagua_blocked', group = 'step_handler.thd_bagua', match = '^(> )*��о�����һ����а��ذ��ԣ����������������������˻�����$', func = handler.thd_bagua_blocked }

-- �һ���Ĺ��
local thd_mudao_tbl = {
	{ 'nu', 'n', 'nd', 'ne', 'e', 'se', 'su', 's', 'sd', 'sw', 'w', 'nw' },
	{ 'nw', 'nu', 'n', 'nd', 'ne', 'e', 'se', 'su', 's', 'sd', 'sw', 'w' },
}
-- from �һ���Ĺ��#M to �һ���Ĺ��#2
function handler:thd_mudao( t )
	t = self.step
	local room = room.get()
	-- arrived at �һ���Ĺ��#2?
	if room.exit.d and not room.exit.out then self:check_step() return end
	-- intercept next located event, i.e. handle failures here instead of by the standard routine
	self:listen{ event = 'located', func = handler.thd_mudao, id = 'step_handler.thd_mudao', sequence = 99, keep_eval = false }
	-- returned to �һ���Ĺ��#1?
	if room.exit.out then
		-- ignore first room because of repetition bug
		if not t.is_fail_known and t.offset ~= 'reset_done' then t.is_fail_known = true return end
		-- reset vars
		t.is_fail_known, t.round = nil, 1
		t.offset = not t.offset and 'later'
						or ( t.offset == 'later' and 'earlier' )
						or ( t.offset == 'earlier' and 'reset' )
						or nil
		if t.offset == 'reset' then -- get time again if tried three hour variations
			t.offset = 'reset_done'
			self:newsub{ class = 'getinfo', time = 'forced', complete_func = handler.thd_mudao }
			return
		end
		-- go down again
		self:send{ 'd' }
		return
	end
	local hour = time.get_current_hour()
	-- wait if hour is 0, since there's no exit during this hour
	if hour < 1 then
		local sec = ( 1 - hour ) * 60 + 5 -- wait until 1 am
		self:newsub{ class = 'killtime', duration = sec, complete_func = handler.thd_mudao }
		return
	end
	hour = math.floor( hour )
	hour = ( t.offset == 'later' and hour + 1 )
			or ( t.offset == 'earlier' and hour - 1 )
			or hour
	hour = hour > 12 and hour - 12 or ( hour < 1 and 12 ) or hour
	-- otherwise move to next room
	t.round = t.round or 1
	self:send{ thd_mudao_tbl[ t.round ][ hour ] }
	t.round = t.round + 1
end
-- from �һ���Ĺ��#2 to �һ���Ĺ��#M
function handler:thd_mudao_up( t )
	local room = room.get()
	if os.time() - room.time > 5 then self:send{ 'l' } return end -- refresh room data if stale
	for _, dir in pairs( DIR_ALL ) do
		if dir ~= 'd' and room.exit[ dir ] then self:send{ dir } return end
	end
end

-- �һ���̫����
-- ���ǲ�
function handler:thd_liangyi( t )
	t = self.step
	if not t.has_time then -- update time info
		t.has_time = true
		self:newsub{ class = 'getinfo', time = 'forced', complete_func = handler.thd_liangyi }
		return
	end
	local room = room.get()
	if not t.dir or room.name ~= '����' then
		t.dir = time.day > 15 and 'sw' or 'ne'
		self:listen{ event = 'located', func = handler.thd_liangyi, id = 'step_handler.thd_liangyi', sequence = 99, keep_eval = false }
		self:send{ room.name == '����' and t.dir or DIR_REVERSE[ t.dir ] }
	else
		self:send{ 'd' }
	end
end
-- �����
local thd_wuxing_tbl = {
	['��'] = { -1, -1, -1, 1, 1, 1, 1, 2, 2, 2, 2, -1 },
	['ľ'] = { 1, 2, 2, 2, 2, -1, -1, -1, -1, 1, 1, 1 },
	['ˮ'] = { 2, 2, -1, -1, -1, -1, 1, 1, 1, 1, 2, 2 },
	['��'] = { 1, 1, 1, 1, 2, 2, 2, 2, -1, -1, -1, -1 },
	['��'] = { -1, -1, -1, -1, 1, 1, 1, 1, 2, 2, 2, 2 },
}
local thd_sixiang_exit_tbl = { ['��'] = '����', ['ˮ'] = '̫��', ['��'] = '̫��', ['ľ'] = '����', ['��'] = '����', }
function handler:thd_sixiang( t )
	t = self.step
	local hour = time.get_current_hour()
	if not t.is_going_down then
		local dir = ( hour >= 5 and hour < 11 and 'e' )
						 or ( hour >= 11 and hour < 17 and 's' )
						 or ( hour >= 17 and hour < 23 and 'w' )
						 or ( hour >= 23 or hour < 5 and 'n' )
		t.is_going_down = 'find'
		self:listen{ event = 'located', func = handler.thd_sixiang, id = 'step_handler.thd_sixiang', sequence = 99, keep_eval = false }
		self:send{ dir }
	elseif t.is_going_down == 'find' then
		local ok_list = {}
		for wx, t in pairs( thd_wuxing_tbl ) do
			if t[ time.month ] > 0 then ok_list[ wx ] = t[ time.month ] end
		end
		local room, wuxing_dest, sixiang_dest, is_central_ok = room.get()
		for wx, score in pairs( ok_list ) do
			sixiang_dest, wuxing_dest = thd_sixiang_exit_tbl[ wx ], wx
			if sixiang_dest == room.name then break end
			if sixiang_dest == '����' then is_central_ok = true end
		end
		if sixiang_dest == room.name then -- go to ���� from current room
			handler.data.wuxing = ok_list[ wuxing_dest ]
			self:send{ 'd' }
		else -- go to ���� from another room
			t.is_going_down = 'ready'
			sixiang_dest = is_central_ok and '����' or sixiang_dest -- prefer central room
			wuxing_dest = sixiang_dest == '����' and '��' or wuxing_dest
			handler.data.wuxing = ok_list[ wuxing_dest ]
			self:newsub{ class = 'go', to = '�һ���' .. sixiang_dest, complete_func = handler.thd_sixiang }
		end
	else
		self:send{ 'd' }
	end
end
-- ���в�
local thd_wuxing_step_tbl = {
	{ ['��'] = 'shui', ['ˮ'] = 'mu', ['ľ'] = 'huo', ['��'] = 'tu', ['��'] = 'jin', },
	{ ['��'] = 'mu', ['ľ'] = 'tu', ['��'] = 'shui', ['ˮ'] = 'huo', ['��'] = 'jin', },
}
function handler:thd_wuxing()
	local room = room.get()
	if room.name == 'ʯ��' then self:check_step() return end
	local dir = thd_wuxing_step_tbl[ handler.data.wuxing ][ room.name ]
	self:listen{ event = 'located', func = handler.thd_wuxing, id = 'step_handler.thd_wuxing', sequence = 99, keep_eval = false }
	self:send{ dir }
end

-- ��ɽɽ��
local patt = any_but '��ľ'^1 * '��ľ��' * lpeg.C( any_but '��'^1 ) * '���ƺ����߹�ȥ'
function handler:ts_longtan()
	local room = room.get()
	if not room.desc then self:send{ 'l' } return end
	local dir = CN_DIR[ patt:match( room.desc ) ]
	self:send{ dir }
end

-- ����ɽ������
local wls_songlin_tbl = { { 'w', 'e' }, { 'w', 'e', 's' }, { 'w', 'n' } }
function handler:wls_songlin( t )
	local room = room.get()
	t.step_count = t.step_count and t.step_count + 1 or 1
	if t.step_count > 50 then self:fail() end -- limit to 50 steps since this maze can be a dead lock
	if not room.desc then self:send{ 'l' } return end
	local pos = room.exit.s == '��Ժ' and 1 or room.exit.e == '���ٲ�' and 3 or 2
	if pos == 1 and t.to.id == '����ɽ��Ժ' then self:send{ 's' } return end
	if pos == 3 and t.to.id == '����ɽ���ٲ�' then self:send{ 'e' } return end
	local t = wls_songlin_tbl[ pos ]
	self:send{ t[ math.random( #t ) ] }
end

-- ����ɽɽ· (quest)

-- �����Ȼ���
-- TODO better handling to keep jing up
function handler:hdg_huapu( t )
	t = self.step
	t.i = t.i or 1
	local room = room.get()
	if room.name == t.to.name then self:check_step() return end
	if room.name == 'ţ��' then self:send{ 'nd' } return end
	self:listen{ event = 'located', func = handler.hdg_huapu, id = 'step_handler.hdg_huapu', sequence = 99, keep_eval = false }
	t.i = t.i + 1
	if t.i > 10 then self:send{ 'yun jing' }; t.i = 0 end
	self:send{ DIR4[ math.random( 4 ) ] }
end

-- ���޺������
function handler:xx_duchonggu()
	local dir = room.get().exit.se and 'se' or 'e'
	self:send{ dir }
end

-- ������ҩ��
local sld_yaopu_step_tbl = { 'northwest', 'north', 'northeast', 'east', 'southeast', 'south', 'southwest', 'west' }
local sld_yaopu_pos_tbl = { 1, 7, 4, 5, 2, 6, 3, 8 }
function handler:sld_yaopu()
	if not time.uptime then self:newsub{ class = 'getinfo', uptime = 'forced', complete_func = handler.sld_yaopu } return end
	local offset, clist, step = math.modf( time.get_uptime() % 1800 / 225 ), {}
	for i = 1, 8 do
		step = sld_yaopu_pos_tbl[ i ] + offset
		step = step > 8 and step % 8 or step
		step = 'to ' .. sld_yaopu_step_tbl[ step ]
		clist[ #clist + 1 ] = step
	end
	self:send( clist )
end

-- ��������

-- ��ɽ�ض�

-- ����ɽ���϶�

-- ��ɽɽ�� (quest)

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return handler
