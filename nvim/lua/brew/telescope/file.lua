local ignore = require 'brew.telescope.ignore'
local git_workspace_root = require('brew.core').git_workspace_root
local tele = require 'telescope.builtin'

local M = {}

M.repo = function()
  if not git_workspace_root() then return end
  tele.git_files({
    prompt_title = 'Files In Repo',
    file_ignore_patterns = ignore,
  })
end

M.cwd = function()
  tele.find_files({
    prompt_title = 'Files In CWD',
    file_ignore_patterns = ignore,
  })
end

local function make_searcher(opts)
  return function()
    opts.hidden = true
    opts.preview = false
    opts.file_ignore_patterns = ignore
    print('GOT HERE')
    tele.find_files(opts)
  end
end

local config = {
  -- searches dotfiles
  { type = 'dots', cwd = vim.env.DOTS, title = 'dotfiles' },
  -- searches university files
  { type = 'university', cwd = vim.env.UNI, title = 'university' },
}

-- put all the searchers together
for _, v in ipairs(config) do
  M[v.type] = make_searcher({
    search_dirs = v.dirs,
    prompt_title = v.title,
    cwd = v.cwd,
  })
end

return M
