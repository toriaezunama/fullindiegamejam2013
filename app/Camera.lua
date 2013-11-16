local Utils 			= _G.Utils
local Entity 			= _G.Entity
local Globals  		= _G.Globals

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
local player = _G.player

-- Seal off to prevent accidentally polluting the global table
local C = {}
setfenv( 1, C )

new = class( "Camera", Entity.new )

-- Utils.printClassInfo( new )

function new:init()
	new.__super.init( self )

	self.prop = MOAICamera2D.new()
	-- Camera 0, 0 starts at top, left so centre
	self.prop:setPiv( Globals.HALF_SCREEN_WIDTH, Globals.HALF_SCREEN_HEIGHT )
end

function new:update( deltatime )
	local x, y = self:getLoc()
	local px, py = Globals.player:getLoc()
	-- print( x, y, px, py)
	self:setLoc( px, py )
end

function new:getMOAICamera()
	return self.prop
end

return C
