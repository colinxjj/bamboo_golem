--------------------------------------------------------------------------------
-- This module parses force related messages
--------------------------------------------------------------------------------

local function parse_dazuo_start()
  player.lasting_action = 'dazuo'
  event.new 'dazuo_start'
end

local function parse_dazuo_end()
  player.lasting_action = false
  event.new 'dazuo_end'
end

local function parse_dazuo_halt()
  player.lasting_action = false
  event.new 'dazuo_halt'
end

local function parse_tuna_start()
  player.lasting_action = 'tuna'
  event.new 'tuna_start'
end

local function parse_tuna_end()
  player.lasting_action = false
  event.new 'tuna_end'
end

local function parse_tuna_halt()
  player.lasting_action = false
  event.new 'tuna_halt'
end

local function parse_sleep_start()
  player.lasting_action = 'sleep'
  event.new 'sleep_start'
end

local function parse_sleep_end()
  player.lasting_action = false
  event.new 'sleep_end'
end


trigger.new{ name = 'dazuo_start', match = '^(> )*你(盘膝而坐|盘膝坐下|盘腿坐下|慢慢盘膝而坐|席地而坐，五心向天|随意坐下，双手平放|轻轻的吸一口气，闭上眼睛，运起玉女心经|运起玄天无极神功，气聚丹田|五心向天，排除一切杂念|手捏剑诀，将寒冰真气提起|抉弃杂念盘膝坐定|你收敛心神闭目打坐|随意一站，双手缓缓抬起，深吸一口气|气运丹田，将体内毒素慢慢逼出|屏息静气，坐了下来|坐下来运气用功)', func = parse_dazuo_start, enabled = true }
trigger.new{ name = 'dazuo_end', match = '^(> )*(过了片刻，)?你(将内息走了个小周天|将内息又运了一个小周天|吸气入丹田，真气运转渐缓|慢慢收气，归入丹田|将周身内息贯通经脉|呼翕九阳，抱一含元|分开双手，黑气慢慢沉下|将寒冰真气按周天之势搬运了一周|双眼微闭，缓缓将天地精华之气吸入体内|将内息在体内运行十二周天|只觉神元归一|感到自己和天地融为一体|一个周天行将下来|将真气在体内沿脉络运行了一圈|真气在体内运行了一个周天|感觉毒素越转越快|将内息走满一个周天|感觉自己已经将玄天无极神功气聚丹田|运功完毕，站了起来)', func = parse_dazuo_end, enabled = true }
trigger.new{ name = 'dazuo_halt', match = '^(> )*你(长出一口气，将内息急速退了回去|面色一沉，迅速收气|内息一转，迅速收气|匆匆将内息退了回去|周身微微颤动，长出口气|双眼缓缓闭合，片刻猛地睁开|双眼一睁|把正在运行的真气强行压回丹田|微一簇眉，将内息压回丹田|感到烦躁难耐，只得懈了内息|感到呼吸紊乱，全身燥热，只好收功|猛的睁开双眼，双手迅速回复体侧|眉头一皱，急速运气，把手放了下来|双掌一分，屈掌握拳|双掌一分，平摊在胸|心神一动，将内息压回丹田)', func = parse_dazuo_halt, enabled = true }

trigger.new{ name = 'tuna_start', match = '^(> )*你闭上眼睛开始吐纳。', func = parse_tuna_start, enabled = true }
trigger.new{ name = 'tuna_end', match = '^(> )*你吐纳完毕，睁开双眼，站了起来。', func = parse_tuna_end, enabled = true }
trigger.new{ name = 'tuna_halt', match = '^(> )*你猛吸几口大气，站了起来。', func = parse_tuna_halt, enabled = true }

trigger.new{ name = 'sleep_start', match = '^(> )*你往(床上|地下角落)一躺，开始睡觉。', func = parse_sleep_start, enabled = true }
trigger.new{ name = 'sleep_end', match = '^(> )*你一觉醒来', func = parse_sleep_end, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
