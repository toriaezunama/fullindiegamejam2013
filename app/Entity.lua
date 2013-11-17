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
local coroutine 		= _G.coroutine

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local E = {}
setfenv( 1, E )

new = class( 'Entity' )
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
	local myProp = self.prop

	if not myProp then
		return
	end

	if myLayer == layer then
		return myProp
	end

    if myLayer then
        myLayer:removeProp( myProp )
    end

    self.layer = layer

    if layer then
        layer:insertProp( myProp )
    end
   
    return self -- chaining    
end

function new:setLoc( x, y )
	local prop = self.prop
	if prop then
		prop:setLoc( x, y )
	end
end

function new:getLoc()
	local prop = self.prop
	if prop then
		return prop:getLoc()
	end
end

function new:setX( x )
	local prop = self.prop
	if prop then
    	prop:setAttr( MOAITransform.ATTR_X_LOC, x )
   end
   return self -- chaining
end

function new:setY( y )
	local prop = self.prop
	if prop then
		prop:setAttr( MOAITransform.ATTR_Y_LOC, y )
	end
   return self -- chaining
end

function new:getX()
	local prop = self.prop
	if prop then
    	return prop:getAttr( MOAITransform.ATTR_X_LOC )
   end
   return 0
end

function new:getY()
	local prop = self.prop
	if prop then
		return prop:getAttr( MOAITransform.ATTR_Y_LOC )
	end
	return 0
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

	if self.prop then
		self.prop:setBounds( xMin, yMin, 0, xMax, yMax, 0 )
	end
end

function new:getCollisionRectInWorldCoords()
	local prop = self.prop
	local xMin, yMin, xMax, yMax = 0,0,0,0
	if prop then
		xMin, yMin, _, xMax, yMax, _ = prop:getBounds()
		xMin, yMin, _ = prop:modelToWorld( xMin, yMin, 0 )
		xMax, yMax, _ = prop:modelToWorld( xMax, yMax, 0 )
	end
	return xMin, yMin, xMax, yMax
end


return E