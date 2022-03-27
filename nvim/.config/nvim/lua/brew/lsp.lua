--
-- https://github.com/neovim/nvim-lspconfig
--

local env = require('brew.core').env

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

local servers = { 'pyright', 'tsserver' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup { on_attach = on_attach }
end
-- lua {{{
local sumneko_root_path = env.home .. '/.local/src/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/lua-language-server'

require('lspconfig').sumneko_lua.setup {
  on_attach = on_attach,
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
        disable = {'undefined-global'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}
-- }}}

local diagnostics_on = true
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = diagnostics_on,
    underline = diagnostics_on,
    signs = diagnostics_on,
  }
)
