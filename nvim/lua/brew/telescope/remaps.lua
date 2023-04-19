local builtin = require('telescope.builtin')
local nnoremap = require('brew.core').nnoremap
local git_workspace_root = require('brew.core').git_workspace_root
local search = { files = {}, string = {} }
local telescope = require('telescope.builtin')

-- stylua: ignore
local t = { file_ignore_patterns = {
  'node_modules', 'LICENSE', 'autoload/plug.vim', '.ccls-cache',
  'yarn.lock', 'error.log', '%.git/', '%.gpg', '%.DS_Store', '%.pdf',
  '%.pdf', '%.png', '%.jpg', '%.gif', '%.sql',
}}

-- git repo operations
search.files.repo = function()
  if not git_workspace_root() then return end
  t.prompt_title, t.cwd, t.search = 'Files in Repo', nil, nil
  telescope.git_files(t)
end
search.string.repo = function()
  local repo_dir = git_workspace_root()
  if repo_dir == nil then return end
  local query = vim.fn.input('Search For > ')
  if query == '' then return end
  t.prompt_title, t.cwd, t.search = 'Word in Repo', repo_dir, query
  telescope.grep_string(t)
end

-- current working dir operations
search.files.cwd = function()
  t.prompt_title, t.cwd, t.search = 'Files in CWD', nil, nil
  telescope.find_files(t)
end
search.string.cwd = function()
  local cwd = vim.fn.getcwd():gsub(vim.env.HOME, '~')
  local query = vim.fn.input('Search In [' .. cwd .. '] > ')
  if query == '' then return end
  t.prompt_title, t.cwd, t.search = 'Word in CWD', cwd, query
  telescope.grep_string(t)
end

search.string.cursor = function()
  local repo_dir = git_workspace_root()
  if repo_dir == nil then return end
  t.prompt_title, t.cwd, t.search = 'Word in Repo', repo_dir, nil
  telescope.grep_string(t)
end

search.files.dots = function()
  t.prompt_title, t.cwd, t.search = 'dotfiles', vim.env.DOTS, nil
  telescope.find_files(t)
end
search.files.university = function()
  t.prompt_title, t.cwd, t.search = 'university', vim.env.UNI, nil
  telescope.find_files(t)
end

-- remaps!

nnoremap('<c-b>', builtin.buffers)
nnoremap('<c-p>', search.files.repo)
nnoremap('<c-f>', search.files.cwd)
-- the only other remap that starts with p is reserved for code formatting
nnoremap('<leader>ps', search.string.repo)
nnoremap('<leader>pf', search.string.cursor)
nnoremap('<leader>pw', search.string.cwd)

nnoremap('<leader>sd', search.files.dots)
nnoremap('<leader>su', search.files.university)

nnoremap('<leader>sh', builtin.help_tags)
nnoremap('<leader>sm', builtin.man_pages)
nnoremap('<leader>gs', builtin.git_status)
