local M = {}
-- sends lsp diagnostics on current window into
-- quickfix/local list
M.diagnostics = function ()
  -- close diagnostics if qflist is already open
  local utils = require('brew.core').utils
  if utils.qflist_is_open() then
    vim.cmd('cclose') print(' ') return
  end

  -- load diagnostics
  local diagnostics = vim.diagnostic.get()

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then
    print "No diagnostics found"
  else
    vim.diagnostic.setqflist()
  end
end

return M
