-- the reson of the existence of this file is because telescope's
-- builtin implementation of send_all_to_qf() includes a function to
-- close the telescope buffer, but I don't want that, since it's
-- already part of select_default()

local action_state = require('telescope.actions.state')
local action_set = require('telescope.actions.set')
local from_entry = require "telescope.from_entry"
local transform_mod = require("telescope.actions.mt").transform_mod

local actions = setmetatable({}, {
  __index = function(_, k)
    error("Key does not exist for 'telescope.actions': " .. tostring(k))
  end,
})

actions.select_default = {
  pre = function(prompt_bufnr)
    action_state.get_current_history():append(
      action_state.get_current_line(),
      action_state.get_current_picker(prompt_bufnr)
    )
  end,
  action = function(prompt_bufnr)
    return action_set.select(prompt_bufnr, "default")
  end,
}

local entry_to_qf = function(entry)
  local text = entry.text

  if not text then
    if type(entry.value) == "table" then
      text = entry.value.text
    else
      text = entry.value
    end
  end

  return {
    bufnr = entry.bufnr,
    filename = from_entry.path(entry, false),
    lnum = vim.F.if_nil(entry.lnum, 1),
    col = vim.F.if_nil(entry.col, 1),
    text = text,
  }
end

local send_all_to_qf = function(prompt_bufnr, mode, target)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local manager = picker.manager

  local qf_entries = {}
  for entry in manager:iter() do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  -- actions.close(prompt_bufnr)

  if target == "loclist" then
    vim.fn.setloclist(picker.original_win_id, qf_entries, mode)
  else
    vim.fn.setqflist(qf_entries, mode)
  end
end

actions.send_to_qflist = function(prompt_bufnr)
  send_all_to_qf(prompt_bufnr, "r")
end

actions = transform_mod(actions)
return actions
