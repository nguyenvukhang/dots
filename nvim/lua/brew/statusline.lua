local git_branch = require('brew.git-branch')

local set_line = function(branch)
  branch = '%#StatusLineBranch#' .. branch .. '%#StatusLine#'
  vim.opt.statusline = ' %f %h%w%m%r ' .. branch .. '%=+ '
end

return { start = function() git_branch.init(set_line) end }
