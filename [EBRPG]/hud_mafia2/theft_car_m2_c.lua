math.randomseed(getTickCount())
function random(min, max)
	local r = math.random(min, max)
	print(r)
	return r
end

local white = tocolor( 255,255,255 )
local red = tocolor( 255,0,0 )
local green = tocolor( 0,255,0 )

local screenWidth, screenHeight = guiGetScreenSize ( )
local theft = false
local key_state = 1
local key_ygol = -9
local count = 0
local coef_ygol = 18/28
local timer_key_p = false
local timer_key_m = false
local key_table = {
	[1] = {["pryjina"] = 0, ["stvol2"] = 0, ["stvol1"] = 0, color = white, value = false, randomize = random(1, 28)},
	[2] = {["pryjina"] = 0, ["stvol2"] = 0, ["stvol1"] = 0, color = white, value = false, randomize = random(1, 28)},
	[3] = {["pryjina"] = 0, ["stvol2"] = 0, ["stvol1"] = 0, color = white, value = false, randomize = random(1, 28)},
}
local theft_img = {
	["zamok"] = {107,0, 80,186},
	["otv"] = {189,21, 19,83},
	["key"] = {208,0, 32,187},
	["stvol1"] = {294,465, 25,12},
	["stvol2"] = {319,465, 25,12},
	["pryjina"] = {368,493, 11,59},
}

--входит в ствол на 14 пикс+14
--пространтсво между стволами 8 пикс

local theft_t = {
	[1] = { ["otv"] = {22+19*0,21}, ["pryjina"] = {26+12*0,25, 11,40}, ["stvol2"] = {19+12*0,72}, ["stvol1"] = {19+12*0,97}, ["key"] = {-76+19*0,22} },
	[2] = { ["otv"] = {22+19*1,21}, ["pryjina"] = {33+12*1,25, 11,40}, ["stvol2"] = {26+12*1,72}, ["stvol1"] = {26+12*1,97}, ["key"] = {-76+19*1,22} },
	[3] = { ["otv"] = {22+19*2,21}, ["pryjina"] = {40+12*2,25, 11,40}, ["stvol2"] = {33+12*2,72}, ["stvol1"] = {33+12*2,97}, ["key"] = {-76+19*2,22} },
}

addEventHandler( "onClientResourceStart", resourceRoot,
function ( startedRes )
	bindKey("e", "down", e_fun)
	bindKey("s", "both", s_fun)
	bindKey("f", "down", f_fun)
end)

function f_fun ( key, keyState )
	theft = not theft
	showCursor( theft )
	setCursorPosition( 0,0 )

	if theft == false then
		if isTimer( timer_key_p ) then killTimer( timer_key_p ) end
		if isTimer( timer_key_m ) then killTimer( timer_key_m ) end

		key_state = 1
		count = 0
		key_ygol = -9

		for i=1,3 do
			key_table[i]["stvol2"] = 0
			key_table[i]["stvol1"] = 0
			key_table[i]["pryjina"] = 0
			key_table[i].color = white
			key_table[i].value = false
			key_table[i].randomize = random(1, 28)
		end
	end
end

function s_fun ( key, keyState )
	if not theft then return end

	if keyState == "down" then
		if isTimer( timer_key_m ) then killTimer( timer_key_m ) end

		timer_key_p = setTimer( function ( ... )
			if 0 <= count and count <= 27 then
				count=count+1
				key_ygol = -9+count*coef_ygol
				key_table[key_state]["stvol2"] = count
				key_table[key_state]["stvol1"] = count
				key_table[key_state]["pryjina"] = count
				print(count , key_table[key_state].randomize)
				if count == key_table[key_state].randomize then
					key_table[key_state].value = true
					key_table[key_state].color = green
				else
					key_table[key_state].value = false
					key_table[key_state].color = white
				end
			else
				killTimer( timer_key_p )
			end
			print(key_ygol,count)
		end, 250, 0 )
	else
		if isTimer( timer_key_p ) then killTimer( timer_key_p ) end

		timer_key_m = setTimer( function ( ... )
			if 1 <= count and count <= 28 then
				count=count-1
				key_ygol = -9+count*coef_ygol
				key_table[key_state]["stvol2"] = count
				key_table[key_state]["stvol1"] = count
				key_table[key_state]["pryjina"] = count
				print(count , key_table[key_state].randomize)
				if count == key_table[key_state].randomize then
					key_table[key_state].value = true
					key_table[key_state].color = green
				else
					key_table[key_state].value = false
					key_table[key_state].color = white
				end
			else
				killTimer( timer_key_m )
			end
			print(key_ygol,count)
		end, 250, 0 )
	end
end

function e_fun ( key, keyState )
	if not theft then return end

	if key_table[key_state].value == true then
		if isTimer( timer_key_p ) then killTimer( timer_key_p ) end
		if isTimer( timer_key_m ) then killTimer( timer_key_m ) end

		key_table[key_state]["stvol2"] = 14+8
		key_table[key_state]["stvol1"] = 14
		key_table[key_state]["pryjina"] = 14+8
		key_table[key_state].color = green
		key_table[key_state].value = true

		key_state = key_state+1
		count = 0
		key_ygol = -9

	elseif key_table[key_state].value == false and 2 <= key_state and key_state <= 3 then
		if isTimer( timer_key_p ) then killTimer( timer_key_p ) end
		if isTimer( timer_key_m ) then killTimer( timer_key_m ) end

		key_table[key_state]["stvol2"] = 0
		key_table[key_state]["stvol1"] = 0
		key_table[key_state]["pryjina"] = 0
		key_table[key_state].color = white
		key_table[key_state].value = false

		key_table_error(key_state)

		key_state = key_state-1
		count = 0
		key_ygol = -9

		key_table[key_state]["stvol2"] = 0
		key_table[key_state]["stvol1"] = 0
		key_table[key_state]["pryjina"] = 0
		key_table[key_state].color = white
		key_table[key_state].value = false
	end

	if key_state == 4 then
		--евент если замок взломан успешно
		print("HACKER MAN")
		f_fun()
	end
end

function key_table_error(key)
	local count = 0
	setTimer( function ( ... )
		count=count+1
		if count%2 == 1 then
			key_table[key].color = red
		elseif count%2 == 0 then
			key_table[key].color = white
		end
	end, 250, 6 )
end

function createText ()
	if not theft then return end

	local x,y = (screenWidth/2)-(theft_img["zamok"][3]/2), (screenHeight/2)-(theft_img["zamok"][4]/2)

	dxDrawImageSection( x, y, theft_img["zamok"][3], theft_img["zamok"][4], theft_img["zamok"][1], theft_img["zamok"][2], theft_img["zamok"][3], theft_img["zamok"][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )
	
	local i, v = "otv", theft_t[1]["otv"]
	dxDrawImageSection( x+v[1], y+v[2], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )
	local i, v = "otv", theft_t[2]["otv"]
	dxDrawImageSection( x+v[1], y+v[2], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )
	local i, v = "otv", theft_t[3]["otv"]
	dxDrawImageSection( x+v[1], y+v[2], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )

	local i, v = "stvol2", theft_t[1]["stvol2"]
	dxDrawImageSection( x+v[1], y+v[2]-key_table[1][i], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', -90, 0, 0, key_table[1].color )
	local i, v = "stvol2", theft_t[2]["stvol2"]
	dxDrawImageSection( x+v[1], y+v[2]-key_table[2][i], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', -90, 0, 0, key_table[2].color )
	local i, v = "stvol2", theft_t[3]["stvol2"]
	dxDrawImageSection( x+v[1], y+v[2]-key_table[3][i], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', -90, 0, 0, key_table[3].color )

	local i, v = "stvol1", theft_t[1]["stvol1"]
	dxDrawImageSection( x+v[1], y+v[2]-key_table[1][i], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', -90, 0, 0, key_table[1].color )
	local i, v = "stvol1", theft_t[2]["stvol1"]
	dxDrawImageSection( x+v[1], y+v[2]-key_table[2][i], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', -90, 0, 0, key_table[2].color )
	local i, v = "stvol1", theft_t[3]["stvol1"]
	dxDrawImageSection( x+v[1], y+v[2]-key_table[3][i], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', -90, 0, 0, key_table[3].color )

	local i, v = "pryjina", theft_t[1]["pryjina"]
	dxDrawImageSection( x+v[1], y+v[2], v[3], v[4]-key_table[1][i], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )
	local i, v = "pryjina", theft_t[2]["pryjina"]
	dxDrawImageSection( x+v[1], y+v[2], v[3], v[4]-key_table[2][i], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )
	local i, v = "pryjina", theft_t[3]["pryjina"]
	dxDrawImageSection( x+v[1], y+v[2], v[3], v[4]-key_table[3][i], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 0, 0, 0, tocolor( 255,255,255,255 ) )

	local i, v = "key", theft_t[key_state]["key"]
	dxDrawImageSection( x+v[1], y+v[2], theft_img[i][3], theft_img[i][4], theft_img[i][1], theft_img[i][2], theft_img[i][3], theft_img[i][4], 'hud/hud2.png', 90-key_ygol, 0, 0, tocolor( 255,255,255,255 ) )
end
addEventHandler ( "onClientRender", root, createText )