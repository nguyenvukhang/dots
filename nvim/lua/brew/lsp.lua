local lsp, M = require('lspconfig'), {}

-- base settings for lsp
local base = function(opts)
  opts = opts or {}
  opts.on_attach = function(_, bufnr)
    local x = { buffer = bufnr, noremap = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, x)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, x)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, x)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, x)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, x)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, x)
  end
  opts.capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  return opts
end

M.clangd = function() lsp.clangd.setup(base()) end
M.typescript = function() lsp.tsserver.setup(base()) end
M.astro = function() lsp.astro.setup(base()) end
M.python = function() lsp.pyright.setup(base()) end
M.swift = function() lsp.sourcekit.setup(base()) end

M.rust = function()
  lsp.rust_analyzer.setup(
    base { root_dir = lsp.util.root_pattern('Cargo.toml', 'rust-project.json') }
  )
end

M.go = function()
  lsp.gopls.setup(base { root_dir = lsp.util.root_pattern('go.mod', '.git') })
end

-- lua
M.lua = function()
  require('neodev').setup {}
  local luapath = vim.split(package.path, ';', {})
  table.insert(luapath, 'lua/?.lua')
  table.insert(luapath, 'lua/?/init.lua')
  local laze = vim.fn.stdpath('data') .. '/lazy'
  lsp.lua_ls.setup(base {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = luapath },
        diagnostics = { globals = { 'vim' } },
        workspace = {
          library = {
            [vim.env.VIMRUNTIME .. '/lua'] = true,
            [vim.env.VIMRUNTIME .. '/lua/vim/lsp'] = true,
            [laze .. '/lazy.nvim/lua/lazy'] = true,
            [laze .. '/telescope.nvim/lua/telescope'] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })
end

-- To install, head over to https://download.eclipse.org/jdtls/snapshots
-- and download the latest version.
-- Unpack it at `jdtls_opts.dir` and make sure the exact filenames below match.
M.java = function()
  local j, jdtls = pcall(require, 'jdtls')
  local s, setup = pcall(require, 'jdtls.setup')
  if not (j and s) then return vim.notify('[jdtls] setup err.') end

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
