local sessions_path = require('brew.core').env.conf..'/data/sessions'

local tele = function(keypress, search_type, search_function)
  local final_type
  if search_type == 'builtin' then
    final_type = "telescope.builtin"
  else
    final_type = 'brew.telescope.'..search_type
  end
  vim.api.nvim_set_keymap('n', keypress,
  ':lua require("'..final_type ..'").' ..search_function..'<CR>',
  { noremap = true, silent = true })
end

tele('<C-b>', 'builtin', 'buffers')

-- file search
tele('<C-p>', 'file', 'repo()')
tele('<C-f>', 'file', 'cwd()')

-- word search
tele('<Leader>ps', 'word', 'repo()')
tele('<Leader>pw', 'word', 'cwd()')
tele('<Leader>pf', 'word', 'this_in_repo()')

-- search dots
tele('<Leader>sd', 'file', 'dots()')

-- search university
tele('<Leader>su', 'file', 'university()')

-- search notes
tele('<Leader>sn', 'file', 'notes()')

-- search telescope
tele('<Leader>st', 'file', 'telescope()')

-- search past-open files (recents)
tele('<Leader>sp', 'file', 'recents()')

-- search repos
tele('<Leader>sr', 'file', 'repo_search()')
tele('<Leader>so', 'file', 'other_repos_search()')

-- search vim help
tele('<Leader>sh', 'builtin', 'help_tags()')

-- search manpages
tele('<Leader>sm', 'builtin', 'man_pages()')

-- session
local save_session = 'save_session({ path = "'..sessions_path..'"})'
tele('<Leader>ss', 'sessions', save_session)
tele('<C-s>', 'sessions', 'sessions()')

-- git stuff
tele('<Leader>gs', 'builtin', 'git_status()')
