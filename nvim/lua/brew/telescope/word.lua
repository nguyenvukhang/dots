local actions = require('brew.telescope.actions')
local home = require('brew').env.home
local ignore = require('brew.telescope.ignore')
local git_check = require('brew').utils.is_git_repo

local M = {}

-- word search (currently triggered by <Leader>ps)
M.repo = function()
  if git_check() then
    local input_string = vim.fn.input("Search For > ")
    if (input_string == '') then
      return
    end
    require("telescope.builtin").grep_string({
      search = input_string,
      prompt_title = "Word In Repo",
      cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
      file_ignore_patterns = ignore,
      layout_config = { height = 100, width = 100 },
      attach_mappings = function(_, map)
        map("i", "<CR>", actions.send_to_qflist + actions.select_default)
        return true
      end
    })
  else
    print('not in a git repo')
  end
end

M.cwd = function()
  local pwd = string.gsub(vim.fn.getcwd(), home, '~/')

  local input_string = vim.fn.input("Search In [" .. pwd .. "] > ")
  if (input_string == '') then
    return
  end
  require("telescope.builtin").grep_string({
    search = input_string,
    prompt_title = "Word In Directory",
    file_ignore_patterns = ignore,
    layout_config = { height = 100, width = 100 },
    attach_mappings = function(_, map)
      map("i", "<CR>", actions.send_to_qflist + actions.select_default)
      return true
    end
  })
end

-- searches repo for work under cursor
M.this_in_repo = function()
  if git_check() then
    require("telescope.builtin").grep_string({
      prompt_title = "Word In Repo",
      cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
      file_ignore_patterns = ignore,
      layout_config = { height = 100, width = 100 },
      attach_mappings = function(_, map)
        map("i", "<CR>", actions.send_to_qflist + actions.select_default)
        return true
      end
    })
  else
    print('not in a git repo')
  end
end

return M
