local topic = {
  ['_/algorithm_design.tex'] = '[ALD]',
  ['_/calculus.tex'] = '[CAL]',
  ['_/complex_analysis.tex'] = '[CPA]',
  ['_/functions.tex'] = '[FUN]',
  ['_/linear_algebra.tex'] = '[LNA]',
  ['_/nonlinear_optimization_constrained.tex'] = '[NOC]',
  ['_/nonlinear_optimization_unconstrained.tex'] = '[NOU]',
  ['_/ordinary_differential_equations.tex'] = '[ODE]',
  ['_/plenary.tex'] = '[PLN]',
  ['_/polynomials.tex'] = '[POL]',
  ['_/statistics_examples.tex'] = '[STX]',
  ['_/errors.tex'] = '[ERR]',
  ['defs/calculus.tex'] = '[d/CAL]',
  ['defs/linear_algebra.tex'] = '[d/LNA]',
  ['defs/optimization.tex'] = '[d/OPT]',
  ['defs/counting.tex'] = '[d/CNT]',
  ['defs/real_analysis.tex'] = '[d/REA]',
  ['defs/machine_learning.tex'] = '[d/REA]',
  ['core/linear_algebra/'] = '[c/LNA]',
  ['core/counting.tex'] = '[c/CNT]',
  ['core/real_analysis.tex'] = '[c/REA]',
  ['lib/linear_algebra.tex'] = '[l/LNA]',
  ['lib/numerical_analysis/'] = '[l/NMA]',
  ['lib/statistics/'] = '[l/STC]',
  ['lib/real_analysis/'] = '[l/REA]',
  ['lib/machine_learning/'] = '[l/ML]',
  ['lib/neural_network/'] = '[l/NN]',
  ['lib/calculus/'] = '[l/CAL]',
}

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local sil = { silent = true }
local M = {}

local marks = table.concat({
  'Algorithm',
  'Axiom',
  'Corollary',
  'Definition',
  'Example',
  'Exercise',
  'Lemma',
  'Notation',
  'Principle',
  'Problem',
  'Proposition',
  'Remark',
  'Result',
  'Theorem',
}, '|')
-- The regex [^}]
-- matches anything but a closing } brace. This means we're looking for
-- non-empty titles.
--[[
local find_query = '^\\\\(' .. marks .. ')\\{[^}].*\\\\label'
local find_command = { 'rg', '--vimgrep', '-ttex', find_query }
--]]

-- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
local parse = function(t)
  local i1 = t.value:find(':')
  local i2 = t.value:find(':', i1 + 1)
  local i3 = t.value:find(':', i2 + 1)
  local fp = t.value:sub(1, i1 - 1)
  local lnum = tonumber(t.value:sub(i1 + 1, i2 - 1))
  local mark = t.value:sub(i2 + 1, i3 - 1)
  local title = t.value:sub(i3 + 1, -9)
  local text = mark .. ': ' .. title
  t.filename, t.lnum, t.text = fp, lnum, text
  return { fp, lnum, text }
end

local get_abbrev = function(query)
  local res = topic[query]
  if res ~= nil then return res end
  for k, v in pairs(topic) do
    if vim.startswith(query, k) then
      topic[query] = v
      return v
    end
  end
  return '[ • ]'
end

local function gen_from_vimgrep_for_math_notes()
  local mt_vimgrep_entry
  local execute_keys = {
    path = function(t) return t.filename end,
    filename = function(t) return parse(t)[1], true end,
    lnum = function(t) return parse(t)[2], true end,
    text = function(t) return parse(t)[3], true end,
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    display = function(e) return get_abbrev(e.filename) .. ' ' .. e.text end,
    __index = function(t, k)
      local raw = rawget(mt_vimgrep_entry, k)
      if raw then return raw end
      local executor = rawget(execute_keys, k)
      if executor then
        local v, save = executor(t)
        if save then rawset(t, k, v) end
        return v
      end
      return rawget(t, rawget({ display = 1, ordinal = 1, value = 1 }, k))
    end,
  }
  return function(line) return setmetatable({ line }, mt_vimgrep_entry) end
end

local handle_sha = function(insert, ref, left, right, fmt)
  local function inner(_, map)
    map('i', '<CR>', function(bufnr)
      local entry = actions_state.get_selected_entry()
      local _, _, sha = string.find(entry[1], '.*:(.*)')
      vim.fn.setreg('', sha)
      actions.close(bufnr)

      if entry and insert then
        local line = vim.api.nvim_set_current_line
        if fmt == 'h' then
          line(string.format('%s\\href{%s}{%s}%s', left, sha, ref, right))
        elseif fmt == 'a' then
          line(string.format('%s\\autoref{%s}%s', left, sha, right))
        end
      end
    end)
    return true
  end
  return inner
end

local split_visual_line = function()
  local r, l, line = vim.fn.col('.'), vim.fn.col('v'), vim.fn.getline('.')
  if r < l then
    l, r = r, l
  end
  return line:sub(l, r), line:sub(0, l - 1), line:sub(r + 1)
end

-- completely custom search only for nguyenvukhang/math
---@param nav boolean whether or not to jump to just copy the SHA
---@param insert boolean whether or not to insert SHA at line
---@param link_type? 'h' | 'a' type of ref (href/autoref)
---@param is_local? boolean whether or not to search locally
local theorem_search = function(nav, insert, link_type, is_local)
  is_local = is_local or false
  local opts = { entry_maker = gen_from_vimgrep_for_math_notes() }

  local attach_mappings = nil
  -- sends the SHA to the unnamed register. comment out this key to revert
  -- to the default behavior of navigating to the header.
  if not nav then
    local ref, left, right = split_visual_line()
    attach_mappings = handle_sha(insert, ref, left, right, link_type)
  end

  local command
  if is_local then
    command = { 'minimath-lsp', vim.fn.expand('%') }
  else
    command = { 'minimath-lsp' }
  end

  pickers
    .new(opts, {
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job(command, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

M.overriding_remaps = function()
  local k, v = vim.keymap.set, vim.cmd
  -- jump to next/prev mark
  k('n', '[[', '^k?\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('n', ']]', '^j/\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('v', '[[', '^k?\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('v', ']]', '^j/\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('n', '[{', '^k?\\v^\\\\subsection\\{<cr>f{lzz', sil)
  k('n', ']}', '^j/\\v^\\\\subsection\\{<cr>f{lzz', sil)
  k('v', '[{', '^k?\\v^\\\\subsection\\{<cr>f{lzz', sil)
  k('v', ']}', '^j/\\v^\\\\subsection\\{<cr>f{lzz', sil)

  -- go to definition (looks for `\label{<cword>}`)
  k('n', 'gd', function()
    local cword = vim.fn.expand('<cword>')
    if not cword then return end
    v('sil lgr --no-column -ttex \\label\\\\{' .. cword .. '}$')
    -- v('silent! lgr /\\v\\\\label\\{' .. cword .. '\\}$/ **/*.tex')
  end)

  -- go to references (looks for `\autoref{<cword>}` or `\href{<cword>}`)
  k('n', 'gr', function()
    local sha = vim.fn.expand('<cword>')
    if not sha then return end
    v("sil gr --no-column -ttex '\\\\(auto\\|h\\|name)ref\\{" .. sha .. "\\}'")
    v('silent bel copen')
    -- v('silent! vim /\\v\\\\(autoref|href)\\{' .. cword .. '\\}/g **/*.tex')
    -- v('silent! bel copen')
  end)

  -- environment wrappers
  k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k')
  k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k')
  k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k')
  k('n', '<leader>bg', 'cc\\begin{gather*}<CR>\\end{gather*}<esc>k')
  k('n', '<leader>bp', 'o<CR>\\begin{proof}<CR>\\end{proof}<esc>k')
end

M.remaps = function()
  local k = vim.keymap.set
  -- completely custom search only for nguyenvukhang/math
  k('n', '<leader>pm', function() theorem_search(true, false) end)
  k('n', '<leader>pM', function() theorem_search(true, false, nil, true) end)
  k('n', '<leader>pt', function() theorem_search(false, false) end)
  k('n', '<leader>pT', function() theorem_search(false, false, nil, true) end)
  k('v', '<leader>h', function() theorem_search(false, true, 'h') end)
  k('v', '<leader>H', function() theorem_search(false, true, 'h', true) end)
  k('v', '<leader>a', function() theorem_search(false, true, 'a') end)
  k('v', '<leader>A', function() theorem_search(false, true, 'a', true) end)
end

return M
