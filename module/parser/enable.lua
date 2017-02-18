--------------------------------------------------------------------------------
-- This module parses enable info
--------------------------------------------------------------------------------

local function parse_prompt()
  player.enable_updated = os.time()
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
  player.enable_updated = os.time()
  event.new 'enable'
end

trigger.new{ name = 'enable1', text = '^(> )*��������Ŀǰʹ���е����⼼�ܡ�$', func = parse_header, enabled = true }
trigger.new{ name = 'enable2', text = '^  \\S+ \\((\\w+)\\)\\s*��\\s*(\\S+)\\s*��Ч�ȼ���\\s*(\\d+)$', func = parse_content }

trigger.new{ name = 'enable0', text = '^(> )*������û��ʹ���κ����⼼�ܡ�$', func = parse_empty, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
