local brew = require("brew.core").functions
local diagnostics = require("brew.diagnostics")

local noremap = function(mode)
    local fn = function(lhs, rhs, verbose)
        if type(rhs) == "string" then
            vim.api.nvim_set_keymap(mode, lhs, rhs, {
                noremap = true,
                silent = not (verbose or false),
            })
        else
            vim.api.nvim_set_keymap(mode, lhs, "", {
                noremap = true,
                silent = not (verbose or false),
                callback = rhs,
            })
        end
    end
    return fn
end

local nnoremap = noremap("n")
local vnoremap = noremap("v")

-- no-ops
nnoremap("<space>", "<nop>")
nnoremap("<bs>", "<nop>")
nnoremap("Q", "<nop>")
nnoremap("K", "<nop>")
nnoremap("<left>", "<nop>")
nnoremap("<right>", "<nop>")
nnoremap("<up>", "<nop>")
nnoremap("<down>", "<nop>")

-- set leader to <space>
vim.g.mapleader = " "

-- on-the-go reload vimrc
nnoremap("<leader><cr>", ":so $MYVIMRC<cr>")

-- the only right way to setup H and L
nnoremap("H", "^")
nnoremap("L", "$")
vnoremap("H", "^")
vnoremap("L", "$")

-- open file under cursor in a split
nnoremap("gF", ":vs <cfile><cr>")

-- slowly increase this until I can use the default
nnoremap("<C-d>", "13jzz")
nnoremap("<C-u>", "13kzz")

-- quickfix list navigation
nnoremap("<silent>", "<C-j> :cnext<cr>")
nnoremap("<silent>", "<C-k> :cprev<cr>")

-- color columns
nnoremap("<leader>7", ":set colorcolumn=71<cr>")
nnoremap("<leader>8", ":set colorcolumn=81<cr>")

-- yank to clipboard (confirmed to work on mac)
nnoremap("<leader>y", '"+y')
vnoremap("<leader>y", '"+y')

-- split jumping
nnoremap("<leader>h", ":wincmd h<cr>")
nnoremap("<leader>l", ":wincmd l<cr>")
nnoremap("<leader>j", ":wincmd j<cr>")
nnoremap("<leader>k", ":wincmd k<cr>")

-- replace in buffer
nnoremap("<leader>rb", 'yiw:%s/<C-r>"//g<left><left>', true)

-- replace in line
nnoremap("<leader>rl", 'yiw:s/<C-r>"//g<left><left>', true)

-- replace visual selection
-- vnoremap <C-s> y:%s/<C-r>"//g<left><left>

-- reverse visual lines
-- vnoremap <C-r> <esc>'<km<'>:'<,.g/^/m '><CR>

-- search visual selection
-- vnoremap * y/<C-r>"<cr>

-- refresh syntax highlighting
nnoremap("<f1>", ":syntax sync fromstart<cr>")

-- toggle spell check
nnoremap("<f5>", ":setlocal spell!<cr>:set spell?<cr>")

-- vim functions
-- command! CloseOtherBuffers execute '%bd|e #|norm `"'
nnoremap("<leader>x", ":CloseOtherBuffers")
nnoremap("<leader>c", ":ColorizerToggle<cr>")

-- lua functions
nnoremap("<leader>t", ":lua require('brew.core').functions.Todolist()<cr>")
nnoremap("<leader>o", brew.ToggleQuickFix)
nnoremap("<leader>O", brew.ToggleLocalList)
nnoremap("<leader>e", diagnostics.diagnostics)

nnoremap("[[", brew.openSq)
nnoremap("]]", brew.closeSq)

-- harpoon
-- nnoremap ("<silent>", "<C-h> :lua require("harpoon.ui").toggle_quick_menu()<cr>")

-- harpoon
-- leader m to mark the file
-- leader a,s,d,f to jump to files

-- show highlight group of char under cursor
-- nnoremap ("<F10>", ":echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'")
--   \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
--   \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
