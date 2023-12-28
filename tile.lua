function Draw_tile(value, pos, size, margin)
	if value < 2 then
		return
	end
	local function draw_text(text)
		local width = love.graphics.getFont():getWidth(text)
		local scale = 1
		local textpos = {
			x = (size / 2 + margin / 2) + ((pos.x - 1) * size),
			y = (size / 2 + margin / 2) + ((pos.y - 1) * size),
		}
		if width > size then
			scale = size / width
		end
		local height = love.graphics.getFont():getHeight()
		local origin = {
			x = (width * scale) / 2,
			y = (height * scale) / 2,
		}
		love.graphics.setColor(Colours.text)
		love.graphics.print(text, textpos.x, textpos.y, 0, scale, scale, origin.x, origin.y)
	end

	love.graphics.setColor(Colours.tile["c" .. tostring(math.min(value, 8192))])
	love.graphics.rectangle("fill", (pos.x - 1) * size + margin / 2, (pos.y - 1) * size + margin / 2, size, size)

	draw_text(tostring(value))
end
