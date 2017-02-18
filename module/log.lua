
local log = {}

--------------------------------------------------------------------------------
-- This module handles logging
--------------------------------------------------------------------------------

-- default log level is set to verbose unless in dev mode
log.level = dev_mode and 'debug' or 'verbose'

local log_path = CWD .. 'userdata/log/'
local log_file

-- create folder for logs if doesn't exist
do
  local f = io.open( log_path .. 'empty.log', 'w' )
  if not f then
    os.execute( 'mkdir ' .. PPATH .. 'userdata' )
    os.execute( 'mkdir ' .. PPATH .. 'userdata\\log' )
  else
    f:close()
  end
end

local function write( level, text )
  assert( type( text ) == 'string', 'log.write - parameter must be a string' )

  local ok -- only writes when log level matches
  if level == 'normal' then
    ok = true
    text = os.date() .. ' ' .. text -- prepend current time to text
  elseif ( level == 'verbose' and log.level ~= 'normal' )
  or ( level == 'debug' and log.level == 'debug' ) then
    ok = true
    text = os.date() .. ' ' .. string.upper( level ) .. ' ' .. text
  end

  if not ok or not player.id then return end -- won't write log when player.id is unknown

  if not log_file then -- append to this player's log file, i.e. one log file per player
    log_file = io.open( log_path .. player.id .. '.txt', 'a+' )
  end

  if log_file then
    log_file:write( text  .. '\n' )
    log_file:flush()
  end
  world.AppendToNotepad( 'log-' .. player.id, text  .. '\r\n' )
end

function log.normal( text )
  write( 'normal', text )
end

function log.verbose( text )
  write( 'verbose', text )
end

function log.debug( text )
  write( 'debug', text )
end

-- start logging mud output
function log.mud_start( session_name )
  assert( session_name == nil or type( session_name ) == 'string', 'log.mud_start - parameter must be a string or be left blank' )

  log.mud_stop() -- always start a new log file each time
  local filename = ( player.id or 'unknown player' ) .. ' - ' .. pathsafe_osdate() .. ( session_name and ( ' ' .. session_name ) or  '' )
  local opened = world.OpenLog( log_path .. filename .. '.html', true )
  if opened ~= 0 then error( 'log.mud_start - OpenLog returned the following error: ' .. translate_errorcode( result ) ) end

  world.WriteLog( [[
    <html>
    <head>
    <title>”Ò÷Òø˛¿‹»’÷æ£∫]] .. ( player.id or 'unknown player' ) .. ' - ' .. os.date() .. [[</title>
    <style type='text/css'>
      body {background-color: black;}
      body {color: #0080FF;}
    </style>
    </head>
    <body>
    <pre><code>
    <font size=2 face='NSimSun'>
    ]] )
end

-- stop logging mud oupout
function log.mud_stop()
  if world.IsLogOpen() then
    world.WriteLog( [[
      </font></code></pre>
      </body>
      </html>
      ]] )
    world.CloseLog()
  end
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return log
