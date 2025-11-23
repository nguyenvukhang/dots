local brew = require('brew')
local autocmd = brew.autocmd
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
    local minimath = brew.prequire('minimath')
    if minimath then
      minimath.overriding_remaps()
      minimath.remaps()
    end
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
  prolog = function() vim.opt_local.commentstring = '% %s' end,
  swift = function() vim.opt_local.commentstring = '// %s' end,
  astro = function() vim.opt_local.commentstring = '// %s' end,
  asm = function() vim.opt_local.commentstring = '# %s' end,
  lean = function()
    local minimath = brew.prequire('minimath')
    if minimath then minimath.lean_remaps() end
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

autocmd { pattern = '*.tex', callback = cfg.latex }
autocmd { pattern = '*.asm', callback = cfg.asm }
autocmd { pattern = { '*.swift' }, callback = cfg.swift }
autocmd { pattern = { '*.mdx', '*.md' }, callback = cfg.markdown }
autocmd { pattern = { '*.java' }, callback = cfg.java }
autocmd { pattern = { '*.lean' }, callback = cfg.lean }
autocmd {
  pattern = { '*.cpp', '*.hpp', '*.h', '*.c', '*.cc' },
  callback = cfg.cpp,
}
autocmd { pattern = { '*.astro' }, callback = cfg.astro }
autocmd { pattern = { '*.pl' }, callback = cfg.prolog }

-- automatically redistribute splits when vim is resized
autocmd({ command = 'wincmd =' }, { 'VimResized' })
