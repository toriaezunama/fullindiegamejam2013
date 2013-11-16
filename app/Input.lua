local assert   = _G.assert
local type 		= _G.type
local print 	= _G.print
local string 	= _G.string

-- Seal off to prevent accidentally polluting the global table
local I = {}
setfenv( 1, I )


--==== MOAIInputCallbacks ====

local xbox = {
	B 		= 'A',
	R 		= 'B',
	L 		= 'X',
	T 		= 'Y',
	Home 	= 'XBox',
	DPad 	= 'DPad',
	RS 	= 'RS',
	R1 	= 'R1',
	R2 	= 'R2',
	R3 	= 'R3',

	LS 	= 'LS', -- stk
	L1 	= 'L1', -- shoulder butn
	L2 	= 'L2',	-- analog trigr
	L3 	= 'L3', -- stick butn

	--==== XBox only  ====
	Start = 'Start',
	Back 	= 'Back',
}

local ouya = {
	B 		= 'O',
	R 		= 'A',
	L 		= 'U',
	T 		= 'Y',
	Home 	= 'System',
	DPad 	= 'DPad',
	RS 	= 'RS',
	R1 	= 'R1',
	R2 	= 'R2',
	R3 	= 'R3',

	LS 	= 'LS', -- stk
	L1 	= 'L1', -- shoulder butn
	L2 	= 'L2',	-- analog trigr
	L3 	= 'L3', -- stick butn

	Touchpad = 'TouchPad',
}

local sensorMap
assert( MOAIInputMgr.joystick0 ~= nil )
for name, mapped in pairs( xbox ) do
	print( name,  MOAIInputMgr.joystick0[ mapped ] )
end

--==== Set according to controller type ====
if  MOAIInputMgr.joystick0.TouchPad ~= nil then
	sensorMap = ouya
elseif MOAIInputMgr.joystick0.XBox ~= nil then
	sensorMap = xbox
else 
	error( 'Unrecognised controller' )
end

--==== Public interface ====
-- e.g. Input.setJoystickCallback( 0, "DPad", function())
-- aSensor = [B|L|T|R|Home|Start|Back|DPad|LS|L1|L2|L3|RS|R1|R2|R3|Touchpad]
function setJoystickCallback( aSensor, aCallback )
	print( "setJoystickCallback", aSensor )
	local s = assert( sensorMap[ aSensor ] )
	--==== Only set if it exists in host e.g. ouya doesn't have back/start buttons ====
	local sensor = MOAIInputMgr.joystick0[ s ]
	if sensor then
		sensor:setCallback( aCallback )
	end
end

--==== Buttons ====
setJoystickCallback( "T", function( aState ) print( "T", aState ) end )
setJoystickCallback( "L", function( aState ) print( "L", aState ) end )
setJoystickCallback( "R", function( aState ) print( "R", aState ) end )
setJoystickCallback( "B", function( aState ) print( "B", aState ) end )

setJoystickCallback( "L1", function( aState ) print( "L1", aState ) end )
setJoystickCallback( "L3", function( aState ) print( "L3", aState ) end )
setJoystickCallback( "R1", function( aState ) print( "R1", aState ) end )
setJoystickCallback( "R3", function( aState ) print( "R3", aState ) end )

setJoystickCallback( "Home", function( aState ) print( "Home", aState ) end )
setJoystickCallback( "Back", function( aState ) print( "Back", aState ) end )
setJoystickCallback( "Start", function( aState ) print( "Start", aState ) end )

setJoystickCallback( "DPad", function( aState ) 
	-- print( string.format( "DPad: %08x", aState ) )
	if aState == 0xE then -- up 
		print( "DPad - U", aState ) 
	elseif aState == 0xD then -- down
		print( "DPad - D", aState ) 
	elseif aState == 0xB then -- left
		print( "DPad - L", aState ) 
	elseif aState == 0x7 then -- right
		print( "DPad - R", aState ) 
	elseif aState == 0xA then -- up left
		print( "DPad - UL", aState ) 
	elseif aState == 0x6 then -- up right
		print( "DPad - UR", aState ) 
	elseif aState == 0x9 then -- down left
		print( "DPad - DL", aState ) 
	elseif aState == 0x5 then -- down right
		print( "DPad - DR", aState ) 
	elseif aState == 0xF then -- neutral
		print( "DPad - Neutral", aState ) 
	end
end )

--==== Sticks/triggers ====
setJoystickCallback( "LS", function( aX, aY )
	if abs( aX ) > 0 or abs( aY ) > 0  then
		print( "LS", aX, aY )
	end
end )	

setJoystickCallback( "RS", function( aX, aY )
	if abs( aX ) > 0 or abs( aY ) > 0  then
		print( "RS", aX, aY )
	end
end )	

setJoystickCallback( "L2", function( aValue )
	if aValue > 0 then 
		print( "Trigger L", aValue )
	end
end )	

setJoystickCallback( "R2", function( aValue )
	if aValue > 0 then
		print( "Trigger R", aValue )
	end
end )	



return I