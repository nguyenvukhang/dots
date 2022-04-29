function! StanGlyphs()
  %s/“/"/g
  %s/”/"/g
  %s/’/'/g
  %s/‘/'/g
endfunction

function! Date()
  let l:filename = expand("%:t")
  if l:filename ==# "notes.yml"
    put =strftime('- date: %Y/%m/%d %H:%M')
  elseif l:filename ==# "log.yml"
    put =strftime('%b %d')
  endif
endfunction

function TeleIfEmpty()
  if @% == ""
    echo "Tele? "
    let c = getchar()
    if c == char2nr("\<CR>")
      lua require('brew.telescope.file').cwd()
    endif
  endif
  redraw!
  echo ""
endfunction

command! StanGlyphs :silent! call StanGlyphs()
command! Date :call Date()

" show highlight group of char under cursor
" nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"   \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"   \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
