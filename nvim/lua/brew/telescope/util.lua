local actions = require('brew.telescope.actions')
local tele = require('telescope.builtin')
local M = { search = {} }

-- stylua: ignore
local ignore = {
  'node_modules', 'LICENSE', 'autoload/plug.vim', '.ccls-cache',
  'yarn.lock', 'error.log', '%.git/', '%.gpg', '%.DS_Store', '%.pdf',
  '%.pdf', '%.png', '%.jpg', '%.gif', '%.sql',
}

--- @param title string
--- @param cwd string
--- @param query? string
M.search.string = function(title, cwd, query)
  tele.grep_string {
    file_ignore_patterns = ignore,
    attach_mappings = function(_, map)
      map('i', '<CR>', actions.send_to_qflist + actions.select_default)
      return true
    end,
    prompt_title = title,
    cwd = cwd,
    search = query,
  }
end

--- @param title string
--- @param cwd? string
M.search.files = function(title, cwd)
  tele.find_files {
    file_ignore_patterns = ignore,
    prompt_title = title,
    cwd = cwd,
  }
end

--- @param title string
M.search.git_files = function(title)
  tele.git_files { file_ignore_patterns = ignore, prompt_title = title }
end

return M
