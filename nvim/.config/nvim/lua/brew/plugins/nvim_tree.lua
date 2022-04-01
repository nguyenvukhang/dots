vim.g.nvim_tree_show_icons = {
  git = 0,
  folders = 1,
  files = 0,
  folder_arrows = 0,
}
require'nvim-tree'.setup()

vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeToggle<cr>',
  { noremap = true, silent = true })
vim.g.nvim_tree_icons = {
  folder = {
    arrow_open = "⋁",
    arrow_closed = ">",
    default = ">",
    open = "⋁",
    empty = ">",
    empty_open = "⋁",
  }
}
