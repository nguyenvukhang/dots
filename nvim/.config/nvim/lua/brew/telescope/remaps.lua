local sessions_path = require("brew.core").env.conf .. "/data/sessions"

-- custom set keymap for telescope to shorten rhs
local set_keymap = function(keypress, callback)
	vim.api.nvim_set_keymap("n", keypress, "", { noremap = true, silent = true, callback = callback })
end

vim.api.nvim_set_keymap("n", "<leader>H", "", {
	noremap = true,
	callback = function()
		print("Hello world!")
	end,
})

set_keymap("<c-b>", "builtin", "buffers()")

-- file search
set_keymap("<c-p>", "file", "repo()")
set_keymap("<c-f>", "file", "cwd()")

-- word search
set_keymap("<leader>ps", "word", "repo()")
set_keymap("<leader>pw", "word", "cwd()")
set_keymap("<leader>pf", "word", "this_in_repo()")

-- search dots
set_keymap("<leader>sd", "file", "dots()")

-- search university
set_keymap("<leader>su", "file", "university()")

-- search notes
set_keymap("<leader>sn", "file", "notes()")

-- search telescope
set_keymap("<leader>st", "file", "telescope()")

-- search past-open files (recents)
set_keymap("<leader>sp", "file", "oldfiles()")

-- search repos
set_keymap("<leader>sr", "file", "repo_search()")
set_keymap("<leader>so", "file", "other_repos_search()")

-- search vim help
set_keymap("<leader>sh", "builtin", "help_tags()")

-- search manpages
set_keymap("<leader>sm", "builtin", "man_pages()")

-- session
local save_session = 'save_session({ path = "' .. sessions_path .. '"})'
set_keymap("<leader>ss", "sessions", save_session)
set_keymap("<c-s>", "sessions", "sessions()")
set_keymap("<leader>rs", "sessions", "sessions()") -- restore session

-- git stuff
set_keymap("<leader>gs", "builtin", "git_status()")
