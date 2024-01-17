local c = require('brew')
local k = vim.keymap.set

local dollarDollar = function()
  k('o', 'i$', ':<c-u>norm! T$vt$<cr>', { silent = true })
  k('o', 'a$', ':<c-u>norm! F$vf$<cr>', { silent = true })
  k('v', 'i$', 'T$ot$', { silent = true })
  k('v', 'a$', 'F$of$', { silent = true })
end

local cfg = {
  java = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
  end,
  latex = function()
    vim.opt.textwidth = 80
    vim.opt.formatoptions = vim.opt.formatoptions + 't'
    vim.bo.filetype = 'tex'
    k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k')
    k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k')
    k('n', '<leader>br', 'cc\\begin{array}<CR>\\end{array}<esc>k')
    k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k')
    k('n', '<leader>bp', 'cc\\begin{proof}<CR>\\end{proof}<esc>k')
    dollarDollar()
  end,
  markdown = function()
    vim.opt.textwidth = 70
    vim.bo.filetype = 'markdown'
    dollarDollar()
  end,
  cpp = function() c.comment_string('// %s') end,
  swift = function() c.comment_string('// %s') end,
  astro = function() c.comment_string('// %s') end,
}

c.autocmd { pattern = '*.tex', callback = cfg.latex }
c.autocmd { pattern = { '*.swift' }, callback = cfg.swift }
c.autocmd { pattern = { '*.mdx', '*.md' }, callback = cfg.markdown }
c.autocmd { pattern = { '*.java' }, callback = cfg.java }
c.autocmd { pattern = { '*.cpp', '*.h', '*.c', '*.cc' }, callback = cfg.cpp }
c.autocmd { pattern = { '*.astro' }, callback = cfg.astro }

-- automatically redistribute splits when vim is resized
c.autocmd({ command = 'wincmd =' }, { 'VimResized' })
