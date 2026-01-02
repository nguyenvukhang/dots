local M, c, cache = {}, { b = '', d = '' }, {}
local sep, l = package.config:sub(1, 1), vim.loop
local df = sep ~= '\\' and l.new_fs_event() or l.new_fs_poll()

local function get_head(f)
  local h = io.open(f)
  if not h then return end
  local HEAD, _ = h:read(), h:close()
  local b = HEAD:match('ref: refs/heads/(.+)$')
  c.b = b and b or HEAD:sub(1, 7)
end

local function update_branch()
  if df == nil then return end
  df:stop()
  if c.d and #c.d > 0 then
    local f = c.d .. sep .. 'HEAD'
    get_head(f)
    df:start(f, sep ~= '\\' and {} or 1000, vim.schedule_wrap(update_branch))
  else
    c.b = '' -- git dir not found
  end
  M.set_statusline(c.b)
end

M.find = function(rt, gd)
  local gp, stat = rt .. sep .. '.git', vim.loop.fs_stat
  local gf = stat(gp)
  if not gf then return gd end
  if gf.type == 'directory' then
    gd = gp
  elseif gf.type == 'file' then
    -- separate git-dir or submodule is used
    local file = io.open(gp)
    if file then
      gd, _ = file:read(), file:close()
      gd = gd and gd:match('gitdir: (.+)$')
    end
    -- submodule / relative file path
    if gd and gd:sub(1, 1) ~= sep and not gd:match('^%a:.*$') then
      gd = gp:match('(.*).git') .. gd
    end
  end
  if not gd then return gd end
  local h = stat(gd .. sep .. 'HEAD')
  return (h and h.type == 'file') and gd or ''
end

function M.find_git_dir(dir)
  dir = dir or vim.fn.expand('%:p:h')
  local rt, gd = dir, ''
  -- Search parents for .git file or folder
  while rt do
    gd = cache[rt]
    if gd then break end
    gd = M.find(rt, gd)
    if gd and #gd > 0 then break end
    rt = rt:match('(.*)' .. sep .. '.-')
  end
  cache[dir], c.d = gd, gd
  update_branch()
  return gd
end

function M.init(set_statusline)
  M.set_statusline = set_statusline
  M.find_git_dir()
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
--     t.assert_eq(M.find_git_dir(cwd .. at), cwd .. dir)
--     t.assert_eq(c.b, branch)
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
--   t.assert_eq(M.find_git_dir(cwd .. '/r5'), nil)
--   t.assert_eq(c.b, '')
--
--   -- t.ls()
--   t.teardown()
-- end

return M
