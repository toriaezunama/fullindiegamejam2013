local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity

local print 			= _G.print
local tonumber 		= _G.tonumber
local assert 			= _G.assert
local ipairs 			= _G.ipairs

local class = Utils.class

local P = {}
setfenv( 1, P )

new = class( 'Pickup', Entity.new )
-- Utils.printClassInfo( new )

function new:init()
	print( 'Pickup:init')

	new.__super.init(self)
end

return P