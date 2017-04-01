--------------------------------------------------------------------------------
-- This file defines some useful heper functions
--------------------------------------------------------------------------------

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

-- remove all spaces from a string
local patt_sp = lpeg.Cs( ( lpeg.P' ' / '' + 1 )^0 )

function remove_space( s )
	return patt_sp:match( s )
end

-- convert chinese numbers to arabic ones
local num = lpeg.Cg( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九', 'num' )
local unit = lpeg.Cg( lpeg.P '十' + '百' + '千' + '万' + '亿' + '零', 'unit' )
local patt = lpeg.Ct( num^-1 * unit + num * -1 )^1

function cntonumber( text )
	local t, result, mul, n, u = { patt:match( text ) }, 0, 1
	for i = #t, 1, -1 do
		n, u = t[ i ].num, t[ i ].unit
		n = CN_NUM[ n ] or ( u == '十' and 1 ) or 0
		u = CN_UNIT[ u ] or 1
		mul = u == 100000000 and 1 or mul
		n = n * u * mul
		result = result + n
		mul = ( u == 10000 or u == 100000000 ) and mul * u or mul
	end
	return result
end

-- convert chinese money amount like 三千七百六十一锭黄金十二两白银九十四文铜钱 to amount in coins
local num = lpeg.C( ( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九' + '十' ) * ( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九' + '十' + '百' + '千' + '万' + '亿' + '零')^0 )
local unit = lpeg.C( lpeg.P '锭黄金'  + '两白银' + '文铜钱' ) * lpeg.P '又'^-1
local patt = lpeg.Ct( num * unit )^1

function cn_amount_to_cash( text )
	local t, result, n, u = { patt:match( text ) }, 0, 1
	for i = #t, 1, -1 do
		n, u = t[ i ][ 1 ], t[ i ][ 2 ]
		n = cntonumber( n )
		u = u == '锭黄金' and 10000 or u == '两白银' and 100 or 1
		n = n * u
		result = result + n
	end
	return result
end

-- convert chinese money amount like 三千七百六十一锭黄金十二两白银九十四文铜钱 to amount in gold, silver, and coins
function cn_amount_to_money( text )
	local t, result, n, u = { patt:match( text ) }, {}, 1
	for i = #t, 1, -1 do
		n, u = t[ i ][ 1 ], t[ i ][ 2 ]
		n = cntonumber( n )
		u = string.sub( u, 3 )
		result[ u ] = n
	end
	return result
end

-- extract name from strings like 丐帮第十九代弟子 何师我
local ansi = lpeg.R( '09', 'az', 'AZ' ) + lpeg.S ',.?!-/:-@%[\\%]^_`{|}~()'
local remove_ansi = lpeg.Cs( ( ansi / '' + 1 )^1 )
local crop_to_sp = lpeg.Cs( ( any_but( ' ' )^0 * ' ' / '' )^1 * any_but( ' ' )^1 )

function extract_name( s )
	local name = remove_ansi:match( s ) or s
	name = crop_to_sp:match( name ) or name
	if #name % 2 ~= 0 then message.warning( 'extract_name: extracting name from "' .. s .. '" results in: ' .. name ) end
	for i = 1, #name / 2 do
		if string.sub( name, i * 2 - 1, i * 2 ) == '」' then
			name = string.sub( name, i * 2 + 1 )
		end
	end
	return name
end

-- extract object name and count from text such as 两位官兵 or 三百枚铜钱
function extract_name_count( text )
	local count = num:match( text )
	local name = count and string.sub( text, #count + 3, -1 ) or text
	count = count and cntonumber( count ) or 1
	if #name % 2 ~= 0 then message.warning( 'extract_name_count: extracting name from "' .. s .. '" results in: ' .. name ) end
	return name, count
end

-- extract name and id from strings like 逐雨(Rain)
function extract_name_id( s )
	local pos = string.find( s, '%(' )
	if not pos then error 'extract_name_id - invalid string format' end
	local name = string.sub( s, 1, pos - 1 )
	local id = string.lower( string.sub( s, pos + 1, -2 ) )
	if #name % 2 ~= 0 then message.warning( 'extract_name_id: extracting name from "' .. s .. '" results in: ' .. name ) end
	return name, id
end

-- extract gender from strings like 男性
function extract_gender( s )
	local gender = ( string.find( s, '男' ) and 'male' ) or ( string.find( s, '女' ) and 'female' ) or 'other'
	return gender
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

-- convert strings like 十个小时 or 一千零七十七天十八小时二十三分五十七秒 to numbers in sec
local unit_to_sec = { ['天'] = 86400, ['个小时'] = 3600, ['小时'] = 3600, ['分'] = 60, ['分钟'] = 60, ['秒'] = 1 }
local num = lpeg.C( ( lpeg.P '一' + '二' + '三' + '四' + '五' + '六' + '七' + '八' + '九' + '十' + '百' + '千' + '万' + '亿' + '零' )^1 )
local unit = lpeg.C( lpeg.P '天' + '个小时' + '小时' + '分' + '分钟' + '秒' )
local patt = lpeg.Ct( num * unit )^0 + 1

function cn_timelen_to_sec( text )
	assert( type( text ) == 'string', 'cn_timelen_to_sec - parameter must be a string' )
	local t, result = { patt:match( text ) }, 0
	for _, v in pairs ( t ) do
		result = result + cntonumber( v[ 1 ] ) * unit_to_sec[ v[ 2 ] ]
	end
	return result
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
