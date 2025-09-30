local c = require('brew')
local k = vim.keymap.set
local sil = { silent = true }

local dollarDollar = function()
  k('o', 'i$', ':<c-u>norm! T$vt$<cr>', sil)
  k('o', 'a$', ':<c-u>norm! F$vf$<cr>', sil)
  k('v', 'i$', 'T$ot$', sil)
  k('v', 'a$', 'F$of$', sil)
end

local function set_tab(n)
  vim.opt.tabstop, vim.opt.shiftwidth = n, n
end

local cfg = {
  java = function() set_tab(4) end,
  latex = function()
    vim.opt.textwidth = 80
    vim.opt.formatoptions = vim.opt.formatoptions + 't'
    vim.bo.filetype = 'tex'
    dollarDollar()
    require('minimath').overriding_remaps()
    require('minimath').remaps()
  end,
  markdown = function()
    vim.opt.textwidth = 80
    vim.bo.filetype = 'markdown'
    dollarDollar()
  end,
  cpp = function()
    vim.opt_local.commentstring = '// %s'
    set_tab(4)
  end,
  swift = function() vim.opt_local.commentstring = '// %s' end,
  astro = function() vim.opt_local.commentstring = '// %s' end,
  asm = function() vim.opt_local.commentstring = '# %s' end,
  lean = function()
    require('minimath').lean_remaps()
    vim.opt_local.foldmarker = ':= by --,-- ∎'
    vim.opt_local.commentstring = '-- %s'

    vim.opt_local.comments = 's0:/-,mb: ,ex:-/,:--' -- see `h: comments`
    local snip = function(a, b) vim.cmd('inoreabbrev ' .. a .. ' ' .. b) end
    local mark = '{{' .. '{'
    local lean = ' : 1 = 0 :=<CR>  by -- ' .. mark .. '<CR>sorry<esc>'
    vim.keymap.set('n', '<leader>be', '0Cexample' .. lean)
    vim.keymap.set('n', '<leader>bt', '0Ctheorem THEOREM' .. lean)
    vim.keymap.set('n', '<leader>bl', '0Clemma LEMMA' .. lean)
    -- vim.opt.formatoptions:remove('r')
    -- vim.opt.formatoptions:remove('o')
    snip('<>', '⟨⟩')
  end,
}

c.autocmd { pattern = '*.tex', callback = cfg.latex }
c.autocmd { pattern = '*.asm', callback = cfg.asm }
c.autocmd { pattern = { '*.swift' }, callback = cfg.swift }
c.autocmd { pattern = { '*.mdx', '*.md' }, callback = cfg.markdown }
c.autocmd { pattern = { '*.java' }, callback = cfg.java }
c.autocmd { pattern = { '*.lean' }, callback = cfg.lean }
c.autocmd {
  pattern = { '*.cpp', '*.hpp', '*.h', '*.c', '*.cc' },
  callback = cfg.cpp,
}
c.autocmd { pattern = { '*.astro' }, callback = cfg.astro }

-- automatically redistribute splits when vim is resized
c.autocmd({ command = 'wincmd =' }, { 'VimResized' })
