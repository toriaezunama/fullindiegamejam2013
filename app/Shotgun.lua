local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity
local Pickup			= _G.Pickup
local Globals        = _G.Globals

local print 			= _G.print
local tonumber 		= _G.tonumber
local assert 			= _G.assert
local ipairs 			= _G.ipairs

local MOAITexture    = _G.MOAITexture

local class = Utils.class

local S = {}
setfenv( 1, S )

new = class( 'Shotgun', Pickup.new )
-- Utils.printClassInfo( new )

function new:init()
	print( 'Shotgun:init')

	new.__super.init(self)
	
	-- 16 x 16 sprites
	local sprite = Sprite.new( Globals.kASSETS .. 'objects.png', 32, 32, 'objects' )
	sprite:addAnim( 'shotgun', { 18 } )
	sprite:setProp( self )

	self.sprite = sprite

	sprite:play( 'shotgun', false )

	self.collisionType = 'col-pickup'
	self:setCollisionRect( -15, -15, 15, 15 )
end

function new:update()
	if self:collide( 'col-player' ) then 
		Globals.debugLabel:setText( 'Shotgun' )
	else 
		Globals.debugLabel:setText( '' )
	end	
end

return S