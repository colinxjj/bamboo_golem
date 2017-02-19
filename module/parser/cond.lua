--------------------------------------------------------------------------------
-- This module parses cond info
--------------------------------------------------------------------------------

-- only moves data to player.status when info is fully parsed.
local cache

local function parse_header()
  cache = {}
  trigger.enable_group 'cond'
end

local function parse_content( _, t )
  cache[ t[ 1 ] ] = {
    name = t[ 1 ],
    duration = cn_timelen_to_sec( t[ 2 ] ),
    category = t[ 3 ],
  }
end

local function parse_footer()
  player.cond, cache = cache, false -- move cache data to player.status and clear cache
  player.cond_update_time = os.time()
  trigger.disable_group 'cond'
  event.new 'cond'
end

local function parse_empty()
  player.cond = {}
  player.cond_update_time = os.time()
  event.new 'cond'
end

trigger.new{ name = 'cond1', text = '^│状态名称', func = parse_header, enabled = true }
trigger.new{ name = 'cond2', text = '^│(\\S+)\\s*　\\s*(\\S+)\\s*　\\s*(\\S+)\\s*│', func = parse_content, group = 'cond' }
trigger.new{ name = 'cond3', text = '^└', func = parse_footer, group = 'cond' }

trigger.new{ name = 'cond0', text = '^(> )*你身上没有包括任何特殊状态。', func = parse_empty, enabled = true }

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------
