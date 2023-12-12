require('brew.core').load_plugins {
  'sainnhe/gruvbox-material',
  'ThePrimeagen/harpoon',
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-fzy-native.nvim',
  'nguyenvukhang/nvim-toggler',
  'terrortylor/nvim-comment',

  'windwp/nvim-autopairs',
  'neovim/nvim-lspconfig',
  'iamcco/markdown-preview.nvim',
  'nvim-lua/plenary.nvim',
  'mfussenegger/nvim-jdtls',
  'tpope/vim-surround',
  'L3MON4D3/LuaSnip',
  'vimplug/nvim-colorizer.lua',
  'sbdchd/neoformat',
  'wuelnerdotexe/vim-astro',

  -- completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',

  -- retired
  -- 'sheerun/vim-polyglot', -- (breaks astro)
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/playground',
}

-- independent of plugins, server-friendly
require('brew.core.sets')
require('brew.core.remaps')
require('brew.core.commands')
require('brew.statusline').start()
require('brew.core.autocmd')

-- require('gruvbox').load()
vim.cmd('colo gruvbox8-mat')
-- vim.g.gruvbox_material_transparent_background = 1
-- vim.cmd('colo gruvbox-material')
