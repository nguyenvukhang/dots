-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
local require = require('lualine.require').require
local utils = require('lualine.utils.utils')
local modules = require('lualine.require').lazy_require {
  utils_notices = 'lualine.utils.notices',
}

local config = {
  options = {
    theme = 'auto',
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
}

---extends config based on configtable
---@param config_table table
---@return table copy of config
local function apply_configuration(config_table)
  if not config_table then
    return utils.deepcopy(config)
  end
  local function parse_sections(section_group_name)
    if config_table[section_group_name] == nil then
      return
    end
    if not next(config_table[section_group_name]) then
      config[section_group_name] = {}
      return
    end
    for section_name, section in pairs(config_table[section_group_name]) do
      config[section_group_name][section_name] = utils.deepcopy(section)
    end
  end
  if config_table.options and config_table.options.globalstatus and vim.fn.has('nvim-0.7') == 0 then
    modules.utils_notices.add_notice(
      '### Options.globalstatus\nSorry `globalstatus` option can only be used in neovim 0.7 or higher.\n'
    )
    config_table.options.globalstatus = false
  end
  parse_sections('options')
  parse_sections('sections')
  parse_sections('inactive_sections')
  return utils.deepcopy(config)
end

--- returns current active config
---@return table a copy of config
local function get_current_config()
  return utils.deepcopy(config)
end

return {
  get_config = get_current_config,
  apply_configuration = apply_configuration,
}
