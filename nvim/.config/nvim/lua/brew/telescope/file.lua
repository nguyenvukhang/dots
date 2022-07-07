local env = require("brew.core").env
local ignore = require("brew.telescope.ignore")
local is_git_repo = require("brew.core").utils.is_git_repo

local M = {}

M.repo = function()
	if not is_git_repo() then
		print("not in a git repo")
		return
	end
	require("telescope.builtin").git_files({
		prompt_title = "Files In Repo",
		file_ignore_patterns = ignore,
	})
end

M.cwd = function()
	require("telescope.builtin").find_files({
		prompt_title = "Files In CWD",
		file_ignore_patterns = ignore,
	})
end

local function make_searcher(opts)
	return function()
		opts.hidden = true
		opts.preview = false
		opts.file_ignore_patterns = ignore
		require("telescope.builtin").find_files(opts)
	end
end

local config = {
	{ -- searches dotfiles
		type = "dots",
		cwd = env.dots_root,
		dirs = env.dots,
		title = "dotfiles",
	},
	{ -- searches telescope source code
		type = "telescope",
		cwd = env.home .. "/.config/nvim/plugged/telescope.nvim/lua/telescope",
		prompt_title = "telescope lua files",
	},
	{ -- searches notes
		type = "notes",
		cwd = env.repos .. "/notes",
		title = "searching in notes",
	},
	{ -- searches repos
		type = "repos_search",
		cwd = env.repos,
		title = "searching in repos",
	},
	{ -- searches other repos
		type = "other_repos_search",
		cwd = env.home .. "/other-repos",
		title = "searching in other-repos",
	},
	{ -- searches university files
		type = "university",
		cwd = env.repos .. "/uni",
		title = "university files",
	},
}

for _, v in ipairs(config) do
	M[v.type] = make_searcher({
		search_dirs = v.dirs,
		prompt_title = v.title,
		cwd = v.cwd,
	})
end

return M
