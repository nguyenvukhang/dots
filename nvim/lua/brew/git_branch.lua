local M = {}

local current_git_branch = ''
local current_git_dir = ''
-- os specific path separator
local sep = package.config:sub(1, 1)
-- event watcher to watch head file
-- Use file watch for non Windows and poll for Windows.
-- Windows doesn't like file watch for some reason.
local file_changed = sep ~= '\\' and vim.loop.new_fs_event()
  or vim.loop.new_fs_poll()
local git_dir_cache = {} -- Stores git paths that we already know of

---sets git_branch variable to branch name or commit hash if not on branch
---@param head_file string full path of .git/HEAD file
local function get_git_head(head_file)
  local f_head = io.open(head_file)
  if f_head then
    local HEAD = f_head:read()
    f_head:close()
    local branch = HEAD:match 'ref: refs/heads/(.+)$'
    current_git_branch = branch and branch or HEAD:sub(1, 7)
  end
end

---updates the current value of git_branch and sets up file watch on HEAD file
local function update_branch()
  if file_changed == nil then return end
  file_changed:stop()
  local git_dir = current_git_dir
  if git_dir and #git_dir > 0 then
    local head_file = git_dir .. sep .. 'HEAD'
    get_git_head(head_file)
    file_changed:start(
      head_file,
      sep ~= '\\' and {} or 1000,
      vim.schedule_wrap(update_branch)
    )
  else
    current_git_branch = '' -- when git dir was not found
  end
  M.set_statusline(current_git_branch)
end

---@return string, boolean
M.git_dir_from_root = function(root_dir, git_dir)
  local git_path = root_dir .. sep .. '.git'
  local git_file_stat = vim.loop.fs_stat(git_path)
  if git_file_stat then
    if git_file_stat.type == 'directory' then
      git_dir = git_path
    elseif git_file_stat.type == 'file' then
      -- separate git-dir or submodule is used
      local file = io.open(git_path)
      if file then
        git_dir = file:read()
        git_dir = git_dir and git_dir:match 'gitdir: (.+)$'
        file:close()
      end
      -- submodule / relative file path
      if
        git_dir
        and git_dir:sub(1, 1) ~= sep
        and not git_dir:match '^%a:.*$'
      then
        git_dir = git_path:match '(.*).git' .. git_dir
      end
    end
    if git_dir then
      local head_file_stat = vim.loop.fs_stat(git_dir .. sep .. 'HEAD')
      if head_file_stat and head_file_stat.type == 'file' then
        return git_dir, true
      else
        return '', false
      end
    end
  end
  return git_dir, false
end

---returns full path to git directory for dir_path or current directory
---@return string
function M.find_git_dir()
  local file_dir = vim.fn.expand '%:p:h' -- dir of current buffer
  local root_dir, git_dir = file_dir, ''
  local to_break = false
  -- Search upward for .git file or folder
  while root_dir do
    if git_dir_cache[root_dir] then
      git_dir = git_dir_cache[root_dir]
      break
    end
    git_dir, to_break = M.git_dir_from_root(root_dir, git_dir)
    if to_break then break end
    root_dir = root_dir:match('(.*)' .. sep .. '.-')
  end
  git_dir_cache[file_dir] = git_dir
  if current_git_dir ~= git_dir then
    current_git_dir = git_dir
    update_branch()
  end
  return git_dir
end

function M.init(set_statusline)
  M.set_statusline = set_statusline
  M.set_statusline ''
  M.find_git_dir()
end

return M
