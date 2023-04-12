local M = {}

function M.setup(config)
  M.config = vim.tbl_deep_extend('force', M.config, config or {})
end

M.load = function()
  if vim.version().minor < 8 then
    vim.notify_once('gruvbox.nvim: you must use neovim 0.8 or higher')
    return
  end

  -- reset colors
  if vim.g.colors_name then vim.cmd.hi('clear') end

  vim.g.colors_name = 'gruvbox'
  vim.o.termguicolors = true

  local groups = require('gruvbox.groups').setup()

  -- add highlights
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return M
