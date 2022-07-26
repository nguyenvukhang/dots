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

function! SynStack()
  if exists("*synstack")
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endif
endfunc

command! UnderMe :call SynStack()
command! StanGlyphs :silent! call StanGlyphs()
command! StripColors :silent! call StripColors()

command! CloseOtherBuffers execute '%bd|e #|norm `"'
