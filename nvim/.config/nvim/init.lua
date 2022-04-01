local conf = require('brew.core').env.conf
local source = function(e) vim.cmd('source '..conf..'/'..e) end

-- the heaviest section of the config
source('vim/plugged-in.vim')
require('brew.sets')
source('vim/auto-pairs.vim')
source('vim/remaps.vim')

require('brew.telescope')
require('brew.lsp')

-- the lighter half
require('brew.plugins.markdown_preview')
require('brew.plugins.lualine')
require('brew.plugins.nvim_cmp')
require('brew.plugins.nvim_comment')
require('brew.plugins.prettier')
require('brew.plugins.ultisnips')
require('brew.plugins.nvim_tree')
require('brew.plugins.vimtex')
source('vim/augroup.vim')
