
local task = {}

--------------------------------------------------------------------------------
-- ���������������
--------------------------------------------------------------------------------

task.class = 'wuguan'

--[[----------------------------------------------------------------------------

job ���̣�

find ����ɽ at ��ݴ���
	w,e,s,n...
ask wan about job
find �⿲ at ���߷�
	w,e,s,n...
ask wu about job
goto ��
	w,e,s,n...
work...(bound to location)
	saodi...
find �⿲ at ���߷�
	w,e,s,n...
give wu tool
find ����ɽ at ��ݴ���
	w,e,s,n...
ask wan about ���


task master ���𲿷֣�

usepot
	find �������� at �鷿
		w,e,s,n...
	learn literate
	find ��ݽ�ͷ at ���䳡#E, ���䳡#N, ���䳡#S
		w,e,s,n...
	learn skills
fullme
	hp
	goto ��Ϣ��
		w,e,s,n...
	sleep
eatdrink
	goto ����
		w,e,s,n...
	ask chuzi about ʳ��
	get rice
	eat rice
	drop rice
	ask chuzi about ��ˮ
	get bowl
	drink bowl
	drop bowl

----------------------------------------------------------------------------]]--

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
