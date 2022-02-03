--
-- https://github.com/lervag/vimtex
--

local brew = require'brew'
local home = brew.env.home
local is_git_repo = brew.utils.is_git_repo

vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_syntax_enabled = true

if is_git_repo(vim.fn.getcwd()) then
  function os.capture(cmd)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    return s
  end

  local cmd_get = function (cmd, t)
    local table = t or false
    local r = os.capture(cmd)
    if r == nil or r == '' then
      return nil
    else
      if table then
        return utils.split(r, '\n\r')
      else -- return string
        return r:gsub('[\r\n]$', '')
      end
    end
  end

  local git_remote = function (dir, upstream)
    local origin = upstream or 'origin'
    local r = cmd_get("git -C "..dir.." config --get remote."..origin..".url")
    -- lua regex: https://www.lua.org/pil/20.2.html
    r = r:gsub('^https://.*/(.*)/', '%1/')
    r = r:gsub('^git@.*:', '')
    r = r:gsub('%.git$', '')
    local _, _, owner, repo_name = string.find(r, "^(.*)/(.*)$")
    return owner, repo_name
  end
  local owner, repo_name = git_remote(vim.fn.getcwd())

  if repo_name == 'uni' then
    vim.g.vimtex_compiler_latexmk = {
      build_dir = home..'repos/uni/tex'
    }
  end
end
