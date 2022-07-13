local brew = require("brew.core").functions
local harpoon = {
	mark = require("harpoon.mark"),
	ui = require("harpoon.ui"),
}

local noremap = function(mode)
	return function(lhs, rhs, verbose)
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
nnoremap("<C-d>", "13j")
nnoremap("<C-u>", "13k")

-- quickfix list navigation
nnoremap("<C-j>", ":cnext<cr>")
nnoremap("<C-k>", ":cprev<cr>")

-- color columns
nnoremap("<leader>6", ":set colorcolumn=61<cr>")
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
vnoremap("<C-r>", 'y:%s/<C-r>"//g<left><left>', true)

-- reverse (flip) visual lines
vnoremap("<C-f>", "<esc>'<km<'>:'<,.g/^/m '><CR>")

-- search visual selection
vnoremap("*", 'y/<C-r>"<cr>', true)

-- refresh syntax highlighting
nnoremap("<f1>", ":syntax sync fromstart<cr>", true)

-- toggle spell check
nnoremap("<f5>", ":setlocal spell!<cr>:set spell?<cr>", true)

-- vim functions
nnoremap("<leader>x", ":CloseOtherBuffers", true)
nnoremap("<leader>c", ":ColorizerToggle<cr>", true)

-- lua functions
nnoremap("<leader>o", brew.ToggleQuickFix)
nnoremap("<leader>O", brew.ToggleLocalList)
nnoremap("<leader>d", brew.ToggleDiagnostics)

nnoremap("[[", brew.OpenSq)
nnoremap("]]", brew.CloseSq)

local jump = function(n)
	return function()
		print("harpooned to index " .. n .. "/4")
		harpoon.ui.nav_file(n)
	end
end

local add = function()
	harpoon.mark.add_file()
	harpoon.ui.toggle_quick_menu()
	print("added file to harpoon")
end

-- harpoon
nnoremap("<leader>m", harpoon.ui.toggle_quick_menu)
nnoremap("mm", add, true)
nnoremap("<leader>4", jump(4), true)
nnoremap("<leader>3", jump(3), true)
nnoremap("<leader>2", jump(2), true)
nnoremap("<leader>1", jump(1), true)

-- diagnostics
-- nnoremap("E", vim.diagnostic.open_float(), true)
nnoremap("<leader>e", vim.diagnostic.open_float, true)
nnoremap("<leader>p", ":Neoformat<CR>", true)

-- harpoon
-- leader m to mark the file
-- leader a,s,d,f to jump to files
