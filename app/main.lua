_G.kASSETS 	= "assets/"
			  	  require( "type-exts")  -- extends lua types
_G.Utils 	= require( "Utils" )
_G.Sprite 	= require( "Sprite")
-- TODO _G.Input = require( "input" )

-- MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 1, 0, 1, 0, 1 )
-- MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0, 0, 1, 1 )

--==== Setup ====
local SCREEN_WIDTH, SCREEN_HEIGHT = 640, 480
MOAISim.openWindow( "FullIndieJam2013", SCREEN_WIDTH, SCREEN_HEIGHT )

local viewport = MOAIViewport.new()
viewport:setSize( SCREEN_WIDTH, SCREEN_HEIGHT )
-- Make 0,0 top left with +ve y downwards
viewport:setScale( SCREEN_WIDTH, -SCREEN_HEIGHT )
viewport:setOffset( -1, 1 )

local layer = MOAILayer.new()
layer:setViewport( viewport )
MOAISim.pushRenderPass( layer ) -- DEPRICATED

--==== BG colour ====
Utils.setBackgroundColor( 0, 0, 0 )

local sprite = Sprite.new( kASSETS .. "characters-32x48.png" , 32, 48 )
sprite:addAnim( "walk-idle", {2})
sprite:addAnim( "walk-down", {1,3})
sprite:play( "walk-down", true  )
layer:insertProp( sprite )

sprite:moveLoc( 50, 50, 1)
