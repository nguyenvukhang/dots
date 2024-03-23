local M, fn = {}, vim.fn

M.debug = function(x) print(vim.inspect(x)) end

-- checks if quickfix is open
local function qf_is_open() return vim.fn.getqflist({ winid = 0 }).winid ~= 0 end

-- Get path to the root of the git workspace
M.git_workspace_root = function()
  local stdout = fn.systemlist('git rev-parse --show-toplevel')[1]
  return vim.v.shell_error == 0 and stdout or vim.notify('not in a git repo')
end

-- Toggles the quickfix list/window
M.toggle_qflist = function() vim.cmd(qf_is_open() and 'cclose' or 'bel copen') end

-- Toggle diagnostics quickfix list
local toggle_diagnostics = function(all)
  -- close diagnostics if qflist is already open
  if qf_is_open() then return vim.cmd('cclose') end

  -- load diagnostics
  local diagnostics
  if all then
    diagnostics = vim.diagnostics.get()
  else
    diagnostics = vim.diagnostics.get(0)
  end

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then return vim.notify('No diagnostics') end

  fn.setqflist(vim.diagnostic.toqflist(diagnostics))
  vim.cmd('bel copen') -- open quickfix window
end

M.toggle_diagnostics = function() toggle_diagnostics(false) end
M.toggle_all_diagnostics = function() toggle_diagnostics(true) end

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
