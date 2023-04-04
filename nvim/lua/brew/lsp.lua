local lsp = require('lspconfig')

local M = {}

-- buffer-specific remap
local function nmap(bufnr, lhs, fn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, '', {
    noremap = true,
    silent = true,
    callback = fn,
  })
end

-- base settings for lsp
local base = function(opts)
  return vim.tbl_extend('keep', opts or {}, {
    on_attach = function(_, bufnr)
      nmap(bufnr, 'gd', vim.lsp.buf.definition)
      nmap(bufnr, 'gD', vim.lsp.buf.declaration)
      nmap(bufnr, 'gt', vim.lsp.buf.type_definition)
      nmap(bufnr, 'gr', vim.lsp.buf.references)
      nmap(bufnr, 'gi', vim.lsp.buf.implementation)
      nmap(bufnr, 'K', vim.lsp.buf.hover)
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
  })
end

lsp.clangd.setup(base()) -- C, C++, Java
lsp.tsserver.setup(base()) -- javascript, typescript
lsp.astro.setup(base()) -- astro.js
lsp.pyright.setup(base()) -- python

-- go
lsp.gopls.setup(base { root_dir = lsp.util.root_pattern('go.mod', '.git') })

-- rust
-- lsp.rls.setup(base({ root_dir = lsp.util.root_pattern 'Cargo.toml' }))
lsp.rust_analyzer.setup(base { root_dir = lsp.util.root_pattern('Cargo.toml') })

-- swift
require('lspconfig').sourcekit.setup(base())

-- lua
require('neodev').setup {}
local runtime_path = vim.split(package.path, ';', {})
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lsp.lua_ls.setup(base {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = runtime_path },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- To install, head over to https://download.eclipse.org/jdtls/snapshots
-- and download the latest version.
-- Unpack it at `jdtls_opts.dir` and make sure the exact filenames below match.
M.java_lsp = function()
  local jdtls_status, jdtls = pcall(require, 'jdtls')
  local setup_status, setup = pcall(require, 'jdtls.setup')

  if not (jdtls_status and setup_status) then
    vim.notify('[jdtls] java lsp not installed.')
    return
  end

  local jdtls_dir = vim.env.HOME .. '/.local/jdtls'

  jdtls.start_or_attach(base {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-jar',
      jdtls_dir
        .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
      '-configuration',
      jdtls_dir .. '/config_mac',
      '-data',
      vim.fn.stdpath('cache')
        .. '/jdtls/'
        .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
    },
    root_dir = setup.find_root { '.git', '.clang-format' },
    settings = { java = {} },
    init_options = { bundles = {} },
  })
end

return M
