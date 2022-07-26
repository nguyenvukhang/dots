--
-- https://github.com/neovim/nvim-lspconfig
--

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require("lspconfig")
local function set_keymap(bufnr, lhs, callback)
	vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, "", {
		noremap = true,
		silent = true,
		callback = callback,
	})
end

-- lsp-specific keymaps
local function on_attach(_, bufnr)
	set_keymap(bufnr, "gd", vim.lsp.buf.definition)
	set_keymap(bufnr, "gD", vim.lsp.buf.declaration)
	set_keymap(bufnr, "gt", vim.lsp.buf.type_definition)
	set_keymap(bufnr, "gr", vim.lsp.buf.references)
	set_keymap(bufnr, "gi", vim.lsp.buf.implementation)
	set_keymap(bufnr, "K", vim.lsp.buf.hover)
	print("LSP attached!")
end

-- javascript lsp
nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- python lsp
nvim_lsp.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- rust lsp
nvim_lsp.rls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		rust = {
			unstable_features = true,
			build_on_save = false,
			all_features = true,
		},
	},
})

-- lua lsp
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = runtime_path },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})
