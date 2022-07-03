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

function! Graph()
  echo "hello"

  %s/X_1T/X₁/g
  %s/X_2T/X₂/g
  %s/X_3T/X₃/g
  %s/X_4T/X₄/g
  %s/X_5T/X₅/g
  %s/X_6T/X₆/g

  %s/Y_1T/Y₁/g
  %s/Y_2T/Y₂/g
  %s/Y_3T/Y₃/g
  %s/Y_4T/Y₄/g
  %s/Y_5T/Y₅/g
  %s/Y_6T/Y₆/g

  %s/Y_0/Y₀/g
  %s/Y_1/Y₁/g
  %s/Y_2/Y₂/g
  %s/Y_3/Y₃/g
  %s/Y_4/Y₄/g
  %s/Y_5/Y₅/g
  %s/Y_6/Y₆/g
  %s/Y_7/Y₇/g
  %s/Y_8/Y₈/g
  %s/Y_9/Y₉/g
  %s/___/→/g
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
command! Graph :call Graph()
" command! Date :call Date()

command! CloseOtherBuffers execute '%bd|e #|norm `"'
