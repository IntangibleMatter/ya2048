Board = {
	require("lib.tween"),
	board = { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } },
	movelength = 0.2,
	pos = { x = 0, y = 0 },
	tilesize = 64,
	boardsize = 4,
	tilemargin = 2,
	drawboardsize = 0,
}

function Board:new()
	self.drawboardsize = self.tilesize * self.boardsize + self.tilemargin * self.boardsize
end

function Board:move(dir)
	local function moveup(board)
		for i = self.boardsize, 2, -1 do
			for y = 2, i do
				for x = 1, self.boardsize do
					if board[x][y - 1] == 0 then
						board[x][y - 1] = board[x][y]
						board[x][y] = 0
					elseif board[x][y - 1] == board[x][y] then
						board[x][y - 1] = board[x][y] * 2
						board[x][y] = 0
					end
					print(board[x][y])
				end
			end
		end
	end

	local function movedown(board)
		for i = 1, self.boardsize - 1 do
			for y = i, self.boardsize - 1 do
				for x = 1, self.boardsize do
					if board[x][y + 1] == 0 then
						board[x][y + 1] = board[x][y]
						board[x][y] = 0
					elseif board[x][y + 1] == board[x][y] then
						board[x][y + 1] = board[x][y] * 2
					end
				end
			end
		end
	end

	local function moveleft(board)
		for i = self.boardsize, 2, -1 do
			for x = 2, i, -1 do
				for y = 1, self.boardsize do
					print(board[x][y])
				end
			end
		end
	end

	local function moveright(board)
		for i = 1, self.boardsize do
			for x = i, self.boardsize - 1 do
				for y = 1, self.boardsize do
					print(board[x][y])
				end
			end
		end
	end

	if dir == "up" then
		moveup(self.board)
	elseif dir == "down" then
		movedown(self.board)
	elseif dir == "left" then
		moveleft(self.board)
	elseif dir == "right" then
		moveright(self.board)
	end
end

function Board:draw()
	love.graphics.setColor(Colours.board_bg)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.drawboardsize, self.drawboardsize)
	for x = 1, self.boardsize do
		for y = 1, self.boardsize do
			love.graphics.setColor(Colours.tile_bg)
			love.graphics.rectangle(
				"fill",
				(x - 1) * self.tilesize + self.tilemargin / 2,
				(y - 1) * self.tilesize + self.tilemargin / 2,
				self.tilesize,
				self.tilesize
			)
			draw_tile(self.board[x][y], { x = x, y = y }, self.tilesize, self.tilemargin)
		end
	end
end
