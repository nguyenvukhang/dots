local builtin = require('telescope.builtin')
local nnoremap = require('brew.core').nnoremap
local util = require('brew.telescope.util')
local git_workspace_root = require('brew.core').git_workspace_root
local search = { files = {}, string = {} }

-- git repo operations
search.files.repo = function()
  if not git_workspace_root() then return end
  util.search.git_files('Files in Repo')
end
search.string.repo = function()
  local repo_dir = git_workspace_root()
  if repo_dir == nil then return end
  local q = vim.fn.input('Search For > ')
  if q == '' then return end
  util.search.string('Word In Repo', repo_dir, q)
end

-- current working dir operations
search.files.cwd = function() util.search.files('Files in CWD') end
search.string.cwd = function()
  local cwd = vim.fn.getcwd():gsub(vim.env.HOME, '~')
  local q = vim.fn.input('Search In [' .. cwd .. '] > ')
  if q == '' then return end
  util.search.string('Word In CWD', cwd, q)
end

search.string.cursor = function()
  local repo_dir = git_workspace_root()
  if repo_dir == nil then return end
  util.search.string('Word in Repo', repo_dir)
end

search.files.dots = function() util.search.files('dotfiles', vim.env.DOTS) end
search.files.university = function() util.search.files('university', vim.env.UNI) end

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
