-- Bootstrap `lazy.nvim` by Folke.

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
  error('lazy.nvim not installed. Run `:Boot` to install it.')
end

vim.opt.runtimepath:prepend(lazypath)
vim.g.mapleader = ' '
