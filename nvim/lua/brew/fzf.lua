local M = {}
local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')
local git_workspace_root = require('brew.server.utils').git_workspace_root

local grep_actions = {
  ['enter'] = {
    fn = function(selection, opts)
      -- print('GOT HERE')
      -- local fzf_pos = tonumber(table.remove(selection, #selection))
      -- opts.copen = false
      -- actions.file_sel_to_qf(selection, opts)
      -- actions.file_edit({ selection[fzf_pos] }, opts)
      actions.file_edit({ selection[1] }, opts)
    end,
    -- prefix = 'select-all',
    -- '{+}' is where all the output will be dumped, and then $FZF_POS will be
    -- printed after.
    -- field_index = '{+} $FZF_POS',
  },
}

-- File searchers --------------------------------------------------------------

-- Search files in the CWD.
M.files = function() fzf.files { winopts = { width = 0.5, height = 0.5 } } end

-- Search files in the git repo.
M.git_files = function()
  local cwd = git_workspace_root()
  if cwd then fzf.git_files { cwd = cwd } end
end

-- Word searchers --------------------------------------------------------------

-- Search words in the CWD.
M.grep = function()
  local prompt = 'CWD Search > '
  fzf.grep { input_prompt = prompt, actions = grep_actions }
end

-- Search words in the git repo.
M.git_grep = function()
  local prompt = 'Repo Search > '
  local cwd = git_workspace_root()
  if cwd then
    fzf.grep { cwd = cwd, input_prompt = prompt, actions = grep_actions }
  end
end

-- Search for <cword> in the git repo.
M.grep_cword = function()
  local cwd = git_workspace_root()
  if cwd then fzf.grep_cword { cwd = cwd, actions = grep_actions } end
end

return M
