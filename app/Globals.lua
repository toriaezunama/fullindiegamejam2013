local assert = _G.assert
local setmetatable = _G.setmetatable
local rawget = _G.rawget
local rawset = _G.rawset
local tostring = _G.tostring

local G = {}
setfenv( 1, G )

--==== Write once then read only ====

setmetatable( G, {
	__newindex = function( t, k, v )
		if rawget( t, k ) ~= nil then
			assert( false, "Trying to overwrite variable '" .. k .. "' with '" .. tostring( v ) .. "'"  )
		else
			rawset( t, k, v )
		end
	end,
	__index = function( t, k )
		return assert( rawget( t, k ), tostring( t ) .. "," .. tostring( k ) )
	end,
} )

return G

