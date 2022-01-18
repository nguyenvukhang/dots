local env = require('brew').env
local ignore = require('brew.telescope.ignore')
local git_check = require('brew').utils.is_git_repo

local M = {}

M.cwd = function ()
  require("telescope.builtin").find_files({
    prompt_title = 'Files In CWD',
    file_ignore_patterns = ignore
  })
end

M.repo = function()
  if git_check() then
    require("telescope.builtin").git_files({
      prompt_title = 'Files In Repo',
      file_ignore_patterns = ignore
    })
  else
    print('not in a git repo')
  end
end

-- searches all dotfiles by filename
M.dots = function()
  require("telescope.builtin").find_files({
    hidden = true,
    cwd = env.dots_root,
    prompt_title = "searching dotfiles",
    file_ignore_patterns = ignore,
  })
end

local dir_search = function(opts)
  require("telescope.builtin").find_files({
    hidden = true,
    preview = false,
    cwd = opts.search_dir,
    prompt_title = opts.prompt_title,
    file_ignore_patterns = ignore,
  })
end

-- searches telescope lua files
M.telescope = function()
  dir_search({
    search_dir = env.home..".config/nvim/plugged/telescope.nvim/lua/telescope",
    prompt_title = 'telescope lua files'
  })
end

-- searches my list of repos
M.repo_search = function()
  dir_search({
    search_dir = env.repos,
    prompt_title = 'searching in repos'
  })
end

-- searches recent files
M.recents = function()
  require('telescope.builtin').oldfiles({
    cwd = env.home,
    prompt_title = 'Recent Files'
  })
end

-- searches other repos I've cloned locally
M.other_repos_search = function()
  dir_search({
    search_dir = env.home..'other-repos',
    prompt_title = 'searching in other-repos'
  })
end

M.notes = function()
  dir_search({
    search_dir = env.repos..'notes',
    prompt_title = 'searching in notes'
  })
end


return M
