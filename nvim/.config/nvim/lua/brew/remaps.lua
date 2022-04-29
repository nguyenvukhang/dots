local sessions_path = require("brew.core").env.conf .. "/data/sessions"

local opts = { noremap = true, silent = true }

local set_keymap = function(...)
	vim.api.nvim_set_keymap(...)
end
