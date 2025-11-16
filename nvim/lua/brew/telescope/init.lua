local actions = require('telescope.actions')
local search = require('brew.telescope.search')
local qf_and_jump = require('brew.telescope.qfnjump').qf_and_jump

vim.keymap.set('n', '<c-p>', search.files.repo)
vim.keymap.set('n', '<c-f>', search.files.cwd)

-- the only other remap that starts with p is reserved for code formatting
vim.keymap.set('n', '<leader>ps', search.string.repo)
vim.keymap.set('n', '<leader>pS', search.string.repo_live)
vim.keymap.set('n', '<leader>pf', search.string.cursor)
vim.keymap.set('n', '<leader>pw', search.string.cwd)

vim.keymap.set('n', '<leader>sd', search.files.dots)
vim.keymap.set('n', '<leader>su', search.files.university)

-- local builtin = require('telescope.builtin')
-- k('n', '<leader>p0', require('telescope.builtin').builtin)
-- k('n', '<leader>sh', builtin.help_tags)
-- k('n', '<leader>sm', builtin.man_pages)

-- require('telescope').setup {
--   defaults = {
--     layout_strategy = 'flex',
--     vimgrep_arguments = { 'rg', '--vimgrep', '--hidden' },
--     color_devicons = false,
--     selection_caret = '  ',
--     mappings = { i = { ['<esc>'] = actions.close } },
--     preview = {
--       treesitter = false,
--     },
--   },
--   pickers = {
--     git_files = { hidden = true, previewer = false, theme = 'dropdown' },
--     find_files = { hidden = true, previewer = false, theme = 'dropdown' },
--     grep_string = {
--       mappings = {
--         i = { ['<CR>'] = qf_and_jump },
--       },
--     },
--   },
--   extensions = { fzy_native = {} },
-- }
-- require('telescope').load_extension('fzy_native')
