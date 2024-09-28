-- it is important that this file can run even with no plugins installed

local v = vim.opt
v.autoread = false -- don't automatically load changes
v.scrolloff = 15 -- scrolls before cursor reaches edge
v.sidescrolloff = 10 -- scrolls before cursor reaches side
v.tabstop = 2 -- # of spaces a <Tab> counts for
v.softtabstop = 1 -- # of spaces a <Tab> is when editing
v.expandtab = true -- space instead tab when pressing <Tab>
v.shiftwidth = 2 -- # of spaces to use for each >> and <<
v.wrap = false -- line wrap
v.wrapscan = true -- search wrap
v.linebreak = true -- wrap without breaking words
v.breakindent = true -- indented wraps
v.guicursor = '' -- make cursor a block
v.relativenumber = true -- line numbers relative to cursor line
v.number = true -- set current line number as actual
v.hidden = true -- allows buffer switching without saving
v.undofile = true -- enables persisted undos
v.incsearch = true -- search as you type
v.hlsearch = false -- unhighlight matches after searching
v.laststatus = 2 -- statusline always on
v.foldmethod = 'marker' -- enables folding
v.spelllang = 'en_us' -- enables spell check
v.errorbells = false -- disables terminal sounds
v.swapfile = false -- disables swap file
v.backup = false -- disables backup
v.pumheight = 8 -- sets popup menu height
v.signcolumn = 'yes' -- always show sign column
v.grepprg = 'rg --vimgrep --hidden --smart-case'
v.grepformat = '%f:%l:%c:%m,%f:%l:%m'
v.termguicolors = true
v.wildignore = '*/node_modules/*'
v.mouse = ''
v.cinoptions:append('L0') -- so that typing `std::` in cpp doesn't de-dent it halfway
v.formatoptions = 'jcroql' -- see :h fo-table too
v.colorcolumn = '81'

-- honorary set
-- set leader to <space>
vim.g.mapleader = ' '
