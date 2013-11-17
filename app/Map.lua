local kASSETS 			= _G.kASSETS
local Utils 			= _G.Utils
local MapLayer 		= _G.MapLayer
local CollisionLayer = _G.CollisionLayer

local tostring			= _G.tostring
local require 			= _G.require
local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local error 			= _G.error
local table 			= _G.table
local setmetatable 	= _G.setmetatable

local MOAITexture 	= _G.MOAITexture
local MOAIProp 		= _G.MOAIProp
local MOAITileDeck2D = _G.MOAITileDeck2D

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local M = {}
setfenv( 1, M )

new = class()
new.__index = MOAIProp.getInterfaceTable()
new.__moai_class = MOAIProp

-- Utils.printClassInfo( new )
--==== Helper ====
local function _getFirstNonZeroTileIndex( data )
	for _, v in ipairs( data ) do
		if v > 0 then
			return v
		end
	end
end

function new:init( path )
	assert( Utils.isString( path ) )
	local mapData = require( path )	

	self.TILE_CNT_X, self.TILE_CNT_Y = mapData.width, mapData.height
	self.TILE_WIDTH, self.TILE_HEIGHT = mapData.tilewidth, mapData.tileheight
	self.width = self.TILE_WIDTH * self.TILE_CNT_X
	self.height = self.TILE_HEIGHT * self.TILE_CNT_Y
	-- local TILE_HALF_WIDTH, TILE_HALF_HEIGHT = TILE_WIDTH * 0.5, TILE_HEIGHT * 0.5

	local deckMap = {}
	self.deckMap = deckMap
	for i, tileSet in ipairs( mapData.tilesets ) do
		local texture = MOAITexture.new()
		local _, e = tileSet.image:find( "../../../../FullIndieJam2013/assets/" )
		local path = tileSet.image:sub( e + 1 ) 
		-- print( path )
		texture:load( kASSETS .. path )

      local tileCntX = tileSet.imagewidth / tileSet.tilewidth
      local tileCntY = tileSet.imageheight / tileSet.tileheight
		
		local tileDeck = MOAITileDeck2D.new()
		tileDeck:setTexture( texture )
		tileDeck:setSize( tileCntX, tileCntY )
		-- tileDeck:setRect( -0.5, -0.5, 0.5, 0.5 )
		-- tileDeck:setRect( )

		tileDeck.name = tileSet.name
		tileDeck.firstgid = tileSet.firstgid
		tileDeck.lastgid = tileDeck.firstgid + tileCntX * tileCntY - 1

		deckMap[ tileSet.name ] = tileDeck
	end

	Utils.printr( tileSets )

	local mapLayersMap = {}
	self.mapLayersMap = mapLayersMap
	for i, layer in ipairs( mapData.layers ) do
		if layer.type == "tilelayer" then
			local tileSetName, deck = self:_getDeckForGid( _getFirstNonZeroTileIndex( layer.data ) )
			if layer.name == "collision" then
				self.collisionLayer = CollisionLayer.new( self.TILE_WIDTH, self.TILE_HEIGHT, layer.width, layer.height, layer.data, deck.firstgid )
			else
				-- print( tileSetName, deck )
				local mapLayer = MapLayer.new( deck, self.TILE_WIDTH, self.TILE_HEIGHT, layer.width, layer.height, layer.data, deck.firstgid )
				mapLayer:setLoc( layer.x, layer.y )
				mapLayer:setVisible( layer.visible )
		      -- layer.opacity = 1,
		      -- layer.properties = {},

		      mapLayersMap[ layer.name ] = mapLayer
			end
			-- TODO: collision layer - grid only!
		end
  
	end

	Utils.printr( mapLayersMap )
	-- TODO: Unload module
end

function new:getDims()
	return self.width, self.height
end

function new:getMapLayerForName( name )
	assert( Utils.isString( name ) )
	return assert( self.mapLayersMap[ name ] )
end

function new:_getDeckForGid( gid )
	for tileSetName, deck in pairs( self.deckMap ) do
		if gid >= deck.firstgid and gid <= deck.lastgid then
			return tileSetName, deck
		end
	end
	error( "No deck found for gid: " .. tostring( gid ) )
end

return M


-- --==== Load in tileset ====
-- local tileDeck = MOAITileDeck2D.new ()
-- tileDeck:setTexture( "numbers.png" )
-- tileDeck:setSize( TILE_CNT_X, TILE_CNT_Y )
-- tileDeck:setRect( -0.5, -0.5, 0.5, 0.5 )

-- --==== Tilemap ====
-- local grid = MOAIGrid.new()
-- grid:setSize( 8, 8, TILE_SIZE, TILE_SIZE )
-- --grid:setRepeat ( true ) -- wrap the grid when drawing

-- local map = {
-- 	{ 1, 2, 3, 4, 5, 6, 7, 8 },
-- 	{ 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10 },
-- 	{ 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18 },
-- 	{ 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20 },
-- 	{ 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28 },
-- 	{ 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30 },
-- 	{ 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38 },
-- 	{ 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f, 0x40 },
-- }
-- for i, row in ipairs( map ) do
-- 	grid:setRow( i, unpack( row ) )
-- end

-- --==== Grid deck ====
-- local gridDeck = MOAIGridDeck2D.new()
-- gridDeck:setGrid( grid )
-- gridDeck:setDeck( tileDeck )
