local git_workspace_root = require('brew.server.utils').git_workspace_root
local M, builtin = { files = {}, string = {} }, require('telescope.builtin')

local t = {
  file_ignore_patterns = {
    'node_modules',
    'LICENSE',
    'autoload/plug.vim',
    '.ccls-cache',
    'yarn.lock',
    'error.log',
    '%.git/',
    '%.gpg',
    '%.DS_Store',
    '%.pdf',
    '%.pdf',
    '%.png',
    '%.jpg',
    '%.gif',
    '%.ttf',
    '%.afdesign',
    '%.afphoto',
    'Cargo.lock',
    -- '%.sql',
  },
}

-- git repo operations

M.files.repo = function()
  if not git_workspace_root() then return end
  t.prompt_title, t.cwd, t.search = 'Files in Repo', nil, nil
  builtin.git_files(t)
end

M.string.repo = function()
  local repo_dir = git_workspace_root()
  if not repo_dir then return end
  local query = vim.fn.input('Search For > ')
  if query == '' then return end
  t.prompt_title, t.cwd, t.search = 'Word in Repo', repo_dir, query
  builtin.grep_string(t)
end

M.string.repo_live = function()
  local repo_dir = git_workspace_root()
  if not repo_dir then return end
  t.prompt_title, t.cwd = 'Word in Repo (Live)', repo_dir
  builtin.live_grep(t)
end

-- current working dir operations

M.files.cwd = function()
  t.prompt_title, t.cwd, t.search = 'Files in CWD', nil, nil
  builtin.find_files(t)
end

M.string.cwd = function()
  local cwd = vim.fn.getcwd():gsub(vim.env.HOME, '~')
  local query = vim.fn.input('Search In [' .. cwd .. '] > ')
  if query == '' then return end
  t.prompt_title, t.cwd, t.search = 'Word in CWD', cwd, query
  builtin.grep_string(t)
end

-- other custom searchers

M.string.cursor = function()
  local repo_dir = git_workspace_root()
  if repo_dir == nil then return end
  t.prompt_title, t.cwd, t.search = 'Word in Repo', repo_dir, nil
  builtin.grep_string(t)
end

M.files.dots = function()
  t.prompt_title, t.cwd, t.search = 'dotfiles', vim.env.DOTS, nil
  builtin.find_files(t)
end

M.files.university = function()
  t.prompt_title, t.cwd, t.search = 'university', vim.env.UNI, nil
  builtin.find_files(t)
end

return M
