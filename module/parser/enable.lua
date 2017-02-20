--------------------------------------------------------------------------------
-- This module parses enable info
--------------------------------------------------------------------------------

local function parse_prompt()
  player.enable_update_time = os.time()
  trigger.disable 'enable2'
  event.new 'enable'
end

local function parse_header( _, t )
  player.enable = player.enable or {}
  trigger.enable 'enable2'
  event.listen{ event = 'prompt', func = parse_prompt, id = 'parser.enable' }
end

local function parse_content( _, t )
  player.enable[ t[ 1 ] ] = {
    skill = t[ 2 ],
    level = tonumber( t[ 3 ] )
  }
end

local function parse_empty()
  player.enable = {}
  player.enable_update_time = os.time()
  event.new 'enable'
end

trigger.new{ name = 'enable1', match = '^(> )*以下是你目前使用中的特殊技能。$', func = parse_header, enabled = true }
trigger.new{ name = 'enable2', match = '^  \\S+ \\((\\w+)\\)\\s*：\\s*(\\S+)\\s*有效等级：\\s*(\\d+)$', func = parse_content }

trigger.new{ name = 'enable0', match = '^(> )*你现在没有使用任何特殊技能。$', func = parse_empty, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
