--
-- https://github.com/nvim-lualine/lualine.nvim
--

local colors = require('brew.core').colors

local bg = colors.bg1
local s = {
  a = { bg = bg, fg = colors.white },
  b = { bg = bg, fg = colors.gray  },
  c = { bg = bg, fg = colors.fg4   },
}

local function wordCount()
  local chars = tostring(vim.fn.wordcount().chars)
  local words = tostring(vim.fn.wordcount().words)
  return "words "..words.." | chars "..chars
end

local setup = function()
  -- makes the statusbar consistent through vim splits
  vim.cmd('hi StatusLine guifg='..colors.bg2)

  -- setup
  require('lualine').setup {
    options = {
      icons_enabled = false,
      component_separators = '', -- within each component
      section_separators = '',   -- across sections
      theme = { normal = s, insert = s, visual = s, replace = s, command = s, inactive = s },
    },
    sections = {
      lualine_a = {'filename'},
      lualine_b = {'branch'},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {'filename'},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
  }
end

setup()
