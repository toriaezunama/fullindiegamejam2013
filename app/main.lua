_G.Globals  = require( "Globals")
	Globals.kASSETS 	= "assets/"
	Globals.kLEVELS 	= "levels/"
	Globals.kFONTS 	= "fonts/"
	Globals.SCREEN_WIDTH, Globals.SCREEN_HEIGHT = 640, 480
	Globals.HALF_SCREEN_WIDTH, Globals.HALF_SCREEN_HEIGHT = Globals.SCREEN_WIDTH * 0.5, Globals.SCREEN_HEIGHT * 0.5

_G.AnimData = require( "anim-data" )
			  	  require( "type-exts")  -- extends lua types
_G.Utils 	= require( "Utils" )
_G.Font 		= require( "Font" )
_G.Label 	= require( "Label" )
_G.Input 	= require( "Input" )
_G.Sprite 	= require( "Sprite" )
_G.Entity   = require( "Entity" )
_G.Camera   = require( "Camera" )
_G.Character= require( "Character" )
_G.GoldKnight=require( "GoldKnight" )
_G.Player 	= require( "Player" )
_G.MapLayer = require( "MapLayer" )
_G.CollisionLayer = require( "CollisionLayer" )
_G.Map      = require( "Map" )
_G.World    = require( "World")
_G.GameWorld= require( "GameWorld" )

--==== Setup ====
MOAISim.openWindow( "FullIndieJam2013", Globals.SCREEN_WIDTH, Globals.SCREEN_HEIGHT )

local viewport = MOAIViewport.new()
viewport:setSize( Globals.SCREEN_WIDTH, Globals.SCREEN_HEIGHT )
-- Make 0,0 top left with +ve y downwards
viewport:setScale( Globals.SCREEN_WIDTH, -Globals.SCREEN_HEIGHT )
viewport:setOffset( -1, 1 )

--==== Layers ====
local world = GameWorld.new()
Globals.camera = Camera.new()
world:setCamera( Globals.camera )
world:setViewport( viewport )
MOAISim.pushRenderPass( world ) -- DEPRICATED
Globals.world = world

local layer = MOAILayer.new()
layer:setViewport( viewport )
MOAISim.pushRenderPass( layer ) -- DEPRICATED
Globals.UILayer = layer  

--==== BG colour ====
Utils.setBackgroundColor( 0, 0, 0 )

--==== Text ====
-- local font = Font.new( 
-- 	Globals.kFONTS .. 'PressStart2P.ttf',  
-- 	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-',
-- 	{ 24, 32, 42 }
-- )

-- local style = Utils.newStyle( font, 24 )
label = Label.new( "hiGH" )
Globals.UILayer:insertProp( label )
Globals.debugLabel = label

--==== Debug ====
local debugToggle = false
local debugTextToggle = false

MOAIDebugLines.setStyle( MOAIDebugLines.PROP_MODEL_BOUNDS, 1, 0, 1, 0, 1 )
MOAIDebugLines.setStyle( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0, 0, 1, 1 )
MOAIDebugLines.setStyle( MOAIDebugLines.PARTITION_CELLS, 1, 1, 1, 0, 1 )
MOAIDebugLines.setStyle( MOAIDebugLines.PARTITION_PADDED_CELLS, 1, 1, 0, 1, 1 )
MOAIDebugLines.setStyle( MOAIDebugLines.TEXT_BOX, 1, 1, 0, 1, 1 )
MOAIDebugLines.setStyle( MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 1, 1 )
MOAIDebugLines.setStyle( MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 1, 0, 1, 1 )

local function showDebugLines( show )
	MOAIDebugLines.showStyle( MOAIDebugLines.PROP_MODEL_BOUNDS, show )
	MOAIDebugLines.showStyle( MOAIDebugLines.PROP_WORLD_BOUNDS, show )
	MOAIDebugLines.showStyle( MOAIDebugLines.PARTITION_CELLS, show )
	MOAIDebugLines.showStyle( MOAIDebugLines.PARTITION_PADDED_CELLS, show )
end

local function showDebugTextLines( show )
	MOAIDebugLines.showStyle( MOAIDebugLines.TEXT_BOX, show )
	MOAIDebugLines.showStyle( MOAIDebugLines.TEXT_BOX_BASELINES, show )
	MOAIDebugLines.showStyle( MOAIDebugLines.TEXT_BOX_LAYOUT, show )
end

-- Hide to start with
-- showDebugLines( false )
showDebugTextLines( false )

Input.setKeyboardCallback( function( key, down )
	if Input.KEY_TAB == key and down then
		debugToggle = not debugToggle 
		showDebugLines( debugToggle )
	elseif Input.KEY_T == key and down then
		debugTextToggle = not debugTextToggle
		showDebugTextLines( debugTextToggle )
	end 
end )

--==== START ====
Globals.world:start()