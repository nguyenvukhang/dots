local builtin = require('telescope.builtin')
local file = require('brew.telescope.file')
local word = require('brew.telescope.word')
local nnoremap = require('brew.core').nnoremap

nnoremap('<c-b>', builtin.buffers)
nnoremap('<c-p>', file.repo)
nnoremap('<c-f>', file.cwd)
-- the only other remap that starts with p is reserved for code formatting
nnoremap('<leader>ps', word.repo)
nnoremap('<leader>pf', word.this_in_repo)
nnoremap('<leader>pw', word.cwd)

nnoremap('<leader>sd', file.dots)
nnoremap('<leader>su', file.university)

nnoremap('<leader>sh', builtin.help_tags)
nnoremap('<leader>sm', builtin.man_pages)

-- git stuff
nnoremap('<leader>gs', builtin.git_status)
