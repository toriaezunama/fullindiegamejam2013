local Utils 			= _G.Utils
local Globals 			= _G.Globals
local Entity 			= _G.Entity
local World 			= _G.World
local Player 			= _G.Player
local Map 				= _G.Map
local GoldKnight 		= _G.GoldKnight

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
local G = {}
setfenv( 1, G )

new = class( 'GameWorld', World.new )

function new:init()
	print( 'GameWorld:init')
	new.__super.init(self)	
	Globals.player = Player.get()
end

function new:start()
	local map = Map.new( Globals.kLEVELS .. "level1" )
	
	--==== Map layers ====
	local groundLayer = map:getMapLayerForName( "ground" )
	local wallLayer = map:getMapLayerForName( "walls" )
	local debugLayer = map:getMapLayerForName( "debug" )

	self:insertProp( groundLayer )
	self:insertProp( wallLayer )
	self:insertProp( debugLayer )

	local objectList = map:getObjectList()
	for i, obj in ipairs( objectList ) do
			print( obj.type )
		if obj.type == 'player' then
			Globals.player:setLoc( obj.x, obj.x )
			self:add( Globals.player )
		elseif obj.type == 'goldKnight' then
			local gk = GoldKnight.new()
			gk:setLoc( obj.x, obj.y )
			self:add( gk )
		end
	end

	self.map = map
	self.groundLayer = groundLayer
	self.wallLayer = wallLayer
	self.debugLayer = debugLayer
end

function new:getMapDims()
	return self.map:getDims()
end

return G

