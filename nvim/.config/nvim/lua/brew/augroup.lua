local utils = require('brew.core').utils
local is_git_repo = utils.is_git_repo
local git_root = utils.git_root

local augroup_id = vim.api.nvim_create_augroup("LuaAugroup", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function ()
    if is_git_repo() then
      vim.api.nvim_command("chdir " .. git_root())
    end
    print('augroup id:', augroup_id)
  end,
  group = augroup_id
})
