local vimgrep = require('minimath.vimgrep')
local M = {}

---@alias MinimathAction
---| 'j' # jump to the location
---| 'y' # yank the SHA to clipboard
---| 'h' # replace `<text>` with `\href{<sha>}{<text>}`
---| 'a' # replace `<text>` with `\autoref{<sha>}`

---@param action MinimathAction
---@param p_open integer[]?
---@param p_close integer[]?
local get_attach_mappings = function(action, p_open, p_close)
  local actions_state = require('telescope.actions.state')
  local actions = require('telescope.actions')
  if action == 'j' then return end
  local function inner(_, map)
    map('i', '<CR>', function(bufnr)
      local entry = actions_state.get_selected_entry()
      if not entry then return end
      actions.close(bufnr)

      if p_open and p_close then
        vim.fn.setpos("'<", { 0, 0, 0, 0 })
        vim.fn.setpos("'>", p_open)
        vim.fn.setpos("'<", p_close)
      end

      -- Run THE action.
      if action == 'y' then
        return vim.fn.setreg('', entry.sha)
      elseif action == 'h' then
        return vim.fn.feedkeys('gv"xc\\href{' .. entry.sha .. '}{}"xP')
      elseif action == 'a' then
        return vim.fn.feedkeys('gv"xc\\autoref{' .. entry.sha .. '}')
      end
    end)
    return true
  end
  return inner
end

-- completely custom search only for nguyenvukhang/math
---@param action MinimathAction
M.theorem_search = function(action)
  local opts = { entry_maker = vimgrep.gen_from_vimgrep_for_latex() }
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values
  local p_open, p_close
  if action == 'h' or action == 'a' then
    p_open = vim.fn.getpos('v')
    p_close = vim.fn.getpos('.')
  end
  pickers
    .new(opts, {
      layout_strategy = 'vertical',
      layout_config = { width = function(_, c, _) return math.min(c, 88) end },
      prompt_title = 'Theorems',
      finder = finders.new_oneshot_job({ 'minimath-rg' }, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = get_attach_mappings(action, p_open, p_close),
    })
    :find()
end

M.lean_theorem_search = function()
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local opts = { entry_maker = vimgrep.gen_from_vimgrep_for_lean() }
  local conf = require('telescope.config').values
  pickers
    .new(opts, {
      layout_strategy = 'vertical',
      layout_config = { width = function(_, c, _) return math.min(c, 88) end },
      prompt_title = 'Lean Theorems',
      finder = finders.new_oneshot_job({ 'slope', 'rg' }, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = get_attach_mappings('j'),
    })
    :find()
end

return M
