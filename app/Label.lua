local Utils 			= _G.Utils
local Globals 			= _G.Globals

local assert   		= _G.assert
local pairs    		= _G.pairs
local ipairs    		= _G.ipairs
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local table 			= _G.table

local MOAITextBox 	= _G.MOAITextBox

local class = Utils.class

-- Seal off to prevent accidentally polluting the global table
local L = {}
setfenv( 1, L )

new = class()
new.__index = MOAITextBox.getInterfaceTable()
new.__moai_class = MOAITextBox

function new:init( msg, style )
	msg = msg or ''
	style = style or Globals.defaultStyle

	-- List of styles. First set is the default
	if Utils.isTable( style ) then
		for _, style in ipairs( style ) do
			self:setStyle( style )
		end
	-- Single style
	elseif style and Utils.isUserdata( style ) then
		self:setStyle( style )
	else
		error( "Lable:init - no font style")
	end

	self:setText( msg )

	-- self:spool()
	-- self:setGlyphScale ( 0.75 )
end

function new:setText( msg )
	assert( Utils.isString( msg ) )

	self:setRect( 0, 0, 1000, 1000 )
	self:setString( msg )
	local xMin, yMin, xMax, yMax = self:getStringBounds( 1, #msg )
	-- print( "Msg", msg, xMin, yMin, xMax, yMax )
	if xMin and yMin and xMax and yMax then
		self:setRect( xMin, yMin, xMax, yMax )
	end
end

function new:alignLeft()
	self:setAlignment( MOAITextBox.CENTER_LEFT, MOAITextBox.CENTER_JUSTIFY )
end

function new:alignCentre()
	self:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
end

function new:alignRight()
	self:setAlignment( MOAITextBox.RIGHT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
end

return L