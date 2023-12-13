local c = require('brew')
local o, bo = vim.opt, vim.bo

local dollarDollar = function()
  c.onoremap('i$', ':<c-u>norm! T$vt$<cr>')
  c.onoremap('a$', ':<c-u>norm! F$vf$<cr>')
  c.vnoremap('i$', 'T$ot$')
  c.vnoremap('a$', 'F$of$')
end

local cfg = {
  java = function()
    o.tabstop, o.shiftwidth = 4, 4
  end,
  latex = function()
    o.textwidth, bo.filetype = 80, 'tex'
    o.formatoptions = o.formatoptions + 't'
    c.nnoremap("<leader>be", "cc\\begin{equation*}<CR><CR>\\end{equation*}<esc>k")
    c.nnoremap("<leader>ba", "cc\\begin{align*}<CR><CR>\\end{align*}<esc>k")
    c.nnoremap("<leader>br", "cc\\begin{array}<CR><CR>\\end{array}<esc>k")
    c.nnoremap("<leader>bc", "cc\\begin{cases}<CR><CR>\\end{cases}<esc>k")
    dollarDollar()
  end,
  markdown = function()
    o.textwidth, bo.filetype = 70, 'markdown'
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

-- c.autocmd({
--   pattern = { '*.tex' },
--   callback = function() vim.fn.systemlist('make') end,
-- }, { 'BufWritePost' })

-- automatically redistribute splits when vim is resized
c.autocmd({ command = 'wincmd =' }, { 'VimResized' })
