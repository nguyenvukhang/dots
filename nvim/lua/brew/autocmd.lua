local c = require('brew')
local k = vim.keymap.set
local math = require('brew.telescope.math')
local theorem_search = math.theorem_search
local sil = { silent = true }

local minimath = function()
  -- completely custom search only for nguyenvukhang/math
  k('n', '<leader>pm', function() theorem_search(true, false) end)
  k('n', '<leader>pt', function() theorem_search(false, false) end)
  k('v', '<leader>h', function() theorem_search(false, true, 'h') end)
  k('v', '<leader>a', function() theorem_search(false, true, 'a') end)

  -- environment wrappers
  k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k')
  k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k')
  k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k')
  k('n', '<leader>bg', 'cc\\begin{gather*}<CR>\\end{gather*}<esc>k')
  k('n', '<leader>bt', 'cc\\begin{Theorem}<CR>\\end{Theorem}<esc>k')

  -- jump to next/prev mark
  k('n', '[[', '^k?\\v^\\\\begin\\{(' .. math.marks .. ')\\}<cr>', sil)
  k('n', ']]', '^j/\\v^\\\\begin\\{(' .. math.marks .. ')\\}<cr>', sil)
end

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
    minimath()
    -- go to definition for my notes
    k('n', 'gd', function()
      vim.cmd('w')
      local cword = vim.fn.expand('<cword>')
      if not cword then return end
      local cmd = "rg --vimgrep -ttex '\\\\label\\{" .. cword .. "\\}'"
      local output = vim.fn.systemlist(cmd)
      if vim.v.shell_error ~= 0 then return end
      local _, _, file, lnum = output[1]:find([[(..-):(%d+)]])
      vim.cmd('e ' .. file)
      vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
    end)
    k('n', 'gr', function()
      vim.cmd('w')
      local cword = vim.fn.expand('<cword>')
      if not cword then return end
      vim.cmd(
        'vimgrep /\\v\\\\(autoref|href)\\{' .. cword .. '\\}/ *.tex **/*.tex'
      )
    end)

    dollarDollar()
  end,
  markdown = function()
    vim.opt.textwidth = 70
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
