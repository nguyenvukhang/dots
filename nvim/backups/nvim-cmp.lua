--[[
{
  'hrsh7th/nvim-cmp',
  enabled = false,
  dependencies = {
    'hrsh7th/vim-vsnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
  },
  config = function()
    local cmp = require('cmp')
    local ct = require('cmp.types')
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
      }, {
        { name = 'buffer' },
        { name = 'path' },
      }),
      preselect = cmp.PreselectMode.None,
      snippet = { expand = function(x) vim.fn['vsnip#anonymous'](x.body) end },
    }
    -- Use buffer source for `/` search
    cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
  end,
},
]]
--
