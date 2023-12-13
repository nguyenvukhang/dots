local nnoremap = require('brew').nnoremap

nnoremap('<leader>p', ':w<CR>:silent !swiftformat "%:p"<CR>', false)
