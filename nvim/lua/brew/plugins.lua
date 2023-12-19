local core = require('brew')
local nnoremap, vnoremap = core.nnoremap, core.vnoremap
local config = {}
local build = {}

config['ThePrimeagen/harpoon'] = function()
  local mark, ui = require('harpoon.mark'), require('harpoon.ui')
  local jump = function(n)
    return function()
      ui.nav_file(n)
      vim.notify('[harpoon] -> ' .. n .. '/4')
    end
  end
  nnoremap('<leader>m', ui.toggle_quick_menu)
  nnoremap('<leader>1', jump(1), true)
  nnoremap('<leader>2', jump(2), true)
  nnoremap('<leader>3', jump(3), true)
  nnoremap('<leader>4', jump(4), true)
  nnoremap('mm', function()
    mark.add_file()
    ui.toggle_quick_menu()
    vim.notify_once('[harpoon] added file')
  end, true)
end

config['nguyenvukhang/nvim-toggler'] = function()
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

--[[
config['L3MON4D3/LuaSnip'] = function()
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

config['hrsh7th/nvim-cmp'] = function()
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

config['terrortylor/nvim-comment'] = function()
  require('nvim_comment').setup { create_mappings = false }
  nnoremap('<C-c>', ':CommentToggle<CR>', true)
  vnoremap('<C-c>', ':CommentToggle<CR>', true)
end

build['iamcco/markdown-preview.nvim'] = function() vim.fn['mkdp#util#install']() end
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

config['nvim-treesitter/nvim-treesitter'] = function()
  -- list of languages that use treesitter for syntax highlighting
  local enabled = { 'latex' }
  -- stylua: ignore
  local _ = {
    'javascript', 'typescript', 'c', 'lua', 'rust', 'tsx', 'css', 'astro',
    'java', 'latex', 'markdown', 'markdown_inline', 'python', 'swift' }
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      disable = function(l, _) return not vim.tbl_contains(enabled, l) end,
      additional_vim_regex_highlighting = false,
    },
    ensure_installed = enabled,
  }
end

config['nvim-telescope/telescope.nvim'] = function() require('brew.telescope') end

config['neovim/nvim-lspconfig'] = function()
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

config['sbdchd/neoformat'] = function()
  vim.g.latexindent_opt = '-l -m'
  vim.g.neoformat_enabled_python = { 'black' }
end

config['rose-pin/neovim'] = function()
  -- print("GOT HERE")
  require('rose-pine').setup { variant = 'main', disable_background = true }
end

config['nvim-lua/plenary.nvim'] = config['ThePrimeagen/harpoon']

return function(t)
  for i = 1, #t do
    t[i] = { t[i], config = config[t[i]], build = build[t[i]] }
  end
  return t
end
