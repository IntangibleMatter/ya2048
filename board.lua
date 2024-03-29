Board = {
	require("lib.tween"),
	require("tile"),
	board = { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } },
	movelength = 0.2,
	pos = { x = 0, y = 0 },
	tilesize = 96,
	boardsize = 5,
	tilemargin = 8,
	drawboardsize = 0,
	changetimer = 0,
	changes = {},
	movingboard = {},
	dead = false,
	deadtimer = 0,
	boardhistory = {},
}

function Board:new()
	local b = {}
	setmetatable(b, { __index = Board })
	b.boardhistory = {}
	b.changetimer = 0
	b.deadtimer = 0
	b.board = {}
	for x = 1, b.boardsize do
		b.board[x] = {}
		for y = 1, b.boardsize do
			b.board[x][y] = 0
		end
	end
	b.drawboardsize = self.tilesize * self.boardsize + self.tilemargin * (self.boardsize + 1)
	b.spawn_tile(b)
	b.spawn_tile(b)
	--Print_table(b)
	--Print_table(b.board)
	return b
end

function Board:move(dir)
	local function moveup(board, movement)
		local moved = 0
		local combined = {}
		for x = 1, self.boardsize do
			for y = 2, self.boardsize do
				if board[x][y] ~= 0 then
					local depth = -1
					for yy = y - 1, 1, -1 do
						if board[x][yy] == 0 or board[x][yy] == board[x][y] then
							depth = yy
						else
							break
						end
					end
					if depth ~= -1 then
						if Check_in_table(combined, { x = x, y = depth }) then
							board[x][depth + 1] = board[x][y]
						elseif board[x][depth] == board[x][y] then
							board[x][depth] = board[x][y] * 2
							table.insert(combined, { x = x, y = depth })
						else
							board[x][depth] = board[x][y]
						end
						board[x][y] = 0
						moved = moved + 1
						table.insert(movement, { from = { x = x, y = y }, to = { x = x, y = depth } })
					end
				end
			end
		end
		return moved ~= 0
	end

	local function movedown(board, movement)
		local moved = 0
		local combined = {}
		for x = 1, self.boardsize do
			for y = self.boardsize - 1, 1, -1 do
				if board[x][y] ~= 0 then
					local depth = -1
					for yy = y + 1, self.boardsize do
						if board[x][yy] == 0 or board[x][yy] == board[x][y] then
							depth = yy
						else
							break
						end
					end
					if depth ~= -1 then
						if Check_in_table(combined, { x = x, y = depth }) then
							board[x][depth - 1] = board[x][y]
						elseif board[x][depth] == board[x][y] then
							board[x][depth] = board[x][y] * 2
							table.insert(combined, { x = x, y = depth })
						else
							board[x][depth] = board[x][y]
						end
						board[x][y] = 0
						moved = moved + 1
						table.insert(movement, { from = { x = x, y = y }, to = { x = x, y = depth } })
					end
				end
			end
		end
		return moved ~= 0
	end

	local function moveleft(board, movement)
		local moved = 0
		local combined = {}
		for y = 1, self.boardsize do
			for x = 2, self.boardsize do
				if board[x][y] ~= 0 then
					local depth = -1
					for xx = x - 1, 1, -1 do
						if board[xx][y] == 0 or board[xx][y] == board[x][y] then
							depth = xx
						else
							break
						end
					end
					if depth ~= -1 then
						if Check_in_table(combined, { x = depth, y = y }) then
							board[depth + 1][y] = board[x][y]
						elseif board[depth][y] == board[x][y] then
							board[depth][y] = board[x][y] * 2
							table.insert(combined, { x = depth, y = y })
						else
							board[depth][y] = board[x][y]
						end
						board[x][y] = 0
						moved = moved + 1
						table.insert(movement, { from = { x = x, y = y }, to = { x = depth, y = y } })
					end
				end
			end
		end
		return moved ~= 0
	end

	local function moveright(board, movement)
		local moved = 0
		local combined = {}
		for y = 1, self.boardsize do
			for x = self.boardsize - 1, 1, -1 do
				if board[x][y] ~= 0 then
					local depth = -1
					for xx = x + 1, self.boardsize do
						if board[xx][y] == 0 or board[xx][y] == board[x][y] then
							depth = xx
						else
							break
						end
					end
					if depth ~= -1 then
						if Check_in_table(combined, { x = depth, y = y }) then
							board[depth - 1][y] = board[x][y]
						elseif board[depth][y] == board[x][y] then
							board[depth][y] = board[x][y] * 2
							table.insert(combined, { x = depth, y = y })
						else
							board[depth][y] = board[x][y]
						end
						board[x][y] = 0
						moved = moved + 1
						table.insert(movement, { from = { x = x, y = y }, to = { x = depth, y = y } })
					end
				end
			end
		end
		return moved ~= 0
	end

	local changed = false
	self.changes = {}

	if dir == "up" then
		changed = moveup(self.board, self.changes)
	elseif dir == "down" then
		changed = movedown(self.board, self.changes)
	elseif dir == "left" then
		changed = moveleft(self.board, self.changes)
	elseif dir == "right" then
		changed = moveright(self.board, self.changes)
	end
	if changed then
		self:spawn_tile()
		self:add_to_history()
		--self.changetimer = self.movelength
		--self.copy_to_moving_board(self)
		if self:check_if_dead() then
			self.dead = true
		end
	end
end

function Board:draw()
	local drawing = love.graphics.newCanvas(self.drawboardsize, self.drawboardsize)
	love.graphics.setCanvas(drawing)
	love.graphics.setColor(Colours.board_bg)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.drawboardsize, self.drawboardsize)
	if self.changetimer > 0 then
		self.draw_moving_tiles(self)
	else
		self.draw_tiles(self)
	end
	if self.dead then
		love.graphics.setColor(
			Colours.board_bg[1],
			Colours.board_bg[2],
			Colours.board_bg[3],
			(math.min(self.deadtimer - 1, 2) / 2)
		)
		love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.drawboardsize, self.drawboardsize)
		love.graphics.setColor(Colours.text)
		love.graphics.print(
			"GAME\nOVER",
			self.drawboardsize / 2,
			self.drawboardsize / 2,
			0,
			2,
			2,
			love.graphics.getFont():getWidth("GAME\nOVER") / 2,
			love.graphics.getFont():getHeight()
		)
	end
	love.graphics.setCanvas()
	return drawing
end

function Board:draw_moving_tiles()
	-- for tile in table.
end

function Board:copy_to_moving_board()
	Print_table(self.board)
	self.movingboard = {}
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			print(x, y, self.board[x][y])
			table.insert(self.movingboard, { x = x, y = y, self.board[x][y] })
		end
	end
end

function Board:draw_tiles()
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			love.graphics.setColor(Colours.tile_bg)
			love.graphics.rectangle(
				"fill",
				((x - 1) * self.tilesize) + (self.tilemargin * x),
				((y - 1) * self.tilesize) + (self.tilemargin * y),
				self.tilesize,
				self.tilesize
			)
		end
	end
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			if self.board[x][y] ~= 0 then
				Draw_tile(self.board[x][y], { x = x, y = y }, self.tilesize, self.tilemargin)
			end
		end
	end
end

function Board:spawn_tile()
	local free_tiles = {}

	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			if self.board[x][y] == 0 then
				table.insert(free_tiles, { x = x, y = y })
			end
		end
	end
	if free_tiles ~= {} then
		local tile = free_tiles[math.random(#free_tiles)]
		local value = 2
		if math.random() > 0.9 then
			value = 4
		end
		self.board[tile.x][tile.y] = value
	end
end

function Board:check_if_dead()
	local free_moves = 0
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			if x - 1 >= 1 then
				if self.board[x - 1][y] == self.board[x][y] or self.board[x - 1][y] == 0 then
					free_moves = free_moves + 1
				end
			end
			if x + 1 <= self.boardsize then
				if self.board[x + 1][y] == self.board[x][y] or self.board[x + 1][y] == 0 then
					free_moves = free_moves + 1
				end
			end
			if y - 1 >= 1 then
				if self.board[x][y - 1] == self.board[x][y] or self.board[x][y - 1] == 0 then
					free_moves = free_moves + 1
				end
			end
			if y + 1 <= self.boardsize then
				if self.board[x][y + 1] == self.board[x][y] or self.board[x][y + 1] == 0 then
					free_moves = free_moves + 1
				end
			end
		end
	end
	return free_moves == 0
end

function Board:copy_board()
	local newboard = {}

	for _, v in pairs(self.board) do
		local boardelement = {}
		for _, v in pairs(v) do
			table.insert(boardelement, v)
		end
		table.insert(newboard, boardelement)
	end
	return newboard
end

function Board:add_to_history()
	table.insert(self.boardhistory, self.copy_board(self))
end

function Board:undo()
	if #self.boardhistory > 1 then
		self.board = self.boardhistory[#self.boardhistory - 1]
		table.remove(self.boardhistory, #self.boardhistory)
		if self.dead then
			self.dead = false
			self.deadtimer = 0
		end
	end
end

function Board:save()
	local savedata = ""
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			savedata = savedata .. self.board[x][y] .. " "
		end
		savedata = savedata .. "\n"
	end
	love.filesystem.write("board.2048", savedata)
	--	love.filesystem.write("history.2048", self.boardhistory)
end

function Board:load()
	local savedata = love.filesystem.read("board.2048")
	self.board = {}
	self.boardhistory = {}
	for s in savedata:gmatch("(.-)\n") do
		table.insert(self.board, {})
		print("---", s, "---")
		for t in s:gmatch("(.-) ") do
			print("+++", t, "+++")
			if t ~= "" then
				table.insert(self.board[#self.board], tonumber(t))
			end
		end
	end
	Print_table(self.board)
end
