function! StanGlyphs()
  %s/“/"/g
  %s/”/"/g
  %s/’/'/g
  %s/‘/'/g
endfunction

" function! Date()
"   let l:filename = expand("%:t")
"   if l:filename ==# "notes.yml"
"     put =strftime('- date: %Y/%m/%d %H:%M')
"   elseif l:filename ==# "log.yml"
"     put =strftime('%b %d')
"   endif
" endfunction

" function TeleIfEmpty()
"   if @% == ""
"     echo "Tele? "
"     let c = getchar()
"     if c == char2nr("\<CR>")
"       lua require('brew.telescope.file').cwd()
"     endif
"   endif
"   redraw!
"   echo ""
" endfunction

command! StanGlyphs :silent! call StanGlyphs()
" command! Date :call Date()

command! CloseOtherBuffers execute '%bd|e #|norm `"'
