--
-- https://github.com/neovim/nvim-lspconfig
--
local env = require('brew.core').env

local setup = function()
  -- lsp-specific keymaps
  local on_attach = function()
    local buf_set_keymap = function (...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
  end

  -- typescript / javascript {{{
  require('lspconfig').tsserver.setup {
    -- handlers = { ["textDocument/publishDiagnostics"] = function () end }
    on_attach = on_attach
  }
  -- }}}
  -- lua {{{
  local sumneko_root_path = env.home..'/.local/src/lua-language-server'
  local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require('lspconfig').sumneko_lua.setup {
    on_attach = on_attach,
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
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
  -- python {{{
  require('lspconfig').pyright.setup{
    on_attach = on_attach
  }
  -- }}}
  require('lspconfig').clangd.setup{}

  local diagnostics_on = true
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = diagnostics_on,
      underline = diagnostics_on,
      signs = diagnostics_on,
    }
  )
end

setup()
