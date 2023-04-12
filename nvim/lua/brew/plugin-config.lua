local core = require('brew.core')
local nnoremap, vnoremap = core.nnoremap, core.vnoremap
local config = {}
local build = {}

-- https://github.com/ThePrimeagen/harpoon
config.harpoon = function()
  local hp = { mark = require('harpoon.mark'), ui = require('harpoon.ui') }

  hp.jump = function(n)
    return function()
      hp.ui.nav_file(n)
      vim.notify_once('[harpoon] -> ' .. n .. '/4')
    end
  end

  hp.add = function()
    hp.mark.add_file()
    hp.ui.toggle_quick_menu()
    vim.notify_once('[harpoon] added file')
  end

  nnoremap('<leader>m', hp.ui.toggle_quick_menu)
  nnoremap('mm', hp.add, true)
  nnoremap('<leader>1', hp.jump(1), true)
  nnoremap('<leader>2', hp.jump(2), true)
  nnoremap('<leader>3', hp.jump(3), true)
  nnoremap('<leader>4', hp.jump(4), true)
end

-- https://github.com/nguyenvukhang/nvim-toggler
config['nvim-toggler'] = function()
  local nt = require('nvim-toggler')
  local inverses = {
    ['- [ ]'] = '- [x]',
    ['row'] = 'column',
    ['width'] = 'height',
    ['sin'] = 'cos',
    ['cot'] = 'tan',
    ['sec'] = 'csc',
    ['good'] = 'bad',
    ['ON'] = 'OFF',
  }
  nt.setup { inverses = inverses, remove_default_keybinds = true }
  vim.keymap.set({ 'n', 'v' }, '<leader>i', nt.toggle, { silent = true })
end

-- https://github.com/hrsh7th/nvim-cmp
config['nvim-cmp'] = function()
  local cmp, types = require('cmp'), require('cmp.types')
  cmp.setup {
    formatting = {
      expandable_indicator = false,
      format = function(_, item)
        item.menu = nil -- remove flair from completion item
        return item
      end,
    },
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args) require('luasnip').lsp_expand(args.body) end,
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
          return types.lsp.CompletionItemKind[e:get_kind()] ~= 'Snippet'
        end,
      },
    }, { { name = 'buffer' }, { name = 'path' } }),
  }
  -- Use buffer source for `/` search
  cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
end

-- https://github.com/terrortylor/nvim-comment
config['nvim-comment'] = function()
  require('nvim_comment').setup { create_mappings = false }
  nnoremap('<C-c>', ':CommentToggle<CR>', true)
  vnoremap('<C-c>', ':CommentToggle<CR>', true)
end

-- https://github.com/windwp/nvim-autopairs
config['nvim-autopairs'] = function()
  local np, Rule = require('nvim-autopairs'), require('nvim-autopairs.rule')
  np.setup()
  np.add_rules {
    Rule('$', '$', 'tex'):with_move(
      function(opts) return opts.next_char == opts.char end
    ),
  }
end

-- https://github.com/iamcco/markdown-preview.nvim
build['markdown-preview.nvim'] = function() vim.fn['mkdp#util#install']() end
config['markdown-preview.nvim'] = function()
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_preview_options = {
    katex = { macros = { ['\\R'] = '\\mathbb{R}', ['\\C'] = '\\mathbb{C}' } },
    disable_sync_scroll = false,
    disable_filename = 1,
  }
  -- abbreviations
  vim.cmd('cnoreabbrev MP MarkdownPreview')
  vim.cmd('cnoreabbrev MS MarkdownPreviewStop')
end

-- https://github.com/nvim-treesitter/nvim-treesitter
config['nvim-treesitter'] = function()
  -- list of languages that use treesitter for syntax highlighting
  local enabled = { 'astro', 'markdown', 'latex' }
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      -- restrict treesitter to just the `treesitter_list`
      disable = function(lang, _) return not vim.tbl_contains(enabled, lang) end,
      additional_vim_regex_highlighting = false,
    },
    -- stylua: ignore
    ensure_installed = { 'javascript', 'typescript', 'c', 'lua', 'rust',
      'astro', 'java', 'latex', 'markdown', 'markdown_inline', 'python' },
  }
end

-- https://github.com/nvim-telescope/telescope.nvim
config['telescope.nvim'] = function() require('brew.telescope') end

-- https://github.com/neovim/nvim-lspconfig
config['nvim-lspconfig'] = function()
  local lsp = require('brew.lsp')
  lsp.rust()
  lsp.clangd()
  lsp.lua()
  lsp.typescript()
  lsp.python()
  -- lsp.swift()
  -- lsp.astro()
  -- lsp.go()
end

-- https://github.com/rose-pine/neovim (rip name convention tbh)
config['rose-pine'] = function()
  require('rose-pine').setup { variant = 'moon', disable_background = true }
end

local setup = function(list)
  for i, name in pairs(list) do
    local key = name:match('/(.*)')
    list[i] = { name, config = config[key], build = build[key] }
  end
  return list
end

return setup
