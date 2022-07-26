local AlternateToggler = {}

local default_table = {
	["true"] = "false",
	["True"] = "False",
	["TRUE"] = "FALSE",
	["Yes"] = "No",
	["YES"] = "NO",
	["yes"] = "no",
	["on"] = "off",
	["1"] = "0",
	["<"] = ">",
	["+"] = "-",
	["T"] = "F",
	["vertical"] = "horizontal",
	["left"] = "right",
	["up"] = "down",
	["begin"] = "end",
	["top"] = "bottom",
	["height"] = "width",
	["below"] = "above",
	["never"] = "always",
}

local user_table = vim.g.at_custom_alternates or {}

vim.tbl_add_reverse_lookup(default_table)
vim.tbl_add_reverse_lookup(user_table)

local merged_table = vim.tbl_extend("force", default_table, user_table)

local function errorHandler(err)
	if not err == nil then
		print("Error toggling to alternate value. Err: " .. err)
	end
end

function AlternateToggler.toggleAlternate(str)
	if merged_table[str] == nil then
		print("Unsupported alternate value.")
		return
	end
	xpcall(vim.cmd("normal ciw" .. merged_table[str]), errorHandler)
end

vim.api.nvim_set_keymap("n", "<Leader>i", ":ToggleAlternate<CR>", { noremap = true, silent = true })

return AlternateToggler
