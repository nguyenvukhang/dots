local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local Path = require('plenary.path')
local MATH_DIR = vim.env.REPOS .. '/math'

local topic = {
  ['algorithm-design.tex'] = '[ALGD]',
  ['calculus.tex'] = '[CALC]',
  ['complex-analysis.tex'] = '[CPXA]',
  ['nonlinear-optimization-constrained.tex'] = '[NLOC]',
  ['nonlinear-optimization-unconstrained.tex'] = '[NLOU]',
  ['ordinary-differential-equations.tex'] = '[ODE.]',
  ['plenary.tex'] = '[PLEN]',
}

---@param buf string
---@param start integer
-- gets the content of the string in between the next '{}' pair
local get_in_between = function(buf, start)
  local stk, s = 0, nil
  for i = start, #buf do
    local c = buf:byte(i)
    if c == 123 then -- '{'
      stk, s = stk + 1, s and s or i
    elseif c == 125 then -- '}'
      if stk == 1 then return buf:sub(s + 1, i - 1), i + 1 end
    end
  end
end

---@param text string
local unpack_text = function(text)
  local t = text:sub(2, text:find('{') - 1)
  local num, i = get_in_between(text, 0)
  local name, _ = get_in_between(text, i)
  t = t .. ' ' .. num
  if name and #name > 0 then t = t .. ' (' .. name .. ')' end
  return t
end

-- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
local parse = function(t)
  local _, _, filename, lnum, col, text =
    t.value:find([[(..-):(%d+):(%d+):(.*)]])
  local ok
  ok, lnum = pcall(tonumber, lnum)
  if not ok then lnum = nil end
  ok, col = pcall(tonumber, col)
  if not ok then col = nil end
  if text then text = unpack_text(text) end
  t.filename, t.lnum, t.col, t.text = filename, lnum, col, text
  return { filename, lnum, col, text }
end

local function gen_from_vimgrep_for_math_notes()
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
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    cwd = MATH_DIR,
    display = function(e)
      return (topic[e.filename] or '[????]') .. ' ' .. e.text
    end,
    __index = function(t, k)
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
    entry_maker = gen_from_vimgrep_for_math_notes(),
    cwd = MATH_DIR,
  }
  local find_command = {
    'rg',
    '--max-depth',
    '1',
    '--vimgrep',
    '^\\\\(Algorithm|Corollary|Definition|Example|Exercise|Lemma|Problem|Proposition|Remark|Result|Theorem)',
    '-g',
    '*.tex',
  }
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
