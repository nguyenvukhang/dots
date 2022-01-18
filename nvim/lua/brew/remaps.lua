local re = function(mode, press, ex, sil)
  sil = not(sil or false)
  local opts = { noremap = true, silent = sil }
  vim.api.nvim_set_keymap(mode, press, ex, opts)
end

-- no-ops
re('n', '<Space>', '<Nop>')
re('n', '<BS>', '<Nop>')
re('n', 'Q', '<Nop>')
re('n', 'K', '<Nop>')
re('n', '<Left>', '<Nop>')
re('n', '<Right>', '<Nop>')
re('n', '<Up>', '<Nop>')
re('n', '<Down>', '<Nop>')

-- set leader to <Space>
vim.g.mapleader = ' '

-- base res (no plugin dependencies)
re('n', '<Leader><CR>', ':so $MYVIMRC<CR>', true)
-- re('n', '<Leader>ev', ':e '..conf..'init.lua<CR>')

-- goodbye hjkl
-- re('n', 'j', ':echo "slip and slide, bruh"<CR>')
-- re('n', 'k', ':echo "slip and slide, bruh"<CR>')

-- zm to close fold softly
-- re('n', 'zc', 'zm')
-- re('n', 'zm', 'zc')

re('n', 'H', '^')
re('n', 'L', '$')
re('v', 'H', '^')
re('v', 'L', '$')
re('n', 'gF', ':vs <cfile><CR>')
re('n', '<C-d>', '12j0zz')
re('n', '<C-u>', '12k0zz')

re('n', '<C-j>', ':cnext<CR>', true)
re('n', '<C-k>', ':cprev<CR>', true)
re('n', '<Leader>7', ':set colorcolumn=71<CR>')
re('n', '<Leader>8', ':set colorcolumn=81<CR>')

-- yank to clipboard
re('n', '<Leader>y', '"+y')
re('v', '<Leader>y', '"+y')

re('n', '<Leader><up>', ':vert res +5<CR>')
re('n', '<Leader><down>', ':vert res -5<CR>')

-- functions
re('n', '<Leader>x', ':%bdelete|edit #|normal `"', true)
re('n', '<Leader>c', ':ColorizerToggle<CR>', true)
re('n', '<Leader>t', ':lua require("brew").functions.Todolist()<CR>')
re('n', '<Leader>o', ':lua require("brew").functions.ToggleQuickFix()<CR>')
re('n', '<Leader>O', ':lua require("brew").functions.ToggleLocalList()<CR>')
-- re('n', '<Leader>h', ':lua require("brew").functions.SplitJump("h")<CR>')
-- re('n', '<Leader>l', ':lua require("brew").functions.SplitJump("l")<CR>')
re('n', '<Leader>pt', ':lua require("brew").functions.DevelopmentTest()<CR>')
re('n', '<Leader>d', ':lua require("brew.diagnostics").diagnostics()<CR>')

re('n', '<Leader>h', ':wincmd h<CR>')
re('n', '<Leader>l', ':wincmd l<CR>')

re('n', '<Leader>j', ':wincmd j<CR>')
re('n', '<Leader>k', ':wincmd k<CR>')

-- replace in buffer
re('n', '<Leader>rb', 'yiw:%s/<C-r>"//g<left><left>', true)

-- replace in line
re('n', '<Leader>rl', 'yiw:s/<C-r>"//g<left><left>', true)

re('v', '<C-r>', 'y:%s/<C-r>"//g<left><left>', true)
re('v', '*', 'y/<C-r>"<CR>')

re('n', '<F1>', ':syntax sync fromstart<CR>', true)
re('n', '<F5>', ':setlocal spell!<CR>:set spell?<CR>', true)


