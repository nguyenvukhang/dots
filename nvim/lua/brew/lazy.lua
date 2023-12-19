local M = {}

---@param lazypath string
-- Create a user command `:Boot` to quickly install lazy.nvim
local function prime_bootstrap(lazypath)
  vim.notify('lazy.nvim not installed. Run `:Boot` to install it.')
  vim.api.nvim_create_user_command('Boot', function()
    vim.notify('installing lazy...')
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    }
    vim.notify('done installing lazy.nvim')
  end, {})
end

-- load plugins using lazy.nvim
---@param plugins table list of plugins to pass straight to lazy.nvim
M.setup = function(plugins)
  local root = vim.fn.stdpath('data') .. '/lazy'
  local lp = root .. '/lazy.nvim'
  if not vim.loop.fs_stat(lp) then return prime_bootstrap(lp) end
  vim.opt.runtimepath:prepend(lp)
  vim.g.mapleader = ' '
  require('lazy').setup(plugins)
end

return M
