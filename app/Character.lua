local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity

local print 			= _G.print
local tonumber 		= _G.tonumber
local assert 			= _G.assert
local ipairs 			= _G.ipairs

local class = Utils.class

local C = {}
setfenv( 1, C )

new = class( 'Character', Entity.new )
-- Utils.printClassInfo( new )

function new:init()
	print( 'Character:init')

	new.__super.init(self)
end

function new:faceLeft()
	self.sprite:play( "idle-left", false )
end	

function new:faceRight()
	self.sprite:play( "idle-right", false )
end	

function new:faceUp()
	self.sprite:play( "idle-up", false )
end	

function new:faceDown()
	self.sprite:play( "idle-down", false )
end	

function new:walkLeft()
	self.sprite:play( "walk-left", true )
end	

function new:walkRight()
	self.sprite:play( "walk-right", true )
end	

function new:walkUp()
	self.sprite:play( "walk-up", true )
end	

function new:walkDown()
	self.sprite:play( "walk-down", true )
end	

-- animInfo: { { name="anim-name", frames = { 1,3,56, etc } }, ... }
function new:setUpSprite( texturePath, w, h, animInfo, name )
	assert( Utils.isTable( animInfo ) and Utils.isString( texturePath ) )
	w = assert( tonumber( w ) )
	h = assert( tonumber( h ) )

	-- 16 x 16 sprites
	local sprite = Sprite.new( texturePath, w, h, name )
	for i, anim in ipairs( animInfo ) do
		sprite:addAnim( anim.name, anim.frames )
	end
	sprite:setProp( self )

	self.sprite = sprite

	-- sprite:dump()
end

return C