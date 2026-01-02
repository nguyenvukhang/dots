local M, fn = {}, vim.fn

-- checks if quickfix is open
local function qf_is_open() return vim.fn.getqflist({ winid = 0 }).winid ~= 0 end

-- Get path to the root of the git workspace
M.git_workspace_root = function()
  local stdout = fn.systemlist('git rev-parse --show-toplevel')[1]
  return vim.v.shell_error == 0 and stdout or vim.notify('not in a git repo')
end

-- `require`, but guarded.
-- USAGE
-- local mod = prequire("test")
-- if mod then
-- end
M.prequire = function(m)
  local ok, err = pcall(require, m)
  if not ok then return nil, err end
  return err
end

-- Toggles the quickfix list/window
M.toggle_qflist = function() vim.cmd(qf_is_open() and 'cclose' or 'bel copen') end

-- Toggle diagnostics quickfix list
M.toggle_local_diagnostics = function()
  -- close diagnostics if qflist is already open
  if qf_is_open() then return vim.cmd('cclose') end

  -- load diagnostics of local buffer
  local diagnostics = vim.diagnostic.get(0)

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then return vim.notify('No diagnostics') end

  fn.setqflist(vim.diagnostic.toqflist(diagnostics))
  vim.cmd('bel copen') -- open quickfix window
end

-- This kinda doesn't work.
M.toggle_local_errors = function()
  -- close diagnostics if qflist is already open
  if qf_is_open() then return vim.cmd('cclose') end

  -- load diagnostics of local buffer
  local diagnostics = vim.diagnostic.get(0)
  diagnostics = vim.tbl_filter(
    function(v) return v.severity <= 1 end,
    diagnostics
  )

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

M.common_augroup = '__BREW__'

vim.api.nvim_create_augroup(M.common_augroup, { clear = true })

---@param opts any
---@param ev? string[]
M.autocmd = function(opts, ev)
  opts['group'] = M.common_augroup
  vim.api.nvim_create_autocmd(
    ev or { 'BufRead', 'BufNewFile', 'BufEnter' },
    opts
  )
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

-- Requires that the user is currently in visual mode (not visual line mode),
-- and also assume that the visual mode spans only one line.
--
-- Splits the line into `left`, `selection`, and `right`.
M.split_visual_line = function()
  local r, l, line = vim.fn.col('.'), vim.fn.col('v'), vim.fn.getline('.')
  if r < l then
    l, r = r, l
  end
  return line:sub(0, l - 1), line:sub(l, r), line:sub(r + 1)
end

return M
