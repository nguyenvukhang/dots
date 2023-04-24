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
    vim.opt.formatoptions = 'jcroql'
    vim.opt.textwidth = 70
    local ls = require('luasnip')
    local s, t = ls.snippet, ls.text_node
    ls.setup()
    vim.keymap.set(
      'i',
      '<tab>',
      function()
        return ls.expand_or_jumpable() and '<Plug>luasnip-expand-or-jump'
          or '<tab>'
      end,
      { noremap = true, expr = true }
    )

    ls.add_snippets('tex', {
      s('x', { t { '\\times' } }),
      s('*', { t { '\\ast' } }),
    })
    dollarDollar()
  end,
  markdown = function()
    vim.bo.filetype = 'markdown'
    vim.opt.textwidth = 70
    dollarDollar()
  end,
  cpp = function() vim.api.nvim_buf_set_option(0, 'commentstring', '// %s') end,
  swift = function()
    vim.opt.formatoptions = 'jcroql'
    vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
  end,
}

autocmd { pattern = '*.tex', callback = cfg.latex }
autocmd { pattern = { '*.swift' }, callback = cfg.swift }
autocmd { pattern = { '*.mdx', '*.md' }, callback = cfg.markdown }
autocmd { pattern = { '*.java' }, callback = cfg.java }
autocmd { pattern = { '*.cpp', '*.h', '*.c', '*.cc' }, callback = cfg.cpp }

autocmd({
  pattern = { '*.tex' },
  callback = function()
    local full_path = vim.fn.expand('%:p')
    local output = vim.fn.systemlist('latext ' .. full_path)
    local ok = #output == 1 and output[1] == '[successful build!]'
    vim.cmd('redraw!')
    if ok then
      print('[pdflatex] successful build!')
    else
      print('[pdflatex] build failed.')
      for i = 1, #output do
        output[i] = { text = output[i] }
      end
      vim.fn.setqflist(output)
    end
  end,
}, { 'BufWritePost' })

-- automatically redistribute splits when vim is resized
autocmd({ command = 'wincmd =' }, { 'VimResized' })
