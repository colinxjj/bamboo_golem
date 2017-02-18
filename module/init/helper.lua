--------------------------------------------------------------------------------
-- This file defines some useful heper functions
--------------------------------------------------------------------------------

-- convert chinese numbers to arabic ones
local num = lpeg.Cg( lpeg.P 'һ' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + '��', 'num' )
local unit = lpeg.Cg( lpeg.P 'ʮ' + '��' + 'ǧ' + '��' + '��' + '��', 'unit' )
local patt = lpeg.Ct( num^-1 * unit + num * -1 )^1

function cntonumber( text )
	local t, result, mul, n, u = { patt:match( text ) }, 0, 1
	for i = #t, 1, -1 do
		n, u = t[ i ].num, t[ i ].unit
		n = CN_NUM[ n ] or ( u == 'ʮ' and 1 ) or 0
		u = CN_UNIT[ u ] or 1
		mul = u == 100000000 and 1 or mul
		n = n * u * mul
		result = result + n
		mul = ( u == 10000 or u == 100000000 ) and mul * u or mul
	end
	return result
end

-- calculate current time in game based on info in the 'time' table
function time.get_current_hour()
  if not time.updated or not time.hour then return end
  local hour_passed = math.floor( ( os.time() - time.updated ) / 60 * 10 ) / 10
  local new_hour = ( time.hour + hour_passed ) % 24
  -- message.debug( '�����ϴθ���ʱ����Ϣ�ѹ� ' .. os.time() - time.updated .. ' �룬��Ϸʱ��Ӧ���ѹ� ' .. hour_passed .. ' Сʱ�����Ƶ�ǰʱ��Ϊ ' .. new_hour .. ' ʱ' )
  return new_hour
end

-- extract name from strings like ؤ���ʮ�Ŵ����� ��ʦ��
local sp_or_end = lpeg.P ' ' + '��' + -1
local nonsp = lpeg.C ( ( 1 - ( lpeg.P ' ' + '��' ) )^1 )
local patt = ( nonsp * sp_or_end )^1

function extract_name( s )
	local t = { patt:match( s ) }
	return t[ #t ]
end

-- extract object name and count from text such as ��λ�ٱ� or ����öͭǮ
local num = lpeg.C( ( lpeg.P 'һ' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + 'ʮ' + '��' + 'ǧ' + '��' + '��' + '��')^1 )

function extract_name_count( text )
	local count = num:match( text )
	local name = count and string.sub( text, #count + 3, -1 ) or text
	count = count and cntonumber( count ) or 1
	return name, count
end

-- extract name and id from strings like ����(Rain)
function extract_name_id( s )
	local pos = string.find( s, '%(' )
	if not pos then error 'extract_name_id - invalid string format' end
	local name = string.sub( s, 1, pos - 1 )
	local id = string.lower( string.sub( s, pos + 1, -2 ) )
	return name, id
end

-- extract gender from strings like ����
function extract_gender( s )
	local gender = ( string.find( s, '��' ) and 'male' ) or ( string.find( s, 'Ů' ) and 'female' ) or 'other'
	return gender
end

-- remove all spaces from a string
local patt_sp = lpeg.Cs( ( lpeg.P' ' / '' + 1 )^0 )

function remove_space( s )
	return patt_sp:match( s )
end

-- translate numeric error codes to meaningful error info
function translate_errorcode( e )
	assert( type( e ) == 'number', 'translate_errorcode - parameter must be a number' )
	for k, v in pairs( error_code ) do
		if v == e then
			e = k
			break
		end
	end
	return e
end

-- returns a datetime string that can be used in FS paths.
function pathsafe_osdate()
	return os.date( '%Y-%m-%d_%H%M%S')
end

-- convert strings like ʮ��Сʱ or һǧ����ʮ����ʮ��Сʱ��ʮ������ʮ���� to numbers in sec
local unit_to_sec = { ['��'] = 86400, ['��Сʱ'] = 3600, ['Сʱ'] = 3600, ['��'] = 60, ['����'] = 60, ['��'] = 1 }
local num = lpeg.C( ( lpeg.P 'һ' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + '��' + 'ʮ' + '��' + 'ǧ' + '��' + '��' + '��' )^1 )
local unit = lpeg.C( lpeg.P '��' + '��Сʱ' + 'Сʱ' + '��' + '����' + '��' )
local patt = lpeg.Ct( num * unit )^0 + 1

function cn_timelen_to_sec( text )
	assert( type( text ) == 'string', 'cn_timelen_to_sec - parameter must be a string' )
	local t, result = { patt:match( text ) }, 0
	for _, v in pairs ( t ) do
		result = result + cntonumber( v[ 1 ] ) * unit_to_sec[ v[ 2 ] ]
	end
	return result
end

-- create a lpeg pattern matches up to a string and captures all until string
function upto( s )
	return lpeg.C( ( lpeg.P( 1 ) - s )^0 ) * s
end

-- create a lpeg pattern matches anything but a set of strings
function any_but( ... )
	local t, p = { ... }, lpeg.P( 1 )
	for _, s in pairs( t ) do
		p = p - s
	end
	return p
end

-- a function to print tables, copied from MUSHclient's implementation
function tprint( t, indent, done )
	-- in case we run it standalone
  local Note = world.Note or print
  local Tell = world.Tell or io.write

  -- show strings differently to distinguish them from numbers
  local function show( val )
    if type( val ) == "string" then
      return "'" .. val .. "'"
    else
      return tostring( val )
    end
  end

  -- entry point here
  done = done or {}
  indent = indent or 0
  for key, value in pairs( t ) do
    Tell( string.rep( ' ', indent ) ) -- indent it
    if type( value ) == "table" and not done[ value ] then
      done[ value ] = true
      Note( show( key ), ':' );
      tprint( value, indent + 2, done )
    else
			Tell( show( key ), ' = ' )
      print( show( value ) )
    end
  end
end
