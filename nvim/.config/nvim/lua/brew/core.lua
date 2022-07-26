-- CONTENTS:
------------------------
-- UTILITIES
-- ENVIRONMENT VARIABLES
-- FUNCTIONS
-- COLORS
------------------------

-- UTILITIES

local qflist_is_open = function()
	if next(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == nil then
		return false
	else
		return true
	end
end

local loclist_is_open = function()
	local next = next
	if next(vim.fn.filter(vim.fn.getwininfo(), "v:val.loclist")) == nil then
		return false
	else
		return true
	end
end

local is_git_repo = function()
	local git_check = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
	if git_check == "true" then
		return true
	else
		return false
	end
end

local cwd_in_git_repo = function(path)
	local cmd = "git -C " .. path .. " rev-parse --is-inside-work-tree"
	local git_check = vim.fn.systemlist(cmd)[1]
	if git_check == "true" then
		return true
	else
		return false
	end
end

local git_root = function()
	if not is_git_repo() then
		print("not in a git repo")
		return
	end
	return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
end

local git_root_from_path = function(path)
	local cmd = "git -C " .. path .. " rev-parse --show-toplevel"
	return vim.fn.systemlist(cmd)[1]
end

-- to clear command line area:
-- vim.cmd('redraw!')

local utils = {
	qflist_is_open = qflist_is_open,
	loclist_is_open = loclist_is_open,
	is_git_repo = is_git_repo,
	git_root = git_root,
	git_root_from_path = git_root_from_path,
	cwd_in_git_repo = cwd_in_git_repo,
}

-- ENVIRONMENT VARIABLES

local HOME = vim.env.HOME
local DOTS = vim.env.DOTS
local env = {
	home = HOME,
	conf = HOME .. "/.config/nvim",
	repos = HOME .. "/repos",
	dots_root = DOTS,
	dots = {
		DOTS .. "/nvim/.config/nvim",
		DOTS .. "/zsh/.config/zsh",
		DOTS .. "/zsh/.local/bin",
		DOTS .. "/personal/.local/bin",
	},
}

-- FUNCTIONS

local ToggleQuickFix = function()
	if utils.qflist_is_open() then
		vim.cmd("cclose")
	else
		vim.cmd("botright copen")
	end
end

local ToggleDiagnostics = function()
	-- close diagnostics if qflist is already open
	if utils.qflist_is_open() then
		vim.cmd("cclose")
		print(" ")
		return
	end

	-- load diagnostics
	local d = vim.diagnostic.get()

	-- check if there are any diagnostics
	if vim.tbl_isempty(d) then
		print("No diagnostics found")
	else
		vim.diagnostic.setqflist()
	end
end

local ToggleLocalList = function()
	if
		not pcall(function()
			if utils.loclist_is_open() then
				vim.cmd("lclose")
			else
				vim.cmd("botright lopen")
			end
		end)
	then
		print("local list doesn't exist")
	end
end

local OpenSq = function()
	vim.fn.searchpair("\\[", "", "\\]", "b")
end

local CloseSq = function()
	vim.fn.searchpair("\\[", "", "\\]")
end

local functions = {
	ToggleQuickFix = ToggleQuickFix,
	ToggleDiagnostics = ToggleDiagnostics,
	ToggleLocalList = ToggleLocalList,
	OpenSq = OpenSq,
	CloseSq = CloseSq,
}

-- COLORS

-- gruvbox: the best color scheme of all time
local colors = {
	black = "#282828",
	white = "#ebdbb2",
	red = "#fb4934",
	green = "#b8bb26",
	blue = "#83a598",
	yellow = "#fabd2f",
	gray = "#928374",
	bg1 = "#3c3836",
	bg2 = "#504945",
	bg3 = "#665c54",
	bg4 = "#7c6f64",
	fg4 = "#a89984",
	fg3 = "#bdae93",
	fg2 = "#d5c4a1",
	fg1 = "#ebdbb2",
	fg0 = "#f9f5d7",
	lightgray = "#504945",
	inactivegray = "#7c6f64",
	orange = "#fe8019",
}

return { colors = colors, env = env, functions = functions, utils = utils }
