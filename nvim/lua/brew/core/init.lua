local M = {}

-- checks if quickfix/loclist is open
---@param listname 'v:val.quickfix' | 'v:val.loclist'
local list_is_open = function(listname)
  return not (next(vim.fn.filter(vim.fn.getwininfo(), listname)) == nil)
end

-- Get path to the root of the git workspace
M.git_workspace_root = function()
  local stdout = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if stdout:match 'fatal: not a git repository' then
    vim.notify 'not in a git repo'
    return nil
  else
    return stdout
  end
end

-- stylua: ignore start
M.nnoremap=function(L,R,v)vim.keymap.set('n',L,R,{noremap=true,silent=not v})end
M.vnoremap=function(L,R,v)vim.keymap.set('v',L,R,{noremap=true,silent=not v})end
M.inoremap=function(L,R,v)vim.keymap.set('i',L,R,{noremap=true,silent=not v})end
M.onoremap=function(L,R,v)vim.keymap.set('o',L,R,{noremap=true,silent=not v})end
-- stylua: ignore end

-- Toggles the quickfix list/window
M.toggle_qflist = function()
  vim.cmd(list_is_open 'v:val.quickfix' and 'cclose' or 'copen')
end

-- Toggle diagnostics quickfix list
M.toggle_diagnostics = function()
  -- close diagnostics if qflist is already open
  if list_is_open 'v:val.quickfix' then
    vim.cmd 'cclose' -- close quickfix window
    return
  end

  -- load diagnostics
  vim.diagnostic.setloclist({ open = false })
  local diagnostics = vim.fn.getloclist(0)

  -- check if there are any diagnostics
  if vim.tbl_isempty(diagnostics) then
    vim.notify 'No diagnostics found'
    return
  end

  vim.fn.setqflist(diagnostics)
  vim.cmd 'copen' -- open quickfix window
end

-- load plugins using lazy.nvim
---@param plugins table list of plugins to pass straight to lazy.nvim
M.load_plugins = function(plugins)
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.notify 'lazy.nvim not installed. Run `:Boot` to install it.'
    vim.api.nvim_create_user_command('Boot', function()
      vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
      })
      print 'done installing lazy.nvim'
    end, {})
  else
    vim.opt.runtimepath:prepend(lazypath)
    vim.g.mapleader = ' '
    require('lazy').setup(plugins, {})
  end
end

M.augroup = function(group_name)
  return function(events, opts)
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })
    vim.api.nvim_create_autocmd(
      events,
      vim.tbl_extend('force', { group = group }, opts)
    )
  end
end

-- to clear command line area:
-- vim.cmd('redraw!')

return M
