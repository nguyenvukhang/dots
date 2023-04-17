-- the reson of the existence of this file is because telescope's
-- builtin implementation of send_all_to_qf() includes a function to
-- close the telescope buffer, but I don't want that, since it's
-- already part of select_default()

local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local action_select = require('telescope.actions.set').select
local path = require('telescope.from_entry').path
local transform_mod = require('telescope.actions.mt').transform_mod

local entry_text = function(entry)
  if entry.text then return entry.text end
  return type(entry.value) == 'table' and entry.value.text or entry.value
end

actions.select_default = {
  pre = function(prompt_bufnr)
    action_state.get_current_history():append(
      action_state.get_current_line(),
      action_state.get_current_picker(prompt_bufnr),
      false
    )
  end,
  action = function(prompt_bufnr)
    local m, qf = action_state.get_current_picker(prompt_bufnr).manager, {}
    for entry in m:iter() do
      table.insert(qf, {
        bufnr = entry.bufnr,
        filename = path(entry, false, false),
        lnum = vim.F.if_nil(entry.lnum, 1),
        col = vim.F.if_nil(entry.col, 1),
        text = entry_text(entry),
      })
    end
    vim.fn.setqflist(qf, 'r')
    return action_select(prompt_bufnr, 'default')
  end,
}

return transform_mod(actions)
