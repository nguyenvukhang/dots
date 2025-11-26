local M = {}

local abbrev = require('minimath.abbrev')

-- Gets called only once to parse everything out for the vimgrep,
-- after that looks up directly.
local parse_latex = function(t)
  _, _, t.filename, t.lnum, t.text, t.sha = t.value:find('(.*):(%d+):(.*):(.*)')
  t.lnum = tonumber(t.lnum)
  return t
end

local parse_lean = function(t)
  _, _, t.filename, t.lnum, t.text = t.value:find('(.*):(%d+):(.*)')
  t.lnum = tonumber(t.lnum)
  return t
end

M.gen_from_vimgrep_for_latex = function()
  local mt_vimgrep_entry
  local execute_keys = {
    path = function(t) return vim.fn.fnamemodify(t.filename, ':p') end,
    filename = function(t) return rawget(parse_latex(t), 'filename') end,
    lnum = function(t) return rawget(parse_latex(t), 'lnum') end,
    text = function(t) return rawget(parse_latex(t), 'text') end,
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    display = function(t) return abbrev.get(t.filename) .. ' | ' .. t.text end,
    __index = function(t, k)
      local z = rawget(mt_vimgrep_entry, k) -- try to get raw value first.
      if z then return z end
      z = rawget(execute_keys, k) -- use the executor.
      if z then
        z = z(t)
        rawset(t, k, z) -- cache the value
        return z
      end
      if k == 'ordinal' or k == 'value' then return rawget(t, 1) end
    end,
  }
  return function(line) return setmetatable({ line }, mt_vimgrep_entry) end
end

M.gen_from_vimgrep_for_lean = function()
  local mt_vimgrep_entry
  local execute_keys = {
    path = function(t) return vim.fn.fnamemodify(t.filename, ':p') end,
    filename = function(t) return rawget(parse_lean(t), 'filename') end,
    lnum = function(t) return rawget(parse_lean(t), 'lnum') end,
    text = function(t) return rawget(parse_lean(t), 'text') end,
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    display = function(t) return t.text end,
    __index = function(t, k)
      local z = rawget(mt_vimgrep_entry, k) -- try to get raw value first.
      if z then return z end
      z = rawget(execute_keys, k) -- use the executor.
      if z then
        z = z(t)
        rawset(t, k, z) -- cache the value
        return z
      end
      if k == 'ordinal' or k == 'value' then return rawget(t, 1) end
    end,
  }
  return function(line) return setmetatable({ line }, mt_vimgrep_entry) end
end

return M
