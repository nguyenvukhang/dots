-- CONTENTS:
------------------------
-- UTILITIES
-- ENVIRONMENT VARIABLES
-- FUNCTIONS
-- COLORS
------------------------

-- LOCAL UTILS

local vimfn = function(vimscript_cmd)
	return function()
		vim.cmd(vimscript_cmd)
		print(" ")
	end
end

local list = {
	qf = {
		open = vimfn("botright copen"),
		close = vimfn("cclose"),
	},
	loc = {
		open = vimfn("botright lopen"),
		close = vimfn("lclose"),
	},
}

-- UTILITIES
local list_is_open = function(listname)
	return function()
		return not (next(vim.fn.filter(vim.fn.getwininfo(), listname)) == nil)
	end
end

local qflist_is_open = list_is_open("v:val.quickfix")
local loclist_is_open = list_is_open("v:val.loclist")

local is_git_repo = function()
	local cmd = "git rev-parse --is-inside-work-tree"
	local git_check = vim.fn.systemlist(cmd)[1]
	return git_check == "true"
end

local git_root = function()
	if not is_git_repo() then
		print("not in a git repo")
		return
	end
	return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
end

local noremap = function(mode)
	return function(lhs, rhs, verbose)
		if type(rhs) == "string" then
			vim.api.nvim_set_keymap(mode, lhs, rhs, {
				noremap = true,
				silent = not (verbose or false),
			})
		else
			vim.api.nvim_set_keymap(mode, lhs, "", {
				noremap = true,
				silent = not (verbose or false),
				callback = rhs,
			})
		end
	end
end


-- to clear command line area:
-- vim.cmd('redraw!')

local utils = {
	qflist_is_open = qflist_is_open,
	loclist_is_open = loclist_is_open,
	is_git_repo = is_git_repo,
	git_root = git_root,
  nnoremap = noremap('n'),
  vnoremap = noremap('v')
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
	if qflist_is_open() then
		list.qf.close()
	else
		list.qf.open()
	end
end

local ToggleDiagnostics = function()
	-- close diagnostics if qflist is already open
	if qflist_is_open() then
		list.qf.close()
		return
	end

	-- load diagnostics
	local d = vim.diagnostic.get(0)

	-- check if there are any diagnostics
	if vim.tbl_isempty(d) then
		print("No diagnostics found")
	else
		vim.diagnostic.setloclist({ open = false })
		vim.fn.setqflist(vim.fn.getloclist(0))
		list.qf.open()
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
