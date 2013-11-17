local Globals 			= _G.Globals
local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity
local Character 		= _G.Character
local AnimData 		= _G.AnimData

local print 			= _G.print

local class = Utils.class

local K = {}
setfenv( 1, K )

new = class( 'GoldKnight', Character.new )
-- Utils.printClassInfo( Player )

function new:init()
	print( 'GoldKnight:init' )

	-- Call super class 
	new.__super.init(self)

	-- 16 x 16 sprites
	self:setUpSprite( Globals.kASSETS .. "chars-32x32.png" , 32, 32, AnimData.goldKnight, 'GoldKnight'  )	
	
	self.prop:play( "idle-down", false )	

	self.collisionType = 'col-enemy'
	self:setCollisionRect( -10, -10, 10, 10 )
end

function new:update( deltatime )
	-- local sprite = self.prop
	-- local dist = 100 * deltatime
	-- local distX = dist
	-- local distY = dist
	-- local cos45 = 0.70710678118
	-- local x, y = self.prop:getLoc()

	-- -- Diagonal
	-- if (Input.UP or Input.DOWN) and (Input.LEFT or Input.RIGHT) then
	-- 	distX = distX * cos45
	-- 	distY = distY * cos45
	-- end
	
	-- local velocityX = 0
	-- local velocityY = 0

	-- if Input.UP then
	-- 	velocityY = -distY
	-- elseif Input.DOWN then
	-- 	velocityY = distY
	-- end
	-- if Input.LEFT then
	-- 	velocityX = -distX
	-- elseif Input.RIGHT then
	-- 	velocityX = distX
	-- end

	-- local c = self:collide( 'walls' )

	-- -- Only test collision if we are moving
	-- if velocityX ~= 0 or velocityY ~= 0 then
	-- 	local radius = 40 -- radius of circle around character
	-- 	-- if dist > radius then -- but if we are moving further then
	-- 	-- 	radius = dist 
	-- 	-- end
	-- 	--local collided, colX, colY = Globals.collisionLayer:collide( x, y, 16, velocityX, velocityY )
	-- 	-- if collided then
	-- 	-- 	Globals.debugLabel:setText( "collide" )
	-- 	-- else
	-- 	-- 	Globals.debugLabel:setText( "" )
	-- 	-- end
	-- end
	-- self:addX( velocityX )
	-- self:addY( velocityY )

	-- -- Globals.collisionLayer

	-- -- print( "updating", deltatime )
	-- if Input.UP then
	-- 	sprite:play( "walk-up", true )
	-- elseif Input.DOWN then
	-- 	if not (Input.LEFT or Input.RIGHT ) then
	-- 		sprite:play( "walk-down", true )
	-- 	end
	-- end
	-- if Input.LEFT then
	-- 	if not Input.UP then
	-- 		sprite:play( "walk-left", true )
	-- 	end
	-- elseif Input.RIGHT then
	-- 	if not Input.UP then
	-- 		sprite:play( "walk-right", true )
	-- 	end
	-- end
	-- if Input.NEUTRAL then
	-- 	if Input.PREV_UP then
	-- 		sprite:play( "idle-up", false )	
	-- 	elseif Input.PREV_DOWN then
	-- 		sprite:play( "idle-down", false )	
	-- 	elseif Input.PREV_LEFT then
	-- 		sprite:play( "idle-left", false )	
	-- 	elseif Input.PREV_RIGHT then
	-- 		sprite:play( "idle-right", false )	
	-- 	end
	-- end

end

return K