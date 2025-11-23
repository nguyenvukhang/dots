local gen = require('minimath.generated')

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
  _, _, t.filename, t.lnum, t.text, t.sha = t.value:find('(.*):(%d+):(.*):(.*)')
  t.lnum = tonumber(t.lnum)
  return t
end

local parse_lean = function(t)
  _, _, t.filename, t.lnum, t.text = t.value:find('(.*):(%d+):(.*)')
  t.lnum = tonumber(t.lnum)
  return t
end

local function gen_from_vimgrep_for_math_notes()
  local mt_vimgrep_entry
  local execute_keys = {
    path = function(t) return vim.fn.fnamemodify(t.filename, ':p') end,
    filename = function(t) return rawget(parse(t), 'filename') end,
    lnum = function(t) return rawget(parse(t), 'lnum') end,
    text = function(t) return rawget(parse(t), 'text') end,
    ordinal = function(t) return t.text end,
  }
  mt_vimgrep_entry = {
    display = function(t) return get_abbrev(t.filename) .. ' | ' .. t.text end,
    __index = function(t, k)
      local z = rawget(mt_vimgrep_entry, k) -- try to get raw value first.
      if z then return z end
      z = rawget(execute_keys, k) -- use the executor.
      if z then
        z = z(t)
        -- Insert filters here, for instance:
        -- if string.find(z, 'Bolzano') then return nil end
        rawset(t, k, z) -- cache the value
        return z
      end
      if k == 'ordinal' or k == 'value' then return rawget(t, 1) end
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
  if action == 'j' then
    return nil
  elseif action == 'y' then
    return function(sha) vim.fn.setreg('', sha) end
  elseif action == 'h' then
    local left, selection, right = split_visual_line()
    return function(sha)
      local x = ('%s\\href{%s}{%s}%s'):format(left, sha, selection, right)
      vim.api.nvim_set_current_line(x)
    end
  elseif action == 'a' then
    local left, _, right = split_visual_line()
    return function(sha)
      local x = ('%s\\autoref{%s}%s'):format(left, sha, right)
      vim.api.nvim_set_current_line(x)
    end
  end
end

local get_attach_mappings = function(action)
  local actions_state = require('telescope.actions.state')
  local actions = require('telescope.actions')
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
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values
  pickers
    .new(opts, {
      layout_strategy = 'vertical',
      layout_config = { width = function(_, c, _) return math.min(c, 88) end },
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job({ 'minimath-rg' }, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = get_attach_mappings(action),
    })
    :find()
end

local function gen_from_vimgrep_for_lean()
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
        -- Insert filters here, for instance:
        -- if string.find(z, 'Bolzano') then return nil end
        rawset(t, k, z) -- cache the value
        return z
      end
      if k == 'ordinal' or k == 'value' then return rawget(t, 1) end
    end,
  }
  return function(line) return setmetatable({ line }, mt_vimgrep_entry) end
end

M.lean_remaps = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local k = vim.keymap.set
  local opts = { silent = true, buffer = bufnr }

  k('n', '<leader>pl', function()
    local finders = require('telescope.finders')
    local pickers = require('telescope.pickers')
    local lopts = { entry_maker = gen_from_vimgrep_for_lean() }
    local conf = require('telescope.config').values
    pickers
      .new(lopts, {
        layout_strategy = 'vertical',
        layout_config = { width = function(_, c, _) return math.min(c, 88) end },
        prompt_title = 'Lean Theorems',
        finder = finders.new_oneshot_job({ 'lake-dino', 'rg' }, lopts),
        previewer = conf.grep_previewer(lopts),
        sorter = conf.generic_sorter(lopts),
        attach_mappings = get_attach_mappings('j'),
      })
      :find()
  end, opts)
end

M.remaps = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local k = vim.keymap.set
  local opts = { silent = true, buffer = bufnr }

  k('n', '<leader>pm', function() theorem_search('j') end, opts)
  k('n', '<leader>pt', function() theorem_search('y') end, opts)
  k('v', '<leader>h', function() theorem_search('h') end, opts)
  k('v', '<leader>a', function() theorem_search('a') end, opts)
  k('n', '<leader>v', function()
    local line = vim.api.nvim_get_current_line()
    local parts = vim.split(line, ' %% ')
    vim.api.nvim_set_current_line(parts[1] .. ' % ' .. os.date('%Y-%m-%d'))
  end, opts)
end

return M
