local c = require('brew.core')
local vnoremap, onoremap, autocmd = c.vnoremap, c.onoremap, c.autocmd

local dollarDollar = function()
  onoremap('i$', ':<c-u>norm! T$vt$<cr>')
  onoremap('a$', ':<c-u>norm! F$vf$<cr>')
  vnoremap('i$', 'T$ot$')
  vnoremap('a$', 'F$of$')
end

local cfg = {
  java = function()
    vim.opt.tabstop, vim.opt.shiftwidth = 4, 4
  end,
  latex = function()
    vim.opt.textwidth = 70
    dollarDollar()
  end,
  markdown = function()
    vim.bo.filetype = 'markdown'
    vim.opt.textwidth = 70
    dollarDollar()
  end,
  cpp = function() c.comment_string('// %s') end,
  swift = function() c.comment_string('// %s') end,
  astro = function() c.comment_string('// %s') end,
}

autocmd { pattern = '*.tex', callback = cfg.latex }
autocmd { pattern = { '*.swift' }, callback = cfg.swift }
autocmd { pattern = { '*.mdx', '*.md' }, callback = cfg.markdown }
autocmd { pattern = { '*.java' }, callback = cfg.java }
autocmd { pattern = { '*.cpp', '*.h', '*.c', '*.cc' }, callback = cfg.cpp }
autocmd { pattern = { '*.astro' }, callback = cfg.astro }

-- autocmd({
--   pattern = { '*.tex' },
--   callback = function() vim.fn.systemlist('make') end,
-- }, { 'BufWritePost' })

-- automatically redistribute splits when vim is resized
autocmd({ command = 'wincmd =' }, { 'VimResized' })
