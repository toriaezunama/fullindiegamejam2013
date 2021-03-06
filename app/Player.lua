local Globals 			= _G.Globals
local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity
local Character 		= _G.Character
local AnimData 		= _G.AnimData

local print 			= _G.print
local math 				= _G.math

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
	self:setUpSprite( Globals.kASSETS .. "characters-32x48.png" , 32, 48, AnimData.punk, 'Player'  )	
	
	self:faceUp()

	-- Place pivot near feet
	self:setPiv( 0, 20 )

	self.collisionType = 'col-player'
	self:setCollisionRect( -10, -2, 10, 24 )
end

-- Singleton
local player = Player()
function player:update( deltatime )
	local dist = 200 * deltatime
	local distX = dist
	local distY = dist
	local cos45 = 0.70710678118

	-- Diagonal
	if (Input.UP or Input.DOWN) and (Input.LEFT or Input.RIGHT) then
		distX = distX * cos45
		distY = distY * cos45
	end
	
	local dirX, dirY = 0,0

	if Input.UP then
		dirY = -1
	elseif Input.DOWN then
		dirY = 1
	end
	if Input.LEFT then
		dirX = -1
	elseif Input.RIGHT then
		dirX = 1
	end

	local velocityX = dirX * distX
	local velocityY = dirY * distY

	local startX, startY = self:getLoc()
	local step = 0.5
	local endX = startX + velocityX	
	local endY = startY + velocityY
	-- print( startX, endX, endX - startX )

	if dirX ~= 0 then
		local stepX = step * dirX
		for x = startX, endX, stepX do
			self:setX( x )
			self:forceUpdate() -- !!! This MUST BE CALLED else internally moai doesn't update the matrix used in prop:modelToWorld() !!!!
			if self:collide( 'col-wall' ) then 
				self:setX( x - stepX )
				break
			end
		end	
	end
	if dirY ~= 0 then
		local stepY = step * dirY
		for y = startY, endY, stepY do
			self:setY( y )
			self:forceUpdate() -- !!! This MUST BE CALLED else internally moai doesn't update the matrix used in prop:modelToWorld() !!!!
			if self:collide( 'col-wall' ) then 
				self:setY( y - stepY )
				break
			end
		end	
	end

	-- print( "updating", deltatime )
	if Input.UP then
		self:walkUp()
	elseif Input.DOWN then
		if not (Input.LEFT or Input.RIGHT ) then
			self:walkDown()
		end
	end
	if Input.LEFT then
		if not Input.UP then
			self:walkLeft()
		end
	elseif Input.RIGHT then
		if not Input.UP then
			self:walkRight()
		end
	end
	if Input.NEUTRAL == true then
		if Input.PREV_UP then
			self:faceUp()
		elseif Input.PREV_DOWN then
			self:faceDown()
		elseif Input.PREV_LEFT then
			self:faceLeft()
		elseif Input.PREV_RIGHT then
			self:faceRight()
		end
	end

end

function get()
	return player
end

return P