local kASSETS 			= _G.kASSETS
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
	local dist = 100 * deltatime

	-- print( "updating", deltatime )
	if Input.UP then
		self:addY( -dist )
		sprite:play( "walk-up", true )
	elseif Input.DOWN then
		self:addY( dist )
		if not (Input.LEFT or Input.RIGHT ) then
			sprite:play( "walk-down", true )
		end
	end
	if Input.LEFT then
		self:addX( -dist )
		if not Input.UP then
			sprite:play( "walk-left", true )
		end
	elseif Input.RIGHT then
		self:addX( dist )
		if not Input.UP then
			sprite:play( "walk-right", true )
		end
	end
	if Input.NEUTRAL then
		if Input.PREV_UP then
			sprite:play( "idle-up", true )	
		elseif Input.PREV_DOWN then
			sprite:play( "idle-down", true )	
		elseif Input.PREV_LEFT then
			sprite:play( "idle-left", true )	
		elseif Input.PREV_RIGHT then
			sprite:play( "idle-right", true )	
		end
	end

end

function get()
	return player
end

return P