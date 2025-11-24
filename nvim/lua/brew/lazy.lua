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

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local lazy_dir_stat = (vim.uv or vim.loop).fs_stat(lazypath)
if not lazy_dir_stat then prime_bootstrap(lazypath) end

vim.opt.runtimepath:prepend(lazypath)
vim.g.mapleader = ' '

-- load plugins using lazy.nvim
---@param plugins table list of plugins to pass straight to lazy.nvim
M.setup = function(plugins)
  if lazy_dir_stat then
    require('lazy').setup { spec = plugins, rocks = { enabled = false } }
  end
end

return M
