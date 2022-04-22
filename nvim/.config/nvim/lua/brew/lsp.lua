--
-- https://github.com/neovim/nvim-lspconfig
--

local env = require('brew.core').env
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require('lspconfig')

-- lsp-specific keymaps
local on_attach = function(_, bufnr)
  local map = function (...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = { noremap = true, silent = true }
  map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>', opts)
  map('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
  map('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
end

-- main loop
local servers = { 'pyright', 'tsserver' }
for _, lsp in pairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- rust lsp
nvim_lsp.rls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}

-- lua lsp
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false
      }
    },
  },
}

local diagnostics_on = true
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = diagnostics_on,
    underline = diagnostics_on,
    signs = diagnostics_on,
  }
)
