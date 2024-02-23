function love.load()
	require("palette")
	require("board")
	require("utils")
	Init_colours()
	Set_palette(Palettes.catppucin)
	love.filesystem.setIdentity("ya2048")
	love.graphics.setNewFont("arcon.otf", 64)
	love.window.setMode(1024, 1024, { minwidth = 100, minheight = 100, resizable = true })
	love.graphics.setDefaultFilter("linear", "linear")
	love.window.setTitle("Yet Another 2048")
	love.window.setIcon(love.image.newImageData("icon.png"))
	Keymaps = {
		up = { "up", "w", "k" },
		down = { "down", "s", "j" },
		left = { "left", "a", "h" },
		right = { "right", "d", "l" },
		undo = { "shift", "tab", "z", "u" },
		save = { "pageup", "[" },
		load = { "pagedown", "]" },
	}
	math.randomseed(os.time())
	Gameboard = Board:new()
	--[[for k, v in pairs(Colours.tile) do
		print("set:", k, "[", v[1], v[2], v[3], "]")
	end]]
	--
end

function love.draw()
	local drawnboard = Gameboard.draw(Gameboard)
	Render_board_to_screen(drawnboard)
	--love.graphics.print("2048", 32, 32)
end

function love.update(dt)
	if Gameboard.dead then
		Gameboard.deadtimer = Gameboard.deadtimer + dt
	end
end

function Render_board_to_screen(drawnboard)
	local boardscale = 1
	local winsize = {
		x = love.graphics.getWidth(),
		y = love.graphics.getHeight(),
	}
	local boardsize = {
		x = drawnboard:getWidth(),
		y = drawnboard:getHeight(),
	}
	-- fine to get it like this, should be symmetrical
	if boardsize.x > winsize.x then
		boardscale = boardsize.x / winsize.x
	end
	if boardsize.y > winsize.y then
		if boardscale < boardsize.y / winsize.y then
			boardscale = boardsize.y / winsize.y
		end
	end
	love.graphics.draw(
		drawnboard,
		winsize.x / 2,
		winsize.y / 2,
		0,
		1 / boardscale,
		1 / boardscale,
		boardsize.x / 2,
		boardsize.y / 2
	)
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
	elseif Check_in_table(Keymaps.undo, key) then
		Gameboard:undo()
	elseif key == "r" then
		Gameboard = Board:new()
	elseif Check_in_table(Keymaps.save, key) then
		Gameboard:save()
	elseif Check_in_table(Keymaps.load, key) then
		Gameboard:load()
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
