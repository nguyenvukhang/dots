local actions = require('telescope.actions')
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

-- local builtin = require('telescope.builtin')
-- nnoremap('<leader>sh', builtin.help_tags)
-- nnoremap('<leader>sm', builtin.man_pages)
-- nnoremap('<leader>gs', builtin.git_status)

require('telescope').setup {
  defaults = {
    vimgrep_arguments = { 'rg', '--vimgrep', '--hidden', '--smart-case' },
    color_devicons = false,
    selection_caret = '  ',
    mappings = { i = { ['<esc>'] = actions.close } },
  },
  pickers = {
    git_files = { hidden = true },
    find_files = { hidden = true, previewer = false, theme = 'dropdown' },
    grep_string = {
      mappings = {
        i = {
          ['<CR>'] = function(bufnr)
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
          end,
        },
      },
    },
  },
}
