vim.deprecate = function() end
vim.diagnostic.config { underline = false, virtual_text = true }

require('brew.lsp')
require('brew.lazy').setup {
  'nvim-lua/plenary.nvim',
  'tpope/vim-surround',
  -- {
  --   'nvim-treesitter/playground',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  -- },
  -- 'wuelnerdotexe/vim-astro',
  -- 'mfussenegger/nvim-jdtls',
  'vimplug/nvim-colorizer.lua',
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        ['<C-l>'] = { 'accept', 'select_and_accept', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        -- preset = 'default'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        menu = {
          draw = {
            columns = { { 'label' }, { 'kind' } },
            -- { 'label', 'label_description', gap = 1 },
            components = {
              label = {
                width = { fill = true, max = 36 },
                text = function(ctx)
                  if ctx.label_detail == '' then
                    return ctx.label
                  else
                    return ctx.label .. ' ' .. ctx.label_detail
                  end
                end,
              },
            },
          },
        },
        list = { selection = { preselect = false } },
        documentation = { auto_show = true },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = { default = { 'lsp', 'path', 'buffer' } },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly
      -- better performance You may use a lua implementation instead by using
      -- `implementation = "lua"` or fallback to the lua implementation, when
      -- the Rust fuzzy matcher is not available, by using `implementation =
      -- "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'ms-jpq/coq_nvim',
    enabled = false,
    branch = 'coq',
    dependencies = {
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
      { 'ms-jpq/coq.thirdparty', branch = '3p' },
    },
    init = function()
      vim.g.coq_settings = {
        auto_start = 'shut-up', -- if you want to start COQ at startup
        completion = {
          always = false,
        },
        -- Your COQ settings here
      }
    end,
  },

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
        ['₂'] = '₁',
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
  -- {
  --   'neovim/nvim-lspconfig',
  --   tag = 'v1.8.0',
  --   config = function()
  --     local lsp = require('brew.lsp')
  --     lsp.rust()
  --     lsp.lean()
  --     lsp.clangd()
  --     lsp.zls()
  --     lsp.lua()
  --     lsp.typescript()
  --     lsp.python()
  --     lsp.swift()
  --     lsp.ocamllsp()
  --     -- lsp.matlab_ls()
  --     -- lsp.astro()
  --     lsp.go()
  --   end,
  -- },
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require('conform')
      conform.setup {
        notify_on_error = true,
        formatters = {
          rustfmt = { options = { default_edition = '2024' } },
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
    'nguyenvukhang/lean.nvim',
    -- tag = 'v2024.10.1',
    -- 'Julian/lean.nvim',
    -- tag = 'v2024.10.1',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local lean = require('lean')
      local base = require('brew.lsp').base
      lean.setup {
        lsp = base {
          init_options = {
            editDelay = 100000,
          },
        },
        infoview = {
          autoopen = false,
          -- show_term_goals = false,
        },
        progress_bars = { enable = false },
        goal_markers = {
          accomplished = '',
          unsolved = '',
        },
      }
      vim.keymap.set(
        'n',
        '<leader>u',
        ':LeanInfoviewToggle<cr>',
        { silent = true }
      )
    end,
  },
  {
    'windwp/nvim-autopairs',
    enabled = false,
    config = function()
      local npairs = require('nvim-autopairs')
      -- local cond = require('nvim-autopairs.conds')
      -- local Rule = require('nvim-autopairs.rule')
      npairs.setup()
      npairs.get_rules("'")[1].not_filetypes = { 'lean', 'rust' }
    end,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    'nvim-mini/mini.pairs',
    config = function()
      local mini_pairs = require('mini.pairs')
      mini_pairs.setup {
        mappings = {
          ['$'] = {
            action = 'closeopen',
            pair = '$$',
            neigh_pattern = '[^\\].',
          },
        },
      }
      require('brew').autocmd {
        pattern = { '*.lean' },
        callback = function()
          -- Ugly hack but I guess it works.
          vim.keymap.set('i', "'", "'", { buffer = true })
          -- local bufnr = vim.api.nvim_get_current_buf()
          -- mini_pairs.unmap_buf(bufnr, 'i', "'", "''")
          -- mini_pairs.unmap('i', "'", "''")
        end,
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    config = function()
      require('noice').setup {
        notify = { enabled = false },
        cmdline = { enabled = false },
        messages = { enabled = false },
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = { lsp_doc_border = false },
      }
    end,
  },
}

-- independent of plugins, server-friendly
require('brew.sets')
require('brew.remaps')
require('brew.commands')
require('brew.statusline')
require('brew.autocmd')
require('harpoon').my_setup()

vim.cmd('colo gruvbox8_generated')
-- require('gruvbox').load()
