local kASSETS 			= _G.kASSETS
local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity

local print 			= _G.print

local class = Utils.class

local P = {}
setfenv( 1, P )

local Player = class( Entity.new )

function Player:init()
	print( 'Player:init' )

	-- Call super class 
	Player.__super.init(self)

	local sprite = Sprite.new( kASSETS .. "characters-32x48.png" , 32, 48 )
	sprite:addAnim( "walk-idle", {2})
	sprite:addAnim( "walk-down", {1,3})
	sprite:play( "walk-down", true  )	

	self.prop = sprite
end

-- Singleton
local player = Player()
function player:update( deltatime )
	local sprite = self.prop
	local dist = 50 * deltatime

	-- print( "updating", deltatime )
	if Input.UP then --Input.DOWN, Input.LEFT, Input.RIGHT )
		self:addY( -dist )
	elseif Input.DOWN then
		self:addY( dist )
	end

end

function get()
	return player
end

return P