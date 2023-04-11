local plug = function(name, config_module)
  return { name, config = function() require(config_module) end }
end

local plugins = {
  plug('ThePrimeagen/harpoon', 'brew.plugins.harpoon'),
  plug('nvim-telescope/telescope.nvim', 'brew.telescope'),
  plug('nguyenvukhang/nvim-toggler', 'brew.plugins.nvim-toggler'),
  plug('terrortylor/nvim-comment', 'brew.plugins.nvim-comment'),
  plug('hrsh7th/nvim-cmp', 'brew.plugins.nvim-cmp'),
  plug('nvim-treesitter/nvim-treesitter', 'brew.treesitter'),
  plug('neovim/nvim-lspconfig', 'brew.lsp'),
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    config = function() require('brew.plugins.markdown-preview') end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      local np = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      np.setup()
      np.add_rules {
        Rule('$', '$', 'tex'):with_move(
          function(opts) return opts.next_char == opts.char end
        ),
      }
    end,
  },
  {
    'rose-pine/neovim',
    config = function()
      require('rose-pine').setup {
        variant = 'moon',
        disable_background = true,
      }
    end,
  },
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
  'MaxMEllon/vim-jsx-pretty',
  'sbdchd/neoformat',
}

require('brew.core').load_plugins(plugins)
require('gruvbox')

-- independent of plugins, server-friendly
require('brew.core.sets')
require('brew.core.remaps')
require('brew.core.commands')
require('brew.core.autocmd')
require('brew.latex')
