local conf = require('brew').env.conf
local source = function(file) vim.cmd('source '..conf..file) end

source('vim/auto-pairs.vim')
source('vim/plugged-in.vim') -- plugins
require('brew.sets')         -- sets
require('brew.remaps')       -- remaps

require('brew.markdown_preview')
require('brew.ultisnips')
require('brew.prettier')
require('brew.autopairs')
require('brew.lsp')
require('brew.nvim_cmp')
require('brew.vimtex')
require('brew.telescope')
require('brew.nvim_comment')
require('brew.color_my_pencils')
require('brew.lualine')

-- attach augroups
source('vim/augroup.vim')
