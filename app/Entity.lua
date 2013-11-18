local Utils 			= _G.Utils
local Globals 			= _G.Globals

local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local math 				= _G.math
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local setmetatable 	= _G.setmetatable

local MOAIProp 		= _G.MOAIProp
local MOAISim 			= _G.MOAISim
local MOAICoroutine 	= _G.MOAICoroutine
local MOAITransform  = _G.MOAITransform
local MOAIEaseType   = _G.MOAIEaseType
local coroutine 		= _G.coroutine

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local E = {}
setfenv( 1, E )

new = class( 'Entity' )
new.__index = MOAIProp.getInterfaceTable()
new.__moai_class = MOAIProp

-- Utils.printClassInfo( new )

function new:init()
	print( 'Entity:init' )

	self.collisionType = 'entity' -- override in derived classes

	--==== Update  ====
	local prevTime = MOAISim.getDeviceTime()

	-- Threads run once every sim step until they exit so run every frame
	local updateThread = MOAICoroutine.new()
	updateThread:run( function()
	   while true do
	   	local t = MOAISim.getDeviceTime()
			local dt = t - prevTime

			-- Add an update member function to the entity to receive updates
			if self.update then
				self:update( dt )
			end
			
			prevTime = t
	      coroutine.yield()
	   end
	end)
end

function new:setParent(parent)
	assert( Utils.isUserdata( parent ) )
   
   self.parent = parent
 
	self:clearAttrLink(MOAITransform.INHERIT_TRANSFORM) 
	self:setAttrLink(MOAITransform.INHERIT_TRANSFORM, parent, MOAITransform.TRANSFORM_TRAIT)
end

-- Borrowed from 'flower's function DisplayObject:setLayer(layer)
function new:setLayer( layer )
	local myLayer = self.layer

	if myLayer == layer then
		return self
	end

    if myLayer then
        myLayer:removeProp( self )
    end

    self.layer = layer

    if layer then
        layer:insertProp( self )
    end
   
    return self -- chaining    
end

function new:_moveLoc( x, y, time, easing )
	easing = easing or MOAIEaseType.LINEAR
	local driver = self:moveLoc( x, y, 0, time, easing )
	-- print( ">>", driver )
	return driver
end

function new:setX( x )
   self:setAttr( MOAITransform.ATTR_X_LOC, x )
end

function new:setY( y )
	self:setAttr( MOAITransform.ATTR_Y_LOC, y )
end

function new:getX()
   return self:getAttr( MOAITransform.ATTR_X_LOC )
end

function new:getY()
	return self:getAttr( MOAITransform.ATTR_Y_LOC )
end

function new:addX( x )
	self:setX( self:getX() + x )
end

function new:addY( y )
	self:setY( self:getY() + y )
end

--==== Collision ====

function new:collide( type )
	return Globals.world:collide( self, type )
end

-- params are LOCAL space
function new:setCollisionRect( xMin, yMin, xMax, yMax )
	xMin = math.min( xMin, xMax )
	xMax = math.max( xMin, xMax )

	yMin = math.min( yMin, yMax )
	yMax = math.max( yMin, yMax )

	self:setBounds( xMin, yMin, 0, xMax, yMax, 0 )
end

function new:getCollisionRectInWorldCoords()
	local xMin, yMin, _, xMax, yMax, _ = self:getBounds()
	xMin, yMin, _ = self:modelToWorld( xMin, yMin, 0 )
	xMax, yMax, _ = self:modelToWorld( xMax, yMax, 0 )
	return xMin, yMin, xMax, yMax
end

return E