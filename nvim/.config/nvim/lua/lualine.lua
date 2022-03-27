-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.


----------------------------------------------
-- start of what used to be in lualine_require
----------------------------------------------
--------------------------------------------
-- end of what used to be in lualine_require
--------------------------------------------
local lualine_require = require('lualine.require')
local modules = lualine_require.lazy_require {
  highlight = 'lualine.highlight',
  loader = 'lualine.utils.loader',
  utils_section = 'lualine.utils.section',
  utils = 'lualine.utils.utils',
  utils_notices = 'lualine.utils.notices',
  config_module = 'lualine.config',
}
local config -- Stores currently applied config

--- creates the statusline string
---@param sections table : section config where components are replaced with
---      component objects
---@param is_focused boolean : whether being evsluated for focused window or not
---@return string statusline string
local statusline = modules.utils.retry_call_wrap(function(sections, is_focused)
  -- The sequence sections should maintain [SECTION_SEQUENCE]
  local section_sequence = { 'a', 'b', 'c', 'x', 'y', 'z' }
  local status = {}
  local applied_midsection_divider = false
  local applied_trunc = false
  for _, section_name in ipairs(section_sequence) do
    if sections['lualine_' .. section_name] then
      -- insert highlight+components of this section to status_builder
      local section_data = modules.utils_section.draw_section(
        sections['lualine_' .. section_name],
        section_name,
        is_focused
      )
      if #section_data > 0 then
        if not applied_midsection_divider and section_name > 'c' then
          applied_midsection_divider = true
          section_data = modules.highlight.format_highlight('c', is_focused) .. '%=' .. section_data
        end
        if not applied_trunc and section_name > 'b' then
          applied_trunc = true
          section_data = '%<' .. section_data
        end
        table.insert(status, section_data)
      end
    end
  end
  if applied_midsection_divider == false and config.options.always_divide_middle ~= false then
    -- When non of section x,y,z is present
    table.insert(status, modules.highlight.format_highlight('c', is_focused) .. '%=')
  end
  return table.concat(status)
end)

local function notify_theme_error(theme_name)
  local message_template = theme_name ~= 'auto'
      and [[
### options.theme
Theme `%s` not found, falling back to `auto`. Check if spelling is right.
]]
    or [[
### options.theme
Theme `%s` failed, falling back to `gruvbox`.
This shouldn't happen.
Please report the issue at https://github.com/nvim-lualine/lualine.nvim/issues .
Also provide what colorscheme you're using.
]]
  modules.utils_notices.add_notice(string.format(message_template, theme_name))
end

--- sets up theme by defining hl groups and setting theme cache in highlight.lua
--- uses options.theme option for theme if it's a string loads theme of that name
--- if it's a table directlybuses it .
--- when theme load fails this fallsback to 'auto' theme if even that fails
--- this falls back to 'gruvbox' theme
--- also sets up auto command to reload lualine on ColorScheme or background
---  change on
local function setup_theme()
  local function get_theme_from_config()
    local theme_name = config.options.theme
    if type(theme_name) == 'string' then
      local ok, theme = pcall(modules.loader.load_theme, theme_name)
      if ok and theme then
        return theme
      end
    elseif type(theme_name) == 'table' then
      -- use the provided theme as-is
      return config.options.theme
    end
    if theme_name ~= 'auto' then
      notify_theme_error(theme_name)
      local ok, theme = pcall(modules.loader.load_theme, 'auto')
      if ok and theme then
        return theme
      end
    end
    notify_theme_error('auto')
    return modules.loader.load_theme('gruvbox')
  end
  local theme = get_theme_from_config()
  modules.highlight.create_highlight_groups(theme)
  vim.cmd([[autocmd lualine ColorScheme * lua require'lualine'.setup()
    autocmd lualine OptionSet background lua require'lualine'.setup()]])
end

--- Sets &ststusline option to lualine
--- adds auto command to redraw lualine on VimResized event
local function set_statusline()
  if next(config.sections) ~= nil or next(config.inactive_sections) ~= nil then
    vim.cmd('autocmd lualine VimResized * redrawstatus')
    vim.go.statusline = "%{%v:lua.require'lualine'.statusline()%}"
    vim.go.laststatus = config.options.globalstatus and 3 or 2
  elseif vim.go.statusline == "%{%v:lua.require'lualine'.statusline()%}" then
    vim.go.statusline = ''
    vim.go.laststatus = 2
  end
end

-- lualine.statusline function
--- Draw correct statusline for current winwow
---@param focused boolean : force the vale of is_focuased . useful for debugginf
---@return string statusline string
local function status_dispatch(focused)
  local retval
  local current_ft = vim.bo.filetype
  local is_focused = focused ~= nil and focused or modules.utils.is_focused()
  for _, ft in pairs(config.options.disabled_filetypes) do
    -- disable on specific filetypes
    if ft == current_ft then
      return ''
    end
  end
  if is_focused then
    retval = statusline(config.sections, is_focused)
  else
    retval = statusline(config.inactive_sections, is_focused)
  end
  return retval
end

-- lualine.setup function
--- sets new user config
--- This function doesn't load components/theme etc.. they are done before
--- first statusline redraw after new config. This is more efficient when
--- lualine config is done in several setup calls in chunks. This way
--- we don't intialize components just to throgh them away .Instead they are
--- initialized when we know we will use them.
--- sets &last_status tl 2
---@param user_config table table
local function setup(user_config)
  if package.loaded['lualine.utils.notices'] then
    -- When notices module is not loaded there are no notices to clear.
    modules.utils_notices.clear_notices()
  end
  config = modules.config_module.apply_configuration(user_config)
  vim.cmd([[augroup lualine | exe "autocmd!" | augroup END]])
  setup_theme()
  -- load components
  modules.loader.load_all(config)
  set_statusline()
  if package.loaded['lualine.utils.notices'] then
    modules.utils_notices.notice_message_startup()
  end
end

return {
  setup = setup,
  statusline = status_dispatch,
  get_config = modules.config_module.get_config,
}
