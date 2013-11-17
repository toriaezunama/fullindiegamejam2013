function table.copy( from, to )
	to = to or {}
	for k,v in pairs( from ) do
		-- print( k, v )
		to[ k ] = v
	end
	return to
end

function table.push( t, obj )
	t[ #t + 1 ] = obj
end

function table.inArray( t, obj )
	for _, v in ipairs( t ) do
		if obj == v then
			return true
		end
	end
	return false
end