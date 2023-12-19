local root = vim.fn.stdpath('data') .. '/lazy-debug'
local lazy_path = root .. '/lazy.nvim'
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  }
end

vim.opt.runtimepath:prepend(lazy_path)

require('lazy').setup({
  'L3MON4D3/LuaSnip',
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').rust_analyzer.setup {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources { { name = 'nvim_lsp' } },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
      }
    end,
  },
  'hrsh7th/cmp-nvim-lsp',
}, { root = root })
