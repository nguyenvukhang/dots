--
-- https://github.com/nvim-telescope/telescope.nvim
--

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

local compact = {
  previewer = false,
  hidden = true,
  sorting_strategy = 'ascending',
  theme = 'dropdown',
}

local pickers = {
  file_browser = compact,
  git_files = { hidden = true },
  find_files = compact,
  oldfiles = compact,
  help_tags = {
    prompt_title = 'search vim help',
    mappings = {
      i = { ["<CR>"] = require('telescope.actions').select_vertical }
    }
  },
  man_pages = {
    prompt_title = 'search man pages',
    previewer = false,
    theme = 'dropdown',
    mappings = {
      i = { ["<CR>"] = require('telescope.actions').select_vertical }
    }
  },
  buffers = {
    show_all_buffers = true,
    ignore_current_buffer = true,
    sort_lastused = true,
    theme = 'dropdown',
    previewer = false,
    path_display = { smart = 1 },
    layout_config = { height = 15, width = 50 },
    mappings = {
      i = {
        ['<c-d>'] = require('telescope.actions').delete_buffer,
      }
    }
  }
}

local setup = function()
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
    pickers = pickers,
  }
  require('telescope').load_extension('fzy_native')
end

require('brew.telescope.remaps')
setup()
