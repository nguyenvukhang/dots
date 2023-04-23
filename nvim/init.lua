require('brew.core').load_plugins {
  'ThePrimeagen/harpoon',
  'nvim-telescope/telescope.nvim',
  'nguyenvukhang/nvim-toggler',
  'terrortylor/nvim-comment',
  'hrsh7th/nvim-cmp',
  'nvim-treesitter/nvim-treesitter',
  'windwp/nvim-autopairs',
  'neovim/nvim-lspconfig',
  'iamcco/markdown-preview.nvim',
  'ChesleyTan/wordCount.vim',
  'folke/neodev.nvim',
  'nvim-lua/plenary.nvim',
  'mfussenegger/nvim-jdtls',
  'tpope/vim-surround',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'L3MON4D3/LuaSnip',
  'vimplug/nvim-colorizer.lua',
  'sbdchd/neoformat',
}

-- independent of plugins, server-friendly
require('brew.core.sets')
require('brew.core.remaps')
require('brew.core.commands')
require('brew.statusline').start()
require('gruvbox').load()
require('brew.core.autocmd')
