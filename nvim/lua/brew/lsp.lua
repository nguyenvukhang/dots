local hover = function()
  local USE_NATIVE = true
  if USE_NATIVE then
    local b = { '·', '─', '·', '│' }
    return vim.lsp.buf.hover { border = b }
  else
    -- lewis6991/hover.nvim
    require('hover').open()
  end
end
-- base settings for lsp
local base = function(opts)
  opts = opts or {}
  opts.on_attach = function(_, bufnr)
    -- Disable LSP-based syntax highlighting. This introduces a color change
    -- after LSP gets attached.
    for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
      vim.api.nvim_set_hl(0, group, {})
    end
    local x = { buffer = bufnr, noremap = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, x)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, x)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, x)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, x)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, x)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, x)
  end
  return opts
end

local lsp_add = setmetatable({}, {
  __newindex = function(_, key, value)
    vim.lsp.config(key, base(value))
    vim.lsp.enable(key)
  end,
})

lsp_add['rust_analyzer'] = {
  filetypes = { 'rust' },
  cmd = { 'rust-analyzer' },
  root_markers = { 'Cargo.toml', 'rust-project.json' },
  settings = {
    ['rust-analyzer'] = {
      cargo = { features = 'all' },
      imports = { granularity = { group = 'item' } },
    },
  },
}

lsp_add['python'] = {
  filetypes = { 'python' },
  cmd = { 'pyright-langserver', '--stdio' },
  root_markers = { '.git' },
  settings = {
    python = {
      analysis = {
        useLibraryCodeForTypes = true,
      },
    },
  },
}

-- lsp_add['python'] = {
--   filetypes = { 'python' },
--   cmd = { 'pyright' },
--   settings = {
--     python = {
--       analysis = {
--         useLibraryCodeForTypes = true,
--       },
--     },
--   },
-- }

local lazy_path = vim.fn.stdpath('data') .. '/lazy'
lsp_add['lua'] = {
  filetypes = { 'lua' },
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = luapath },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = {
          [vim.env.VIMRUNTIME .. '/lua'] = true,
          [vim.env.VIMRUNTIME .. '/lua/vim/lsp'] = true,
          [lazy_path .. '/lazy.nvim/lua/lazy'] = true,
          [lazy_path .. '/telescope.nvim/lua/telescope'] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

return { base = base }
--[[

M.matlab_ls = function()
  lsp.matlab_ls.setup {
    -- single_file_support = true,
  }
end
M.clangd = function() lsp.clangd.setup(base { filetypes = { 'c', 'cpp' } }) end
M.ocamllsp = function() lsp.ocamllsp.setup(base()) end
M.typescript = function() lsp.ts_ls.setup(base()) end
M.astro = function() lsp.astro.setup(base()) end
M.python = function()
  lsp.pyright.setup(base {
    -- root_dir = lsp.util.root_pattern('pyproject.toml'),
    settings = {
      python = {
        analysis = {
          -- typeCheckingMode = 'off',
          useLibraryCodeForTypes = true,
        },
      },
    },
  })
end
M.swift = function()
  lsp.sourcekit.setup(base {
    -- cmd = { '/opt/homebrew/opt/swift/bin/sourcekit-lsp' },
    -- cmd = { '/opt/homebrew/opt/swift/Swift-6.0.xctoolchain/usr/bin/sourcekit-lsp' },
    filetypes = { 'objc', 'swift' },
    root_dir = lsp.util.root_pattern('Package.swift', '.git'),
  })
  -- print('GOT HERE')
  -- vim.keymap.set('n', '<leader>n', function()
  --   local bufnr = vim.api.nvim_get_current_buf()
  --   print('Buffer:', bufnr)
  --   local client = vim.lsp.get_active_clients({ name = 'sourcekit' })[1]
  --   if client then
  --     print('Attaching...')
  --     vim.lsp.buf_attach_client(bufnr, client.id)
  --   end
  -- end)
end

M.rust = function()
  lsp.rust_analyzer.setup(base {
    root_dir = lsp.util.root_pattern('Cargo.toml', 'rust-project.json'),
    settings = {
      ['rust-analyzer'] = {
        cargo = { features = 'all' },
        imports = {
          granularity = {
            group = 'item',
          },
        },
      },
    },
  })
end

M.lean = function()
  lsp.leanls.setup(base { root_dir = lsp.util.root_pattern('lakefile.toml') })
end

M.go = function()
  lsp.gopls.setup(base { root_dir = lsp.util.root_pattern('go.mod', '.git') })
end

-- TODO: don't open Location List with this. Ideally, send all diagnostics to
-- global list, or just don't open any lists.
M.zls = function()
  lsp.zls.setup(base {
    handlers = {
      ['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        { virtual_text = true }
      ),
    },
  })
end

-- lua
M.lua = function()
  pcall(function() require('neodev').setup {} end, 'neodev')
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
]]
