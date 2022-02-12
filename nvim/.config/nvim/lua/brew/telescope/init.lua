--
-- https://github.com/nvim-telescope/telescope.nvim
--

local setup = function()
  local colors = require('brew.core').colors
  local actions = require('telescope.actions')
  vim.cmd('highlight TelescopeSelection guibg='..colors.lightgray..' guifg='..colors.white)
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

require('brew.telescope.remaps')
setup()
