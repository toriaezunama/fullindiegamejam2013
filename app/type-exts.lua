function table.copy( from, to )
	for k,v in pairs( from ) do
		to[ k ] = v
	end
	return to
end