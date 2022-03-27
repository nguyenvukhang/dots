-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
local M = {}
local lualine_require = require('lualine_require')
local modules = lualine_require.lazy_require { utils = 'lualine.utils.utils', }

local section_highlight_map = { x = 'c', y = 'b', z = 'a' }
local theme_hls = {}

-- table to store the highlight names created by lualine
local loaded_highlights = {}

--- determine if an highlight exist and isn't cleared
---@param highlight_name string
---@return boolean whether hl_group was defined with highlight_name
function M.highlight_exists(highlight_name)
  return loaded_highlights[highlight_name] or false
end

--- clears loaded_highlights table and highlights
local function clear_highlights()
  for highlight_name, _ in pairs(loaded_highlights) do
    vim.cmd('highlight clear ' .. highlight_name)
  end
  loaded_highlights = {}
end

---converts cterm, color_name type colors to #rrggbb format
---@param color string|number
---@return string
local function sanitize_color(color)
  if color == nil or color == '' then
    return 'None'
  end
  return color
end

--- Define a hl_group
---@param name string
---@param foreground string|number: color
---@param background string|number: color
---@param gui table cterm/gui options like bold/italic ect
---@param link string hl_group name to link new hl to
function M.highlight(name, foreground, background, gui, link)
  local command = { 'highlight!' }
  if link and #link > 0 then
    if loaded_highlights[name] and loaded_highlights[name].link == link then
      return
    end
    vim.list_extend(command, { 'link', name, link })
  else
    foreground = sanitize_color(foreground)
    background = sanitize_color(background)
    gui = (gui ~= nil and gui ~= '') and gui or 'None'
    if
      loaded_highlights[name]
      and loaded_highlights[name].fg == foreground
      and loaded_highlights[name].bg == background
      and loaded_highlights[name].gui == gui
    then
      return -- color is already defined why are we doing this anyway ?
    end
    table.insert(command, name)
    table.insert(command, 'guifg=' .. foreground)
    table.insert(command, 'guibg=' .. background)
    table.insert(command, 'gui=' .. gui)
  end
  vim.cmd(table.concat(command, ' '))

  -- update attached hl groups
  local old_hl_def = loaded_highlights[name]
  if old_hl_def and next(old_hl_def.attached) then
    -- Update attached hl groups as they announced to depend on hl_group 'name'
    -- 'hl' being in 'name'a attached table means 'hl'
    -- depends of 'name'.
    -- 'hl' key in attached table will contain a table that
    -- defines the reletaion between 'hl' & 'name'.
    -- name.attached.hl = { bg = 'fg' } means
    -- hl's fg is same as 'names' bg . So 'hl's fg should
    -- be updated when ever 'name' changes it's 'bg'
    local bg_changed = old_hl_def.bg ~= background
    local fg_changed = old_hl_def.bg ~= foreground
    local gui_changed = old_hl_def.gui ~= gui
    for attach_name, attach_desc in pairs(old_hl_def.attached) do
      if bg_changed and attach_desc.bg and loaded_highlights[attach_name] then
        M.highlight(
          attach_name,
          attach_desc.bg == 'fg' and background or loaded_highlights[attach_name].fg,
          attach_desc.bg == 'bg' and background or loaded_highlights[attach_name].bg,
          loaded_highlights[attach_name].gui,
          loaded_highlights[attach_name].link
        )
      end
      if fg_changed and attach_desc.fg and loaded_highlights[attach_name] then
        M.highlight(
          attach_name,
          attach_desc.fg == 'fg' and foreground or loaded_highlights[attach_name].fg,
          attach_desc.fg == 'bg' and foreground or loaded_highlights[attach_name].bg,
          loaded_highlights[attach_name].gui,
          loaded_highlights[attach_name].link
        )
      end
      if gui_changed and attach_desc.gui and loaded_highlights[attach_name] then
        M.highlight(
          attach_name,
          loaded_highlights[attach_name].fg,
          loaded_highlights[attach_name].bg,
          gui,
          loaded_highlights[attach_name].link
        )
      end
    end
  end
  -- store current hl state
  loaded_highlights[name] = {
    fg = foreground,
    bg = background,
    gui = gui,
    link = link,
    attached = old_hl_def and old_hl_def.attached or {},
  }
end

---define hl_groups for a theme
---@param theme table
function M.create_highlight_groups(theme)
  clear_highlights()
  theme_hls = {}
  local psudo_options = { self = { section = 'a' } }
  for section, color in pairs(theme) do
    local hl_tag = 'normal'
    psudo_options.self.section = section
    theme_hls[section] = M.create_component_highlight_group(color, hl_tag, psudo_options, true)
  end
end

---@description: adds '_mode' at end of highlight_group
---@param highlight_group string name of highlight group
---@return string highlight group name with mode
local function append_mode(highlight_group, is_focused)
  if is_focused == nil then
    is_focused = modules.utils.is_focused()
  end
  if is_focused == false then
    return highlight_group .. '_inactive'
  end
  return highlight_group .. '_normal'
end

---Create highlight group with fg bg and gui from theme
---@param color table has to be { fg = "#rrggbb", bg="#rrggbb" gui = "effect" }
---       all the color elements are optional if fg or bg is not given options
---       must be provided So fg and bg can default the themes colors
---@param highlight_tag string is unique tag for highlight group
---returns the name of highlight group
---@param options table is parameter of component.init() function
---@return table that can be used by component_format_highlight
---  to retrieve highlight group
function M.create_component_highlight_group(color, highlight_tag, options, apply_no_default)
  local section = options.self.section
  local tag_id = 0
  while
    M.highlight_exists(table.concat({ 'lualine', section, highlight_tag }, '_'))
    or (section and M.highlight_exists(table.concat({ 'lualine', section, highlight_tag, 'normal' }, '_')))
  do
    highlight_tag = highlight_tag .. '_' .. tostring(tag_id)
    tag_id = tag_id + 1
  end

  if type(color) == 'string' then
    local highlight_group_name = table.concat({ 'lualine', section, highlight_tag }, '_')
    M.highlight(highlight_group_name, nil, nil, nil, color) -- l8nk to group
    return {
      name = highlight_group_name,
      fn = nil,
      no_mode = true,
      link = true,
      section = section,
      options = options,
      no_default = apply_no_default,
    }
  end

  if type(color) ~= 'function' and (apply_no_default or (color.bg and color.fg)) then
    -- When bg and fg are both present we donn't need to set highlighs for
    -- each mode as they will surely look the same. So we can work without options
    local highlight_group_name = table.concat({ 'lualine', section, highlight_tag }, '_')
    M.highlight(highlight_group_name, color.fg, color.bg, color.gui, nil)
    return {
      name = highlight_group_name,
      fn = nil,
      no_mode = true,
      section = section,
      options = options,
      no_default = apply_no_default,
    }
  end

  local mode = 'normal'
  local hl_name = table.concat({ 'lualine', section, highlight_tag, mode }, '_')
  local cl = color
  cl = { link = cl }
  M.highlight(hl_name, cl.fg, cl.bg, cl.gui, cl.link)

  return {
    name = table.concat({ 'lualine', section, highlight_tag }, '_'),
    fn = type(color) == 'function' and color,
    no_mode = false,
    link = false,
    section = section,
    options = options,
    no_default = apply_no_default,
  }
end

---@description: retrieve highlight_groups for components
---@param highlight table return value of create_component_highlight_group
---  return value of create_component_highlight_group is to be passed in
---  this parameter to receive highlight that was created
---@return string formatted highlight group name
function M.component_format_highlight(highlight, is_focused)
  if not highlight.fn then
    local highlight_group = highlight.name
    if highlight.no_mode then
      return '%#' .. highlight_group .. '#'
    end
    highlight_group = append_mode(highlight_group, is_focused)
    return '%#' .. highlight_group .. '#'
  else
    local color = highlight.fn { section = highlight.section } or {}
    local hl_name = highlight.name
    M.highlight(hl_name, nil, nil, nil, color)
    return '%#' .. hl_name .. '#'
  end
end

---@description: retrieve highlight_groups for section
---@param section string highlight group name without mode
---  return value of create_component_highlight_group is to be passed in
---  this parameter to receive highlight that was created
---@param is_focused boolean
---@return string formatted highlight group name
function M.format_highlight(section, is_focused)
  local ret = ''
  if theme_hls and theme_hls[section] then
    ret = M.component_format_highlight(theme_hls[section], is_focused)
  elseif theme_hls and section > 'c' and theme_hls[section_highlight_map[section]] then
    ret = M.component_format_highlight(theme_hls[section_highlight_map[section]], is_focused)
  end
  return ret
end

return M
