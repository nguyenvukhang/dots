local sessions_path = require('brew.core').env.conf..'/data/sessions'

local tele = function(keypress, search_type, search_function)
  local final_type
  if search_type == 'builtin' then
    final_type = "telescope.builtin"
  else
    final_type = 'brew.telescope.'..search_type
  end
  vim.api.nvim_set_keymap('n', keypress,
  ':lua require("'..final_type ..'").' ..search_function..'<cr>',
  { noremap = true, silent = true })
end

tele('<c-b>', 'builtin', 'buffers()')

-- file search
tele('<c-p>', 'file', 'repo()')
tele('<c-f>', 'file', 'cwd()')

-- word search
tele('<leader>ps', 'word', 'repo()')
tele('<leader>pw', 'word', 'cwd()')
tele('<leader>pf', 'word', 'this_in_repo()')

-- search dots
tele('<leader>sd', 'file', 'dots()')

-- search university
tele('<leader>su', 'file', 'university()')

-- search notes
tele('<leader>sn', 'file', 'notes()')

-- search telescope
tele('<leader>st', 'file', 'telescope()')

-- search past-open files (recents)
tele('<leader>sp', 'file', 'oldfiles()')

-- search repos
tele('<leader>sr', 'file', 'repo_search()')
tele('<leader>so', 'file', 'other_repos_search()')

-- search vim help
tele('<leader>sh', 'builtin', 'help_tags()')

-- search manpages
tele('<leader>sm', 'builtin', 'man_pages()')

-- session
local save_session = 'save_session({ path = "'..sessions_path..'"})'
tele('<leader>ss', 'sessions', save_session)
tele('<c-s>', 'sessions', 'sessions()')

-- git stuff
tele('<leader>gs', 'builtin', 'git_status()')
