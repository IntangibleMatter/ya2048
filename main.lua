function love.load()
	require("palette")
	require("board")
	Init_colours()
	love.graphics.setNewFont("arcon.otf", 64)
	love.window.setMode(1024, 1024, { minwidth = 256, minheight = 256, resizable = true })
	love.graphics.setDefaultFilter("linear", "linear")
	love.window.setTitle("Yet Another 2048")
	board = Board:new()
	for k, v in pairs(Colours.tile) do
		print("set:", k, "[", v[1], v[2], v[3], "]")
	end
end

function love.draw()
	board.draw(board)
	--love.graphics.print("2048", 32, 32)
end

function love.keypressed(key)
	if key == "up" then
		board:move("up")
	elseif key == "down" then
		board:move("down")
	elseif key == "left" then
		board:move("left")
	elseif key == "right" then
		board:move("right")
	elseif key == "r" then
		board = Board:new()
	end
end
