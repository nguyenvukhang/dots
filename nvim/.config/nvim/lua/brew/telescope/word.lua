local actions = require("brew.telescope.actions")
local ignore = require("brew.telescope.ignore")
local is_git_repo = require("brew.core").utils.is_git_repo
local grep = require("telescope.builtin").grep_string

local M = {}

local mappings = function(_, map)
	map("i", "<CR>", actions.send_to_qflist + actions.select_default)
	return true
end

M.repo = function()
	if not is_git_repo() then
		print("not in a git repo")
		return
	end
	local input_string = vim.fn.input("Search For > ")
	if input_string == "" then
		return
	end
	grep({
		cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
		file_ignore_patterns = ignore,
		prompt_title = "Word In Repo",
		search = input_string,
		attach_mappings = mappings,
	})
end

M.cwd = function()
	local cwd = string.gsub(vim.fn.getcwd(), vim.env.HOME, "~")
	local input_string = vim.fn.input("Search In [" .. cwd .. "] > ")
	if input_string == "" then
		return
	end
	grep({
		file_ignore_patterns = ignore,
		prompt_title = "Word In CWD",
		search = input_string,
		attach_mappings = mappings,
	})
end

-- searches repo for word under cursor
M.this_in_repo = function()
	if not is_git_repo() then
		print("not in a git repo")
		return
	end
	grep({
		cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
		file_ignore_patterns = ignore,
		prompt_title = "Word In Repo",
		attach_mappings = mappings,
	})
end

return M
