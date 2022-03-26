local conf = require('brew.core').env.conf
local source = function(e) vim.cmd('source '..conf..'/'..e) end

source('vim/auto-pairs.vim')
source('vim/plugged-in.vim') -- plugins
source('vim/statusline.vim') -- statusline
require('brew.sets')         -- sets
source('vim/remaps.vim')     -- remaps

require('brew.plugins.markdown_preview')
require('brew.plugins.nvim_cmp')
require('brew.plugins.nvim_comment')
require('brew.plugins.prettier')
require('brew.plugins.ultisnips')
require('brew.plugins.vimtex')

require('brew.telescope')
require('brew.lsp')

-- attach augroups
source('vim/augroup.vim')
