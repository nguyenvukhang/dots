--
-- https://github.com/nvim-telescope/telescope.nvim
--

local actions = require 'telescope.actions'

local compact = {
  previewer = false,
  hidden = true,
  sorting_strategy = 'ascending',
  theme = 'dropdown',
}

require 'brew.telescope.remaps'
require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    color_devicons = false,
    selection_caret = '  ',
    entry_prefix = '  ',
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<esc>'] = actions.close,
      },
    },
  },
  pickers = {
    git_files = { hidden = true },
    file_browser = compact,
    find_files = compact,
    oldfiles = compact,
    buffers = {
      ignore_current_buffer = true,
      sort_lastused = true,
      previewer = false,
      theme = 'dropdown',
      path_display = { smart = 1 },
      mappings = {
        i = { ['<c-d>'] = require('telescope.actions').delete_buffer },
      },
    },
  },
})
