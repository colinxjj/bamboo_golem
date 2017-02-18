
local task = {}

--------------------------------------------------------------------------------
-- 襄阳武馆新手任务
--------------------------------------------------------------------------------

task.class = 'wuguan'

--[[----------------------------------------------------------------------------

job 流程：

find 万震山 at 武馆大厅
	w,e,s,n...
ask wan about job
find 吴坎 at 工具房
	w,e,s,n...
ask wu about job
goto 马房
	w,e,s,n...
work...(bound to location)
	saodi...
find 吴坎 at 工具房
	w,e,s,n...
give wu tool
find 万震山 at 武馆大厅
	w,e,s,n...
ask wan about 完成


task master 负责部分：

usepot
	find 教书先生 at 书房
		w,e,s,n...
	learn literate
	find 武馆教头 at 练武场#E, 练武场#N, 练武场#S
		w,e,s,n...
	learn skills
fullme
	hp
	goto 休息室
		w,e,s,n...
	sleep
eatdrink
	goto 厨房
		w,e,s,n...
	ask chuzi about 食物
	get rice
	eat rice
	drop rice
	ask chuzi about 饮水
	get bowl
	drink bowl
	drop bowl

----------------------------------------------------------------------------]]--

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return task
