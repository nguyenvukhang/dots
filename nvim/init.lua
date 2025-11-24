-- vim:fmr=--<,-->

-- Bootstrap `lazy.nvim` by Folke.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.api.nvim_create_user_command('Boot', function()
    vim.notify('installing lazy...')
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    }
    vim.notify('done installing lazy.nvim')
  end, {})
  error('lazy.nvim not installed. Run `:Boot` to install it.')
end

vim.opt.runtimepath:prepend(lazypath)
vim.g.mapleader = ' '

vim.diagnostic.config { underline = false, virtual_text = true }

local fzf_separator = '  .'

---@class MiniFzfEntryData
---@field filename string
---@field lnum number?

---@class MiniFzf
---@field data table<string, MiniFzfEntryData>
---@field fzf_choices string[]
local MiniFzf = { data = {}, fzf_choices = {} }

MiniFzf.load_minimath = function(self) --<
  for _, line in pairs(vim.fn.systemlist('minimath-rg')) do
    local _, _, filename, lnum, text, sha = line:find('(.*):(%d+):(.*):(.*)')
    self.data[sha] = { filename = filename, lnum = tonumber(lnum) }
    local abbrev = require('minimath.abbrev').get(filename)
    self.fzf_choices[sha] = abbrev
      .. ' | '
      .. text
      .. '\x1b[37m'
      .. fzf_separator
      .. sha
      .. '\x1b[m'
  end
end -->
MiniFzf.load_lean = function(self) --<
  for i, line in pairs(vim.fn.systemlist { 'lake-dino', 'rg' }) do
    local _, _, filename, lnum, text = line:find('(.*):(%d+):(.*)')
    local sha = tostring(i)
    self.data[sha] = { filename = filename, lnum = tonumber(lnum) }
    local abbrev = require('minimath.abbrev').get(filename)
    self.fzf_choices[sha] = abbrev
      .. ' | '
      .. text
      .. '\x1b[37m'
      .. fzf_separator
      .. sha
      .. '\x1b[m'
  end
end -->
---@param fzf_choice string
MiniFzf.get_sha = function(fzf_choice) --<
  local parts = vim.fn.split(fzf_choice, fzf_separator)
  return parts[#parts]
end -->
---@param fzf_choice string
MiniFzf.get_target = function(self, fzf_choice) --<
  return self.data[MiniFzf.get_sha(fzf_choice)]
end -->
---@param target MiniFzfEntryData
MiniFzf.jump = function(target) --<
  local bufnr = vim.fn.bufadd(target.filename)
  vim.fn.bufload(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(0, { target.lnum, 0 })
  vim.fn.feedkeys('zz$T{', 'n')
end -->

-- plugin archive
-- * nvim-treesitter/playground
-- * wuelnerdotexe/vim-astro
-- * mfussenegger/nvim-jdtls

require('lazy').setup {
  rocks = { enabled = false },
  spec = {
    'tpope/vim-surround',
    'vimplug/nvim-colorizer.lua',
    --< nvim-lua/plenary.nvim
    {
      'nvim-lua/plenary.nvim',
      config = function() require('harpoon').my_setup() end,
    }, -->
    --< saghen/blink.cmp
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
    }, -->
    --< ibhagwan/fzf-lua
    {
      'ibhagwan/fzf-lua',
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
              fzf.files {
                cwd = vim.env.DOTS,
                winopts = { title = 'Search dots' },
              }
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
        local brew = require('brew.server.utils')
        local rg = MiniFzf

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
    }, -->
    --< nguyenvukhang/nvim-toggler
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
    }, -->
    --< stevearc/conform.nvim
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
    }, -->
    --< terrortylor/nvim-comment
    {
      'terrortylor/nvim-comment',
      main = 'nvim_comment',
      keys = {
        { '<C-c>', ':CommentToggle<CR>' },
        { '<C-c>', ':CommentToggle<CR>', mode = 'v' },
      },
      opts = { create_mappings = false },
    }, -->
    --< nvim-treesitter/nvim-treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      tag = 'v0.9.3',
      config = function()
        local languages = { 'latex' }
        -- shut up nvim-treesitter.
        local setup = function(x) require('nvim-treesitter.configs').setup(x) end
        -- javascript, typescript, c, lua, rust, tsx, css, astro, java,
        -- latex, markdown, markdown_inline, python, swift
        setup {
          modules = {},
          ensure_installed = languages,
          sync_install = false,
          auto_install = false,
          highlight = {
            enable = true,
            disable = function(l) return not vim.tbl_contains(languages, l) end,
            additional_vim_regex_highlighting = false,
          },
        }
        -- local p_config = require("nvim-treesitter.parsers").get_parser_config()
        -- print(vim.inspect(require("nvim-treesitter.parsers")))
      end,
    }, -->
    --< m4xshen/autoclose.nvim
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
    }, -->
    --< folke/noice.nvim
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
          },
        },
        presets = { lsp_doc_border = false },
      },
    }, -->
    --< nguyenvukhang/lean.nvim
    {
      'nguyenvukhang/lean.nvim', -- Julian
      dependencies = {
        'neovim/nvim-lspconfig',
        'nvim-lua/plenary.nvim',
      },
      lazy = false,
      opts = function()
        require('brew.lsp').add['leanls'] =
          { init_options = { editDelay = 100000 } }
        return {
          infoview = {
            autoopen = false,
            -- show_term_goals = false,
          },
          inlay_hint = { enabled = false },
          progress_bars = { enable = false },
          goal_markers = {
            accomplished = '',
            unsolved = '',
          },
        }
      end,
      keys = { { '<leader>u', ':LeanInfoviewToggle<cr>', { silent = true } } },
    }, -->
  },
}

require('brew.lsp.config')

-- independent of plugins, server-friendly
require('brew.server.sets')
require('brew.server.remaps')
require('brew.server.commands')
require('brew.server.statusline')
require('brew.server.autocmd')

vim.cmd('colo gruvbox8_generated')
