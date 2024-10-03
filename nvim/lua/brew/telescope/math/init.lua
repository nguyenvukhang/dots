local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local topics = require('brew.telescope.math.topics')
local abbrev_cache = {}
local sil = { silent = true, buffer = true }
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
  local filename = t.value:sub(1, i1 - 1)
  local lnum = tonumber(t.value:sub(i1 + 1, i2 - 1))
  local mark = t.value:sub(i2 + 1, i3 - 1)
  local title = t.value:sub(i3 + 1, -9)
  local text = mark .. ': ' .. title
  t.filename, t.lnum, t.text = filename, lnum, text
  return { filename, lnum, text }
end

---@param filename string
---@return string
local get_abbrev = function(filename)
  local res = abbrev_cache[filename]
  if res ~= nil then return res end
  local topic = filename:sub(1, filename:find('/', filename:find('/') + 1) - 1)
  local abbrev = topics[topic] or '[ • ]'
  abbrev_cache[filename] = abbrev
  return abbrev
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

---@param action string (length: 1) type of action
local handle_sha = function(ref, left, right, action)
  local function inner(_, map)
    map('i', '<CR>', function(bufnr)
      local entry = actions_state.get_selected_entry()
      local _, _, sha = string.find(entry[1], '.*:(.*)')
      vim.fn.setreg('', sha)
      actions.close(bufnr)

      if not entry or action == 'y' then return end

      local line = vim.api.nvim_set_current_line

      if action == 'h' then
        line(('%s\\href{%s}{%s}%s'):format(left, sha, ref, right))
      elseif action == 'a' then
        line(('%s\\autoref{%s}%s'):format(left, sha, right))
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

---Action
-- 'h': surround the text with \href{...}{<text>}
-- 'a': replace the text with \autoref{...}
-- 'j': jump to the location
-- 'y': yank the ID to clipboard

-- completely custom search only for nguyenvukhang/math
---@param action 'a' | 'h' | 'j' | 'y' type of action
local theorem_search = function(action)
  local opts = { entry_maker = gen_from_vimgrep_for_math_notes() }

  -- leaving `attach_mappings` as nil will make it a jump.
  local attach_mappings = nil
  -- sends the SHA to the unnamed register. comment out this key to revert
  -- to the default behavior of navigating to the header.
  if action ~= nil and action ~= 'j' then
    local ref, left, right = split_visual_line()
    attach_mappings = handle_sha(ref, left, right, action)
  end

  pickers
    .new(opts, {
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job({ 'minimath-rg' }, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

M.overriding_remaps = function()
  local k, v = vim.keymap.set, vim.cmd
  -- jump to next/prev mark
  k('n', '[[', '^k?\\v^\\\\(' .. marks .. ')<cr>f{lzz', sil)
  k('n', ']]', '^j/\\v^\\\\(' .. marks .. ')<cr>f{lzz', sil)
  k('v', '[[', '^k?\\v^\\\\(' .. marks .. ')<cr>f{lzz', sil)
  k('v', ']]', '^j/\\v^\\\\(' .. marks .. ')<cr>f{lzz', sil)
  -- jump to next/prev subsection
  k('n', '[{', '^k?\\v^\\\\subsection<cr>f{lzz', sil)
  k('n', ']}', '^j/\\v^\\\\subsection<cr>f{lzz', sil)
  k('v', '[{', '^k?\\v^\\\\subsection<cr>f{lzz', sil)
  k('v', ']}', '^j/\\v^\\\\subsection<cr>f{lzz', sil)

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
  end)

  -- environment wrappers
  k('n', '<leader>be', 'cc\\begin{equation*}<CR>\\end{equation*}<esc>k')
  k('n', '<leader>bi', 'cc\\begin{itemize}<CR>\\end{itemize}<esc>k')
  k('n', '<leader>ba', 'cc\\begin{align*}<CR>\\end{align*}<esc>k')
  k('n', '<leader>bc', 'cc\\begin{cases}<CR>\\end{cases}<esc>k')
  k('n', '<leader>bg', 'cc\\begin{gather*}<CR>\\end{gather*}<esc>k')
  k('n', '<leader>bp', 'o<CR>\\begin{proof}<CR>\\end{proof}<esc>k')
  k('n', 'K', function()
    --[[
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col = pos[1], pos[2]
    local buf = vim.api.nvim_create_buf(false, true)
    print("BUFFER", buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'This is a popup!' })
    local opts = {
      relative = 'cursor', -- Position relative to the cursor
      row = -1, -- One line below the cursor
      col = 0, -- Same column as the cursor
      width = 20, -- Width of the popup window
      height = 1, -- Height of the popup window
      style = 'minimal', -- Minimal style (no borders, no title)
    }
    vim.api.nvim_open_win(buf, true, opts)
    --]]
  end)
end

M.remaps = function()
  local k = vim.keymap.set
  ---@param action 'a' | 'h' | 'j' | 'y' type of action
  local ts = function(action)
    return function() theorem_search(action) end
  end
  -- completely custom search only for nguyenvukhang/math
  k('n', '<leader>pm', ts('j'))
  k('n', '<leader>pt', ts('y'))
  k('v', '<leader>h', ts('h'))
  k('v', '<leader>a', ts('a'))
end

return M
