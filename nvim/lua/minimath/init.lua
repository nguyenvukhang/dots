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

local parse_lean = function(t)
  _, _, t.filename, t.lnum, t.text = t.value:find('(.*):(%d+):(.*)')
  t.lnum = tonumber(t.lnum)
  return t
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

return M
