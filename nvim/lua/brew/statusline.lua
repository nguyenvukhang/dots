local set_line = function(branch)
  branch = '%#StatusLineBranch#' .. branch .. '%#StatusLine#'
  vim.opt.statusline = ' %f %h%w%m%r ' .. branch .. '%=+ '
end

require('brew.git-branch').init(set_line)
