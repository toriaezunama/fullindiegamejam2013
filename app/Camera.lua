local Utils 			= _G.Utils
local Entity 			= _G.Entity
local Globals  		= _G.Globals
local Map 				= _G.Map

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
local MOAICamera2D   = _G.MOAICamera2D

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local C = {}
setfenv( 1, C )

new = class( "Camera", Entity.new )
new.__index = MOAICamera2D.getInterfaceTable()
new.__moai_class = MOAICamera2D

-- Utils.printClassInfo( new )

function new:init()
	print( 'Camera:init' )

	new.__super.init( self )

	-- Camera 0, 0 starts at top, left so centre
	self:setPiv( Globals.HALF_SCREEN_WIDTH, Globals.HALF_SCREEN_HEIGHT )
end

function new:update( deltatime )
	-- print( 'update' )
	local x, y = self:getLoc()
	local px, py = Globals.player:getLoc()
	local mw, mh = Globals.world:getMapDims()
	local maxX = mw-- - Globals.HALF_SCREEN_WIDTH
	local maxY = mh-- - Globals.HALF_SCREEN_HEIGHT
	-- print( mw, mh, maxX, maxY )
	
	if px < 0 or px > maxX then
		self:setX( x )
	else 
		self:setX( px )
	end
	if py < 0 or py > maxY then 
		self:setY( y )
	else 
		self:setY( py )
	end
end

return C
