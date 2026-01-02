local Path = require('plenary.path')
local utils = require('harpoon.utils')

local data_path = vim.fn.stdpath('data')
local cache_config = string.format('%s/harpoon.json', data_path)

local M = {}

local GROUP =
  vim.api.nvim_create_augroup('THE_PRIMEAGEN_HARPOON', { clear = true })

vim.api.nvim_create_autocmd({ 'BufLeave', 'VimLeave' }, {
  callback = function() require('harpoon.mark').store_offset() end,
  group = GROUP,
})
HarpoonConfig = HarpoonConfig or {}

-- tbl_deep_extend does not work the way you would think
local function merge_table_impl(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == 'table' then
      if type(t1[k]) == 'table' then
        merge_table_impl(t1[k], v)
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
end

local function mark_config_key() return utils.project_key() end

local function merge_tables(...)
  local out = {}
  for i = 1, select('#', ...) do
    merge_table_impl(out, select(i, ...))
  end
  return out
end

local function ensure_correct_config(config)
  local projects = config.projects
  local mark_key = mark_config_key()
  if projects[mark_key] == nil then projects[mark_key] = { marks = {} } end

  local proj = projects[mark_key]
  if proj == nil then proj = { marks = {} } end
  for idx, mark in pairs(proj.marks) do
    if type(mark) == 'string' then
      mark = { filename = mark }
      proj.marks[idx] = mark
    end
    proj.marks[idx].filename = utils.normalize_path(mark.filename)
  end
  return config
end

local function expand_dir(config)
  local projects = config.projects or {}
  for k in pairs(projects) do
    local expanded_path = Path.new(k):expand()
    projects[expanded_path] = projects[k]
    if expanded_path ~= k then projects[k] = nil end
  end
  return config
end

function M.save()
  -- first refresh from disk everything but our project
  M.refresh_projects_b4update()
  Path:new(cache_config):write(vim.fn.json_encode(HarpoonConfig), 'w')
end

local function read_config(local_config)
  return vim.json.decode(Path:new(local_config):read())
end

function M.setup()
  local ok2, c_config = pcall(read_config, cache_config)
  if not ok2 then c_config = {} end
  local complete_config = merge_tables({
    projects = {},
  }, expand_dir(c_config))
  HarpoonConfig = complete_config
end

function M.get_global_settings() return HarpoonConfig.global_settings end

-- refresh all projects from disk, except our current one
function M.refresh_projects_b4update()
  -- save current runtime version of our project config for merging back in later
  local cwd = mark_config_key()
  local current_p_config = {
    projects = { [cwd] = ensure_correct_config(HarpoonConfig).projects[cwd] },
  }

  -- erase all projects from global config, will be loaded back from disk
  HarpoonConfig.projects = nil

  -- this reads a stale version of our project but up-to-date versions
  -- of all other projects
  local ok2, c_config = pcall(read_config, cache_config)

  if not ok2 then c_config = { projects = {} } end
  -- don't override non-project config in HarpoonConfig later
  c_config = { projects = c_config.projects }

  -- erase our own project, will be merged in from current_p_config later
  c_config.projects[cwd] = nil

  local complete_config = merge_tables(
    HarpoonConfig,
    expand_dir(c_config),
    expand_dir(current_p_config)
  )

  -- There was this issue where the vim.loop.cwd() didn't have marks,
  -- but had an object for vim.loop.cwd()
  ensure_correct_config(complete_config)

  HarpoonConfig = complete_config
end

function M.get_mark_config()
  return ensure_correct_config(HarpoonConfig).projects[mark_config_key()]
end

-- Sets a default config with no values
M.setup()

M.my_setup = function()
  local mark, ui = require('harpoon.mark'), require('harpoon.ui')
  local jump = function(n)
    return function()
      ui.nav_file(n)
      vim.notify('[harpoon] -> ' .. n .. '/4')
    end
  end
  local nnoremap = function(L, R) vim.keymap.set('n', L, R) end
  nnoremap('<leader>m', ui.toggle_quick_menu)
  nnoremap('<leader>1', jump(1))
  nnoremap('<leader>2', jump(2))
  nnoremap('<leader>3', jump(3))
  nnoremap('<leader>4', jump(4))
  nnoremap('mm', function()
    mark.add_file()
    ui.toggle_quick_menu()
    vim.notify_once('[harpoon] added file')
  end)
end

return M
