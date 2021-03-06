local assert   		= _G.assert
local type 				= _G.type
local print 			= _G.print
local string 			= _G.string
local error 			= _G.error
local MOAIInputMgr   = _G.MOAIInputMgr


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
-- for name, mapped in pairs( xbox ) do
-- 	print( name,  MOAIInputMgr.joystick0[ mapped ] )
-- end

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
	-- print( "setJoystickCallback", aSensor )
	local s = assert( sensorMap[ aSensor ] )
	--==== Only set if it exists in host e.g. ouya doesn't have back/start buttons ====
	local sensor = MOAIInputMgr.joystick0[ s ]
	if sensor then
		sensor:setCallback( aCallback )
	end
end

UP 	= false
DOWN 	= false
LEFT 	= false
RIGHT	= false
PREV_UP 		= false
PREV_DOWN 	= false
PREV_LEFT 	= false
PREV_RIGHT	= false
T 		= false
L 		= false
R 		= false
B		= false
L1 	= false
L3		= false
R1 	= false
R3		= false
HOME  = false
BACK  = false
START = false 
NEUTRAL=true

--==== Buttons ====
setJoystickCallback( "T", function( aState ) T = aState --[[print( "T", aState )]] end )
setJoystickCallback( "L", function( aState ) L = aState --[[print( "L", aState ) ]] end )
setJoystickCallback( "R", function( aState ) R = aState --[[print( "R", aState ) ]] end )
setJoystickCallback( "B", function( aState ) B = aState --[[print( "B", aState ) ]] end )

setJoystickCallback( "L1", function( aState ) L1 = aState --[[print( "L1", aState ) ]] end )
setJoystickCallback( "L3", function( aState ) L3 = aState --[[print( "L3", aState ) ]] end )
setJoystickCallback( "R1", function( aState ) R1 = aState --[[print( "R1", aState ) ]] end )
setJoystickCallback( "R3", function( aState ) R3 = aState --[[print( "R3", aState ) ]] end )

setJoystickCallback( "Home", function( aState ) HOME = aState --[[print( "Home", aState ) ]] end )
setJoystickCallback( "Back", function( aState ) BACK = aState --[[print( "Back", aState ) ]] end )
setJoystickCallback( "Start", function( aState ) START = aState --[[print( "Start", aState ) ]] end )

setJoystickCallback( "DPad", function( aState ) 
	-- print( string.format( "DPad: %08x", aState ) )
	PREV_UP 		= UP
	PREV_DOWN 	= DOWN
	PREV_LEFT 	= LEFT
	PREV_RIGHT	= RIGHT

	UP 	= false
	DOWN 	= false
	LEFT 	= false
	RIGHT	= false
	NEUTRAL = false

	if aState == 0xE then -- up 
		-- print( "DPad - U", aState ) 
		UP = true
	elseif aState == 0xD then -- down
		-- print( "DPad - D", aState ) 
		DOWN = true
	elseif aState == 0xB then -- left
		-- print( "DPad - L", aState ) 
		LEFT = true
	elseif aState == 0x7 then -- right
		-- print( "DPad - R", aState ) 
		RIGHT = true
	elseif aState == 0xA then -- up left
		LEFT = true
		UP = true
		-- print( "DPad - UL", aState ) 
	elseif aState == 0x6 then -- up right
		RIGHT = true
		UP = true
		-- print( "DPad - UR", aState ) 
	elseif aState == 0x9 then -- down left
		-- print( "DPad - DL", aState ) 
		DOWN = true
		LEFT = true
	elseif aState == 0x5 then -- down right
		-- print( "DPad - DR", aState ) 
		DOWN = true
		RIGHT = true
	elseif aState == 0xF then -- neutral
		-- print( "DPad - Neutral", aState ) 
		NEUTRAL = true
	end
end )

--==== Sticks/triggers ====
-- Not implemented with current OSX host ...

-- setJoystickCallback( "LS", function( aX, aY )
-- 	if abs( aX ) > 0 or abs( aY ) > 0  then
-- 		print( "LS", aX, aY )
-- 	end
-- end )	

-- setJoystickCallback( "RS", function( aX, aY )
-- 	if abs( aX ) > 0 or abs( aY ) > 0  then
-- 		print( "RS", aX, aY )
-- 	end
-- end )	

-- setJoystickCallback( "L2", function( aValue )
-- 	if aValue > 0 then 
-- 		print( "Trigger L", aValue )
-- 	end
-- end )	

-- setJoystickCallback( "R2", function( aValue )
-- 	if aValue > 0 then
-- 		print( "Trigger R", aValue )
-- 	end
-- end )	

local userKeyboardCallback

KEY_UP = 283
KEY_DOWN = 284
KEY_LEFT = 285
KEY_RIGHT = 286
KEY_SPACE = 32
KEY_TAB = 293
KEY_T = 84

local function handleKey(key, down)
	-- print( '>>>', key, down )

	PREV_UP 		= UP
	PREV_DOWN 	= DOWN
	PREV_LEFT 	= LEFT
	PREV_RIGHT	= RIGHT

	if key == KEY_SPACE then
		B = down
	elseif key == KEY_UP then
		UP 	= down
	elseif key == KEY_DOWN then
		DOWN 	= down
	elseif key == KEY_LEFT then
		LEFT 	= down
	elseif key == KEY_RIGHT then
		RIGHT	= down
	end

	if not LEFT and not RIGHT and not DOWN and not UP then
		NEUTRAL = true
	else
		NEUTRAL = false
	end
	if userKeyboardCallback then
		userKeyboardCallback( key, down )
	end
end

local keyboardSensor = MOAIInputMgr.device.keyboard
if keyboardSensor then
	keyboardSensor:setCallback( handleKey )
end

-- callback: function( key, isDown ) ... end
function setKeyboardCallback( callback )
	userKeyboardCallback = callback
end

function keyIsDown(key)
	if keyboardSensor then
		return keyboardSensor:keyIsDown(key)
	end
end

return I