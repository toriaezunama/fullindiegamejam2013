local kASSETS 			= _G.kASSETS
local Globals 			= _G.Globals
local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity
local Character 		= _G.Character
local AnimData 		= _G.AnimData

local print 			= _G.print

local class = Utils.class

local P = {}
setfenv( 1, P )

local Player = class( 'Player', Character.new )
-- Utils.printClassInfo( Player )

function Player:init()
	print( 'Player:init' )

	-- Call super class 
	Player.__super.init(self)

	-- 16 x 16 sprites
	self:setUpSprite( kASSETS .. "characters-32x48.png" , 32, 48, AnimData.punk, 'Player'  )	
	
	self.prop:play( "idle-up", false )	
end

-- Singleton
local player = Player()
function player:update( deltatime )
	local sprite = self.prop
	local distX = 100 * deltatime
	local distY = distX
	local cos45 = 0.70710678118
	local x, y = self.prop:getLoc()

	-- Diagonal
	if (Input.UP or Input.DOWN) and (Input.LEFT or Input.RIGHT) then
		distX = distX * cos45
		distY = distY * cos45
	end
	local velocityX = 0
	local velocityY = 0

	if Input.UP then
		velocityY = -distY
	elseif Input.DOWN then
		velocityY = distY
	end
	if Input.LEFT then
		velocityX = -distX
	elseif Input.RIGHT then
		velocityX = distX
	end

	local collided, colX, colY = Globals.collisionLayer:collide( x, y, 16, velocityX, velocityY )
	self:addX( velocityX )
	self:addY( velocityY )

	-- Globals.collisionLayer

	-- print( "updating", deltatime )
	if Input.UP then
		sprite:play( "walk-up", true )
	elseif Input.DOWN then
		if not (Input.LEFT or Input.RIGHT ) then
			sprite:play( "walk-down", true )
		end
	end
	if Input.LEFT then
		if not Input.UP then
			sprite:play( "walk-left", true )
		end
	elseif Input.RIGHT then
		if not Input.UP then
			sprite:play( "walk-right", true )
		end
	end
	if Input.NEUTRAL then
		if Input.PREV_UP then
			sprite:play( "idle-up", false )	
		elseif Input.PREV_DOWN then
			sprite:play( "idle-down", false )	
		elseif Input.PREV_LEFT then
			sprite:play( "idle-left", false )	
		elseif Input.PREV_RIGHT then
			sprite:play( "idle-right", false )	
		end
	end

end

function get()
	return player
end

return P