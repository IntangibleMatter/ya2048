function love.load()
	love.graphics.setNewFont("arcon.otf", 64)
	love.window.setMode(1024, 1024, { minwidth = 256, minheight = 256 })
	love.graphics.setDefaultFilter("linear", "linear")
	love.graphics.setCanvas()
	love.window.setTitle("Yet Another 2048")
end

function love.draw()
	love.graphics.print("2048", 32, 32)
end
