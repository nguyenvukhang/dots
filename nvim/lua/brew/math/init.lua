local augroup = require('brew.core').augroup
local autocmd = augroup('BREW_MATH')
local sep = package.config:sub(1, 1)

local M = {}
local counts = {}
local cmd

local initialized_buffers = {}
local bufdir = function()
  return vim.fn.expand('%:p:h') -- dir of current buffer
end

local watchlist_path = function() return bufdir() .. sep .. '.watchtex' end

local function wrap(watcher, fullpath)
  watcher:stop()
  if cmd ~= nil then vim.fn.system(cmd) end
  print(cmd)
  counts[fullpath] = counts[fullpath] and counts[fullpath] + 1 or 1
  watcher:start(
    fullpath,
    {},
    vim.schedule_wrap(function() wrap(watcher, fullpath) end)
  )
end

---@return boolean
local file_exists = function(f)
  local file = io.open(f, 'r')
  if file then
    file:close()
    return true
  end
  return false
end

local create_watcher = function(line)
  local watcher = vim.loop.new_fs_event()
  if watcher ~= nil then
    local fullpath = bufdir() .. sep .. line
    watcher:start(
      fullpath,
      {},
      vim.schedule_wrap(function() wrap(watcher, fullpath) end)
    )
  end
end

-- gets a list of files to watch, by taking the ./.watchtex relative
-- to the current buffer.
--
-- first line is used as the command to run on each file change
-- the rest of the liens are the files to watch
local start_watch = function()
  local wl_path = watchlist_path()
  if not file_exists(wl_path) then return end
  local iter = io.lines(wl_path)
  cmd = iter()
  if cmd ~= nil then vim.fn.system(cmd) end
  for line in iter do
    create_watcher(line)
  end
end

M.init = function()
  -- initialize once per buffer
  local bufnr = vim.api.nvim_get_current_buf()
  if initialized_buffers[bufnr] then return end
  initialized_buffers[bufnr] = true
  start_watch()
end

autocmd({ 'BufEnter' }, {
  pattern = { '*.tex', '*.latex' },
  callback = M.init,
})

return M
