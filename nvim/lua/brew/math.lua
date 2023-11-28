local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local Path = require('plenary.path')
local utils = require('telescope.utils')

local topic = {
  ['algorithm-design.tex'] = '[ALGD]',
  ['calculus.tex'] = '[CALC]',
  ['complex-analysis.tex'] = '[CXAS]',
  ['nonlinear-optimization-constrained.tex'] = '[NLOC]',
  ['nonlinear-optimization-unconstrained.tex'] = '[NLOU]',
  ['ordinary-differential-equations.tex'] = '[ODE]',
  ['plenary.tex'] = '[PLEN]',
}

---@param buf string
---@param start integer
local get_in_between = function(buf, start)
  local stk, s = 0, nil
  for i = start, #buf do
    local c = buf:byte(i)
    if c == 123 then
      stk, s = stk + 1, s and s or i
    elseif c == 125 then
      if stk == 1 then return buf:sub(s + 1, i - 1), i + 1 end
    end
  end
end

-- \\Theorem{2.2.7}{Convex optimization}\\label{f546fc9}
---@param text string
local unpack_text = function(text)
  local entity = text:sub(2, text:find('{') - 1)
  local num, i = get_in_between(text, 0)
  local name, _ = get_in_between(text, i)
  entity = entity .. ' ' .. num
  if name and #name > 0 then entity = entity .. ' (' .. name .. ')' end
  return entity
end

local handle_entry_index = function(opts, t, k)
  local override = ((opts or {}).entry_index or {})[k]
  if not override then return end
  local val, save = override(t, opts)
  if save then rawset(t, k, val) end
  return val
end

-- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
local parse = function(t)
  local _, _, filename, lnum, col, text =
    string.find(t.value, [[(..-):(%d+):(%d+):(.*)]])
  local ok
  ok, lnum = pcall(tonumber, lnum)
  if not ok then lnum = nil end
  ok, col = pcall(tonumber, col)
  if not ok then col = nil end
  t.filename, t.lnum, t.col, t.text = filename, lnum, col, text
  return { filename, lnum, col, text }
end

local function gen_from_vimgrep_for_math_notes(opts)
  opts = opts or {}

  local mt_vimgrep_entry

  local execute_keys = {
    path = function(t)
      if Path:new(t.filename):is_absolute() then
        return t.filename, false
      else
        return Path:new({ t.cwd, t.filename }):absolute(), false
      end
    end,

    filename = function(t) return parse(t)[1], true end,
    lnum = function(t) return parse(t)[2], true end,
    col = function(_) return 0, true end,
    text = function(t) return parse(t)[4], true end,
  }

  -- For text search only: the ordinal value is actually the text.
  execute_keys.ordinal = function(t) return t.text end

  mt_vimgrep_entry = {
    cwd = vim.fn.expand(opts.cwd or vim.loop.cwd()),
    display = function(entry)
      local display_filename = utils.transform_path(opts, entry.filename)
      if opts.hide_filename then display_filename = '*' end
      return string.format('%s:%s', display_filename, entry.text)
    end,
    __index = function(t, k)
      local override = handle_entry_index(opts, t, k)
      if override then return override end
      local raw = rawget(mt_vimgrep_entry, k)
      if raw then return raw end
      local executor = rawget(execute_keys, k)
      if executor then
        local val, save = executor(t)
        if save then rawset(t, k, val) end
        return val
      end
      return rawget(t, rawget({ display = 1, ordinal = 1, value = 1 }, k))
    end,
  }
  return function(line) return setmetatable({ line }, mt_vimgrep_entry) end
end

-- completely custom search only for nguyenvukhang/math
local theorem_search = function()
  local opts = {
    entry_maker = gen_from_vimgrep_for_math_notes { hide_filename = true },
  }
  local find_command = {
    'rg',
    '--vimgrep',
    '^\\\\(Algorithm|Corollary|Definition|Example|Exercise|Lemma|Problem|Proposition|Remark|Result|Theorem)',
    '-g',
    '*.tex',
  }
  local x = vim.fn.systemlist(find_command)
  print(vim.inspect(x))
  pickers
    .new(opts, {
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job(find_command, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return { theorem_search = theorem_search }
