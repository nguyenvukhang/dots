local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local gen = require('minimath.generated')
local sil = { silent = true, buffer = true }

local M = {}

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

-- Gets called only once to parse everything out for the vimgrep,
-- after that looks up directly.
local parse = function(t)
  local _, _, filename, lnum, text, sha = t.value:find('(.*):(%d+):(.*):(.*)')
  t.filename = filename
  t.lnum = tonumber(lnum)
  t.text = text
  t.sha = sha
  return { t.filename, t.lnum, t.text }
end

local function gen_from_vimgrep_for_math_notes()
  local mt_vimgrep_entry
  local execute_keys = {
    path = function(t) return vim.fn.fnamemodify(t.filename, ':p') end,
    filename = function(t) return parse(t)[1], true end,
    lnum = function(t) return parse(t)[2], true end,
    text = function(t) return parse(t)[3], true end,
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    display = function(e) return get_abbrev(e.filename) .. ' | ' .. e.text end,
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

-- Requires that the user is currently in visual mode (not visual line mode),
-- and also assume that the visual mode spans only one line.
--
-- Splits the line into `left`, `selection`, and `right`.
local split_visual_line = function()
  local r, l, line = vim.fn.col('.'), vim.fn.col('v'), vim.fn.getline('.')
  if r < l then
    l, r = r, l
  end
  return line:sub(0, l - 1), line:sub(l, r), line:sub(r + 1)
end

---@param action 'a' | 'h' | 'j' | 'y' type of action
local get_attach_mappings_callback = function(action)
  if action == 'j' then return nil end
  if action == 'y' then
    return function(sha) vim.fn.setreg('', sha) end
  end
  if action == 'h' then
    local left, selection, right = split_visual_line()
    return function(sha)
      local x = ('%s\\href{%s}{%s}%s'):format(left, sha, selection, right)
      vim.api.nvim_set_current_line(x)
    end
  end
  if action == 'a' then
    local left, _, right = split_visual_line()
    return function(sha)
      local x = ('%s\\autoref{%s}%s'):format(left, sha, right)
      vim.api.nvim_set_current_line(x)
    end
  end
end

local get_attach_mappings = function(action)
  local callback = get_attach_mappings_callback(action)
  if callback == nil then return end
  local function inner(_, map)
    map('i', '<CR>', function(bufnr)
      local entry = actions_state.get_selected_entry()
      if not entry then return end
      actions.close(bufnr)
      callback(entry.sha)
    end)
    return true
  end
  return inner
end

-- [Action]
-- 'j': jump to the location
-- 'y': yank the SHA to clipboard
-- 'h': replace `<text>` with `\href{<sha>}{<text>}`
-- 'a': replace `<text>` with `\autoref{<sha>}`

-- completely custom search only for nguyenvukhang/math
---@param action 'a' | 'h' | 'j' | 'y' type of action
local theorem_search = function(action)
  local opts = { entry_maker = gen_from_vimgrep_for_math_notes() }
  pickers
    .new(opts, {
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job({ 'minimath-rg' }, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = get_attach_mappings(action),
    })
    :find()
end

-- Get path to the root of the git workspace
local git_workspace_root = function()
  local stdout = vim.fn.systemlist('git rev-parse --show-toplevel')
  return vim.v.shell_error == 0 and stdout[1] or vim.notify('not in a git repo')
end

M.overriding_remaps = function()
  local k, v = vim.keymap.set, vim.cmd

  -- jump to next/prev mark
  local marks = table.concat(gen.marks, '|')
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
    local cword, root = vim.fn.expand('<cword>'), git_workspace_root()
    if not cword or not root then return end
    v('silent lgrep --no-column -ttex \\label\\\\{' .. cword .. '} ' .. root)
  end)

  -- go to references (looks for `\autoref{<cword>}` or `\href{<cword>}`)
  k('n', 'gr', function()
    local cword, root = vim.fn.expand('<cword>'), git_workspace_root()
    if not cword or not root then return end
    local ref = "'\\\\(auto\\|h\\|name)ref\\{" .. cword .. "\\}'"
    v('silent grep -ttex ' .. ref .. ' ' .. root)
    if #vim.fn.getqflist() == 0 then
      vim.notify('No references found.')
    else
      v('silent bel copen')
    end
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
  vim.keymap.set('n', '<leader>pm', function() theorem_search('j') end)
  vim.keymap.set('n', '<leader>pt', function() theorem_search('y') end)
  vim.keymap.set('v', '<leader>h', function() theorem_search('h') end)
  vim.keymap.set('v', '<leader>a', function() theorem_search('a') end)
  vim.keymap.set('n', '<leader>v', function()
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_set_current_line(line .. ' % ' .. os.date('%Y-%m-%d'))
  end)
end

return M
