
local message = {}

--------------------------------------------------------------------------------
-- This module displays messages to the user
--------------------------------------------------------------------------------

-- default message level is set to verbose unless in dev mode
message.level = dev_mode and 'debug' or 'verbose'

local function write( level, text )
  assert( type( text ) == 'string', 'message.write - parameter must be a string' )

  local fcolor, bcolor
  local ok -- only writes when message level matches
  if level == 'normal' then
    ok = true
    fcolor, bcolor = 'white', 'green'
  elseif level == 'warning' then
    ok = true
    fcolor, bcolor = 'black', 'red'
  elseif ( level == 'verbose' and message.level ~= 'normal' ) then
    ok = true
    fcolor, bcolor = 'black', 'yellowgreen'
  elseif ( level == 'debug' and message.level == 'debug' ) then
    ok = true
    fcolor, bcolor = 'black', 'yellow'
    text = 'DEBUG' .. '¡¤' .. text
  end

  if ok then
    world.ColourNote( fcolor, bcolor, 'ÓñÖñ¿þÀÜ¡¤' .. text )
  end
end

function message.normal( text )
  write( 'normal', text )
end

function message.verbose( text )
  write( 'verbose', text )
end

function message.debug( text )
  write( 'debug', text )
end

function message.warning( text )
  write( 'warning', text )
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return message
