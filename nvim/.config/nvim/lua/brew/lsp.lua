--
-- https://github.com/neovim/nvim-lspconfig
--

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require('lspconfig')
local map = function (bufnr, ...)
  vim.api.nvim_buf_set_keymap(bufnr, ...)
end
local opts = { noremap = true, silent = true }

-- lsp-specific keymaps
local on_attach = function(_, bufnr)
  map(bufnr, 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  map(bufnr, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
  map(bufnr, 'n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>', opts)
  map(bufnr, 'n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
  map(bufnr, 'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
  map(bufnr, 'n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
  print('LSP on_attach called!')
end

-- javascript lsp
nvim_lsp.tsserver.setup {
  on_attach = function(_, bufnr)
    on_attach(_, bufnr)
    map(bufnr, 'n', '<leader>p', ':silent w<CR>:silent !prettier --write %<CR>', opts)
  end,
  capabilities = capabilities,
}

-- python lsp
nvim_lsp.pyright.setup {
  on_attach = function(_, bufnr)
    on_attach(_, bufnr)
    map(bufnr, 'n', '<leader>p', ':Black<CR>', opts)
  end,
  capabilities = capabilities,
}

-- C++
require("lspconfig").ccls.setup {
  on_attach = function(_, bufnr)
    on_attach(_, bufnr)
    map(bufnr, 'n', '<leader>p', ':silent w<CR>:silent !clang-format -i %<CR>', opts)
  end,
  capabilities = capabilities,
}

-- require'lspconfig'.clangd.setup{
-- }

-- golang lsp
nvim_lsp.gopls.setup {
  on_attach = function(_, bufnr)
    on_attach(_, bufnr)
    map(bufnr, 'n', '<leader>p', ':silent w<CR>silent !gofmt -w %<CR>', opts)
  end,
  capabilities = capabilities,
}


-- rust lsp
nvim_lsp.rls.setup {
  on_attach = function(_, bufnr)
    on_attach(_, bufnr)
    map(bufnr, 'n', '<leader>p', ':RustFmt<CR>', opts)
  end,
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
