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

local autocmd = function(events, opts)
  vim.api.nvim_create_autocmd(
    events,
    vim.tbl_extend('force', { group = group }, opts)
  )
end

local general_entry = { 'BufRead', 'BufNewFile', 'BufEnter' }

autocmd(general_entry, {
  pattern = 'kanban.md',
  callback = function() require('brew.kanban').init() end,
})

autocmd(general_entry, {
  pattern = '*.tex',
  callback = setup.latex,
})

autocmd(general_entry, {
  pattern = { '*.cpp', '*.h', '*.c', '*.cc' },
  callback = setup.cpp,
})

autocmd(general_entry, {
  pattern = { '*.mdx', '*.md' },
  callback = setup.markdown,
})

autocmd(general_entry, {
  pattern = { '*.swift' },
  callback = setup.swift,
})

autocmd(general_entry, {
  pattern = { '*.java' },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
  end,
})

autocmd({ 'BufEnter', 'FocusGained', 'BufWritePost' }, {
  callback = function()
    local set_line = function(branch)
      -- print('set branch -> [' .. branch .. ']')
      local L = '%#StatusLine# %f %h%w%m%r %#StatusLineDim#'
      -- local R = '%=%{wordCount#WordCount()} '
      local R = '%=.'
      vim.opt.statusline = L .. branch .. R
    end
    git_branch.init(set_line)
  end,
})

--- @return boolean, string[]
local function pdflatex(doc)
  vim.fn.delete('.build/tmp', 'rf')
  vim.fn.mkdir('.build', 'p')
  local args = {
    'pdflatex',
    '--halt-on-error',
    '--output-directory=.build',
    '--jobname',
    vim.fn.expand('%:t:r'),
  }
  local cmd = table.concat(args, ' ') .. '>.build/tmp;echo $?>.build/status'
  local handle = io.popen(cmd, 'w')
  if handle ~= nil then
    local transform = require('brew.latex').transform
    for _, v in pairs(doc) do
      handle:write(transform(v) .. '\n')
    end
    handle:flush()
    handle:close()
    local ok = vim.fn.readfile('.build/status')[1] == '0'
    local output = ok and {} or vim.fn.readfile('.build/tmp')
    return ok, output
  end
  return false, {}
end

autocmd({ 'BufWritePost' }, {
  pattern = { '*.tex' },
  callback = function()
    local buffer = vim.fn.getline(1, '$')
    local success, output = pdflatex(buffer)
    vim.cmd('redraw')
    if not success then
      print('[pdflatex] build failed.')
      local qf = {}
      for _, v in pairs(output) do
        table.insert(qf, { text = v })
      end
      vim.fn.setqflist(qf)
    else
      print('[pdflatex] build successful!')
    end
  end,
})

-- temporary for writing math
-- autocmd({ 'BufWritePost' }, { pattern = { '*.tex.lua' }, callback = function() vim.cmd('redraw') vim.fn.systemlist('make build') end, })

autocmd(general_entry, {
  pattern = { '*.prez' },
  callback = function()
    vim.opt.ft = 'markdown'
    vim.opt.scrolloff = 0
    nnoremap('<c-j>', '/^#\\s<CR>zt')
    nnoremap('<c-k>', '?^#\\s<CR>zt')
    -- nnoremap('<c-j>', '/\\~\\~\\~\\~\\~ \\d\\+$<CR>zt')
    -- nnoremap('<c-k>', '?\\~\\~\\~\\~\\~ \\d\\+<CR>zt')
  end,
})

-- automatically redistribute splits when vim is resized
autocmd('VimResized', { command = 'wincmd =' })
