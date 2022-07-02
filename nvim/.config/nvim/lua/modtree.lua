local env = require("brew.core").env

-- os.execute("node $HOME/modtree/hours.js")

local json = {}

json.read = function(filepath)
	local file = io.open(filepath, "rb")
	if file then
		local jsonString = file:read("*a")
		file:close()
		return vim.json.decode(jsonString)
	else
		return nil
	end
end

json.write = function(filepath, data)
	local file = io.open(filepath, "w")
	if file then
		file:write(vim.json.encode(data))
		file:close()
		return true
	else
		return false
	end
end

vim.api.nvim_create_augroup("modtree", { clear = true })

local modtree_data_filename = 'khang.json'
local modtree_data_filepath = env.home .. "/modtree/wiki/hours/" .. modtree_data_filename

vim.api.nvim_create_autocmd("BufEnter", {
	group = "modtree",
	callback = function()
		local filename = vim.fn.expand("%:p")
		-- cancel on empty buffers
		if filename == "" or vim.fn.bufname() == modtree_data_filename then
			return
		end
		-- read existing data
		local data = json.read(modtree_data_filepath)
		-- get current timestamp
		local timestamp = {
			file = filename,
			date = os.date("%Y/%m/%d"),
			time = os.date("%X"),
			action = "open",
		}
		-- add the timestamp to current data
		table.insert(data["timestamps"], timestamp)
		-- write to json file
		local result = json.write(modtree_data_filepath, data)
		if result then
			print("updated modtree log!")
		end
    print(filename)
	end,
})
