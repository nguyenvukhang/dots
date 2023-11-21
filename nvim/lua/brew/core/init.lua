local M, fn = {}, vim.fn

M.load_plugins = require('brew.core.lazy').load_plugins

M.debug = function(x) print(vim.inspect(x)) end

-- checks if quickfix is open
local function qf_is_open() return vim.fn.getqflist({ winid = 0 }).winid ~= 0 end

-- Get path to the root of the git workspace
M.git_workspace_root = function()
  local stdout = fn.systemlist('git rev-parse --show-toplevel')[1]
  return vim.v.shell_error == 0 and stdout or vim.notify('not in a git repo')
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
M.toggle_qflist = function() vim.cmd(qf_is_open() and 'cclose' or 'bel copen') end

-- Toggle diagnostics quickfix list
M.toggle_diagnostics = function()
  -- close diagnostics if qflist is already open
  if qf_is_open() then return vim.cmd('cclose') end

  -- load diagnostics
  local diagnostics = vim.diagnostic.get(0)

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then return vim.notify('No diagnostics') end

  fn.setqflist(vim.diagnostic.toqflist(diagnostics))
  vim.cmd('bel copen') -- open quickfix window
end

-- lists files and sub-directories in a directory
M.list_dir = function(dir)
  return vim.loop.fs_readdir(vim.loop.fs_opendir(dir, nil, 2048))
end

-- returns true on successful execution (sh return code 0)
---@param cmd string
---@return boolean
function M.status(cmd) return vim.fn.system(cmd) and vim.v.shell_error == 0 end

vim.api.nvim_create_augroup('BREW', { clear = true })

---@param opts any
---@param ev? string[]
M.autocmd = function(opts, ev)
  opts['group'], ev = 'BREW', ev or { 'BufRead', 'BufNewFile', 'BufEnter' }
  vim.api.nvim_create_autocmd(ev, opts)
end

---@param cs string comment string e.g. '// %s'
M.comment_string = function(cs)
  vim.api.nvim_buf_set_option(0, 'commentstring', cs)
end

-- Mimics the default / search
---@param query string search query
M.search = function(query)
  query = '\\<' .. query .. '\\>'
  vim.notify_once('/' .. query)
  vim.fn.setreg('/', query)
  return vim.fn.search(query, 's')
end

return M
