-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy-debug/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup {
  {
    'ibhagwan/fzf-lua',
    keys = function()
      local actions = require('fzf-lua.actions')
      local fzf = require('fzf-lua')
      return {
        {
          '<c-p>',
          function()
            fzf.grep {
              actions = {
                ['enter'] = {
                  fn = function(s, opts)
                    print(vim.inspect(s))
                    local tmp_file = s[1]
                    local fzf_pos = s[2]
                    local entries = vim.split(
                      io.open(tmp_file, 'r'):read('*a'),
                      opts.fzf_opts['--read0'] and '\0' or '\n'
                    )
                    entries[#entries] = nil
                    opts.copen = false
                    actions.file_sel_to_qf(entries, opts)
                    actions.file_edit({ entries[tonumber(fzf_pos)] }, opts)
                  end,
                  prefix = 'select-all',
                  field_index = '{+f} $FZF_POS',
                },
              },
            }
          end,
        },
      }
    end,
    config = function()
      -- hey
      require('fzf-lua').setup()
    end,
  },
}
