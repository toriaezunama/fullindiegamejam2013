local Utils 			= _G.Utils
local Globals 			= _G.Globals
local Entity 			= _G.Entity
local World 			= _G.World
local Player 			= _G.Player
local Pickup 			= _G.Pickup
local Shotgun 			= _G.Shotgun
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
local MOAITexture    = _G.MOAITexture 

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
	Globals.collisionLayer = map:getCollisionLayer()
	-- self:add( Globals.collisionLayer )

	local groundLayer = map:getMapLayerForName( "ground" )
	local groundDecorationLayer = map:getMapLayerForName( "ground-decoration" )
	local wallLayer = map:getMapLayerForName( "walls" )
	local decorationLayer = map:getMapLayerForName( "decoration" )
	local debugLayer = map:getMapLayerForName( "debug" )

	self:add( groundLayer )
	groundLayer:setPriority( 100 )

	self:add( groundDecorationLayer )
	groundDecorationLayer:setPriority( 101 )

	self:add( wallLayer )
	wallLayer:setPriority( 105 )

	self:add( decorationLayer )
	decorationLayer:setPriority( 3000 )

	self:add( debugLayer )
	debugLayer:setPriority( 3001 )

	-- z-ordering
	local entityPriority = 200

	local objectList = map:getObjectList()
	for i, obj in ipairs( objectList ) do
			-- print( obj.type )
		local entity 
		if obj.type == 'spawn' then
			if obj.name == 'player' then
				entity = Globals.player
			elseif obj.name == 'goldKnight' then
				entity = GoldKnight.new()
			end
		elseif obj.type == 'pickup' then
			if obj.name == 'shotgun' then
				-- local deck = map:getDeckForTilesetName( 'objects' )
				entity = Shotgun.new()
			end
		end
		if entity then
			self:add( entity )
			entity:setLoc( obj.x, obj.x )
			entity:setPriority( entityPriority )
			entityPriority = entityPriority + 1
		end
	end

	self.map = map
	self.groundLayer = groundLayer
	self.wallLayer = wallLayer
	self.decorationLayer = decorationLayer
	self.debugLayer = debugLayer
end

function new:getMapDims()
	return self.map:getDims()
end

return G

