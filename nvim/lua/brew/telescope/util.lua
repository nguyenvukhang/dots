local t, M = require('telescope.builtin'), { search = {} }

-- stylua: ignore
local ignore = {
  'node_modules', 'LICENSE', 'autoload/plug.vim', '.ccls-cache',
  'yarn.lock', 'error.log', '%.git/', '%.gpg', '%.DS_Store', '%.pdf',
  '%.pdf', '%.png', '%.jpg', '%.gif', '%.sql',
}

--- @param title string
--- @param cwd string
--- @param search? string
M.search.string = function(title, cwd, search)
  t.grep_string {
    prompt_title = title,
    cwd = cwd,
    search = search,
    file_ignore_patterns = ignore,
  }
end

--- @param title string
--- @param cwd? string
M.search.files = function(title, cwd)
  t.find_files {
    prompt_title = title,
    cwd = cwd,
    file_ignore_patterns = ignore,
  }
end

--- @param title string
M.search.git_files = function(title)
  t.git_files { prompt_title = title, file_ignore_patterns = ignore }
end

return M
