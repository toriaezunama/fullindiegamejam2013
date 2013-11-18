local Globals 			= _G.Globals
local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity
local Character 		= _G.Character
local AnimData 		= _G.AnimData

local print 			= _G.print
local assert 			= _G.assert
local coroutine 		= _G.coroutine
local MOAICoroutine  = _G.MOAICoroutine

local MOAIPathFinder = _G.MOAIPathFinder
local MOAIThread		= _G.MOAIThread

local class = Utils.class

local K = {}
setfenv( 1, K )

new = class( 'GoldKnight', Character.new )
-- Utils.printClassInfo( Player )

local STATE_CHASE = 1
local STATE_LOOK_AROUND = 2

function new:init()
	print( 'GoldKnight:init' )

	-- Call super class 
	new.__super.init(self)

	-- 16 x 16 sprites
	self:setUpSprite( Globals.kASSETS .. "chars-32x32.png" , 32, 32, AnimData.goldKnight, 'GoldKnight'  )	
	
	self.prop:play( "idle-down", false )	

	self.collisionType = 'col-enemy'
	self:setCollisionRect( -10, -10, 10, 10 )

	self.state = STATE_CHASE
end

function new:update( deltatime )
	local state = self.state
	local sprite = self.prop

	if state == STATE_CHASE then
		local collisionLayer = Globals.collisionLayer
		local player = Globals.player
		local startCell = collisionLayer:getCellAddressForEntity( self )
		local targetCell = collisionLayer:getCellAddressForEntity( player )

		-- print( startCell, targetCell )
		
		local pathFinder = MOAIPathFinder.new()
		pathFinder:setGraph( collisionLayer )
		pathFinder:init( startCell, targetCell )

		while pathFinder:findPath( 3 ) do
			-- print( 'finding...' )
			
			-- 1) Calculate over several frames
			coroutine:yield()
		end

		local pathSize = pathFinder:getPathSize()
		assert( pathSize > 0 )
		for i = 1, pathSize do
			local cellAddr = pathFinder:getPathEntry( i )

			local x, y = self:getLoc()
			local ptx, pty = collisionLayer:locToCoord( x, y )
			local tx, ty = collisionLayer:cellAddrToCoord( cellAddr )
			local nx, ny = collisionLayer:getTileLoc( tx, ty )
			-- print( ptx, pty, tx, ty, nx, ny )

			-- Play relevent animation
			if pty < ty then
				sprite:play( "walk-down", true )
			elseif pty > ty then
				sprite:play( "walk-up", true )
			end
			if ptx < tx then
				sprite:play( "walk-right", true )
			elseif ptx > tx then
				sprite:play( "walk-left", true )
			end
	
			-- 2) Wait to arrive
			MOAIThread.blockOnAction( self:moveLoc( nx - x, ny - y, 0.4 ) ) 

			if pty < ty then
				self:faceDown()
			elseif pty > ty then
				self:faceUp()
			end
			if ptx < tx then
				self:faceRight()
			elseif ptx > tx then
				self:faceLeft()
			end
	
		end
		-- Arrived
		self.state = STATE_LOOK_AROUND

	elseif state == STATE_LOOK_AROUND then		
		coroutine.sleep( 0.3 )
		self:faceDown()
		coroutine.sleep( 0.4 )
		self:faceUp()
		coroutine.sleep( 0.5 )
		self:faceRight()
		coroutine.sleep( 0.5 )
		self:faceLeft()
		coroutine.sleep( 0.2 )
		self.state = STATE_CHASE
		print( 'END' )
	end
end

return K