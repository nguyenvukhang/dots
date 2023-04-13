local M = {}
local lazy = {}

---@param lazypath string
lazy.prime_bootstrap = function(lazypath)
  vim.notify('lazy.nvim not installed. Run `:Boot` to install it.')
  vim.api.nvim_create_user_command('Boot', function()
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    }
    print('done installing lazy.nvim')
  end)
end

-- load plugins using lazy.nvim
---@param plugins table list of plugins to pass straight to lazy.nvim
M.load_plugins = function(plugins)
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

  if not vim.loop.fs_stat(lazypath) then
    lazy.prime_bootstrap(lazypath)
    return
  end

  -- load the plugins!
  vim.opt.runtimepath:prepend(lazypath)
  vim.g.mapleader = ' '
  local configure = require('brew.plugin-config')
  require('lazy').setup(configure(plugins), {})
end

return M
