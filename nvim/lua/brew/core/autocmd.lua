local group = vim.api.nvim_create_augroup('FILETYPES', { clear = true })
local core = require('brew.core')
local vnoremap = core.vnoremap
local onoremap = core.onoremap
local nnoremap = core.nnoremap
local git_branch = require('brew.git-branch')

local dollarDollar = function()
  -- require('nvim-autopairs').add_rule;
  onoremap('i$', ':<c-u>norm! T$vt$<cr>')
  onoremap('a$', ':<c-u>norm! F$vf$<cr>')
  vnoremap('i$', 'T$ot$')
  vnoremap('a$', 'F$of$')
end

local setup = {
  latex = function()
    vim.opt.textwidth = 70
    dollarDollar()
  end,
  markdown = function()
    vim.bo.filetype = 'markdown'
    vim.opt.textwidth = 70
    dollarDollar()
  end,
  cpp = function() vim.api.nvim_buf_set_option(0, 'commentstring', '// %s') end,
  swift = function() vim.api.nvim_buf_set_option(0, 'commentstring', '// %s') end,
}

local general_entry = { 'BufRead', 'BufNewFile', 'BufEnter' }

core.autocmd(general_entry, {
  pattern = '*.tex',
  callback = setup.latex,
})

core.autocmd(general_entry, {
  pattern = { '*.cpp', '*.h', '*.c', '*.cc' },
  callback = setup.cpp,
})

core.autocmd(general_entry, {
  pattern = { '*.mdx', '*.md' },
  callback = setup.markdown,
})

core.autocmd(general_entry, {
  pattern = { '*.swift' },
  callback = setup.swift,
})

core.autocmd(general_entry, {
  pattern = { '*.java' },
  callback = function()
    vim.opt.tabstop, vim.opt.shiftwidth = 4, 4
  end,
})

core.autocmd(nil, {
  callback = function()
    git_branch.init(function(branch)
      branch = '%#StatusLineBranch#' .. branch .. '%#StatusLine#'
      local b = { ' %f %h%w%m%r ', branch, '%=+ ' }
      vim.opt.statusline = table.concat(b)
    end)
  end,
})

core.autocmd({ 'BufWritePost' }, {
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
      for i, v in pairs(output) do
        output[i] = { text = v }
      end
      vim.fn.setqflist(output)
    end
  end,
})

-- automatically redistribute splits when vim is resized
core.autocmd({ 'VimResized' }, { command = 'wincmd =' })
