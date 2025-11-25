local fzf_separator = '  .'
local abbrev = require('minimath.abbrev')

-- Purposely bomb the types (they are supposed to be prepended with '---', not
-- '--') because lua-language-server is trolling with false positive warnings of
-- duplicate definitions of fields.

--@class EntryData
--@field filename string
--@field lnum number?

local M = {
  --@field data table<string, EntryData>
  data = {},
  --@field fzf_choices string[]
  fzf_choices = {},
}

M.load_minimath = function(self)
  for _, line in pairs(vim.fn.systemlist('minimath-rg')) do
    local _, _, filename, lnum, text, sha = line:find('(.*):(%d+):(.*):(.*)')
    self.data[sha] = { filename = filename, lnum = tonumber(lnum) }
    self.fzf_choices[sha] = ('%s | %s\x1b[37m%s%s\x1b[m'):format(
      abbrev.get(filename),
      text,
      fzf_separator,
      sha
    )
  end
end

M.load_lean = function(self)
  for i, line in pairs(vim.fn.systemlist { 'lake-dino', 'rg' }) do
    local _, _, filename, lnum, text = line:find('(.*):(%d+):(.*)')
    local sha = tostring(i)
    self.data[sha] = { filename = filename, lnum = tonumber(lnum) }
    self.fzf_choices[sha] = ('%s\x1b[37m%s%s\x1b[m'):format(
      text,
      fzf_separator,
      sha
    )
  end
end

---@param fzf_choice string
M.get_sha = function(fzf_choice)
  local parts = vim.fn.split(fzf_choice, fzf_separator)
  return parts[#parts]
end

---@param fzf_choice string
M.get_target = function(self, fzf_choice)
  return self.data[M.get_sha(fzf_choice)]
end

--@param target EntryData
M.jump = function(target)
  local bufnr = vim.fn.bufadd(target.filename)
  vim.fn.bufload(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(0, { target.lnum, 0 })
  vim.fn.feedkeys('zz$T{', 'n')
end

return M
