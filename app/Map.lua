local Utils 			= _G.Utils
local MapLayer 		= _G.MapLayer
local CollisionLayer = _G.CollisionLayer
local Player 			= _G.Player
local Globals 			= _G.Globals

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

new = class( 'Map' )
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
	print( 'Map:init' )

	assert( Utils.isString( path ) )

	local mapData = require( path )	

	self.TILE_CNT_X, self.TILE_CNT_Y = mapData.width, mapData.height
	self.TILE_WIDTH, self.TILE_HEIGHT = mapData.tilewidth, mapData.tileheight
	self.width = self.TILE_WIDTH * self.TILE_CNT_X
	self.height = self.TILE_HEIGHT * self.TILE_CNT_Y
	-- local TILE_HALF_WIDTH, TILE_HALF_HEIGHT = TILE_WIDTH * 0.5, TILE_HEIGHT * 0.5

   self.objects = {}

	local deckMap = {}
	self.deckMap = deckMap
	for i, tileSet in ipairs( mapData.tilesets ) do
		local texture = MOAITexture.new()
		-- print( tileSet.image )
		local _, e = tileSet.image:find( "../assets/" )
		local path = tileSet.image:sub( e + 1 ) 
		-- print( path )
		texture:load( Globals.kASSETS .. path )
		texture:setFilter( MOAITexture.GL_NEAREST )

      local tileCntX = tileSet.imagewidth / tileSet.tilewidth
      local tileCntY = tileSet.imageheight / tileSet.tileheight
		
		local tileDeck = MOAITileDeck2D.new()
		tileDeck:setTexture( texture )
		tileDeck:setSize( tileCntX, tileCntY )
		tileDeck:setRect( -0.5, 0.5, 0.5, -0.5 )
		-- tileDeck:setRect( )

		tileDeck.name = tileSet.name
		tileDeck.firstgid = tileSet.firstgid
		tileDeck.lastgid = tileDeck.firstgid + tileCntX * tileCntY - 1

		deckMap[ tileSet.name ] = tileDeck
	end

	-- Utils.printr( tileSets )

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

				if layer.name == "debug" then
					mapLayer:clearGrid()
				end

		      mapLayersMap[ layer.name ] = mapLayer
			end
		elseif layer.type == "objectgroup" then
			self:processObjects( layer )
		end
  
	end

	-- Utils.printr( mapLayersMap )
	-- TODO: Unload module
end

function new:processObjects( layer )
   -- name = "objects",
   -- visible = true,
   -- opacity = 1,
   for i, obj in ipairs( layer.objects ) do
		table.push( self.objects, {
			type=obj.type,
			name=obj.name,
			x=obj.x,
			y=obj.y
		} )
				-- shape = "ellipse",
				-- width = 0,
				-- height = 0,
				-- rotation = 0,
				-- visible = true,
				-- properties = {}
   		
   end

   -- objects = {
   --   {
   --     name = "player",
   --     type = "spawn",
   --     shape = "ellipse",
   --     x = 160,
   --     y = 128,
   --     width = 0,
   --     height = 0,
   --     rotation = 0,
   --     visible = true,
   --     properties = {}
   --   }
   -- }

end

function new:getDims()
	return self.width, self.height
end

function new:getMapLayerForName( name )
	assert( Utils.isString( name ) )
	return assert( self.mapLayersMap[ name ] )
end

function new:getDeckForTilesetName( name )
	return assert( self.deckMap[ name ] )
end

function new:_getDeckForGid( gid )
	for tileSetName, deck in pairs( self.deckMap ) do
		if gid >= deck.firstgid and gid <= deck.lastgid then
			return tileSetName, deck
		end
	end
	error( "No deck found for gid: " .. tostring( gid ) )
end

function new:getCollisionLayer()
	return self.collisionLayer
end

function new:getObjectList()
	return self.objects
end

return M
