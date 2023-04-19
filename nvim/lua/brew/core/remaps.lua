local c = require('brew.core')
local nnoremap, vnoremap, inoremap = c.nnoremap, c.vnoremap, c.inoremap

-- no-ops
nnoremap('<space>', '<nop>')
nnoremap('<bs>', '<nop>')
nnoremap('Q', '<nop>')
nnoremap('K', '<nop>')
nnoremap('<left>', '<nop>')
nnoremap('<right>', '<nop>')
nnoremap('<up>', '<nop>')
nnoremap('<down>', '<nop>')

-- the only right way to setup H and L
nnoremap('H', '^')
nnoremap('L', '$')
vnoremap('H', '^')
vnoremap('L', '$')

-- non-disruptive join
nnoremap('J', 'mZJ`Z')

-- open file under cursor in a split
nnoremap('gF', ':vs <cfile><cr>')

-- open file under cursor with `open` (macOS)
nnoremap('go', ':silent! !open <cfile><cr>')

-- slowly increase this until I can use the default
nnoremap('<C-d>', '13j')
nnoremap('<C-u>', '13k')

-- quickfix list navigation
nnoremap('<C-j>', ':cnext<cr>')
nnoremap('<C-k>', ':cprev<cr>')

-- color columns
nnoremap('<leader>6', ':set colorcolumn=61<cr>')
nnoremap('<leader>7', ':set colorcolumn=71<cr>')
nnoremap('<leader>8', ':set colorcolumn=81<cr>')
nnoremap('<leader>0', ':set colorcolumn=<cr>')

-- yank to clipboard (confirmed to work on mac)
nnoremap('<leader>y', '"+y')
vnoremap('<leader>y', '"+y')

-- split jumping
nnoremap('<leader>h', ':wincmd h<cr>')
nnoremap('<leader>l', ':wincmd l<cr>')
nnoremap('<leader>j', ':wincmd j<cr>')
nnoremap('<leader>k', ':wincmd k<cr>')

-- replace in buffer
nnoremap('<leader>rb', 'yiw:%s/<C-r>"//g<left><left>', true)

-- replace in line
nnoremap('<leader>rl', 'yiw:s/<C-r>"//g<left><left>', true)

-- replace visual selection
vnoremap('<C-r>', 'y:%s/<C-r>"//g<left><left>', true)

-- reverse (flip) visual lines
vnoremap('<C-f>', "<esc>'<km<'>:'<,.g/^/m '><CR>")

-- sort visual lines
vnoremap('<C-s>', ':sort<CR>')

-- search visual selection
vnoremap('*', 'y/<C-r>"<cr>', true)

-- refresh syntax highlighting
nnoremap('<f1>', ':syntax sync fromstart<cr>', true)
nnoremap('<leader>ph', ':syntax sync fromstart<CR>', true)

-- toggle spell check
nnoremap('<f5>', ':setlocal spell!<cr>:set spell?<cr>', true)

-- vim functions
nnoremap('<leader>x', ':CloseOtherBuffers', true)
nnoremap('<leader>c', ':ColorizerToggle<cr>', true)

-- lua functions
nnoremap('<leader>o', c.toggle_qflist)
nnoremap('<leader>d', c.toggle_diagnostics)

-- to copy the behavior of `[(` and `[{` to `[[`
nnoremap('[[', function() vim.fn.searchpair('\\[', '', '\\]', 'b') end)
nnoremap(']]', function() vim.fn.searchpair('\\[', '', '\\]') end)

-- diagnostics
nnoremap('<leader>e', vim.diagnostic.open_float, true)
nnoremap('<leader>p', ':Neoformat<CR>', true)
inoremap('<S-Tab>', '<C-V><Tab>', false)

-- fold markers
nnoremap('<leader>zz', 'o{{{}}}<esc>:CommentToggle<CR>^f}i  <left>', false)
