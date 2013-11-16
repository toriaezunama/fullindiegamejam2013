local Utils 			= _G.Utils

local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local setmetatable 	= _G.setmetatable

local MOAIProp 		= _G.MOAIProp
local MOAISim 			= _G.MOAISim
local MOAICoroutine 	= _G.MOAICoroutine
local coroutine 		= _G.coroutine

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local E = {}
setfenv( 1, E )

new = class()

function new:init()
	print( 'Entity:init' )

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

return E