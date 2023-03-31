local nnoremap = require('brew.core').nnoremap

-- harpoon!
local harpoon = {
  mark = require('harpoon.mark'),
  ui = require('harpoon.ui'),
}

harpoon.jump = function(n)
  return function()
    harpoon.ui.nav_file(n)
    vim.notify_once('[harpoon] -> ' .. n .. '/4')
  end
end

harpoon.add = function()
  harpoon.mark.add_file()
  harpoon.ui.toggle_quick_menu()
  vim.notify_once('[harpoon] added file')
end

nnoremap('<leader>m', harpoon.ui.toggle_quick_menu)
nnoremap('mm', harpoon.add, true)
nnoremap('<leader>1', harpoon.jump(1), true)
nnoremap('<leader>2', harpoon.jump(2), true)
nnoremap('<leader>3', harpoon.jump(3), true)
nnoremap('<leader>4', harpoon.jump(4), true)
