require('brew.lazy').load_plugins {
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
  'vimplug/nvim-colorizer.lua',
  'sbdchd/neoformat',
  'wuelnerdotexe/vim-astro',

  -- completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/vim-vsnip',

  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/playground',
}

-- independent of plugins, server-friendly
require('brew.sets')
require('brew.remaps')
require('brew.commands')
require('brew.statusline').start()
require('brew.autocmd')

-- require('gruvbox').load()
vim.cmd('colo gruvbox8-mat')
-- vim.g.gruvbox_material_transparent_background = 1
-- vim.cmd('colo gruvbox-material')
