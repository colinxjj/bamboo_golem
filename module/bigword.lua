
local bigword = {}

--------------------------------------------------------------------------------
-- This module handles big words
--------------------------------------------------------------------------------

-- convert binary strings to Chinese character graphs
local function binary_to_graph( binary )
	local graph, startpos, line1, line2, gline = {}
	for row = 1, 16, 2 do -- binary data is for 16x16 graphs, so it's 16 lines, 2 for each time
		startpos = ( row - 1 ) * 16
		line1 = string.sub( binary, startpos + 1 , startpos + 16 )
		line2 = string.sub( binary, startpos + 17, startpos + 32 )
		gline = ''
		for i = 1, 16 do
			local s = string.sub( line1, i, i ) .. string.sub( line2, i, i )
			s = ( s == '00' and ' ' ) or -- combine two lines to one to reduce vertical height
				( s == '01' and '.' ) or
				( s == '10' and '`' ) or
				( s == '11' and ':' )
				gline = gline .. s
		end
		table.insert( graph, gline )
	end
	return graph
end

-- print text as big words
function bigword.print( text, framed, fcolor, bcolor )
  assert( type( text ) == 'string', 'bigword.print - parameter must be a string' )
	assert( #text % 2 == 0, 'bigword.print - invalid text length' )

	local graph, line, char, v, pos = {}, {}

	world.DatabaseOpen( 'chinese', CWD .. 'data/chinese_graph.sqlite' )
	for i = 1, #text / 2 do
		pos = i * 2 - 1
    char = string.sub( text, pos , pos + 1 )
		v = world.DatabaseGetField( 'chinese', 'SELECT binary FROM chinese WHERE char = \'' .. char .. '\'')
    assert( v, 'bigword.print - didn\'t find binary for the following char: ' .. char )
		table.insert( graph, binary_to_graph( v ) )
	end
	world.DatabaseClose 'chinese'

  local spacer_num = math.floor( #graph / 2 )
  local remove_trail_sp = #graph % 2 ~= 0 and true

	for i = 1, 8 do
		line[ i ] = ''
		for _, g in pairs( graph ) do
			line[ i ] = line[ i ] .. g[ i ] .. ' '
    end
    if framed then -- add frames to text
      if remove_trail_sp then
        line[i ] = string.sub( line[ i ], 1, -2 ) --remove trailing space if needed
      end
      line[ i ] = '©¦' .. line[ i ] .. '©¦'
    end
  end

  if framed then -- add frames to text
    local header = '©°' .. string.rep( '©¤', #graph * 8 + spacer_num ) .. '©´'
    local footer = '©¸' .. string.rep( '©¤', #graph * 8 + spacer_num ) .. '©¼'
    table.insert( line, 1, header )
    table.insert( line, footer )
  end

  fcolor = fcolor or 'white'
  bcolor = bcolor or 'black'
  for _, l in pairs( line ) do
    world.ColourNote( fcolor, bcolor, l )
  end
end

--translate big words to plain text, accepts a table of 8 lines of text
function bigword.translate( t )
  assert( type( t ) == 'table', 'bigword.translate - parameter must be a table' )
  assert( #t == 8, 'bigword.translate - parameter must be a table with 8 lines of text' )

  local char_count, result, sp, ep, pos, c, c1, c2, bline1, bline2, failed = math.floor( #t[ 1 ] / 16 ), {}

  for line_num, line in ipairs( t ) do
    for cur_char = 1, char_count do
      result[ cur_char ] = line_num == 1 and {} or result[ cur_char ]  -- a table for each char
      sp = ( cur_char - 1 ) * 17 + 1
      ep = ( cur_char - 1 ) * 17 + 16
      bline1, bline2 = '', ''
      for pos = sp, ep do
        c = string.sub( line, pos, pos )
        c1 = ( c == ':' or c == '`' ) and '1' or '0'
        c2 = ( c == ':' or c == '.' ) and '1' or '0'
        bline1, bline2 = bline1 .. c1, bline2 .. c2
      end
      table.insert( result[ cur_char ], bline1 )
      table.insert( result[ cur_char ], bline2 )
    end
  end

	world.DatabaseOpen( 'chinese', CWD .. 'data/chinese_graph.sqlite' )
  for k, v in pairs( result ) do
    v = table.concat( v )
		v = world.DatabaseGetField( 'chinese', 'SELECT char FROM chinese WHERE binary = \'' .. v .. '\'')
		if not v then
			failed = true
			break
		end
    result[ k ] = v
  end
	world.DatabaseClose 'chinese'

  return not failed and table.concat( result ) or nil
end

--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return bigword
