--
-- https://github.com/nvim-telescope/telescope.nvim
--

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local search = require('brew.telescope.search')
local nnoremap = require('brew.core').nnoremap

nnoremap('<c-p>', search.files.repo)
nnoremap('<c-f>', search.files.cwd)

-- the only other remap that starts with p is reserved for code formatting
nnoremap('<leader>ps', search.string.repo)
nnoremap('<leader>pf', search.string.cursor)
nnoremap('<leader>pw', search.string.cwd)

nnoremap('<leader>sd', search.files.dots)
nnoremap('<leader>su', search.files.university)

nnoremap('<leader>sh', builtin.help_tags)
nnoremap('<leader>sm', builtin.man_pages)
nnoremap('<leader>gs', builtin.git_status)

local compact = {
  previewer = false,
  hidden = true,
  sorting_strategy = 'ascending',
  theme = 'dropdown',
}

require('telescope').setup {
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
        ['<CR>'] = function(bufnr)
          local action_state = require('telescope.actions.state')
          local manager, qf = action_state.get_current_picker(bufnr).manager, {}
          for e in manager:iter() do
            local i = { bufnr = e.bufnr }
            i.filename = require('telescope.from_entry').path(e, false, false)
            i.lnum, i.col = vim.F.if_nil(e.lnum, 1), vim.F.if_nil(e.col, 1)
            local v, t = e.value, e.text
            i.text = t and t or type(v) == 'table' and v.text or v
            table.insert(qf, i)
          end
          vim.fn.setqflist(qf, 'r')
          return require('telescope.actions.set').select(bufnr, 'default')
        end,
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
  },
}
