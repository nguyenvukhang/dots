local builtin = require("telescope.builtin")
local file = require("brew.telescope.file")
local word = require("brew.telescope.word")
local sessions = require("brew.telescope.sessions")

-- custom set keymap for telescope to shorten rhs
local nnoremap = function(keypress, callback)
	vim.api.nvim_set_keymap("n", keypress, "", { noremap = true, silent = true, callback = callback })
end

nnoremap("<c-b>", builtin.buffers)
nnoremap("<c-p>", file.repo)
nnoremap("<c-f>", file.cwd)
-- the only other remap that starts with p is reserved for code formatting
nnoremap("<leader>ps", word.repo)
nnoremap("<leader>pf", word.this_in_repo)
nnoremap("<leader>pw", word.cwd)

nnoremap("<leader>sd", file.dots)
nnoremap("<leader>sh", builtin.help_tags)
nnoremap("<leader>sm", builtin.man_pages)
nnoremap("<leader>sn", file.notes)
nnoremap("<leader>so", file.other_repos_search)
nnoremap("<leader>sp", file.oldfiles)
nnoremap("<leader>sr", file.repo_search)
nnoremap("<leader>su", file.university)

nnoremap("<leader>ss", sessions.save_session)
nnoremap("<leader>rs", sessions.sessions) -- restore session

-- git stuff
nnoremap("<leader>gs", builtin.git_status)
