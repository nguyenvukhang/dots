local core = require('brew.core')
local nnoremap, vnoremap = core.nnoremap, core.vnoremap
local config = {}
local build = {}

-- https://github.com/ThePrimeagen/harpoon
config.harpoon = function()
  local h, b = require('harpoon'), '[harpoon] ⇁ '
  h:setup()
  local jump = function(n)
    return function() vim.notify(b .. n .. '/4', h:list():select(n)) end
  end
  nnoremap('<leader>m', function() h.ui:toggle_quick_menu(h:list()) end)
  nnoremap('<leader>1', jump(1), true)
  nnoremap('<leader>2', jump(2), true)
  nnoremap('<leader>3', jump(3), true)
  nnoremap('<leader>4', jump(4), true)
  nnoremap('mm', function()
    vim.notify_once('[harpoon] added file', h:list():append())
    h.ui:toggle_quick_menu(h:list())
  end, true)
end

-- https://github.com/nguyenvukhang/nvim-toggler
config['nvim-toggler'] = function()
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
end

-- https://github.com/L3MON4D3/LuaSnip
--[[
config['LuaSnip'] = function()
  local ls = require('luasnip')
  print('GOT HERE')
  local s = ls.snippet
  local t = ls.text_node
  ls.add_snippets('markdown', {
    s('pp', { t('hello') }),
  })
  vim.keymap.set({ 'i' }, '<Tab>', ls.expand_or_jump, { silent = true })
end
--]]

-- https://github.com/hrsh7th/nvim-cmp
config['nvim-cmp'] = function()
  local cmp, ct, ls = require('cmp'), require('cmp.types'), require('luasnip')
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
    snippet = { expand = function(args) ls.lsp_expand(args.body) end },
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
  np.setup { ignored_next_char = [=[[%w%%%'%[%"%.%`]]=] }
  np.add_rules {
    Rule('$', '$', { 'tex', 'markdown' }):with_move(
      function(o) return o.next_char == o.char end
    ),
  }
end

-- https://github.com/iamcco/markdown-preview.nvim
build['markdown-preview.nvim'] = function() vim.fn['mkdp#util#install']() end
config['markdown-preview.nvim'] = function()
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
end

-- https://github.com/nvim-treesitter/nvim-treesitter
config['nvim-treesitter'] = function()
  -- list of languages that use treesitter for syntax highlighting
  local enabled = { 'latex' }
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      -- restrict treesitter to just the `treesitter_list`
      disable = function(lang, _) return not vim.tbl_contains(enabled, lang) end,
      additional_vim_regex_highlighting = false,
    },
    -- stylua: ignore
    ensure_installed = { 'javascript', 'typescript', 'c', 'lua', 'rust', 'tsx', 'css',
      'astro', 'java', 'latex', 'markdown', 'markdown_inline', 'python', 'swift' },
  }
end

-- https://github.com/nvim-telescope/telescope.nvim
config['telescope.nvim'] = function() require('brew.telescope') end

-- https://github.com/neovim/nvim-lspconfig
config['nvim-lspconfig'] = function()
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
end

-- https://github.com/sbdchd/neoformat
config['neoformat'] = function()
  vim.g.latexindent_opt = '-l -m'
  vim.g.neoformat_enabled_python = { 'black' }
end

-- https://github.com/rose-pine/neovim (rip name convention tbh)
-- config['rose-pine'] = function()
--   require('rose-pine').setup { variant = 'moon', disable_background = true }
-- end

return function(list)
  for i = 1, #list do
    local key = list[i]:match('/(.*)')
    list[i] = { list[i], config = config[key], build = build[key] }
  end
  return list
end
