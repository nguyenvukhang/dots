local nt = require('nvim-toggler')
nt.setup {
  inverses = {
    ['- [ ]'] = '- [x]',
    ['row'] = 'column',
    ['good'] = 'bad',
    ['ON'] = 'OFF',
  },
  remove_default_keybinds = true,
}
vim.keymap.set({ 'n', 'v' }, '<leader>i', nt.toggle, { silent = true })
