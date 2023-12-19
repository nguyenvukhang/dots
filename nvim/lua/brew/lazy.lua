local M = {}

---@param lazypath string
local function prime_bootstrap(lazypath)
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
  end, {})
end

-- load plugins using lazy.nvim
---@param plugins table list of plugins to pass straight to lazy.nvim
M.load_plugins = function(plugins, opts)
  opts = opts or {}
  local root = opts.root or vim.fn.stdpath('data') .. '/lazy'
  local lp = root .. '/lazy.nvim'
  if not vim.loop.fs_stat(lp) then return prime_bootstrap(lp) end
  vim.opt.runtimepath:prepend(lp)
  vim.g.mapleader = ' '
  require('lazy').setup(require('brew.plugins')(plugins), { root = root })
end

return M
