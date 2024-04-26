local actions = require('telescope.actions')
local search = require('brew.telescope.search')
local k = vim.keymap.set
local qf_and_jump = require('brew.telescope.qfnjump').qf_and_jump

require("brew.telescope.math").remaps()

k('n', '<c-p>', search.files.repo)
k('n', '<c-f>', search.files.cwd)

-- the only other remap that starts with p is reserved for code formatting
k('n', '<leader>ps', search.string.repo)
k('n', '<leader>pS', search.string.repo_live)
k('n', '<leader>pf', search.string.cursor)
k('n', '<leader>pw', search.string.cwd)

k('n', '<leader>sd', search.files.dots)
k('n', '<leader>su', search.files.university)

-- local builtin = require('telescope.builtin')
-- k('n', '<leader>p0', require('telescope.builtin').builtin)
-- k('n', '<leader>sh', builtin.help_tags)
-- k('n', '<leader>sm', builtin.man_pages)

require('telescope').setup {
  defaults = {
    layout_strategy = 'flex',
    vimgrep_arguments = { 'rg', '--vimgrep', '--hidden', '--smart-case' },
    color_devicons = false,
    selection_caret = '  ',
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
require('telescope').load_extension('fzy_native')
