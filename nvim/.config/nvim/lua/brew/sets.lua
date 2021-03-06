local dots_root = require("brew.core").env.dots_root
vim.opt.scrolloff = 15 -- scrolls before cursor reaches edge
vim.opt.sidescrolloff = 10 -- scrolls before cursor reaches side
vim.opt.tabstop = 2 -- # of spaces a <Tab> counts for
vim.opt.softtabstop = 1 -- # of spaces a <Tab> is when editing
vim.opt.expandtab = true -- space instead tab when pressing <Tab>
vim.opt.shiftwidth = 2 -- # of spaces to use for each >> and <<
vim.opt.wrap = false -- line wrap
vim.opt.wrapscan = true -- search wrap
vim.opt.linebreak = true -- wrap without breaking words
vim.opt.breakindent = true -- indented wraps
vim.opt.guicursor = "" -- make cursor a block
vim.opt.relativenumber = true -- line numbers relative to cursor line
vim.opt.number = true -- set current line number as actual
vim.opt.hidden = true -- allows buffer switching without saving
vim.opt.undofile = true -- enables persisted undos
vim.opt.incsearch = true -- search as you type
vim.opt.hlsearch = false -- unhighlight matches after searching
vim.opt.laststatus = 2 -- statusline always on
vim.opt.foldmethod = "marker" -- enables folding
vim.opt.spelllang = "en_us" -- enables spell check
vim.opt.errorbells = false -- disables terminal sounds
vim.opt.swapfile = false -- disables swap file
vim.opt.backup = false -- disables backup
vim.opt.autochdir = false -- follow/keep pwd static
vim.opt.pumheight = 8 -- sets popup menu height
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.completeopt = "menu,menuone,noselect" -- recommended by nvim-cmp
vim.opt.shortmess = vim.o.shortmess .. "c"
vim.opt.spellfile = dots_root .. "/personal/.config/nvim/data/spell/en.utf-8.add"
vim.opt.grepprg = "rg --color=never --no-heading --with-filename --line-number --column --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.fillchars = "fold: "
vim.opt.termguicolors = true
vim.opt.wildignore = "*/node_modules/*"
-- vim.opt.undodir = dots_root .. "/personal/.config/nvim/data/undodir"

-- honorary set
-- set leader to <space>
vim.g.mapleader = " "

-- color scheme
vim.g.gruvbox_italics = false
vim.g.gruvbox_italicize_strings = false
vim.g.gruvbox_transp_bg = true
vim.g.gruvbox_bold = false
vim.cmd("colorscheme gruvbox8")
