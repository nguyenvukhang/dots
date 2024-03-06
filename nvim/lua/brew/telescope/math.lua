local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local Path = require('plenary.path')
local actions_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local make_entry = require('telescope.make_entry')
local qf_and_jump = require('brew.telescope.qfnjump').qf_and_jump

local M = {}

local MATH_DIR = vim.env.REPOS .. '/math'

local topic = {
  ['algorithm-design.tex'] = '[ALGD]',
  ['calculus.tex'] = '[CALC]',
  ['complex-analysis.tex'] = '[CPXA]',
  ['functions.tex'] = '[FUNC]',
  ['linear-algebra.tex'] = '[LINA]',
  ['nonlinear-optimization-constrained.tex'] = '[NLOC]',
  ['nonlinear-optimization-unconstrained.tex'] = '[NLOU]',
  ['numerical-analysis.tex'] = '[NUMA]',
  ['ordinary-differential-equations.tex'] = '[ODE ]',
  ['plenary.tex'] = '[PLEN]',
  ['real-analysis.tex'] = '[RELA]',
  ['statistics-1.tex'] = '[STC1]',
  ['statistics-1-examples.tex'] = '[STC1X]',
  ['core/linear-algebra.tex'] = '[core/linalg]',
  ['defs/calculus.tex'] = '[defs/calc]',
  ['defs/linear-algebra.tex'] = '[defs/linalg]',
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
    text = function(t) return parse(t)[3], true end,
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    cwd = MATH_DIR,
    col = 0,
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

local handle_sha = function(insert, ref, left, right)
  local function inner(_, map)
    map('i', '<CR>', function(bufnr)
      local entry = actions_state.get_selected_entry()
      local parts = vim.fn.split(entry[1], '|')
      local sha = parts[#parts]
      vim.fn.setreg('', sha)
      actions.close(bufnr)

      if entry and insert then
        vim.api.nvim_set_current_line(
          string.format('%s\\href{%s}{%s}%s', left, sha, ref, right)
        )
      end
    end)
    return true
  end
  return inner
end

-- completely custom search only for nguyenvukhang/math
---@param nav boolean whether or not to jump to just copy the SHA
---@param insert boolean whether or not to insert SHA at line
M.theorem_search = function(nav, insert)
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
  if not nav then
    local left, right, ref
    if insert then
      local r, l, line = vim.fn.col('.'), vim.fn.col('v'), vim.fn.getline('.')
      if r < l then
        l, r = r, l
      end
      ref, left, right = line:sub(l, r), line:sub(0, l - 1), line:sub(r + 1)
    end
    attach_mappings = handle_sha(insert, ref, left, right)
  end

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

-- completely custom lsp search only for nguyenvukhang/math
M.list_references = function(cword)
  local opts = {
    entry_maker = make_entry.gen_from_vimgrep(),
    cwd = MATH_DIR,
  }
  local find_command = { 'minimath-lsp', 'references', cword }

  pickers
    .new(opts, {
      prompt_title = 'References',
      finder = finders.new_oneshot_job(find_command, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(_, map)
        map('i', '<CR>', qf_and_jump)
        return true
      end,
    })
    :find()
end

return M
