local kASSETS 			= _G.kASSETS
local Utils 			= _G.Utils
local Input 			= _G.Input
local Sprite 			= _G.Sprite
local Entity 			= _G.Entity
local Character 		= _G.Character

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
	local animData = {
		{ name="idle-down", frames= {2} },
		{ name="walk-down", frames= {1,3} },
		{ name="idle-up", frames= {50} },
		{ name="walk-up", frames= {49,51} },
		{ name="idle-left", frames= {18} },
		{ name="walk-left", frames= {17,19} },
		{ name="idle-right", frames= {34} },
		{ name="walk-right", frames= {33,35} },
	}
	self:setUpSprite( kASSETS .. "characters-32x48.png" , 32, 48, animData, 'Player'  )	
	
	self.prop:play( "idle-up", false )	
end

-- Singleton
local player = Player()
function player:update( deltatime )
	local sprite = self.prop
	local dist = 50 * deltatime

	-- print( "updating", deltatime )
	if Input.UP then
		self:addY( -dist )
		if not (Input.LEFT or Input.RIGHT ) then
			sprite:play( "walk-up", true )
		end
	elseif Input.DOWN then
		self:addY( dist )
		if not (Input.LEFT or Input.RIGHT ) then
			sprite:play( "walk-down", true )
		end
	end
	if Input.LEFT then
		self:addX( -dist )
		sprite:play( "walk-left", true )
	elseif Input.RIGHT then
		self:addX( dist )
		sprite:play( "walk-right", true )
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