-- finds all instances of `find` in buffer,
-- and replaces it with `replace`
local sub = function(find, replace)
  pcall(vim.cmd, 'silent! %s/' .. find .. '/' .. replace .. '/g')
end

-- normalize all non-standard glyphs
vim.api.nvim_create_user_command('StanGlyphs', function()
  sub('“', '"')
  sub('”', '"')
  sub('’', "'")
  sub('‘', "'")
  print('Standardized glyphs!')
end, {})

-- strip buffer of ANSI color codes
vim.api.nvim_create_user_command('StripColors', function()
  sub('\\e\\[[0-9;]\\+[mK]', '')
  sub('\\e\\[\\+[mK]', '')
  print('Stripped ANSI color codes!')
end, {})

-- list loaded packages
vim.api.nvim_create_user_command('Packs', function()
  print(vim.inspect(vim.tbl_map(function(p) return p end, package.loaded)))
end, {})

-- get highlight group under cursor
vim.api.nvim_create_user_command('UnderMe', function()
  if not vim.fn.exists('*synstack') then return end
  local groups = {}
  local highlights = vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))
  for _, v in pairs(highlights) do
    table.insert(groups, vim.fn.synIDattr(v, 'name'))
  end
  print(vim.inspect(groups))
end, {})

-- create new line (at current cursor position) and insert date
vim.api.nvim_create_user_command('Date', function()
  local date = vim.fn.strftime('%-d %b')
  vim.api.nvim_put({ date }, 'l', false, false)
end, {})
