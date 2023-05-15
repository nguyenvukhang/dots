local nnoremap = require('brew.core').nnoremap

nnoremap('<leader>p', ':w<CR>:silent !swiftformat "%:p"<CR>', false)
