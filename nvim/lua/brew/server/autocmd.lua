local utils = require('brew.server.utils')
local autocmd = utils.autocmd
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

    local opts = { silent = true, buffer = true }
    -- bigg wrappers
    k('n', '<leader>b(', 'i\\biggl(\\biggr)<esc>T(', opts)
    k('n', '<leader>b[', 'i\\biggl[\\biggr]<esc>T[', opts)
    k('v', '<leader>(', 'c\\biggl(\\biggr)<esc>T(P', opts)
    k('v', '<leader>[', 'c\\biggl[\\biggr]<esc>T[P', opts)
    k('v', '<leader>|', 'c\\biggl|\\biggr|<esc>T|P', opts)
    -- environment wrappers
    k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k', opts)
    k('n', '<leader>bi', 'cc\\begin{itemize}<CR>\\end{itemize}<esc>k', opts)
    k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k', opts)
    k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k', opts)
    k('n', '<leader>bg', 'cc\\begin{gather*}<CR>\\end{gather*}<esc>k', opts)
    k('n', '<leader>bp', 'o<CR>\\begin{proof}<CR>\\end{proof}<esc>k', opts)

    local gen = require('minimath.generated')

    -- jump to next/prev mark
    local marks = table.concat(gen.marks, '|')
    k('n', '[[', 'k?\\v^\\\\(' .. marks .. ')<cr>f{lzz', opts)
    k('n', ']]', 'j/\\v^\\\\(' .. marks .. ')<cr>f{lzz', opts)
    k('v', '[[', 'k?\\v^\\\\(' .. marks .. ')<cr>f{lzz', opts)
    k('v', ']]', 'j/\\v^\\\\(' .. marks .. ')<cr>f{lzz', opts)

    -- yank the current mark's SHA into system clipboard
    k(
      'n',
      '[y',
      'mK?\\v^\\\\(' .. marks .. ')<cr>/\\\\label<cr>f{"+yi{0`K',
      opts
    )

    -- go to definition (looks for `\label{<cword>}`)
    k('n', 'gd', function()
      local cword, root = vim.fn.expand('<cword>'), utils.git_workspace_root()
      if not cword or not root then return end
      vim.cmd(
        'silent lgrep --no-column -ttex \\label\\\\{' .. cword .. '} ' .. root
      )
    end)

    -- go to references (looks for `\autoref{<cword>}` or `\href{<cword>}`)
    k('n', 'gr', function()
      local cword, root = vim.fn.expand('<cword>'), brew.git_workspace_root()
      if not cword or not root then return end
      local ref = "'\\\\(auto\\|h\\|name)ref\\{" .. cword .. "\\}'"
      vim.cmd('silent grep -ttex ' .. ref .. ' ' .. root)
      if #vim.fn.getqflist() == 0 then
        vim.notify('No references found.')
      else
        vim.cmd('silent bel copen')
      end
    end)
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
