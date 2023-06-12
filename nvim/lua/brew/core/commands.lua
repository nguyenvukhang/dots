-- finds all instances of `find` in buffer,
-- and replaces it with `replace`
local sub = function(f, r) vim.cmd('silent! %s/' .. f .. '/' .. r .. '/g') end
local cmd = function(name, fn) vim.api.nvim_create_user_command(name, fn, {}) end

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
end)

-- create new line (at current cursor position) and insert date
cmd('Date', function()
  local date = vim.fn.strftime('%-d %b')
  vim.api.nvim_put({ date }, 'l', false, false)
end)
