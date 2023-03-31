local augroup = require('brew.core').augroup
local M = {}

local initialized_buffers = {}

M.init = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if initialized_buffers[bufnr] then return end
  if M.autocmd == nil then M.autocmd = augroup('KANBAD') end
  initialized_buffers[bufnr] = true
  M.autocmd({ 'BufWritePre' }, {
    buffer = bufnr,
    callback = function() print('sMAHSED') end,
  })
end

return M
