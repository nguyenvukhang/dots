aug THE_BREWERY
  au!
  " make splits equally sized on window resize
  au VimResized * wincmd =
  " markdown/mdx handling
  au BufRead,BufNewFile *.mdx set ft=markdown | set tw=70
  au BufRead,BufNewFile *.m UltiSnipsAddFiletypes markdown
  " made all /bin/sh files be highlighted as if they were zsh files
	au BufRead,BufNewFile *	if &ft == 'sh' | set ft=zsh | endif
	au BufRead,BufNewFile *.md set tw=70 | set fo-=l
aug END

function! StanGlyphs()
  %s/“/"/g
  %s/”/"/g
  %s/’/'/g
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
      lua require("brew.telescope.file").cwd()
    endif
  endif
  redraw!
  echo ""
endfunction

" au VimEnter * call TeleIfEmpty()

command! StanGlyphs :silent! call StanGlyphs()
" command! Date :silent! call Date()
command! Date :call Date()
