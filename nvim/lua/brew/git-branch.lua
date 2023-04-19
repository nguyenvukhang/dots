local M = {}

local curr, first_set = { branch = '', gdir = '' }, false
local sep, l = package.config:sub(1, 1), vim.loop
local file_changed = sep ~= '\\' and l.new_fs_event() or l.new_fs_poll()
local gdir_cache = {} -- Stores git paths that we already know of

---sets git_branch variable to branch name or commit hash if not on branch
---@param head_file string full path of .git/HEAD file
local function get_git_head(head_file)
  local f_head = io.open(head_file)
  if f_head then
    local HEAD, _ = f_head:read(), f_head:close()
    local branch = HEAD:match('ref: refs/heads/(.+)$')
    curr.branch = branch and branch or HEAD:sub(1, 7)
  end
end

---updates the current value of git_branch and sets up file watch on HEAD file
local function update_branch()
  if file_changed == nil then return end
  file_changed:stop()
  if curr.gdir and #curr.gdir > 0 then
    local f_head = curr.gdir .. sep .. 'HEAD'
    get_git_head(f_head)
    file_changed:start(f_head, {}, vim.schedule_wrap(update_branch))
  else
    curr.branch = '' -- git dir not found
  end
  M.set_statusline(curr.branch)
end

---@return string, boolean
M.gdir_from_root = function(root, gdir)
  local git_path = root .. sep .. '.git'
  local git_file_stat = vim.loop.fs_stat(git_path)
  if git_file_stat then
    if git_file_stat.type == 'directory' then
      gdir = git_path
    elseif git_file_stat.type == 'file' then
      -- separate git-dir or submodule is used
      local file = io.open(git_path)
      if file then
        gdir, _ = file:read(), file:close()
        gdir = gdir and gdir:match('gitdir: (.+)$')
      end
      -- submodule / relative file path
      if gdir and gdir:sub(1, 1) ~= sep and not gdir:match('^%a:.*$') then
        gdir = git_path:match('(.*).git') .. gdir
      end
    end
    if gdir then
      local hfs = vim.loop.fs_stat(gdir .. sep .. 'HEAD')
      if hfs and hfs.type == 'file' then
        return gdir, true
      else
        return '', false
      end
    end
  end
  return gdir, false
end

---returns full path to git directory for dir_path or current directory
---@return string
function M.find_gdir()
  local dir = vim.fn.expand('%:p:h')
  local root, gdir, found = dir, '', false
  -- Search upward (through parents) for .git file or folder
  while root do
    if gdir_cache[root] then
      gdir = gdir_cache[root]
      break
    end
    gdir, found = M.gdir_from_root(root, gdir)
    if found then break end
    root = root:match('(.*)' .. sep .. '.-')
  end
  gdir_cache[dir] = gdir
  if curr.gdir ~= gdir then curr.gdir = gdir end
  update_branch()
  return gdir
end

function M.init(set_statusline)
  M.set_statusline = set_statusline
  if not first_set then
    first_set = true
    M.set_statusline('')
  end
  M.find_gdir()
end

return M
