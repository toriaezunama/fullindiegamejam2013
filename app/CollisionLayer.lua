local Utils 			= _G.Utils

local tostring			= _G.tostring
local require 			= _G.require
local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local table 			= _G.table
local tonumber 		= _G.tonumber
local error 			= _G.error
local setmetatable 	= _G.setmetatable

local MOAIGrid 		= _G.MOAIGrid
local MOAIGridSpace	= _G.MOAIGridSpace

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local G = {}
setfenv( 1, G )

new = class()
new.__index = MOAIGrid.getInterfaceTable()
new.__moai_class = MOAIGrid

-- Utils.printClassInfo( new )

function new:init( tcx, tcy, tiledata, gidbase )
	assert( tonumber( tcx ) and tonumber( tcy ) and tonumber( gidbase ) )

	-- print( tileDeck, tw, th, tcx, tcy, tiledata, gidbase )

	self:setSize( tcx, tcy, tw, th )

	for y = 1, tcy do
		for x = 1, tcx do
			self:setTile( x, y, (tiledata[ (y - 1) * tcx + x ] - gidbase) + 1 )
		end
	end

	-- print( self:getCellAddr( 2, 2 ) ) -- tile x,y to y * w + x
	print( "locToCellAddr", self:locToCellAddr( 1,2 ) ) --> 102: 50 * 2 + 1

	-- Transforms a coordinate in grid space into a tile index
	print( "locToCoord", self:locToCoord( 1, 1) ) --> 2, 2  (+1,+1)
	print( "locToCoord", self:locToCoord( 2, 3 ) ) --> 3, 4 (+1,+1)

	-- 1, 1
	print( "getTileSize", self:getTileSize() )

	-- Should be 0,0 
	print( "getOffset", self:getOffset() )
	
	-- width and height in tiles of map
	print( "getSize", self:getSize() ) --> 50, 50

	-- grid space coordinate of the tile
	-- The optional 'position' flag determines the location of the coordinate within the tile.
	print( "getTileLoc", self:getTileLoc( 1, 1, MOAIGridSpace.TILE_LEFT_TOP ) ) --> 0, 0
	print( "getTileLoc", self:getTileLoc( 1, 1, MOAIGridSpace.TILE_CENTER ) ) --> 0.5, 0.5
	print( "getTileLoc", self:getTileLoc( 1, 2, MOAIGridSpace.TILE_CENTER ) ) --> 0.5, 1.5
end

return G
