local is_git_repo = require("brew.core").utils.is_git_repo

--[[
* if currently in a git repo, search files tracked by git
* else, reject query (use another searcher instead)
]]
vim.api.nvim_set_keymap("n", "<leader>ps", "", {
	noremap = true,
	callback = function()
		if not is_git_repo() then
			print("not in a git repo")
			return
		end

		local query = vim.fn.input("Search For > ")
		if query == "" then
			return
		end

		local git_files = vim.fn.systemlist("git ls-files")
		local file_list = ""
		for _, file in pairs(git_files) do
			file_list = file_list .. " " .. file
		end
		print('searching for "' .. query .. '" ...')
		local grep = function()
			vim.api.nvim_command("silent vimgrep /" .. query .. "/gj" .. file_list)
			print("Results sent to quickfix list.")
		end
		if not pcall(grep) then
			print('"' .. query .. '" not found.')
		end
	end,
})
