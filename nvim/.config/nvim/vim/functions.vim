function! StanGlyphs()
  %s/“/"/g
  %s/”/"/g
  %s/’/'/g
  %s/‘/'/g
endfunction

function! StripColors()
  %s/\[30m//g
  %s/\[31m//g
  %s/\[32m//g
  %s/\[33m//g
  %s/\[34m//g
  %s/\[35m//g
  %s/\[36m//g
  %s/\[37m//g
  %s/\[38m//g
  %s/\[39m//g
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

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! UnderMe :call SynStack()
command! StanGlyphs :silent! call StanGlyphs()
command! StripColors :silent! call StripColors()
" command! Date :call Date()

command! CloseOtherBuffers execute '%bd|e #|norm `"'
