local c = require('brew')
local k = vim.keymap.set
local sil = { silent = true }

local dollarDollar = function()
  k('o', 'i$', ':<c-u>norm! T$vt$<cr>', sil)
  k('o', 'a$', ':<c-u>norm! F$vf$<cr>', sil)
  k('v', 'i$', 'T$ot$', sil)
  k('v', 'a$', 'F$of$', sil)
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
    dollarDollar()
    require('brew.telescope.math').overriding_remaps()
  end,
  markdown = function()
    vim.opt.textwidth = 80
    vim.bo.filetype = 'markdown'
    dollarDollar()
  end,
  cpp = function() c.comment_string('// %s') end,
  swift = function() c.comment_string('// %s') end,
  astro = function() c.comment_string('// %s') end,
  asm = function() c.comment_string('# %s') end,
}

c.autocmd { pattern = '*.tex', callback = cfg.latex }
c.autocmd { pattern = '*.asm', callback = cfg.asm }
c.autocmd { pattern = { '*.swift' }, callback = cfg.swift }
c.autocmd { pattern = { '*.mdx', '*.md' }, callback = cfg.markdown }
c.autocmd { pattern = { '*.java' }, callback = cfg.java }
c.autocmd { pattern = { '*.cpp', '*.h', '*.c', '*.cc' }, callback = cfg.cpp }
c.autocmd { pattern = { '*.astro' }, callback = cfg.astro }

-- automatically redistribute splits when vim is resized
c.autocmd({ command = 'wincmd =' }, { 'VimResized' })
