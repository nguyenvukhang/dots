local M = {}
local _abbrev_cache = {}

---@param filename string
---@return string abbreviation
M.get = function(filename)
  local gen = require('minimath.generated')
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

return M
