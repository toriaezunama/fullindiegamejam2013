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

function new:collide( x, y, radius, velX, velY )
	local tileX, tileY = self:locToCoord( x, y )

	local r, g, b = 19, 20, 21
	local debugMapLayer = Globals.debugMapLayer
	debugMapLayer:clearGrid()

	-- local dist = math.sqrt( velX*velX + velY*velY)
	-- local invDist = 1/dist

	local dirX = 1
	if velX < 0 then
		dirX = -1
	elseif velX > 0 then
		dirX = 1
	end

	local dirY = 1
	if velY < 0 then
		dirY = -1
	elseif velY > 0 then
		dirY = 1
	end

	local rangeX = x + velX + radius*dirX
	local rangeY = y + velY + radius*dirY

	local dx, _ = self:locToCoord( rangeX, 1 )
	local _, dy = self:locToCoord( 1, rangeY )
	-- print( dx, dy, tileX, tileY )
	-- print( dx, tileX )
	-- print( tileX, rangeX, dirX, dx, dy, tileY, rangeX, rangeY, dirX, dirY )
	for yy = tileY, dy, dirY do
		for xx = tileX, dx, dirX do
			-- print( yy, xx )
			if tileX ~= xx or tileY ~= yy then 
				if self:getTile( xx, yy ) ~= 0 then
					debugMapLayer:setTile( xx, yy, r )
				else
					debugMapLayer:setTile( xx, yy, g )
				end
			end
		end
	end

	-- 

	-- for iy = tileY - 1, tileY + 1 do
	-- 	for ix = tileX - 1, tileX + 1 do

	-- 		-- skip the tile we are on
	-- 		if ix ~= tileX or iy ~= tileY then 
	-- 			if self:getTile( ix, iy ) ~= 0 then
	-- 				debugMapLayer:setTile( ix, iy, r )
	-- 			else
	-- 				debugMapLayer:setTile( ix, iy, g )
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- print("#", tileX, tileY )
	-- 			if self:getTile( ix, iy ) ~= 0 then
	-- 				local tx, ty = self:getTileLoc( ix, iy )
	-- 				local dx = tx - x
	-- 				local dy = ty - y
	-- 				if dx*dx + dy*dy < radius*radius then
	-- 					return true
	-- 				end
	-- 			end 
	-- 		end
	-- 	end
	-- end
	return false
end

return G
