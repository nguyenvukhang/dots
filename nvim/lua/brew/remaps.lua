local c = require('brew')
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

-- remap Shift + Tab to actually give a tab char
inoremap('<S-Tab>', '<C-V><Tab>')

-- the only right way to setup H and L
nnoremap('H', '^')
nnoremap('L', '$')
vnoremap('H', '^')
vnoremap('L', '$')

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
nnoremap('<leader>7', ':set colorcolumn=71<cr>')
nnoremap('<leader>8', ':set colorcolumn=81<cr>')

-- yank to clipboard (confirmed to work on mac)
nnoremap('<leader>y', '"+y')
vnoremap('<leader>y', '"+y')

-- Yank the entire buffer to clipboard
nnoremap('<leader>Y', 'gg"+yG<c-o>')

-- preserve yank buffer on Visual Mode paste
vnoremap('<leader>p', '"_dP')

-- split jumping
nnoremap('<leader>h', ':wincmd h<cr>')
nnoremap('<leader>l', ':wincmd l<cr>')
nnoremap('<leader>j', ':wincmd j<cr>')
nnoremap('<leader>k', ':wincmd k<cr>')

-- replace in buffer
-- :%s/\<foo\>/bar/g
nnoremap('<leader>rb', ':%s/<C-r><C-w>//g<left><left>', true)
nnoremap('<leader>rB', ':%s/\\<<C-r><C-w>\\>//g<left><left>', true)

-- replace in line
nnoremap('<leader>rl', ':s/<C-r><C-w>//g<left><left>', true)
nnoremap('<leader>rL', ':s/\\<<C-r><C-w>\\>//g<left><left>', true)

-- reverse (flip) visual lines
vnoremap('<C-f>', "<esc>'<V'><esc>'<O<esc>m<'>:'<,.g/^/m '><CR>'<dd")

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

--[[
vim.keymap.set('n', '*', function()
  local line, r = vim.fn.getline('.'), vim.fn.col('.')
  local want = function(x) return x == 46 or (48 <= x and x <= 57) end
  if not want(line:byte(r)) then return c.search(vim.fn.expand('<cword>')) end
  local l, n = r, line:len()
  while l > 1 and want(line:byte(l - 1)) do
    l = l - 1
  end
  while r < n and want(line:byte(r + 1)) do
    r = r + 1
  end
  local query = line:sub(l, r)
  if query:match('[0-9]+%.[0-9]+%.[0-9]+') then
    return c.search(query:gsub('%.', '\\.'))
  else
    return c.search(vim.fn.expand('<cword>'))
  end
end, { noremap = true })
--]]
