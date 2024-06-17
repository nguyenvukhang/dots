--[[
vim.lsp.start(require('brew.lsp').base {
  name = 'mylsp',
  cmd = { '/home/khang/repos/mylsp/target/debug/mylsp' },
  filetypes = { 'tex' },
  autostart = true,
  root_dir = vim.fs.dirname(
    vim.fs.find({ 'Cargo.toml' }, { upward = true })[1]
  ),
})
--]]
