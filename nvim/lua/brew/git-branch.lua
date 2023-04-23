local M = {}
local curr, first_set = { branch = '', gdir = '' }, false
local sep, l = package.config:sub(1, 1), vim.loop
local file_changed = sep ~= '\\' and l.new_fs_event() or l.new_fs_poll()
local gdir_cache = {} -- Stores git paths that we already know of

---sets git_branch variable to branch name or commit hash if not on branch
---@param head_file string full path of .git/HEAD file
local function get_git_head(head_file)
  local f_head = io.open(head_file)
  if not f_head then return end
  local HEAD, _ = f_head:read(), f_head:close()
  local branch = HEAD:match('ref: refs/heads/(.+)$')
  curr.branch = branch and branch or HEAD:sub(1, 7)
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

---@return string
M.gdir_from_root = function(root, gdir)
  local git_path, stat = root .. sep .. '.git', vim.loop.fs_stat
  local git_fs = stat(git_path)
  if not git_fs then return gdir end
  if git_fs.type == 'directory' then
    gdir = git_path
  elseif git_fs.type == 'file' then
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
  if not gdir then return gdir end
  local hfs = stat(gdir .. sep .. 'HEAD')
  return (hfs and hfs.type == 'file') and gdir or ''
end

---returns full path to git directory for dir_path or current directory
---@return string
function M.find_gdir(dir)
  dir = dir or vim.fn.expand('%:p:h')
  local root, gdir = dir, ''
  -- Search parents for .git file or folder
  while root do
    gdir = gdir_cache[root]
    if gdir then break end
    gdir = M.gdir_from_root(root, gdir)
    if gdir and #gdir > 0 then break end
    root = root:match('(.*)' .. sep .. '.-')
  end
  gdir_cache[dir], curr.gdir = gdir, gdir
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

--[[
#!/bin/sh
nvim --headless -c "lua require('brew.git-branch').test()" -c q
--]]

-- M.test = function()
--   local t = require('brew.test-utils')
--   t.setup()
--   t.log = false
--   local cwd = t.tmp_dir
--   local test = function(at, dir, branch)
--     t.assert_eq(M.find_gdir(cwd .. at), cwd .. dir)
--     t.assert_eq(curr.branch, branch)
--   end
--
--   -- create regular git repo and find git branch
--   t.run('mkdir -p r1/a')
--   t.run('cd r1 && git init && git branch -M base1')
--   t.run('cd r1/a && git init && git branch -M base1up')
--   t.run('cd r1 && touch g && git add g && git commit -m "x"')
--
--   test('/r1', '/r1/.git', 'base1')
--   test('/r1/a/b/c', '/r1/a/.git', 'base1up')
--
--   -- bare repository with workspaces in siblings
--   t.run('mkdir -p r2 && cd r2 && git init --bare .git')
--   t.run('cd r2 && git init --bare .git')
--   t.run('cd r2/.git && git branch -M base2')
--   t.run('cd r2 && git worktree add t')
--   t.run('mkdir -p r2/t/a/b/c')
--
--   test('/r2/t/a/b', '/r2/.git', 'base2')
--
--   -- regular repository with workspaces in .git directory
--   t.run('mkdir -p r3 && cd r3 && git init')
--   t.run('cd r3/.git && git branch -M base3')
--   t.run('cd r3/.git && git worktree add t')
--   t.run('mkdir -p r3/.git/t/a/b/c')
--
--   test('/r3/.git/t/a/b', '/r3/.git', 'base3')
--
--   -- git submodule
--   t.run('mkdir -p r4 && cd r4 && git init')
--   t.run('cd r4 && git branch -M base4')
--   local sub = 'https://github.com/nguyenvukhang/void.git'
--   t.run('cd r4 && git submodule add -- ' .. sub .. ' s')
--   t.run('cd r4/s && git branch -M sub_branch')
--   t.run('mkdir -p r4/s/a/b/c')
--
--   test('/r4', '/r4/.git', 'base4')
--   test('/r4/s/a', '/r4/s/../.git/modules/s', 'sub_branch')
--
--   -- not a git repository
--   t.run('mkdir -p r5')
--   t.assert_eq(M.find_gdir(cwd .. '/r5'), nil)
--   t.assert_eq(curr.branch, '')
--
--   -- t.ls()
--   t.teardown()
-- end

return M
