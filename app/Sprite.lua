local Utils 			= _G.Utils

local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local setmetatable 	= _G.setmetatable

local MOAIProp 		= _G.MOAIProp
local MOAITexture 	= _G.MOAITexture
local MOAITileDeck2D = _G.MOAITileDeck2D
local MOAIAnimCurve  = _G.MOAIAnimCurve
local MOAIAnim       = _G.MOAIAnim
local MOAIEaseType   = _G.MOAIEaseType

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local S = {}
setfenv( 1, S )

new = class( 'Sprite' )

-- Utils.printClassInfo( new )

function new:init( path, sw, sh, name )
	name = name or 'unnamed-sprite'
	self.name = name
	-- print( 'Sprite:init' )

	local texture = MOAITexture.new()
	texture:load( path )
	texture:setFilter( MOAITexture.GL_NEAREST ) -- Prevent fuzzy images
	local textureW, textureH = texture:getSize()
	local spriteW, spriteH = sw, sh
	local hSpriteW, hSpriteH = spriteW * 0.5, spriteH * 0.5

	local spriteSheet = MOAITileDeck2D.new()
	spriteSheet:setTexture( texture )
	spriteSheet:setSize( textureW/spriteW, textureH/spriteH )
	spriteSheet:setRect( -hSpriteW, hSpriteH, hSpriteW, -hSpriteH )

	self.deck = spriteSheet
	self.texture = texture
	
	self.anims = {}
end

function new:setProp( prop )
	self.prop = prop
	prop:setDeck( self.deck )

	for name, anim in pairs( self.anims ) do
		anim:setLink( 1, anim.curve, prop, MOAIProp.ATTR_INDEX )
	end
end

-- name: animation name, used in .play()
-- animFrames: [1,4,8] etc
-- fps[optional]: Frames Per Second - play back speed 
function new:addAnim( name, animFrames, fps )
	assert( name and Utils.isString( name ) )
	assert( animFrames and Utils.isTable( animFrames ) )
	fps = fps or 5

	-- repeat last frame other wise it won't show
	local len = #animFrames
	animFrames[ len + 1 ] = animFrames[ len ]

	local curve = MOAIAnimCurve.new()
	curve:reserveKeys( #animFrames )
	local invFPS = 1/fps
	for i,frame in ipairs( animFrames ) do
		curve:setKey( 
			i, 					-- key
			invFPS * (i-1), 	-- Time
			frame, 				-- value
			MOAIEaseType.FLAT -- ease
		)	
	end

	local anim = MOAIAnim.new()
	anim:setCurve(curve)
	anim:reserveLinks(1)
	anim.curve = curve

	self.anims[ name ] = anim
end

function new:play( name, loop )  
	local anims = self.anims
	local currentAnimName = self.currentAnimName

	if currentAnimName == name then
		return -- already playing
	end
	
	if currentAnimName then
		local anim = anims[ currentAnimName ]
		anim:stop()
	end

	if not Utils.isBool( loop ) then
		loop = false
	end

	local anim = anims[ name ]
	assert( name and Utils.isString( name ) and anim )
	
	self.currentAnimName = name

	if loop then
		anim:setMode( MOAIAnim.LOOP )
	else
		anim:setMode( MOAIAnim.NORMAL )
	end

	anim:start()
end

-- DEBUG
function new:dump()
	Utils.printf( 'Sprite[%s]:dump', self.name )
	for name, anim in pairs( self.anims ) do
		print( name, anim )
	end
end

return S


-- anim:setListener( MOAITimer.EVENT_TIMER_KEYFRAME, function( anim, key, times, time ) 
-- 	print( string.format( "Anim: %s - keyframe: key=%d, time=%f, repeat count=%d", tostring( anim), key, time, times ) )
-- end )

-- MOAITimer.EVENT_TIMER_BEGIN_SPAN
-- anim:setListener( MOAITimer.EVENT_TIMER_END_SPAN, function( aAnim, aTimesExecuted ) 
-- 	print( "anim ended" ) 
-- end )

-- -- MOAITimer.EVENT_TIMER_BEGIN_SPAN
-- anim:setListener( MOAITimer.LOOPED, function( aAnim, aTimesExecuted ) 
-- 	print( "anim looped" ) 
-- end )
