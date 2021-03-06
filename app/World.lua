local Utils 			= _G.Utils
local Globals 			= _G.Globals
local Entity 			= _G.Entity

local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local table 			= _G.table

local MOAILayer 		= _G.MOAILayer

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local W = {}
setfenv( 1, W )

new = class( 'World' )
new.__index = MOAILayer.getInterfaceTable()
new.__moai_class = MOAILayer

function new:init()
	print( 'World:init')

	self.entityList = {}
end

function new:add( entity )
	table.push( self.entityList, entity )
	entity:setLayer( self )
end

local function _rectsIntersect( aMinX, aMinY, aMaxX, aMaxY, bMinX, bMinY, bMaxX, bMaxY )
	-- print( aMinX, aMinY, aMaxX, aMaxY, bMinX, bMinY, bMaxX, bMaxY )
	if aMaxX < bMinX then
		return false
	elseif aMinX > bMaxX then
		return false
	elseif aMaxY < bMinY then
		return false
	elseif aMinY > bMaxY then
		return false
	end
	return true
end

function new:collide( testEntity, aType )
	assert( Utils.isUserdata( testEntity ) and Utils.isString( aType ) )
	
	local aMinX, aMinY, aMaxX, aMaxY = testEntity:getCollisionRectInWorldCoords()
	-- print( aMinX, aMaxX )

	if aType == "col-wall" then
		return Globals.collisionLayer:collide( aMinX, aMinY, aMaxX, aMaxY )
	end

	for i, entity in ipairs( self.entityList ) do
		-- Don't collide with ourself
		if entity ~= testEntity then
			if entity.collisionType == aType then
				collided = _rectsIntersect( aMinX, aMinY, aMaxX, aMaxY, entity:getCollisionRectInWorldCoords() )
				if collided then
					-- Globals.debugLabel:setText( "collide" )
					return true, entity
				else
					-- Globals.debugLabel:setText( "" )
				end
			end
		end
	end
	return false
end

--==== INTERFACE (override in derived class) ====
function new:start()
end

return W