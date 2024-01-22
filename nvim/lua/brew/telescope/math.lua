local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local Path = require('plenary.path')
local actions_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local MATH_DIR = vim.env.REPOS .. '/math'

local topic = {
  ['algorithm-design.tex'] = '[ALGD]',
  ['calculus.tex'] = '[CALC]',
  ['real-analysis.tex'] = '[RELA]',
  ['numerical-analysis.tex'] = '[NUMA]',
  ['complex-analysis.tex'] = '[CPXA]',
  ['nonlinear-optimization-constrained.tex'] = '[NLOC]',
  ['nonlinear-optimization-unconstrained.tex'] = '[NLOU]',
  ['ordinary-differential-equations.tex'] = '[ODE.]',
  ['plenary.tex'] = '[PLEN]',
}

-- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
local parse = function(t)
  local _, _, filename, lnum, text, sha =
    t.value:find([[(..-):(%d+):(.*)|(.*)]])
  lnum = tonumber(lnum)
  t.filename, t.lnum, t.col, t.text = filename, lnum, 1, text
  return { filename, lnum, text, sha }
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
    text = function(t) return parse(t)[3], true end,
    ordinal = function(t) return t.text end,
    sha = function(t) return parse(t)[4], true end,
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

local sha_to_register = function(_, map)
  map('i', '<CR>', function(bufnr)
    local entry = actions_state.get_selected_entry()
    local parts = vim.fn.split(entry[1], '|')
    vim.fn.setreg('', parts[#parts])
    actions.close(bufnr)
  end)
  return true
end

-- completely custom search only for nguyenvukhang/math
---@param nav boolean whether or not to jump to just copy the SHA
local theorem_search = function(nav)
  vim.cmd('norm! m`')
  local opts = {
    entry_maker = gen_from_vimgrep_for_math_notes(),
    cwd = MATH_DIR,
  }
  -- local find_command = {
  --   'rg',
  --   '--max-depth',
  --   '1',
  --   '--vimgrep',
  --   '^\\\\(Axiom|Principle|Algorithm|Corollary|Definition|Example|Exercise|Lemma|Problem|Proposition|Remark|Result|Theorem)',
  --   '-g',
  --   '*.tex',
  -- }
  local find_command = { 'minimath-telescope' }

  local attach_mappings = nil
  -- sends the SHA to the unnamed register. comment out this key to revert
  -- to the default behavior of navigating to the header.
  if not nav then attach_mappings = sha_to_register end

  pickers
    .new(opts, {
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job(find_command, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

return { theorem_search = theorem_search }
