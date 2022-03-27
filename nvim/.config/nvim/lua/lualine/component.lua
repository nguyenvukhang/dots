-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.
local require = require('lualine_require').require
local highlight = require('lualine.highlight')
local M = require('lualine.utils.class'):extend()

-- Used to provide a unique id for each component
local component_no = 1

-- variable to store component output for manipulation
M.status = ''

function M:__tostring()
  local str = 'Component: ' .. self.options.component_name
  if self.debug then
    str = str .. '\n---------------------\n' .. vim.inspect(self)
  end
  return str
end

M.__is_lualine_component = true

---initialize new component
---@param options table options for component
--- I_need_this
function M:init(options)
  self.options = options or {}
  component_no = component_no + 1
  if not self.options.component_name then
    self.options.component_name = tostring(component_no)
  end
  self.component_no = component_no
  self:create_option_highlights()
end

---creates hl group from color option
--- I_need_this
function M:create_option_highlights()
  -- set custom highlights
  if self.options.color then
    self.options.color_highlight = highlight.create_component_highlight_group(
      self.options.color,
      self.options.component_name,
      self.options,
      false
    )
  end
end

---adds spaces to left and right of a component
--- I_need_this
function M:apply_padding()
  local padding = self.options.padding
  if padding == nil then
    padding = 1
  end

  if padding then
    if self.status:find('%%#.*#') == 1 then
      -- When component has changed the highlight at begining
      -- we will add the padding after the highlight
      local pre_highlight = vim.fn.matchlist(self.status, [[\(%#.\{-\}#\)]])[2]
      self.status = pre_highlight .. string.rep(' ', padding) .. self.status:sub(#pre_highlight + 1, #self.status)
    else
      self.status = string.rep(' ', padding) .. self.status
    end
    self.status = self.status .. string.rep(' ', padding)
  end
end

---applies custom highlights for component
--- I_need_this
function M:apply_highlights(default_highlight)
  if self.options.color_highlight then
    local hl_fmt
    hl_fmt, M.color_fn_cache = highlight.component_format_highlight(self.options.color_highlight)
    self.status = hl_fmt .. self.status
  end
  -- Prepend default hl when the component doesn't start with hl otherwise
  -- color in previous component can cause side effect
  if not self.status:find('^%%#') then
    self.status = default_highlight .. self.status
  end
end

-- luacheck: push no unused args
---actual function that updates a component. Must be overwritten with component functionality
function M:update_status(is_focused) end
-- luacheck: pop

---driver code of the class
function M:draw(default_highlight, is_focused)
  self.status = ''

  if self.options.cond ~= nil and self.options.cond() ~= true then
    return self.status
  end
  self.default_hl = default_highlight
  local status = self:update_status(is_focused)
  if self.options.fmt then
    status = self.options.fmt(status or '')
  end
  if type(status) == 'string' and #status > 0 then
    self.status = status
    self:apply_padding()
    self:apply_highlights(default_highlight)
  end
  return self.status
end

return M
