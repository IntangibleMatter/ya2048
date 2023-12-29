Colours = {
	text = {},
	screen_bg = {},
	board_bg = {},
	tile_bg = {},
	tile = {
		c2 = {},
		c4 = {},
		c8 = {},
		c16 = {},
		c32 = {},
		c64 = {},
		c128 = {},
		c256 = {},
		c512 = {},
		c1024 = {},
		c2048 = {},
		c4096 = {},
		c8192 = {},
	},
}
Palettes = {
	catppucin = {}, -- mix of mocha for base/text and latte for colours
	tokyonight = {},
	nord = {},
	dracula = {},
}

function Init_colours()
	Palettes.tokyonight = {
		screen_bg = Hex2col("24283b"),
		board_bg = Hex2col("1f2335"),
		tile_bg = Hex2col("292e42"),
		text = Hex2col("c8d3f5"),
		tile = {
			c2 = Hex2col("545c7e"),
			c4 = Hex2col("565f89"),
			c8 = Hex2col("3d59a1"),
			c16 = Hex2col("7aa2f7"),
			c32 = Hex2col("7dcfff"),
			c64 = Hex2col("bb9af7"),
			c128 = Hex2col("9d7cd8"),
			c256 = Hex2col("4fd6be"),
			c512 = Hex2col("41a6b5"),
			c1024 = Hex2col("ffc777"),
			c2048 = Hex2col("ff9e64"),
			c4096 = Hex2col("ff757f"),
			c8192 = Hex2col("ff007c"),
		},
	}
	Palettes.catppucin = {
		text = Hex2col("cdd6f4"),
		screen_bg = Hex2col("1e1e2e"),
		board_bg = Hex2col("11111b"),
		tile_bg = Hex2col("313244"),
		tile = {
			c2 = Hex2col("dc8a78"),
			c4 = Hex2col("dd7878"),
			c8 = Hex2col("ea76cb"),
			c16 = Hex2col("8839ef"),
			c32 = Hex2col("d20f39"),
			c64 = Hex2col("e64553"),
			c128 = Hex2col("fe640b"),
			c256 = Hex2col("df8e1d"),
			c512 = Hex2col("40a02b"),
			c1024 = Hex2col("179299"),
			c2048 = Hex2col("04a5e5"),
			c4096 = Hex2col("209fb5"),
			c8192 = Hex2col("1e66f5"),
		},
	}
	Palettes.nord = {
		text = Hex2col("eceff4"),
		screen_bg = Hex2col("2e3440"),
		board_bg = Hex2col("3b4252"),
		tile_bg = Hex2col("434c5e"),
		tile = {
			c2 = Hex2col("739695"),
			c4 = Hex2col("6c9d9c"),
			c8 = Hex2col("8fbcbb"),
			c16 = Hex2col("88c0d0"),
			c32 = Hex2col("81a1c1"),
			c64 = Hex2col("5e81ac"),
			c128 = Hex2col("b48ead"),
			c256 = Hex2col("a3be8c"),
			c512 = Hex2col("ebcb8b"),
			c1024 = Hex2col("d08770"),
			c2048 = Hex2col("bf616a"),
			c4096 = Hex2col("d24b56"),
			c8192 = Hex2col("d62e3f"),
		},
	}
	Palettes.dracula = {
		text = Hex2col("f8f8f2"),
		screen_bg = Hex2col("282a36"),
		board_bg = Hex2col("44475a"),
		tile_bg = Hex2col("6272a4"),
		tile = {
			c2 = Hex2col("d8df90"),
			c4 = Hex2col("e3e891"),
			c8 = Hex2col("f1fa8c"),
			c16 = Hex2col("e8c196"),
			c32 = Hex2col("eec191"),
			c64 = Hex2col("ffb86c"),
			c128 = Hex2col("50fa7b"),
			c256 = Hex2col("8be9fd"),
			c512 = Hex2col("bd93f9"),
			c1024 = Hex2col("ff79c6"),
			c2048 = Hex2col("ff5555"),
			c4096 = Hex2col("ff2929"),
			c8192 = Hex2col("ff0f0f"),
		},
	}
	Set_palette(Palettes.tokyonight)
end

function Set_palette(pal)
	Colours = pal
	love.graphics.setBackgroundColor(Colours.screen_bg)
end

function Hex2col(hex)
	local col = {}
	if string.len(hex) < 6 then
		return { 0, 0, 0, 1 }
	end
	table.insert(col, tonumber(string.sub(hex, 1, 2), 16) / 255)
	table.insert(col, tonumber(string.sub(hex, 3, 4), 16) / 255)
	table.insert(col, tonumber(string.sub(hex, 5, 6), 16) / 255)
	if string.len(hex) >= 8 then
		table.insert(col, tonumber(string.sub(hex, 7, 8), 16) / 255)
	else
		table.insert(col, 1)
	end

	return col
end

function draw_pallette(position, pal) end
