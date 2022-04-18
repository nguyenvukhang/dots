local utils = require('brew.core').utils
local cwd_in_git_repo = utils.cwd_in_git_repo
local git_root_from_path = utils.git_root_from_path

local augroup_id = vim.api.nvim_create_augroup("LuaAugroup", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function ()
    local fn = vim.fn.getbufinfo()[1]
    if fn.name == '' then return end
    local file_dir = string.match(fn.name, ".*/")
    if cwd_in_git_repo(file_dir) then
      vim.api.nvim_command("chdir " .. git_root_from_path(file_dir))
    end
  end,
  group = augroup_id
})
