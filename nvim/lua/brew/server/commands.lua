-- finds all instances of `find` in buffer,
-- and replaces it with `replace`
local sub = function(f, r) vim.cmd('silent! %s/' .. f .. '/' .. r .. '/g') end
local cmd = function(name, fn) vim.api.nvim_create_user_command(name, fn, {}) end

local feedkeys = function(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode,
    true
  )
end

-- normalize all non-standard glyphs
cmd('StanGlyphs', function()
  sub('“', '"')
  sub('”', '"')
  sub('’', "'")
  sub('‘', "'")
  print('Standardized glyphs!')
end)

-- strip buffer of ANSI color codes
cmd('StripColors', function()
  sub('\\e\\[[0-9;]\\+[mK]', '')
  sub('\\e\\[\\+[mK]', '')
  print('Stripped ANSI color codes!')
end)

-- normalize all non-standard glyphs
cmd('MarkdownToLatex', function()
  vim.cmd('silent! s/\\*\\*\\([A-Za-z \\.:-]*\\)\\*\\*/\\\\textbf{\\1}/g')
  vim.cmd('silent! s/_\\([A-Za-z \\.:-]*\\)_/\\\\textit{\\1}/g')
  print('Markdown -> Latex!')
end)

-- list loaded packages
-- cmd('Packs', function() print(vim.inspect(package.loaded)) end)

-- get highlight group under cursor
-- NOTE: use `:Inspect` instead. built-ins!
cmd('UnderMe', function()
  if not vim.fn.exists('*synstack') then return end
  local hl = vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))
  for i = 1, #hl do
    hl[i] = vim.fn.synIDattr(hl[i], 'name')
  end
  print(vim.inspect(hl))
  pcall(vim.cmd, 'TSHighlightCapturesUnderCursor')
end)

-- create new line (at current cursor position) and insert date
cmd('Date', function()
  -- local date = vim.fn.strftime('%-d %b')
  local date = vim.fn.strftime('# %-d %b, %Y')
  feedkeys('O' .. date .. '<esc>', 'n')
end)

-- create new line (at current cursor position) and insert date
cmd('Time', function()
  local time = vim.fn.strftime('%H:%M:%S')
  feedkeys('O' .. time .. '<esc>', 'n')
end)
