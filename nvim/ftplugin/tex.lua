--[[
local base = require('brew.lsp').base

vim.lsp.start(base {
  name = 'mylsp',
  cmd = { '/Users/khang/repos/lsp/pygls/mylsp' },
  filetypes = { 'tex' },
  autostart = true,
  root_dir = vim.fs.dirname(
    vim.fs.find({ 'Cargo.toml' }, { upward = true })[1]
  ),
})
--]]
