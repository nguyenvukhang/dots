local core = require('brew')
local nnoremap, vnoremap = core.nnoremap, core.vnoremap
local config = {}
local dir = {}
local build = {}

config['nvim-treesitter/nvim-treesitter'] = function()
  -- list of languages that use treesitter for syntax highlighting
  local enabled = { 'latex' }
  -- stylua: ignore
  local _ = {
    'javascript', 'typescript', 'c', 'lua', 'rust', 'tsx', 'css', 'astro',
    'java', 'latex', 'markdown', 'markdown_inline', 'python', 'swift' }
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      disable = function(l, _) return not vim.tbl_contains(enabled, l) end,
      additional_vim_regex_highlighting = false,
    },
    ensure_installed = enabled,
  }
end

config['nvim-telescope/telescope.nvim'] = function() require('brew.telescope') end

config['sbdchd/neoformat'] = function()
  vim.g.latexindent_opt = '-l -m'
  vim.g.neoformat_enabled_python = { 'black' }
end

config['rose-pin/neovim'] = function()
  -- print("GOT HERE")
  require('rose-pine').setup { variant = 'main', disable_background = true }
end

dir['hrsh7th/nvim-cmp'] = '/Users/khang/repos/nvim-cmp'

return function(t)
  for i = 1, #t do
    t[i] = { t[i], config = config[t[i]], build = build[t[i]], dir = dir[t[i]] }
  end
  return t
end
