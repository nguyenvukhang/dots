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

local helps = function(prompt_title)
  return {
    prompt_title = prompt_title,
    mappings = {
      i = { ["<CR>"] = require('telescope.actions').select_vertical }
    }
  }
end

local pickers = {
  git_files = { hidden = true },
  file_browser = compact,
  find_files = compact,
  oldfiles = compact,
  help_tags = helps('search vim help'),
  man_pages = helps('search man pages'),
  buffers = {
    ignore_current_buffer = true,
    sort_lastused = true,
    previewer = false,
    theme = 'dropdown',
    path_display = { smart = 1 },
    mappings = {
      i = {
        ['<c-d>'] = require('telescope.actions').delete_buffer,
      }
    }
  }
}

local config = {
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
  pickers = pickers,
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  },
}

require('brew.telescope.remaps')
require('telescope').setup(config)
require('telescope').load_extension('fzy_native')
