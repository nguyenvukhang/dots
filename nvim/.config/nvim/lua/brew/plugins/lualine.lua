--
-- https://github.com/nvim-lualine/lualine.nvim
--

local colors = require("brew.core").colors

local bg = colors.bg1
local s = {
	a = { bg = bg, fg = colors.white },
	b = { bg = bg, fg = colors.gray },
	c = { bg = bg, fg = colors.fg4 },
}
local theme = {
	command = s,
	normal = s,
	inactive = s,
	insert = s,
	replace = s,
	terminal = s,
	visual = s,
}

local function wordCount()
	local chars = tostring(vim.fn.wordcount().chars)
	local words = tostring(vim.fn.wordcount().words)
	return "words " .. words .. " | chars " .. chars
end

local function get_filename()
	local data = vim.fn.expand("%:~:.")
	if vim.bo.modified then
		data = data .. "[+]"
	elseif vim.bo.modifiable == false or vim.bo.readonly == true then
		data = data .. "[-]"
	end
	return data
end

local setup = function()
	-- makes the statusbar consistent through vim splits
	vim.cmd("hi StatusLine guifg=" .. bg)

	-- setup
	require("lualine").setup({
		options = {
			path = 1,
			icons_enabled = false,
			component_separators = "", -- within each component
			section_separators = "", -- across sections
			theme = theme,
		},
		sections = {
			lualine_a = { get_filename },
			lualine_b = { "branch" },
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = { get_filename },
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
	})
end

setup()
