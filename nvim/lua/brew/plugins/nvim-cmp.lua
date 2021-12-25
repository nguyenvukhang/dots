--
-- https://github.com/hrsh7th/nvim-cmp
--

local cmp = require 'cmp'
local types = require 'cmp.types'

cmp.setup({
  formatting = {
    expandable_indicator = false,
    -- remove extra flair from completion menu item
    format = function(_, vim_item)
      vim_item.menu = nil
      return vim_item
    end,
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    {
      name = 'nvim_lsp',
      -- remove `Snippet` entries
      entry_filter = function(entry)
        return types.lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
      end,
    },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Use buffer source for `/` search
cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
