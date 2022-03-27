-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
local M = {}
local require = require('lualine.require').require
local utils = require('lualine.utils.utils')
local highlight = require('lualine.highlight')

---@param section table list of components
---@param section_name string used for getting proper hl
---@param is_focused boolean
---@return string formated string for a section
function M.draw_section(section, section_name, is_focused)
  local highlight_name = highlight.format_highlight(section_name, is_focused)

  local status = {}
  for _, component in pairs(section) do
    -- load components into status table
    if type(component) ~= 'table' or (type(component) == 'table' and not component.component_no) then
      return '' -- unknown element in section. section posibly not yet loaded
    end
    table.insert(status, component:draw(highlight_name, is_focused))
  end

  -- Remove empty strings from status
  status = utils.list_shrink(status)
  local status_str = table.concat(status)

  if #status_str == 0 then
    return ''
  end

  return status_str
end

return M
