-- 'hrsh7th/nvim-cmp'
require('brew.lazy').setup {
  'tpope/vim-surround',
  'wuelnerdotexe/vim-astro',
  'nvim-treesitter/playground',
  'mfussenegger/nvim-jdtls',
  'vimplug/nvim-colorizer.lua',
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
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
        snippet = { expand = function(x) vim.fn['vsnip#anonymous'](x.body) end },
      }
      -- Use buffer source for `/` search
      cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function() require('brew.telescope') end,
  },
  {
    'nguyenvukhang/nvim-toggler',
    config = function()
      local nt = require('nvim-toggler')
      local inverses = {
        ['- [ ]'] = '- [x]',
        ['shift'] = 'unshift',
        ['next'] = 'prev',
        ['odd'] = 'even',
        ['forall'] = 'exists',
        ['row'] = 'column',
        ['positive'] = 'negative',
        ['horizontal'] = 'vertical',
        ['min'] = 'max',
        ['width'] = 'height',
        ['sin'] = 'cos',
        ['begin'] = 'end',
        ['True'] = 'False',
        ['TRUE'] = 'FALSE',
        ['cot'] = 'tan',
        ['sec'] = 'csc',
        ['good'] = 'bad',
        ['ON'] = 'OFF',
        ['Yes'] = 'No',
        ['and'] = 'or',
      }
      nt.setup {
        inverses = inverses,
        remove_default_keybinds = true,
        autoselect_longest_match = true,
      }
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
    tag = 'v1.8.0',
    config = function()
      local lsp = require('brew.lsp')
      lsp.rust()
      lsp.clangd()
      lsp.zls()
      lsp.lua()
      -- lsp.lean()
      lsp.typescript()
      lsp.python()
      lsp.swift()
      lsp.ocamllsp()
      -- lsp.matlab_ls()
      -- lsp.astro()
      lsp.go()
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    -- just run `:call mkdp#util#install()` at some point. wgt.
    build = function() vim.fn['mkdp#util#install']() end,
    config = function()
      vim.cmd('cnoreabbrev MP MarkdownPreview')
      vim.cmd('cnoreabbrev MS MarkdownPreviewStop')
    end,
  },
  {
    'stevearc/conform.nvim',
    tag = 'v7.1.0',
    config = function()
      local conform = require('conform')
      conform.formatters.rustfmt = { options = { default_edition = '2024' } }
      conform.setup {
        notify_on_error = true,
        formatters = {
          latexindent = function()
            -- local lnum = tonumber(vim.fn.line('.'))
            -- local t, b = lnum - 50, lnum + 50
            -- local lines = '--lines ' .. t .. '-' .. b
            return { prepend_args = { '-l', '-g=/dev/null' } }
            -- return { prepend_args = { '-l' } }
          end,
          tex_fmt = function()
            return { command = 'tex-fmt', args = { '--stdin' } }
          end,
          java_custom = function()
            local cwd = vim.fn.getcwd()
            local has = function(x) return string.find(cwd, x) end
            if has('repos/tp') and has('/src/') and has('/java/') then
              local gradle = vim.fs.find('gradlew', { upward = true })[1]
              local root = vim.fs.dirname(gradle)
              -- vim.cmd('!cd ' .. root .. '; ./gradlew spotlessApply')
              -- print("Formatted with gradle spotless!")
              return nil
            end
            return { command = 'clang-format' }
          end,
        },
        async = true,
        formatters_by_ft = {
          java = { 'java_custom' },
          zig = { 'zigfmt' },
          markdown = { 'prettier' },
          css = { 'prettier' },
          astro = { 'prettier' },
          c = { 'clang_format' },
          cpp = { 'clang_format' },
          bash = { 'shfmt' },
          sh = { 'shfmt' },
          zsh = { 'shfmt' },
          lua = { 'stylua' },
          python = { 'black' },
          go = { 'gofmt' },
          ocaml = { 'ocamlformat' },
          javascript = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          tex = { 'latexindent' },
          rust = { 'rustfmt' },
          swift = { 'swiftformat' },
          typescriptreact = { 'prettier' },
        },
      }
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
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local languages = { 'latex' }
      -- javascript, typescript, c, lua, rust, tsx, css, astro, java,
      -- latex, markdown, markdown_inline, python, swift
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = function(l) return not vim.tbl_contains(languages, l) end,
          additional_vim_regex_highlighting = false,
        },
        ensure_installed = languages,
      }
      -- local p_config = require("nvim-treesitter.parsers").get_parser_config()
      -- print(vim.inspect(require("nvim-treesitter.parsers")))
    end,
  },
  {
    'Julian/lean.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local lean = require('lean')
      local lsp = require('lspconfig')
      local base = require('brew.lsp').base
      lean.setup {
        lsp = base { root_dir = lsp.util.root_pattern('lakefile.toml') },
      }
      vim.keymap.set(
        'n',
        '<leader>u',
        ':LeanInfoviewToggle<cr>',
        { silent = true }
      )
    end,
  },
}

-- independent of plugins, server-friendly
require('brew.sets')
require('brew.remaps')
require('brew.commands')
require('brew.statusline')
require('brew.autocmd')
require('minimath').remaps()
require('harpoon').my_setup()

vim.cmd('colo gruvbox8')
-- require('gruvbox').load()
