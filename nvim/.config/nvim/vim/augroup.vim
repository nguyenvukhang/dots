" SAFE REMAPS ONLY
" don't put <leader>anything or <C-anything>

fu! __MARKDOWN__()
  set tw=70 ft=markdown
  hi link markdownError Normal
  let b:AutoPairs={'$':'$','(':')','[':']','{':'}',"'":"'",
    \ '"':'"','```':'```','"""':'"""',"'''":"'''","`":"`"}
  " use $ as bounding delimiters, kinda like () and {}
  onoremap <buffer> <silent> i$ :<c-u>normal! T$vt$<cr>
  onoremap <buffer> <silent> a$ :<c-u>normal! F$vf$<cr>
  vnoremap <buffer> i$ T$ot$
  vnoremap <buffer> a$ F$of$
endfu

fu! __LATEX__()
  set tw=70
  let b:AutoPairs={'$':'$','(':')','[':']','{':'}',"'":"'",
    \ '"':'"','```':'```','"""':'"""',"'''":"'''","`":"`"}
endfu

fu! __CPP__()
  let &l:commentstring="// %s"
endfu

aug THE_BREWERY
  au!
  " make splits equally sized on window resize
  au VimResized * wincmd =

  " file extension handling
  au BufRead,BufNewFile *.mdx,*.md call __MARKDOWN__()
  au BufRead,BufNewFile *.cpp,*.h call __CPP__()
  au BufRead,BufNewFile *.tex call __LATEX__()
	au BufRead,BufNewFile *	if &ft == 'sh' | set ft=zsh | endif
aug END
