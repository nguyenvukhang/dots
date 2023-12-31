local actions = require('telescope.actions')
local search = require('brew.telescope.search')
local theorem_search = require('brew.telescope.math').theorem_search
local k = vim.keymap.set

k('n', '<c-p>', search.files.repo)
k('n', '<c-f>', search.files.cwd)

-- the only other remap that starts with p is reserved for code formatting
k('n', '<leader>ps', search.string.repo)
k('n', '<leader>pf', search.string.cursor)
k('n', '<leader>pw', search.string.cwd)

k('n', '<leader>sd', search.files.dots)
k('n', '<leader>su', search.files.university)

-- completely custom search only for nguyenvukhang/math
k('n', '<leader>pm', function() theorem_search(true) end)
k('n', '<leader>pt', function() theorem_search(false) end)

-- local builtin = require('telescope.builtin')
-- k('n', '<leader>p0', require('telescope.builtin').builtin)
-- k('n', '<leader>sh', builtin.help_tags)
-- k('n', '<leader>sm', builtin.man_pages)

local qf_and_jump = function(bufnr)
  local as = require('telescope.actions.state')
  local m, qf = as.get_current_picker(bufnr).manager, {}
  for e in m:iter() do
    local i, t, v = { bufnr = e.bufnr }, e.text, e.value
    i.filename = require('telescope.from_entry').path(e, false, false)
    i.lnum, i.col = vim.F.if_nil(e.lnum, 1), vim.F.if_nil(e.col, 1)
    i.text = t and t or type(v) == 'table' and v.text or v
    table.insert(qf, i)
  end
  vim.fn.setqflist(qf, 'r')
  return require('telescope.actions.set').select(bufnr, 'default')
end

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
    git_files = { hidden = true },
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
