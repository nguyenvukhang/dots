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

-- os.execute("node $HOME/modtree/hours.js")
local json = require("json")

vim.api.nvim_create_augroup("modtree", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = "modtree",
	callback = function()
		local open = io.open
		local file = open(env.home .. "/modtree/wiki/khang_hours.json", "rb")
		local jsonString = file:read("*a")
		local data = json.decode(jsonString)
		-- print(vim.inspect(data))
		-- local buffer = vim.fn.getbufinfo()
		-- for k, v in ipairs(buffer) do
		-- print("yes", k, v)
		-- end
		-- os.execute("node $HOME/modtree/hours.js " .. )
	end,
})
