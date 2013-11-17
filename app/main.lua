_G.kASSETS 	= "assets/"
_G.kLEVELS 	= "levels/"
_G.Globals  = require( "Globals")
Globals.SCREEN_WIDTH, Globals.SCREEN_HEIGHT = 640, 480
Globals.HALF_SCREEN_WIDTH, Globals.HALF_SCREEN_HEIGHT = Globals.SCREEN_WIDTH * 0.5, Globals.SCREEN_HEIGHT * 0.5
_G.AnimData = require( "anim-data" )

			  	  require( "type-exts")  -- extends lua types
_G.Utils 	= require( "Utils" )
_G.Input 	= require( "Input" )
_G.Sprite 	= require( "Sprite" )
_G.Entity   = require( "Entity" )
_G.Camera   = require( "Camera" )
_G.Character= require( "Character" )
_G.Player 	= require( "Player" )
_G.MapLayer = require( "MapLayer" )
_G.CollisionLayer = require( "CollisionLayer" )
_G.Map      = require( "Map" )

-- MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 1, 0, 1, 0, 1 )
-- MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0, 0, 1, 1 )

--==== Setup ====
MOAISim.openWindow( "FullIndieJam2013", Globals.SCREEN_WIDTH, Globals.SCREEN_HEIGHT )

local viewport = MOAIViewport.new()
viewport:setSize( Globals.SCREEN_WIDTH, Globals.SCREEN_HEIGHT )
-- Make 0,0 top left with +ve y downwards
viewport:setScale( Globals.SCREEN_WIDTH, -Globals.SCREEN_HEIGHT )
viewport:setOffset( -1, 1 )

--==== Layers ====
local layer = MOAILayer.new()
Globals.camera = Camera.new()
layer:setCamera( Globals.camera:getMOAICamera() )
layer:setViewport( viewport )
MOAISim.pushRenderPass( layer ) -- DEPRICATED
Globals.worldLayer = layer  

--==== BG colour ====
Utils.setBackgroundColor( 0, 0, 0 )

--==== Map ====
Globals.map = Map.new( kLEVELS .. "level1" )

local groundLayer = Globals.map:getMapLayerForName( "ground" )
Globals.worldLayer:insertProp( groundLayer )

local wallLayer = Globals.map:getMapLayerForName( "walls" )
Globals.worldLayer:insertProp( wallLayer )

--==== Player ====
Globals.player = Player.get()
Globals.player:setLayer( layer )

-- player.prop:moveLoc( 500, 500, 0, 5 )
-- camera:setParent( player.prop )
