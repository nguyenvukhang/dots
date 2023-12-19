-- local core = require('brew')
-- local nnoremap, vnoremap = core.nnoremap, core.vnoremap

require('brew.lazy').setup {
  'wuelnerdotexe/vim-astro',
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function() require('brew.telescope') end,
  },
  {
    'harpoon',
    dev = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('harpoon').my_setup() end,
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
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    config = function()
      vim.g.mkdp_preview_options = {
        ['katex'] = {
          ['macros'] = {
            ['\\R'] = '\\mathbb{R}',
            ['\\C'] = '\\mathbb{C}',
            ['\\norm'] = '\\left\\lVert{#1}\\right\\rVert',
          },
        },
      }
      vim.cmd('cnoreabbrev MP MarkdownPreview')
      vim.cmd('cnoreabbrev MS MarkdownPreviewStop')
    end,
  },
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
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp, ct = require('cmp'), require('cmp.types')
      cmp.setup {
        formatting = {
          expandable_indicator = false,
          format = function(_, item)
            item.menu = nil -- remove flair from completion item
            return item
          end,
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-l>'] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources({
          {
            name = 'nvim_lsp',
            entry_filter = function(e) -- remove `Snippet` entries
              return ct.lsp.CompletionItemKind[e:get_kind()] ~= 'Snippet'
            end,
          },
        }, { { name = 'buffer' }, { name = 'path' } }),
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args) vim.fn['vsnip#anonymous'](args.body) end,
        },
      }
      -- Use buffer source for `/` search
      cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
    end,
  },
  {
    'terrortylor/nvim-comment',
    keys = {
      { '<C-c>', ':CommentToggle<CR>' },
      { '<C-c>', ':CommentToggle<CR>', mode = 'v' },
    },
    config = function()
      require('nvim_comment').setup { create_mappings = false }
    end,
  },
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
-- require('harpoon').my_setup()

-- require('gruvbox').load()
vim.cmd('colo gruvbox8-mat')
-- vim.g.gruvbox_material_transparent_background = 1
-- vim.cmd('colo gruvbox-material')
