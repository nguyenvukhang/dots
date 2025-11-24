local gen = require('minimath.generated')

local separator = '  .'
local _abbrev_cache = {}

---@param filename string
---@return string abbreviation
local get_abbrev = function(filename)
  -- If a result has been computed before, then just return that.
  local res = _abbrev_cache[filename]
  if res ~= nil then return res end

  -- Otherwise, we start analyzing components. One-up is the topic, two-up is
  -- the category. We take the first letter from the category, and the
  -- abbreviation of the topic (from `gen.topics`).
  local components = vim.fn.split(filename, '/')
  if #components < 3 then return '[ • ]' end

  local category_abbrev = string.sub(components[#components - 2], 1, 1)

  local topic = components[#components - 1]
  local topic_abbrev = gen.topics[topic] or '???'

  local abbrev = category_abbrev .. '/' .. topic_abbrev

  -- Add to cache
  _abbrev_cache[filename] = abbrev
  return abbrev
end

---@class MiniRgEntryData
---@field filename string
---@field lnum number?

---@class MiniRg
---@field data table<string, MiniRgEntryData>
---@field fzf_choices string[]
local MiniRg = {
  data = {},
  fzf_choices = {},
}

---@param self MiniRg
---@param cmd string?
MiniRg.load = function(self, cmd)
  cmd = cmd or 'minimath-rg'
  for i, line in pairs(vim.fn.systemlist(cmd)) do
    local _, _, filename, lnum, text, sha = line:find('(.*):(%d+):(.*):(.*)')
    self.data[sha] = { filename = filename, lnum = tonumber(lnum) }
    local abbrev = get_abbrev(filename)
    self.fzf_choices[i] = abbrev
      .. ' | '
      .. text
      .. '\x1b[37m'
      .. separator
      .. sha
      .. '\x1b[m'
  end
end

---@param fzf_choice string
MiniRg.get_sha = function(fzf_choice)
  local parts = vim.fn.split(fzf_choice, separator)
  return parts[#parts]
end

---@param self MiniRg
---@param fzf_choice string
MiniRg.get_target = function(self, fzf_choice)
  return self.data[MiniRg.get_sha(fzf_choice)]
end

---@param target MiniRgEntryData
MiniRg.jump = function(target)
  local bufnr = vim.fn.bufadd(target.filename)
  vim.fn.bufload(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_win_set_cursor(0, { target.lnum, 0 })
  vim.fn.feedkeys('zz$T{', 'n')
end

return MiniRg
