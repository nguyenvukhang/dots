--
-- https://github.com/prettier/vim-prettier
--

-- what a good life would look like:
vim.g['prettier#config#semi'] = false
vim.g['prettier#config#single_quote'] = true
vim.g['prettier#config#print_width'] = 80
-- but let's go with the defaults
-- vim.g['prettier#config#semi'] = true
-- vim.g['prettier#config#single_quote'] = false

local remaps = function()
  local remap = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }
  -- remap('n', '<Leader>p', ':Prettier<CR>', opts)
end

remaps()
