Colours = {
	text = {},
	bg = {},
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
	catppucin = {},
	tokyonight = {},
	nord = {},
}

function Init_colours()
	Palettes.tokyonight = {
		bg = Hex2col("222436"),
		text = Hex2col("c8d3f5"),
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

	Set_palette(Palettes.tokyonight)
end

function Set_palette(pal)
	Text = pal.text
	Bg = pal.bg
end

function Hex2col(hex)
	local col = {}
	if string.len(hex) < 6 then
		return { 0, 0, 0, 0 }
	end
	table.insert(col, tonumber(string.sub(hex, 1, 2), 16))
	table.insert(col, tonumber(string.sub(hex, 3, 4), 16))
	table.insert(col, tonumber(string.sub(hex, 5, 6), 16))
	if string.len(hex) >= 8 then
		col.insert(tonumber(string.sub(hex, 7, 8), 16))
	else
		col.insert(0)
	end

	return col
end

function draw_pallette(position, pal) end
