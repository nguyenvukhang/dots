vim.deprecate = function() end
vim.diagnostic.config { underline = false, virtual_text = true }

-- plugin archive
-- * nvim-treesitter/playground
-- * wuelnerdotexe/vim-astro
-- * mfussenegger/nvim-jdtls

-- As opposed to fzf-lua
local USE_TELESCOPE = false

-- Add `lazy.nvim` to vim's runtime path. First.
local lazy = require('brew.lazy')
local lsp = require('brew.lsp')

lazy.setup {
  {
    'nvim-lua/plenary.nvim',
    config = function() require('harpoon').my_setup() end,
  },
  'tpope/vim-surround',
  'vimplug/nvim-colorizer.lua',
  {
    'saghen/blink.cmp',

    -- use a release tag to download pre-built binaries
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        ['<C-l>'] = { 'accept', 'select_and_accept', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        -- preset = 'default'
      },

      completion = {
        menu = {
          draw = {
            columns = { { 'label' }, { 'kind' } },
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
        ghost_text = { enabled = false },
        list = { selection = { preselect = false } },
        documentation = { auto_show = true },
      },

      sources = { default = { 'lsp', 'path', 'buffer' } },

      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    enabled = USE_TELESCOPE,
    dependencies = {
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-lua/plenary.nvim',
    },
    keys = function()
      local search = require('brew.telescope_search')
      return {
        { '<c-p>', search.files.repo },
        { '<c-f>', search.files.cwd },
        { '<leader>ps', search.string.repo },
        { '<leader>pS', search.string.repo_live },
        { '<leader>pf', search.string.cursor },
        { '<leader>pw', search.string.cwd },
        { '<leader>sd', search.files.dots },
        { '<leader>su', search.files.university },
      }
    end,
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local a_state = require('telescope.actions.state')
      local a_set = require('telescope.actions.set')
      local from_entry = require('telescope.from_entry')

      -- Load all results to quickfix list AND jump to the selected one.
      local qf_and_jump = function(bufnr)
        local p, qf = a_state.get_current_picker(bufnr), {}
        for e in p.manager:iter() do
          local i, t, v = { bufnr = e.bufnr }, e.text, e.value
          i.filename = from_entry.path(e, false, false)
          i.lnum, i.col = vim.F.if_nil(e.lnum, 1), vim.F.if_nil(e.col, 1)
          i.text = t and t or type(v) == 'table' and v.text or v
          table.insert(qf, i)
        end
        vim.fn.setqflist(qf, 'r')
        return a_set.select(bufnr, 'default')
      end

      telescope.setup {
        defaults = {
          layout_strategy = 'flex',
          vimgrep_arguments = { 'rg', '--vimgrep', '--hidden' },
          color_devicons = false,
          selection_caret = '> ',
          mappings = { i = { ['<esc>'] = actions.close } },
          preview = {
            treesitter = false,
          },
        },
        pickers = {
          git_files = { hidden = true, previewer = false, theme = 'dropdown' },
          find_files = { hidden = true, previewer = false, theme = 'dropdown' },
          grep_string = {
            mappings = {
              i = { ['<CR>'] = qf_and_jump },
            },
          },
        },
        extensions = { fzy_native = {} },
      }

      telescope.load_extension('fzy_native')
    end,
  },
  {
    -- 'nguyenvukhang/fzf-lua',
    'ibhagwan/fzf-lua',
    enabled = not USE_TELESCOPE,
    opts = {
      winopts = {
        preview = {
          vertical = 'up:45%',
          horizontal = 'right:50%',
        },
      },
      hls = {
        border = 'Comment',
        preview_border = 'Comment',
      },
      -- Specific picker options
      files = {
        winopts = {
          preview = { hidden = true },
        },
      },
    },
    keys = function()
      local bfzf = require('brew.fzf')
      local fzf = require('fzf-lua')
      return {
        -- file searches.
        { '<C-f>', bfzf.files },
        { '<C-p>', bfzf.git_files },
        {
          '<leader>sd',
          function()
            fzf.files { cwd = vim.env.DOTS, winopts = { title = 'Search dots' } }
          end,
        },
        -- word searches.
        { '<leader>pw', bfzf.grep },
        { '<leader>ps', bfzf.git_grep },
        { '<leader>pf', bfzf.grep_cword },
      }
    end,
    config = function(spec)
      local fzf = require('fzf-lua')
      local brew = require('brew')
      local rg = require('minimath.rg')

      fzf.setup(spec.opts)

      local keymap = function(mode, keymap, callback)
        vim.keymap.set(mode, keymap, function()
          rg:load_minimath()
          fzf.fzf_exec(rg.fzf_choices, { actions = { ['enter'] = callback } })
        end, { silent = true, buffer = true })
      end

      brew.autocmd {
        pattern = '*.lean',
        callback = function()
          vim.keymap.set('n', '<leader>pm', function()
            rg:load_lean()
            fzf.fzf_exec(rg.fzf_choices, {
              actions = {
                ['enter'] = function(fzf_choices)
                  rg.jump(rg:get_target(fzf_choices[1]))
                end,
              },
            })
          end, { silent = true, buffer = true })
        end,
      }

      brew.autocmd {
        pattern = '*.tex',
        callback = function()
          keymap('n', '<leader>pm', function(fzf_choices)
            -- Jump to a theorem.
            rg.jump(rg:get_target(fzf_choices[1]))
          end)
          keymap('n', '<leader>pt', function(fzf_choices)
            -- Copy the theorem's SHA to empty register.
            vim.fn.setreg('', rg.get_sha(fzf_choices[1]))
          end)
          keymap('v', '<leader>h', function(fzf_choices)
            -- Surround the selection with a \href{...}{<selection>}
            local sha = rg.get_sha(fzf_choices[1])
            vim.fn.feedkeys('gv"xc\\href{' .. sha .. '}{}"xP')
          end)
          keymap('v', '<leader>a', function(fzf_choices)
            -- Replace the selection with a \autoref{...}
            local sha = rg.get_sha(fzf_choices[1])
            vim.fn.feedkeys('gv"xc\\autoref{' .. sha .. '}')
          end)
        end,
      }
    end,
  },
  {
    'nguyenvukhang/nvim-toggler',
    opts = {
      inverses = {
        ['₂'] = '₁',
        ['- [ ]'] = '- [x]',
        ['shift'] = 'unshift',
        ['exact'] = 'refine',
        ['next'] = 'prev',
        ['odd'] = 'even',
        ['forall'] = 'exists',
        ['row'] = 'column',
        ['positive'] = 'negative',
        ['horizontal'] = 'vertical',
        ['above'] = 'below',
        ['Above'] = 'Below',
        ['min'] = 'max',
        ['width'] = 'height',
        ['sin'] = 'cos',
        ['begin'] = 'end',
        ['True'] = 'False',
        ['TRUE'] = 'FALSE',
        ['upper'] = 'lower',
        ['cot'] = 'tan',
        ['sec'] = 'csc',
        ['good'] = 'bad',
        ['ON'] = 'OFF',
        ['Yes'] = 'No',
        ['and'] = 'or',
      },
      autoselect_longest_match = true,
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
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
        java_custom = function()
          local cwd = vim.fn.getcwd()
          local has = function(x) return string.find(cwd, x) end
          if has('repos/tp') and has('/src/') and has('/java/') then
            -- local gradle = vim.fs.find('gradlew', { upward = true })[1]
            -- local root = vim.fs.dirname(gradle)
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
    },
  },
  {
    'terrortylor/nvim-comment',
    main = 'nvim_comment',
    keys = {
      { '<C-c>', ':CommentToggle<CR>' },
      { '<C-c>', ':CommentToggle<CR>', mode = 'v' },
    },
    opts = { create_mappings = false },
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
      lean.setup {
        lsp = lsp.base {
          init_options = {
            editDelay = 100000,
          },
        },
        infoview = {
          autoopen = false,
          -- show_term_goals = false,
        },
        inlay_hint = {
          enabled = false,
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
    'm4xshen/autoclose.nvim',
    opts = {
      options = {
        disable_command_mode = true,
      },
      keys = {
        ['$'] = {
          escape = true,
          close = true,
          pair = '$$',
          enabled_filetypes = { 'tex' },
        },
        ['('] = { escape = false, close = true, pair = '()' },
        ['['] = { escape = false, close = true, pair = '[]' },
        ['{'] = { escape = false, close = true, pair = '{}' },

        ['>'] = { escape = true, close = false, pair = '<>' },
        [')'] = { escape = true, close = false, pair = '()' },
        [']'] = { escape = true, close = false, pair = '[]' },
        ['}'] = { escape = true, close = false, pair = '{}' },

        ['"'] = { escape = true, close = true, pair = '""' },
        ['`'] = { escape = true, close = true, pair = '``' },
        ["'"] = {
          escape = true,
          close = true,
          pair = "''",
          disabled_filetypes = { 'lean', 'rust', 'tex' },
        },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
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
    },
  },
}

-- independent of plugins, server-friendly
require('brew.sets')
require('brew.remaps')
require('brew.commands')
require('brew.statusline')
require('brew.autocmd')

vim.cmd('colo gruvbox8_generated')
