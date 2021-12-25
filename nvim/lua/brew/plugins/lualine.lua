--
-- https://github.com/nvim-lualine/lualine.nvim
--

-- stylua: ignore
local gruvbox = { black = '#282828', white = '#ebdbb2', red = '#fb4934', green = '#b8bb26', blue = '#83a598', yellow = '#fabd2f', gray = '#928374', bg1 = '#3c3836', bg2 = '#504945', bg3 = '#665c54', bg4 = '#7c6f64', fg4 = '#a89984', fg3 = '#bdae93', fg2 = '#d5c4a1', fg1 = '#ebdbb2', fg0 = '#f9f5d7', lightgray = '#504945', inactivegray = '#7c6f64', orange = '#fe8019', }

local bg = gruvbox.bg1
local s = {
  a = { bg = bg, fg = gruvbox.white },
  b = { bg = bg, fg = gruvbox.gray },
  c = { bg = bg, fg = gruvbox.fg4 },
}

-- local function countChars()
--   return 'chars: ' .. vim.fn.wordcount().chars
-- end

-- makes the statusbar consistent through vim splits
vim.api.nvim_set_hl(0, 'StatusLine', { bg = bg })

local setup_opts = {
  options = {
    path = 1,
    icons_enabled = false,
    component_separators = '', -- within each component
    section_separators = '', -- across sections
    theme = { normal = s },
  },
  sections = {
    lualine_a = { 'filename' },
    lualine_b = { 'branch' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { 'filename' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

-- setup
-- require('lualine').setup(setup_opts)
