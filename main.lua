function love.load()
	require("palette")
	require("board")
	require("utils")
	Init_colours()
	Set_palette(Palettes.nord)
	love.graphics.setNewFont("arcon.otf", 64)
	love.window.setMode(1024, 1024, { minwidth = 256, minheight = 256, resizable = true })
	love.graphics.setDefaultFilter("linear", "linear")
	love.window.setTitle("Yet Another 2048")
	Keymaps = {
		up = { "up", "w", "k" },
		down = { "down", "s", "j" },
		left = { "left", "a", "h" },
		right = { "right", "d", "l" },
	}
	Gameboard = Board:new()
	for k, v in pairs(Colours.tile) do
		print("set:", k, "[", v[1], v[2], v[3], "]")
	end
end

function love.draw()
	Gameboard.draw(Gameboard)
	--love.graphics.print("2048", 32, 32)
end

function love.keypressed(key)
	if Check_in_table(Keymaps.up, key) then
		Gameboard:move("up")
	elseif Check_in_table(Keymaps.down, key) then
		Gameboard:move("down")
	elseif Check_in_table(Keymaps.left, key) then
		Gameboard:move("left")
	elseif Check_in_table(Keymaps.right, key) then
		Gameboard:move("right")
	elseif key == "r" then
		Gameboard = Board:new()
	end
end

function Print_table(t)
	assert(type(t) == "table", "Print table needs to be a table")
	print(t)
	for k, v in pairs(t) do
		print(k, v)
		if type(v) == "table" then
			Print_table(v)
		end
	end
end
