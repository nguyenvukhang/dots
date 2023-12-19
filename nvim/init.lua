local core = require('brew')
local nnoremap, vnoremap = core.nnoremap, core.vnoremap

require('brew.lazy').setup {
  'nvim-telescope/telescope-fzy-native.nvim',
  'terrortylor/nvim-comment',
  {
    'nvim-telescope/telescope.nvim',
    config = function() require('brew.telescope') end,
  },
  {
    'nguyenvukhang/nvim-toggler',
    config = function()
      local nt = require('nvim-toggler')
      local inverses = {
        ['- [ ]'] = '- [x]',
        ['row'] = 'column',
        ['positive'] = 'negative',
        ['min'] = 'max',
        ['width'] = 'height',
        ['sin'] = 'cos',
        ['begin'] = 'end',
        ['True'] = 'False',
        ['cot'] = 'tan',
        ['sec'] = 'csc',
        ['good'] = 'bad',
        ['ON'] = 'OFF',
        ['Yes'] = 'No',
        ['and'] = 'or',
      }
      nt.setup { inverses = inverses, remove_default_keybinds = true }
      vim.keymap.set({ 'n', 'v' }, '<leader>i', nt.toggle, { silent = true })
    end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      local np, Rule = require('nvim-autopairs'), require('nvim-autopairs.rule')
      np.setup { ignored_next_char = [=[[%w%%%'%[%"%.%`]]=] }
      np.add_rules {
        Rule('$', '$', { 'tex', 'markdown' }):with_move(
          function(o) return o.next_char == o.char end
        ),
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lsp = require('brew.lsp')
      lsp.rust()
      lsp.clangd()
      lsp.ocamllsp()
      lsp.lua()
      lsp.typescript()
      lsp.python()
      lsp.swift()
      -- lsp.astro()
      -- lsp.go()
    end,
  },
  'iamcco/markdown-preview.nvim',
  'nvim-lua/plenary.nvim',
  'mfussenegger/nvim-jdtls',
  'tpope/vim-surround',
  'vimplug/nvim-colorizer.lua',
  {
    'sbdchd/neoformat',
    config = function()
      vim.g.latexindent_opt = '-l -m'
      vim.g.neoformat_enabled_python = { 'black' }
    end,
  },
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

require('harpoon').my_setup(core.nnoremap)

-- require('gruvbox').load()
vim.cmd('colo gruvbox8-mat')
-- vim.g.gruvbox_material_transparent_background = 1
-- vim.cmd('colo gruvbox-material')
