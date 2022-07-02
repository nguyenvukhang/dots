local env = require("brew.core").env

-- os.execute("node $HOME/modtree/hours.js")
local json = require("json")

vim.api.nvim_create_augroup("modtree", { clear = true })

local modtree_data_filepath = env.home .. "/modtree/wiki/khang_hours.json"

vim.api.nvim_create_autocmd("BufEnter", {
	group = "modtree",
	callback = function()
		local open = io.open
		local file = open(modtree_data_filepath, "rb")
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
