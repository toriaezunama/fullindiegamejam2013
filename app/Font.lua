local Utils 			= _G.Utils
local Globals 			= _G.Globals

local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local table 			= _G.table

local MOAIFont 		= _G.MOAIFont

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local F = {}
setfenv( 1, F )

new = class()
new.__index = MOAIFont.getInterfaceTable()
new.__moai_class = MOAIFont

function new:init( fontPath, charcodes, sizeList )
	assert( Utils.isString( charcodes ) and Utils.isTable( sizeList ) )

	self.supportedSizes = table.copy( sizeList )
print( fontPath )
	self:load( fontPath )
	for _, fontSize in ipairs( sizeList ) do
		self:preloadGlyphs( charcodes, fontSize )
	end
end

function new:sizeSupported( size )
	return table.inArray( self.supportedSizes, size )
end

Globals.defaultFont = new( 
	Globals.kFONTS .. 'PressStart2P.ttf', 
	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&\'()*+,-./0123456789:;<=>?@[\\]^_`',
	{ 12, 24, 32, 42 }
)

Globals.defaultStyle = Utils.newStyle( Globals.defaultFont, 12 )

return F