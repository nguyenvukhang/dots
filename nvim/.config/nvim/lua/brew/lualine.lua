--
-- https://github.com/nvim-lualine/lualine.nvim
--

local colors = require('brew').colors

local standard = {
  a = { bg = colors.bg1,  fg = colors.white },
  b = { bg = colors.bg1,  fg = colors.gray  },
  c = { bg = colors.bg1,  fg = colors.fg4   },
  -- x = { bg = colors.bg1,  fg = colors.green },
  -- y = { bg = colors.bg1,  fg = colors.green },
  -- z = { bg = colors.bg1,  fg = colors.green },
}

local gruvbox = {
  normal = standard,
  insert = standard,
  visual = standard,
  replace = standard,
  command = standard,
  inactive = standard
}

local function wordCount()
  local chars = tostring(vim.fn.wordcount().chars)
  local words = tostring(vim.fn.wordcount().words)
  return "words "..words.." | chars "..chars
end

local setup = function()
  -- makes the statusbar consistent through vim splits
  vim.cmd('highlight Statusline guifg='..colors.bg1)

  -- setup
  require'lualine'.setup {
    options = {
      icons_enabled = false,
      theme = gruvbox,
      component_separators = '', -- within each component
      section_separators = '',   -- across sections
    },
    sections = {
      lualine_a = {'filename'},
      lualine_b = {'branch'},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {wordCount}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }
end

setup()
