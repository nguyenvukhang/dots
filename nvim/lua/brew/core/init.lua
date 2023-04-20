local M, fn = {}, vim.fn

M.load_plugins = require('brew.core.lazy').load_plugins

-- checks if quickfix/loclist is open
---@param n 'quickfix' | 'loclist'
local function is_open(n) return #fn.filter(fn.getwininfo(), 'v:val.' .. n) > 0 end

-- Get path to the root of the git workspace
M.git_workspace_root = function()
  local stdout = fn.systemlist('git rev-parse --show-toplevel')[1]
  if stdout:match('fatal: not a git repository') then
    return vim.notify('not in a git repo')
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
  vim.cmd(is_open('quickfix') and 'cclose' or 'bel copen')
end

-- Toggle diagnostics quickfix list
M.toggle_diagnostics = function()
  -- close diagnostics if qflist is already open
  if is_open('quickfix') then return vim.cmd('cclose') end

  -- load diagnostics
  vim.diagnostic.setloclist { open = false }
  local diagnostics = fn.getloclist(0)

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then return vim.notify('No diagnostics') end

  fn.setqflist(diagnostics)
  vim.cmd('bel copen') -- open quickfix window
end

-- returns true on successful execution (sh return code 0)
---@param cmd string
function M.status(cmd)
  return fn.systemlist(cmd .. ' >/dev/null && echo 0 || echo 1')[1] == '0'
end

vim.api.nvim_create_augroup('BREW', { clear = true })

---@param ev? string[]
---@param opts any
M.autocmd = function(ev, opts)
  opts['group'], ev = 'BREW', ev or { 'BufRead', 'BufNewFile', 'BufEnter' }
  vim.api.nvim_create_autocmd(ev, opts)
end

return M
