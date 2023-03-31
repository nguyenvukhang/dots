local group = vim.api.nvim_create_augroup('FILETYPES', { clear = true })
local core = require('brew.core')
local vnoremap = core.vnoremap
local onoremap = core.onoremap
local nnoremap = core.nnoremap
local git_branch = require('brew.git_branch')

local dollarDollar = function()
  -- require('nvim-autopairs').add_rule;
  onoremap('i$', ':<c-u>norm! T$vt$<cr>')
  onoremap('a$', ':<c-u>norm! F$vf$<cr>')
  vnoremap('i$', 'T$ot$')
  vnoremap('a$', 'F$of$')
end

local __LATEX__ = function()
  vim.opt.textwidth = 70
  dollarDollar()
end

local __MARKDOWN__ = function()
  vim.bo.filetype = 'markdown'
  vim.opt.textwidth = 70
  dollarDollar()
end

local __CPP__ = function()
  vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
end

local autocmd = function(events, opts)
  vim.api.nvim_create_autocmd(
    events,
    vim.tbl_extend('force', { group = group }, opts)
  )
end

local general_entry = { 'BufRead', 'BufNewFile', 'BufEnter' }

autocmd(general_entry, {
  pattern = 'kanban.md',
  callback = function() require('brew.kanban').init() end,
})

autocmd(general_entry, {
  pattern = '*.tex',
  callback = __LATEX__,
})

autocmd(general_entry, {
  pattern = { '*.cpp', '*.h', '*.c', '*.cc' },
  callback = __CPP__,
})

autocmd(general_entry, {
  pattern = { '*.mdx', '*.md' },
  callback = __MARKDOWN__,
})

autocmd(general_entry, {
  pattern = { '*.java' },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
  end,
})

autocmd({ 'BufEnter', 'FocusGained', 'BufWritePost' }, {
  callback = function()
    local set_line = function(branch)
      -- print('set branch -> [' .. branch .. ']')
      local L = '%#StatusLine# %f %h%w%m%r %#StatusLineDim#'
      local R = '%=.'
      vim.opt.statusline = L .. branch .. R
    end
    git_branch.init(set_line)
  end,
})

autocmd({ 'BufWritePost' }, {
  pattern = { '*.tex' },
  callback = function()
    vim.fn.system('pdflatex -halt-on-error ' .. vim.fn.expand('%:p'))
  end,
})

autocmd(general_entry, {
  pattern = { '*.prez' },
  callback = function()
    vim.opt.ft = 'markdown'
    vim.opt.scrolloff = 0
    __MARKDOWN__()
    nnoremap('<c-j>', '/^#\\s<CR>zt')
    nnoremap('<c-k>', '?^#\\s<CR>zt')
    -- nnoremap('<c-j>', '/\\~\\~\\~\\~\\~ \\d\\+$<CR>zt')
    -- nnoremap('<c-k>', '?\\~\\~\\~\\~\\~ \\d\\+<CR>zt')
  end,
})

-- automatically redistribute splits when vim is resized
autocmd('VimResized', { command = 'wincmd =' })
