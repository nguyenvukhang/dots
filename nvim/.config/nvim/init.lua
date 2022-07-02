local env = require("brew.core").env
local source = function(e)
	vim.cmd("source " .. env.conf .. "/" .. e)
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
source("vim/functions.vim")
source("vim/augroup.vim")

local open = io.open
local file = open("/Users/khang/modtree/hours.json", "rb")
local json = file:read("*a")
print(json)
file:close()
