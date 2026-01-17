local c = require('brew.server.utils')
local k = vim.keymap.set
local s = { silent = true }

-- no-ops
k('n', '<space>', '<nop>')
k('n', '<bs>', '<nop>')
k('n', 'Q', '<nop>')
k('n', 'K', '<nop>')
k('n', '<left>', '<nop>')
k('n', '<right>', '<nop>')
k('n', '<up>', '<nop>')
k('n', '<down>', '<nop>')

-- remap Shift + Tab to actually give a tab char
k('i', '<S-Tab>', '<C-V><Tab>')

-- the only right way to setup H and L
k('n', 'H', '^')
k('n', 'L', '$')
k('v', 'H', '^')
k('v', 'L', '$')

-- open file under cursor in a split
-- k('n', 'gF', ':vs <cfile><cr>', s)

-- open file under cursor with `open` (macOS)
k('n', 'go', ':!open <cfile><cr>', s)

-- slowly increase this until I can use the default
k('n', '<C-d>', '13j', s)
k('n', '<C-u>', '13k', s)
k('v', '<C-d>', '13j', s)
k('v', '<C-u>', '13k', s)

-- quickfix list navigation
k('n', '<C-j>', ':cnext<cr>', s)
k('n', '<C-k>', ':cprev<cr>', s)

-- color columns
k('n', '<leader>7', ':set colorcolumn=71<cr>', s)
k('n', '<leader>8', ':set colorcolumn=81<cr>', s)

-- yank to clipboard (confirmed to work on mac)
k('n', '<leader>y', '"+y')
k('v', '<leader>y', '"+y')

-- Yank the entire buffer to clipboard
k('n', '<leader>Y', 'gg"+yG<c-o>')

-- split jumping
k('n', '<leader>h', ':wincmd h<cr>', s)
k('n', '<leader>l', ':wincmd l<cr>', s)
k('n', '<leader>j', ':wincmd j<cr>', s)
k('n', '<leader>k', ':wincmd k<cr>', s)

-- replace in buffer
-- :%s/\<foo\>/bar/g
k('n', '<leader>rb', ':%s/<C-r><C-w>//g<left><left>')
k('n', '<leader>rB', ':%s/\\<<C-r><C-w>\\>//g<left><left>')

-- replace in line
k('n', '<leader>rl', ':s/<C-r><C-w>//g<left><left>')
k('n', '<leader>rL', ':s/\\<<C-r><C-w>\\>//g<left><left>')

-- reverse (flip) visual lines
k('v', '<C-f>', "<esc>'<V'><esc>'<O<esc>m<'>:'<,.g/^/m '><CR>'<dd")

-- sort visual lines
k('v', '<C-s>', ':sort<CR>')

-- search visual selection
k('v', '*', 'y/<C-r>"<cr>')

-- refresh syntax highlighting
k('n', '<f1>', ':syntax sync fromstart<cr>')
k('n', '<leader>ph', ':syntax sync fromstart<CR>')

-- toggle spell check
k('n', '<f5>', ':setlocal spell!<cr>:set spell?<cr>')

-- vim functions
k('n', '<leader>c', ':ColorizerToggle<cr>')

-- lua functions
k('n', '<leader>o', c.toggle_qflist)
k('n', '<leader>d', c.toggle_local_diagnostics)
k('n', '<leader>D', c.toggle_local_errors)

-- to copy the behavior of `[(` and `[{` to `[[`
k('n', '[[', function() vim.fn.searchpair('\\[', '', '\\]', 'b') end)
k('n', ']]', function() vim.fn.searchpair('\\[', '', '\\]') end)

-- diagnostics
k('n', '<leader>e', vim.diagnostic.open_float)
-- k('n', '<leader>p', ':Neoformat<CR>')
k('n', '<leader>p', function()
  local cf = require('conform')
  local fmt = vim.tbl_map(function(t) return t.name end, cf.list_formatters())
  if vim.tbl_isempty(fmt) then
    return print('No formatters defined for this filetype.')
  end
  print('[fmt]', table.concat(fmt, ', '))
  cf.format { async = true }
end)

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
end)
--]]

-- Load current buffer into quickfix list.
k('n', '<leader>Q', function()
  local tbl = {}
  local buf = vim.api.nvim_get_current_buf()
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local _, _, filename, lnum, text = line:find('(.*):(%d+):(.*)')
    table.insert(
      tbl,
      { filename = filename, lnum = tonumber(lnum), text = text }
    )
  end
  vim.fn.setqflist(tbl)
end, s)
