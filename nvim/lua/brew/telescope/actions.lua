-- the reson of the existence of this file is because telescope's
-- builtin implementation of send_all_to_qf() includes a function to
-- close the telescope buffer, but I don't want that, since it's
-- already part of select_default()

local as = require('telescope.actions.state')
local actions, pk = require('telescope.actions'), as.get_current_picker
local hist = as.get_current_history

actions.select_default = {
  pre = function(bf) hist():append(as.get_current_line(), pk(bf), false) end,
  action = function(bf)
    local m, qf = pk(bf).manager, {}
    for e in m:iter() do
      table.insert(qf, {
        bufnr = e.bufnr,
        lnum = vim.F.if_nil(e.lnum, 1),
        col = vim.F.if_nil(e.col, 1),
        filename = require('telescope.from_entry').path(e, false, false),
        text = e.text and e.text
          or type(e.value) == 'table' and e.value.text
          or e.value,
      })
    end
    vim.fn.setqflist(qf, 'r')
    return require('telescope.actions.set').select(bf, 'default')
  end,
}

return require('telescope.actions.mt').transform_mod(actions)
