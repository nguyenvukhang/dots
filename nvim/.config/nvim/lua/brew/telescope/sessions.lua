local themes = require('telescope.themes')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('brew.core').env.conf

local M = {}

local file_exists = function(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

M.save_session = function(opts)
  -- change path to enable autocomplete for session names
  local original_path = vim.api.nvim_eval("&path")
  local session_path = vim.fn.expand(opts.path)
  vim.cmd('set path='..session_path)

  -- prompt for which session to restore
  print('session directory: ', vim.o.path)
  local new_ses = vim.trim(vim.fn.input("Enter session name > ", "", "file_in_path"))
  vim.cmd('redraw!')

  -- exit on null
  if (new_ses == "") then
    print('[no session name supplied, exiting.]')
    return
  end

  local full_path = session_path .. '/' .. new_ses

  -- check if should overwrite
  local shouldOverwrite
  if (file_exists(full_path)) then
    vim.cmd('redraw!')
    local ask = "[" ..new_ses.. "] already exists. Overwrite? (Y/n) > "
    shouldOverwrite = vim.trim(vim.fn.input(ask))
  else
    shouldOverwrite = "y"
  end
  vim.cmd('redraw!')

  -- execute the write
  if (shouldOverwrite == "y") then
    vim.cmd('mks! '..full_path)
    print('['..new_ses..'] session saved!')
  else
    print('['..new_ses..'] session was not overwritten.')
  end

  -- restore vim path (unset session name autocomplete)
  vim.o.path = original_path
end

-- action to be used in session picker
local delete_session = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local cfm_mes = "Confirm delete session [".. selection.filename.. "]? (Y/n) > "
  local cfm = vim.fn.input(cfm_mes)
  vim.cmd('redraw!')
  if (cfm == 'y' or cfm == 'Y') then
    vim.cmd('silent exec \"!rm '..selection.path..'"')
    -- refresh telescope
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:delete_selection()
  end
end

-- action to be used in session picker
local source_session = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  vim.cmd("source "..selection.path)
end

-- session picker
M.sessions = function()
  require('telescope.builtin').find_files(themes.get_dropdown({
    attach_mappings = function(_, map)
      actions.select_default:replace(source_session)
      map('i', '<C-d>', delete_session)
      return true
    end,
    cwd = conf.."/data/sessions",
    hidden = true,
    previewer = false,
    prompt_title = 'Sessions',
  }))
end

return M
