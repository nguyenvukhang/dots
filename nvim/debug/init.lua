-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy-debug/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup {
  {
    'nguyenvukhang/lean.nvim', -- Julian
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
    },
    lazy = false,
    config = function()
      print('GOT HERE')
      require('lean').setup {
        lsp = {
          init_options = {
            editDelay = 100000,
          },
        },
        infoview = {
          autoopen = false,
          -- show_term_goals = false,
        },
        inlay_hint = {
          enabled = false,
        },
        progress_bars = { enable = false },
        goal_markers = {
          accomplished = '',
          unsolved = '',
        },
      }
    end,
    keys = {
      { '<leader>u', ':LeanInfoviewToggle<cr>', { silent = true } },
    },
  },
}
