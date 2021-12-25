local actions = require 'brew.telescope.actions'
local ignore = require 'brew.telescope.ignore'
local git_workspace_root = require('brew.core').git_workspace_root

local M = {}

local grep = function(opts)
  opts.file_ignore_patterns = ignore
  opts.attach_mappings = function(_, map)
    map('i', '<CR>', actions.send_to_qflist + actions.select_default)
    return true
  end
  require('telescope.builtin').grep_string(opts)
end

-- searches git repository
M.repo = function()
  local search_dir = git_workspace_root()
  if search_dir == nil then return end
  local q = vim.fn.input 'Search For > '
  if q == '' then return end
  grep({ prompt_title = 'Word In Repo', cwd = search_dir, search = q })
end

-- searches cwd
M.cwd = function()
  local cwd = vim.fn.getcwd():gsub(vim.env.HOME, '~')
  local q = vim.fn.input('Search In [' .. cwd .. '] > ')
  if q == '' then return end
  grep({ prompt_title = 'Word In CWD', search = q })
end

-- searches repo for word under cursor
M.this_in_repo = function()
  local search_dir = git_workspace_root()
  if search_dir == nil then return end
  grep({ prompt_title = 'Word In Repo', cwd = search_dir })
end

return M
