--
-- https://github.com/terrortylor/nvim-comment
--

local remaps = function()
	local remap = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }
	-- note that vim registers <C-/> as <C-_>
	remap("n", "<C-c>", ":CommentToggle<CR>", opts)
	remap("v", "<C-c>", ":CommentToggle<CR>", opts)
end

local setup = function()
	require("nvim_comment").setup({ create_mappings = false })
end

setup()
remaps()
