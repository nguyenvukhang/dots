local M = {}

M.load_plugins = require('brew.core.lazy').load_plugins

-- checks if quickfix/loclist is open
---@param name 'quickfix' | 'loclist'
local list_is_open = function(name)
  return #vim.fn.filter(vim.fn.getwininfo(), 'v:val.' .. name) > 0
end

-- Get path to the root of the git workspace
M.git_workspace_root = function()
  local stdout = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if stdout:match('fatal: not a git repository') then
    vim.notify('not in a git repo')
    return nil
  else
    return stdout
  end
end

-- stylua: ignore start

-- nnoremap(LHS, RHS, verbose)
M.nnoremap=function(L,R,v)vim.keymap.set('n',L,R,{noremap=true,silent=not v})end
-- vnoremap(LHS, RHS, verbose)
M.vnoremap=function(L,R,v)vim.keymap.set('v',L,R,{noremap=true,silent=not v})end
-- inoremap(LHS, RHS, verbose)
M.inoremap=function(L,R,v)vim.keymap.set('i',L,R,{noremap=true,silent=not v})end
-- onoremap(LHS, RHS, verbose)
M.onoremap=function(L,R,v)vim.keymap.set('o',L,R,{noremap=true,silent=not v})end
-- stylua: ignore end

-- Toggles the quickfix list/window
M.toggle_qflist = function()
  vim.cmd(list_is_open('quickfix') and 'cclose' or 'bel copen')
end

-- Toggle diagnostics quickfix list
M.toggle_diagnostics = function()
  -- close diagnostics if qflist is already open
  if list_is_open('quickfix') then
    vim.cmd('cclose') -- close quickfix window
    return
  end

  -- load diagnostics
  vim.diagnostic.setloclist { open = false }
  local diagnostics = vim.fn.getloclist(0)

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then
    vim.notify('No diagnostics found')
    return
  end

  vim.fn.setqflist(diagnostics)
  vim.cmd('bel copen') -- open quickfix window
end

M.augroup = function(group_name)
  return function(events, opts)
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })
    vim.api.nvim_create_autocmd(
      events,
      vim.tbl_extend('force', { group = group }, opts)
    )
  end
end

-- returns true on successful execution (sh return code 0)
---@param cmd string
M.status = function(cmd)
  return vim.fn.systemlist(cmd .. ' >/dev/null && echo 0 || echo 1')[1] == '0'
end

local augroups = {}

---@param group string
---@param events string[]
---@param pattern string
---@param callback function
M.autocmd = function(group, events, pattern, callback)
  group = string.upper(group) .. '_GROUP'
  if augroups[group] == nil then
    augroups[group] = vim.api.nvim_create_augroup(group, { clear = true })
  end
  local x = { pattern = pattern, callback = callback, group = augroups[group] }
  vim.api.nvim_create_autocmd(events, x)
end

return M
