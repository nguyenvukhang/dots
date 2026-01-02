local utils = require('brew.server.utils')

-- automatically redistribute splits when vim is resized
utils.autocmd({ command = 'wincmd =' }, { 'VimResized' })

local autocmd = setmetatable({}, {
  __newindex = function(_, p, c) utils.autocmd { pattern = p, callback = c } end,
})
local k = function(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = true })
end

local dollarDollar = function()
  k('o', 'i$', ':<c-u>norm! T$vt$<cr>')
  k('o', 'a$', ':<c-u>norm! F$vf$<cr>')
  k('v', 'i$', 'T$ot$')
  k('v', 'a$', 'F$of$')
end

local function set_tab(n)
  vim.opt.tabstop, vim.opt.shiftwidth = n, n
end

-- Lean 4
autocmd['*.lean'] = function()
  vim.opt_local.foldmarker = ':= by --,-- ∎'
  vim.opt_local.commentstring = '-- %s'
  vim.opt_local.comments = 's0:/-,mb: ,ex:-/,:--' -- see `h: comments`
  local snip = function(a, b) vim.cmd('inoreabbrev ' .. a .. ' ' .. b) end
  snip('<>', '⟨⟩')
end

-- C/C++
autocmd[{ '*.cpp', '*.hpp', '*.h', '*.c', '*.cc' }] = function()
  vim.opt_local.commentstring = '// %s'
  set_tab(4)
end

-- LaTeX
autocmd['*.tex'] = function()
  vim.opt.textwidth = 80
  vim.opt.formatoptions = vim.opt.formatoptions + 't'
  vim.bo.filetype = 'tex'
  dollarDollar()

  k('n', '<leader>t', 'ciw\\texttt{}<esc>P')
  k('n', '<leader>T', 'ciW\\texttt{}<esc>P')

  -- bigg wrappers
  k('n', '<leader>b(', 'i\\biggl(\\biggr)<esc>T(')
  k('n', '<leader>b[', 'i\\biggl[\\biggr]<esc>T[')
  k('v', '<leader>(', 'c\\biggl(\\biggr)<esc>T(P')
  k('v', '<leader>[', 'c\\biggl[\\biggr]<esc>T[P')
  k('v', '<leader>|', 'c\\biggl|\\biggr|<esc>T|P')
  -- environment wrappers
  k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k')
  k('n', '<leader>bi', 'cc\\begin{itemize}<CR>\\end{itemize}<esc>k')
  k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k')
  k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k')
  k('n', '<leader>bg', 'cc\\begin{gather*}<CR>\\end{gather*}<esc>k')
  k('n', '<leader>bp', 'o<CR>\\begin{proof}<CR>\\end{proof}<esc>k')

  local gen = require('minimath.generated')

  -- jump to next/prev mark
  local marks = table.concat(gen.marks, '|')
  k('n', '[[', 'k?\\v^\\\\(' .. marks .. ')<cr>f{lzz')
  k('n', ']]', 'j/\\v^\\\\(' .. marks .. ')<cr>f{lzz')
  k('v', '[[', 'k?\\v^\\\\(' .. marks .. ')<cr>f{lzz')
  k('v', ']]', 'j/\\v^\\\\(' .. marks .. ')<cr>f{lzz')

  -- yank the current mark's SHA into system clipboard
  k('n', '[y', 'mK?\\v^\\\\(' .. marks .. ')<cr>/\\\\label<cr>f{"+yi{0`K')

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
    local cword, root = vim.fn.expand('<cword>'), utils.git_workspace_root()
    if not cword or not root then return end
    local ref = "'\\\\(auto\\|h\\|name)ref\\{" .. cword .. "\\}'"
    vim.cmd('silent grep -ttex ' .. ref .. ' ' .. root)
    if #vim.fn.getqflist() == 0 then
      vim.notify('No references found.')
    else
      vim.cmd('silent bel copen')
    end
  end)
end

-- Assembly
autocmd['*.asm'] = function() vim.opt_local.commentstring = '# %s' end

-- Swift
autocmd['*.swift'] = function() vim.opt_local.commentstring = '// %s' end

-- Java
autocmd['*.java'] = function() set_tab(4) end

-- Astro
autocmd['*.astro'] = function() vim.opt_local.commentstring = '// %s' end

-- Prolog
autocmd['*.pl'] = function() vim.opt_local.commentstring = '% %s' end

-- Markdown
autocmd[{ '*.mdx', '*.md' }] = function()
  vim.opt_local.textwidth = 80
  vim.bo.filetype = 'markdown'
  dollarDollar()
end
