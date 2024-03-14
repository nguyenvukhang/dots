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
  'Principle',
  'Problem',
  'Proposition',
  'Remark',
  'Result',
  'Theorem',
}, '|')
local find_query = '^\\\\(' .. marks .. ').*\\\\label'
local find_command = { 'rg', '--vimgrep', '-ttex', find_query }
-- '^\\\\begin\\{(' .. marks .. ')\\}\\[.*\\\\label',

local topic = {
  ['algorithm-design.tex'] = '[ALD]',
  ['calculus.tex'] = '[CAL]',
  ['complex-analysis.tex'] = '[CPA]',
  ['functions.tex'] = '[FUN]',
  ['linear-algebra.tex'] = '[LNA]',
  ['nonlinear-optimization-constrained.tex'] = '[NOC]',
  ['nonlinear-optimization-unconstrained.tex'] = '[NOU]',
  ['numerical-analysis.tex'] = '[NMA]',
  ['ordinary-differential-equations.tex'] = '[ODE]',
  ['plenary.tex'] = '[PLN]',
  ['real-analysis.tex'] = '[REA]',
  ['statistics-1.tex'] = '[ST1]',
  ['statistics-examples.tex'] = '[STX]',
  ['sandbox.tex'] = '[SBX]',
  ['draft.tex'] = '[DFT]',
  ['defs/calculus.tex'] = '[d/CAL]',
  ['defs/linear-algebra.tex'] = '[d/LNA]',
  ['defs/counting.tex'] = '[d/CNT]',
  ['core/linear-algebra.tex'] = '[c/LNA]',
  ['core/functions.tex'] = '[c/FUN]',
  ['core/counting.tex'] = '[c/CNT]',
  ['core/real-analysis.tex'] = '[c/REA]',
}

-- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
local parse = function(t)
  local k, _, filename, lnum, text = string.find(t.value, [[(..-):(%d+):(.*)]])
  -- _, _, k, text = string.find(text, '\\begin{(.*)}%[(.*)%]')
  _, _, k, text = string.find(text, '\\(.*){(.*)}\\label{.*}')
  text = (#text > 0) and k .. ': ' .. text or k
  lnum = tonumber(lnum)
  t.filename, t.lnum, t.text = filename, lnum, text
  return { filename, lnum, text }
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
    display = function(e)
      return (topic[e.filename] or '[...]') .. ' ' .. e.text
    end,
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
      local _, _, sha = string.find(entry[1], '\\label{(.*)}')
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
    command = { 'rg', '--vimgrep', find_query, vim.fn.expand('%') }
  else
    command = find_command
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

M.remaps = function()
  local k, v = vim.keymap.set, vim.cmd
  -- completely custom search only for nguyenvukhang/math
  k('n', '<leader>pm', function() theorem_search(true, false) end)
  k('n', '<leader>pM', function() theorem_search(true, false, nil, true) end)
  k('n', '<leader>pt', function() theorem_search(false, false) end)
  k('v', '<leader>h', function() theorem_search(false, true, 'h') end)
  k('v', '<leader>a', function() theorem_search(false, true, 'a') end)

  -- environment wrappers
  k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k')
  k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k')
  k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k')
  k('n', '<leader>bg', 'cc\\begin{gather*}<CR>\\end{gather*}<esc>k')

  -- jump to next/prev mark
  k('n', '[[', '^k?\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('n', ']]', '^j/\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('v', '[[', '^k?\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)
  k('v', ']]', '^j/\\v^\\\\(' .. marks .. ')\\{<cr>f{lzz', sil)

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
end

return M
