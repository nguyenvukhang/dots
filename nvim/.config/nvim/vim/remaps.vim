" no-ops
nnoremap <space> <nop>
nnoremap <bs> <nop>
nnoremap Q <nop>
nnoremap K <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>

" set leader to <space>
let mapleader = ' '

" on-the-go reload vimrc
" nnoremap <leader><cr> :so $MYVIMRC<cr>

" the only right way to setup H and L
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

" open file under cursor in a split
nnoremap gF :vs <cfile><cr>

" slowly increase this until I can use the default
nnoremap <C-d> 12jzz
nnoremap <C-u> 12kzz

" quickfix list navigation
nnoremap <silent> <C-j> :cnext<cr>
nnoremap <silent> <C-k> :cprev<cr>

" color columns
nnoremap <leader>7 :set colorcolumn=71<cr>
nnoremap <leader>8 :set colorcolumn=81<cr>

" yank to clipboard (confirmed to work on mac)
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" split jumping
nnoremap <leader>h :wincmd h<cr>
nnoremap <leader>l :wincmd l<cr>
nnoremap <leader>j :wincmd j<cr>
nnoremap <leader>k :wincmd k<cr>

" replace in buffer
nnoremap <leader>rb yiw:%s/<C-r>"//g<left><left>

" replace in line
nnoremap <leader>rl yiw:s/<C-r>"//g<left><left>

" replace visual selection
vnoremap <C-s> y:%s/<C-r>"//g<left><left>

" reverse visual lines
vnoremap <C-r> <esc>'<km<'>:'<,.g/^/m '><CR>

" search visual selection
vnoremap * y/<C-r>"<cr>

" refresh syntax highlighting
nnoremap <f1> :syntax sync fromstart<cr>

" toggle spell check
nnoremap <f5> :setlocal spell!<cr>:set spell?<cr>

" vim functions
command! CloseOtherBuffers execute '%bd|e #|norm `"'
nnoremap <leader>x :CloseOtherBuffers
nnoremap <leader>c :ColorizerToggle<cr>
nnoremap <leader>P :Prettier<cr>

" lua functions
nnoremap <silent> <leader>t :lua require('brew.core').functions.Todolist()<cr>
nnoremap <silent> <leader>o :lua require('brew.core').functions.ToggleQuickFix()<cr>
nnoremap <silent> <leader>O :lua require('brew.core').functions.ToggleLocalList()<cr>
nnoremap <silent> <leader>d :lua require('brew.diagnostics').diagnostics()<cr>

" complete the trio of [{, [[, [(
nnoremap <silent> [[ :call searchpair('\[', '', '\]', 'b')<cr>
nnoremap <silent> ]] :call searchpair('\[', '', '\]')<cr>

" harpoon
nnoremap <silent> <C-h> :lua require("harpoon.ui").toggle_quick_menu()<cr>
