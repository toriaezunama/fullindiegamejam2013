local Utils 			= _G.Utils
local Globals 			= _G.Globals
local Entity 			= _G.Entity

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

new = class( 'CollisionLayer', Entity.new )
new.__index = MOAIGrid.getInterfaceTable()
new.__moai_class = MOAIGrid

-- Utils.printClassInfo( new )

function new:init( tw, th, tcx, tcy, tiledata, gidbase )
	print( 'CollisionLayer:init' )

	assert( tonumber( tcx ) and tonumber( tcy ) and tonumber( gidbase ) )
	
	new.__super.init(self)

	-- print( tileDeck, tw, th, tcx, tcy, tiledata, gidbase )

	self:setSize( tcx, tcy, tw, th )

	for y = 1, tcy do
		for x = 1, tcx do
			self:setTile( x, y, (tiledata[ (y - 1) * tcx + x ] - gidbase) + 1 )
		end
	end

	self.collisionType = 'col-wall'

--[[
	-- print( self:getCellAddr( 2, 2 ) ) -- tile x,y to y * w + x
	print( "locToCellAddr", self:locToCellAddr( 1,2 ) ) --> 1

	-- Transforms a coordinate in grid space into a tile index
	print( "locToCoord", self:locToCoord( 1, 1) ) --> 1, 1
	print( "locToCoord", self:locToCoord( 40, 34 ) ) --> 2, 2

	print( "getTileSize", self:getTileSize() ) --> 32, 32 

	print( "getOffset", self:getOffset() ) --> 0, 0 
	
	-- width and height in tiles of map
	print( "getSize", self:getSize() ) --> 50, 50

	-- grid space coordinate of the tile
	-- The optional 'position' flag determines the location of the coordinate within the tile.
	print( "getTileLoc", self:getTileLoc( -1, -1, MOAIGridSpace.TILE_LEFT_TOP ) ) --> -64, -64
	print( "getTileLoc", self:getTileLoc( 1, 1, MOAIGridSpace.TILE_LEFT_TOP ) ) --> 0, 0
	print( "getTileLoc", self:getTileLoc( 1, 1, MOAIGridSpace.TILE_CENTER ) ) --> 16, 16
	print( "getTileLoc", self:getTileLoc( 1, 2, MOAIGridSpace.TILE_CENTER ) ) --> 16, 48

	print( "getTile", self:getTile( -10, -10 ) ) --> 0 (seems to clip to 0 if out of range)
]]

end

function new:collide( aMinX, aMinY, aMaxX, aMaxY )
	-- local debugMapLayer = Globals.debugMapLayer
	-- debugMapLayer:clearGrid()
	-- print( aMinX, aMinY, aMaxX, aMaxY )

	-- TL
	local tx, ty = self:locToCoord( aMinX, aMinY )
	if self:getTile( tx, ty ) ~= 0 then
		return true
	end

	-- TR
	tx, ty = self:locToCoord( aMaxX, aMinY )
	if self:getTile( tx, ty ) ~= 0 then
		return true
	end

	-- BL
	tx, ty = self:locToCoord( aMinX, aMaxY )
	if self:getTile( tx, ty ) ~= 0 then
		return true
	end

	-- BR
	tx, ty = self:locToCoord( aMaxX, aMaxY )
	if self:getTile( tx, ty ) ~= 0 then
		return true
	end

	return false
end

return G
