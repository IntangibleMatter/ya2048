Board = {
	require("lib.tween"),
	require("tile"),
	board = { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } },
	movelength = 0.2,
	pos = { x = 0, y = 0 },
	tilesize = 96,
	boardsize = 4,
	tilemargin = 8,
	drawboardsize = 0,
	changetimer = 0,
	changes = {},
	movingboard = {},
}

function Board:new()
	local b = {}
	setmetatable(b, { __index = Board })
	changetimer = 0
	for x = 1, b.boardsize do
		for y = 1, b.boardsize do
			b.board[x][y] = 0
		end
	end
	b.drawboardsize = self.tilesize * self.boardsize + self.tilemargin * self.boardsize
	b.spawn_tile(b)
	b.spawn_tile(b)
	print(b.drawboardsize)
	return b
end

function Board:move(dir)
	local function moveup(board, movement)
		local moved = 0
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
						if board[x][depth] == 0 then
							board[x][depth] = board[x][y]
						else
							board[x][depth] = board[x][y] * 2
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
						if board[x][depth] == 0 then
							board[x][depth] = board[x][y]
						else
							board[x][depth] = board[x][y] * 2
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
						if board[depth][y] == 0 then
							board[depth][y] = board[x][y]
						else
							board[depth][y] = board[x][y] * 2
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
						if board[depth][y] == 0 then
							board[depth][y] = board[x][y]
						else
							board[depth][y] = board[x][y] * 2
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
		self.changetimer = self.movelength
		self.copy_to_moving_board(self)
	end
end

function Board:draw()
	love.graphics.setColor(Colours.board_bg)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.drawboardsize, self.drawboardsize)
	if self.movelength ~= 0 then
		self.draw_moving_tiles(self)
	else
		self.draw_tiles(self)
	end
end

function Board:draw_moving_tiles()
	for tile in table.
end

function Board:copy_to_moving_board()
	self.movingboard = {}
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			table.insert(self.movingboard, { x = x, y = y, board[x][y] })
		end
	end
end

function Board:draw_tiles()
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			love.graphics.setColor(Colours.tile_bg)
			love.graphics.rectangle(
				"fill",
				((x - 1) * self.tilesize) + (self.tilemargin / 2),
				((y - 1) * self.tilesize) + (self.tilemargin / 2),
				self.tilesize,
				self.tilesize
			)
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
		self.board[tile.x][tile.y] = 2
	end
end
