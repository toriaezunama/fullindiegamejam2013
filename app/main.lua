			  require( "type-exts")  -- extends lua types
_G.Utils = require( "utils" )
-- TODO _G.Input = require( "input" )
_G.kASSETS = "assets/"

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
local fb = MOAIGfxDevice:getFrameBuffer()
fb:setClearColor( 0, 0, 0 )

--==== Sprite sheet ====
local texture = MOAITexture.new()
texture:load( kASSETS .. "characters-32x48.png" )
texture:setFilter( MOAITexture.GL_NEAREST ) -- Prevent fuzzy images
local textureW, textureH = texture:getSize()
local spriteW, spriteH = 32, 48
local hSpriteW, hSpriteH = spriteW * 0.5, spriteH * 0.5

local spriteSheet = MOAITileDeck2D.new()
spriteSheet:setTexture( texture )
spriteSheet:setSize( textureW/spriteW, textureH/spriteH )
spriteSheet:setRect( -hSpriteW, hSpriteH, hSpriteW, -hSpriteH )

local prop = MOAIProp.new()
prop:setDeck( spriteSheet )
layer:insertProp( prop )

prop:moveLoc( 50, 50, 1)

