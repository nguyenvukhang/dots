-- Bootstrap lazy.nvim
local root = vim.fn.stdpath('data') .. '/lazy-debug'
local lazypath = root .. '/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
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
  root = root,
  spec = {
    {
      'ibhagwan/fzf-lua',
      opts = {
        winopts = {
          preview = {
            vertical = 'up:45%',
            horizontal = 'right:50%',
          },
        },
        hls = {
          border = 'Comment',
          preview_border = 'Comment',
        },
        -- Specific picker options
        files = {
          winopts = {
            preview = { hidden = true },
          },
        },
      },
    },
  },
}
