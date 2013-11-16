local kASSETS 			= _G.kASSETS
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

local MOAITexture 	= _G.MOAITexture
local MOAIProp 		= _G.MOAIProp
local MOAIGrid 		= _G.MOAIGrid

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local L = {}
setfenv( 1, L )

new = class()
new.__index = MOAIProp.getInterfaceTable()
new.__moai_class = MOAIProp

-- Utils.printClassInfo( new )

function new:init( tileDeck, tw, th, tcx, tcy, tiledata, gidbase )
	assert( Utils.isUserdata( tileDeck ) )
	assert( tonumber( tw ) and tonumber( th ) and tonumber( tcx ) and tonumber( tcy ) and tonumber( gidbase ) )

	-- print( tileDeck, tw, th, tcx, tcy, tiledata, gidbase )

	local grid = MOAIGrid.new()
	grid:setSize( tcx, tcy, tw, th )

	for y = 1, tcy do
		for x = 1, tcx do
			grid:setTile( x, y, (tiledata[ (y - 1) * tcx + x ] - gidbase) + 1 )
		end
	end

	self:setGrid( grid )
	self:setDeck( tileDeck )
	
end

return L