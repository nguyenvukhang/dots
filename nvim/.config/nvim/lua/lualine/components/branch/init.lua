-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.
local M = require('lualine.component'):extend()
local modules = require('lualine.require').lazy_require {
  git_branch = 'lualine.components.branch.git_branch',
  highlight = 'lualine.highlight',
  utils = 'lualine.utils.utils',
}

-- Initilizer
M.init = function(self, options)
  M.super.init(self, options)
  modules.git_branch.init()
end

M.update_status = function(_, is_focused)
  local buf = (not is_focused and vim.api.nvim_get_current_buf())
  local branch = modules.git_branch.get_branch(buf)
  return modules.utils.stl_escape(branch)
end

return M
