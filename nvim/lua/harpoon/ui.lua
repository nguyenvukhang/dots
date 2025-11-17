local popup = require('plenary.popup')
local Marked = require('harpoon.mark')
local utils = require('harpoon.utils')

local M = {}

Harpoon_win_id = nil
Harpoon_bufh = nil

-- We save before we close because we use the state of the buffer as the list
-- of items.
local function close_menu()
  vim.api.nvim_win_close(Harpoon_win_id, true)
  Harpoon_win_id = nil
  Harpoon_bufh = nil
end

local function create_window()
  local width = 60
  local height = 10
  local bufnr = vim.api.nvim_create_buf(false, false)

  local Harpoon_win_id, win = popup.create(bufnr, {
    title = 'Harpoon',
    highlight = 'HarpoonWindow',
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  })

  vim.api.nvim_set_option_value(
    'winhl',
    'Normal:HarpoonBorder',
    { win = win.border.win_id }
  )

  return { bufnr = bufnr, win_id = Harpoon_win_id }
end

local function get_menu_items()
  local lines = vim.api.nvim_buf_get_lines(Harpoon_bufh, 0, -1, true)
  local indices = {}
  for _, line in pairs(lines) do
    if not utils.is_white_space(line) then table.insert(indices, line) end
  end
  return indices
end

function M.toggle_quick_menu()
  if Harpoon_win_id ~= nil and vim.api.nvim_win_is_valid(Harpoon_win_id) then
    return close_menu()
  end

  local win_info = create_window()
  local contents = {}

  Harpoon_win_id = win_info.win_id
  Harpoon_bufh = win_info.bufnr

  for idx = 1, Marked.get_length() do
    local file = Marked.get_marked_file_name(idx)
    if file == '' then file = '(empty)' end
    contents[idx] = string.format('%s', file)
  end

  vim.api.nvim_set_option_value('number', true, { win = Harpoon_win_id })
  vim.api.nvim_set_option_value('wrap', false, { win = Harpoon_win_id })
  vim.api.nvim_buf_set_name(Harpoon_bufh, 'harpoon-menu')
  vim.api.nvim_buf_set_lines(Harpoon_bufh, 0, #contents, false, contents)
  vim.api.nvim_set_option_value('filetype', 'harpoon', { buf = Harpoon_bufh })
  vim.api.nvim_set_option_value('buftype', 'acwrite', { buf = Harpoon_bufh })
  vim.api.nvim_set_option_value('bufhidden', 'delete', { buf = Harpoon_bufh })

  vim.keymap.set('n', '<esc>', M.toggle_quick_menu, {
    buffer = Harpoon_bufh,
    silent = true,
  })
  vim.api.nvim_create_autocmd(
    { 'BufWriteCmd' },
    { buffer = Harpoon_bufh, callback = M.on_menu_save }
  )
  vim.api.nvim_create_autocmd(
    { 'TextChanged', 'TextChangedI' },
    { buffer = Harpoon_bufh, callback = M.on_menu_save }
  )
  vim.api.nvim_create_autocmd(
    { 'BufModifiedSet' },
    { buffer = Harpoon_bufh, command = 'set nomodified' }
  )
end

function M.on_menu_save() Marked.set_mark_list(get_menu_items()) end

local function get_or_create_buffer(filename)
  local buf_exists = vim.fn.bufexists(filename) ~= 0
  if buf_exists then return vim.fn.bufnr(filename) end

  return vim.fn.bufadd(filename)
end

function M.nav_file(id)
  local idx = Marked.get_index_of(id)
  if not Marked.valid_index(idx) then return end

  local mark = Marked.get_marked_file(idx)
  local filename = vim.fs.normalize(mark.filename)
  local buf_id = get_or_create_buffer(filename)
  local set_row = not vim.api.nvim_buf_is_loaded(buf_id)

  local old_bufnr = vim.api.nvim_get_current_buf()

  vim.api.nvim_set_current_buf(buf_id)

  vim.api.nvim_set_option_value('buflisted', true, { buf = buf_id })

  if set_row and mark.row and mark.col then
    vim.cmd(string.format(':call cursor(%d, %d)', mark.row, mark.col))
  end

  local old_bufinfo = vim.fn.getbufinfo(old_bufnr)
  if type(old_bufinfo) == 'table' and #old_bufinfo >= 1 then
    old_bufinfo = old_bufinfo[1]
    local no_name = old_bufinfo.name == ''
    local one_line = old_bufinfo.linecount == 1
    local unchanged = old_bufinfo.changed == 0
    if no_name and one_line and unchanged then
      vim.api.nvim_buf_delete(old_bufnr, {})
    end
  end
end

return M
