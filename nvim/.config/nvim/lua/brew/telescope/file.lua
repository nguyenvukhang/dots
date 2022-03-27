local env = require('brew.core').env
local ignore = require('brew.telescope.ignore')
local is_git_repo = require('brew.core').utils.is_git_repo

local M = {}

M.repo = function()
  if not is_git_repo() then print('not in a git repo') return end
  require('telescope.builtin').git_files({
    prompt_title = 'Files In Repo',
    file_ignore_patterns = ignore
  })
end

M.cwd = function()
  require('telescope.builtin').find_files({
    prompt_title = 'Files In CWD',
    file_ignore_patterns = ignore,
  })
end

-- searches recent files
M.oldfiles = function()
  require('telescope.builtin').oldfiles({
    cwd = env.home,
    prompt_title = 'Recent Files'
  })
end

local dir_search = function(opts)
  opts.hidden = true
  opts.preview = false
  opts.file_ignore_patterns = ignore
  require('telescope.builtin').find_files(opts)
end

-- searches dotfiles
M.dots = function()
  dir_search({
    cwd = env.dots_root,
    search_dirs = env.dots,
    prompt_title = "dotfiles",
  })
end

-- searches telescope lua files
M.telescope = function()
  dir_search({
    cwd = env.home.."/.config/nvim/plugged/telescope.nvim/lua/telescope",
    prompt_title = 'telescope lua files'
  })
end

-- searches university files
M.university = function()
  dir_search({
    cwd = env.repos.."/uni",
    prompt_title = 'university files'
  })
end

-- searches my list of repos
M.repo_search = function()
  dir_search({
    cwd = env.repos,
    prompt_title = 'searching in repos'
  })
end

-- searches other repos I've cloned locally
M.other_repos_search = function()
  dir_search({
    cwd = env.home..'/other-repos',
    prompt_title = 'searching in other-repos'
  })
end

-- searches notes directory
M.notes = function()
  dir_search({
    cwd = env.repos..'/notes',
    prompt_title = 'searching in notes'
  })
end

return M
