local M = {}
local a_state = require('telescope.actions.state')
local a_set = require('telescope.actions.set')

M.qf_and_jump = function(bufnr)
  local m, qf = a_state.get_current_picker(bufnr).manager, {}
  for e in m:iter() do
    local i, t, v = { bufnr = e.bufnr }, e.text, e.value
    i.filename = require('telescope.from_entry').path(e, false, false)
    i.lnum, i.col = vim.F.if_nil(e.lnum, 1), vim.F.if_nil(e.col, 1)
    i.text = t and t or type(v) == 'table' and v.text or v
    table.insert(qf, i)
  end
  vim.fn.setqflist(qf, 'r')
  return a_set.select(bufnr, 'default')
end

return M
