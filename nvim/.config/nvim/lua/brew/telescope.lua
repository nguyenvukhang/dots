--
-- https://github.com/nvim-telescope/telescope.nvim
--

local remaps = function()
  local sessions_path = require('brew').env.conf..'data/sessions'
  local remap = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  remap('n', '<C-b>', ':lua require("telescope.builtin").buffers()<CR>', opts)

  -- file search
  remap('n', '<C-p>', ':lua require("brew.telescope.file").repo()<CR>', opts)
  remap('n', '<C-f>', ':lua require("brew.telescope.file").cwd()<CR>', opts)

  -- word search
  remap('n', '<Leader>ps', ':lua require("brew.telescope.word").repo()<CR>', opts)
  remap('n', '<Leader>pw', ':lua require("brew.telescope.word").cwd()<CR>', opts)
  remap('n', '<Leader>pf', ':lua require("brew.telescope.word").this_in_repo()<CR>', opts)

  -- search dots
  remap('n', '<Leader>sd', ':lua require("brew.telescope.file").dots()<CR>', opts)
  -- search university
  remap('n', '<Leader>su', ':lua require("brew.telescope.file").university()<CR>', opts)
  -- search notes
  remap('n', '<Leader>sn', ':lua require("brew.telescope.file").notes()<CR>', opts)
  -- search telescope
  remap('n', '<Leader>st', ':lua require("brew.telescope.file").telescope()<CR>', opts)
  -- search repos
  remap('n', '<Leader>sr', ':lua require("brew.telescope.file").recents()<CR>', opts)
  remap('n', '<Leader>so', ':lua require("brew.telescope.file").other_repos_search()<CR>', opts)
  -- search vim help
  remap('n', '<Leader>sh', ':lua require("telescope.builtin").help_tags()<CR>', opts)
  -- search manpages
  remap('n', '<Leader>sm', ':lua require("telescope.builtin").man_pages()<CR>', opts)

  -- session
  remap('n', '<Leader>ss', ':lua require("brew.telescope.sessions").save_session({ path = "'..sessions_path..'"})<CR>', opts)
  remap('n', '<C-s>', ':lua require("brew.telescope.sessions").sessions()<CR>', opts)

  -- git stuff
  remap('n', '<Leader>gs', ':lua require("telescope.builtin").git_status()<CR>', opts)
end

local setup = function()
  local colors = require('brew').colors
  local actions = require('telescope.actions')
  vim.api.nvim_command('highlight TelescopeSelection guibg='..colors.lightgray..' guifg='..colors.white)
  local vimgrep_arguments = {
    "rg",
    "--hidden",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case"
  }
  require('telescope').setup {
    defaults = {
      vimgrep_arguments = vimgrep_arguments,
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      color_devicons = false,
      mappings = {
        i = {
          ['<C-q>'] = actions.send_to_qflist,
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
          ['<esc>'] = actions.close,
        },
      },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    },
    pickers = {
      file_browser = {
        theme = 'dropdown',
        previewer = false,
        sorting_strategy = 'ascending',
      },
      find_files = {
        theme = 'dropdown',
        previewer = false,
        sorting_strategy = 'ascending',
      },
      help_tags = {
        prompt_title = 'search vim help',
        mappings = {
          i = {
            ["<CR>"] = require('telescope.actions').select_vertical
          }
        }
      },
      man_pages = {
        theme = 'dropdown',
        previewer = false,
        prompt_title = 'search man pages',
        mappings = {
          i = {
            ["<CR>"] = require('telescope.actions').select_vertical
          }
        }
      },
      buffers = {
        show_all_buffers = true,
        ignore_current_buffer = true,
        sort_lastused = true,
        theme = 'dropdown',
        previewer = false,
        layout_config = {
          height = 10,
          width = 40
        },
        mappings = {
          i = {
            ['<c-d>'] = require('telescope.actions').delete_buffer,
          }
        }
      }
    }
  }
  require('telescope').load_extension('fzy_native')
end

remaps()
setup()
