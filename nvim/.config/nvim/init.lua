local conf = require("brew.core").env.conf
local source = function(e)
	vim.cmd("source " .. conf .. "/" .. e)
end

-- the heaviest section of the config
source("vim/plugged-in.vim")
require("brew.sets")
source("vim/auto-pairs.vim")
-- source('vim/remaps.vim')

require("brew.remaps")
require("brew.telescope")
require("brew.lsp")

-- the lighter half
require("brew.plugins.markdown_preview")
require("brew.plugins.lualine")
require("brew.plugins.nvim_cmp")
require("brew.plugins.nvim_comment")
require("brew.plugins.ultisnips")
require("brew.plugins.vimtex")

-- modtree hours tracker
require("modtree")

source("vim/functions.vim")
source("vim/augroup.vim")
