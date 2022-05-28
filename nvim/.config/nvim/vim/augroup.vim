" SAFE REMAPS ONLY
" don't put <leader>anything or <C-anything>
" except for file-specific styling <leader>p

fu! ChaChing()
  let b:AutoPairs = copy(g:AutoPairs)
  let b:AutoPairs['$'] = '$'
endf

fu! __MARKDOWN__()
  set tw=70
  hi link markdownError Normal
  hi link xmlError Normal
  call ChaChing()
  " use $ as bounding delimiters, kinda like () and {}
  onoremap <buffer> <silent> i$ :<c-u>normal! T$vt$<cr>
  onoremap <buffer> <silent> a$ :<c-u>normal! F$vf$<cr>
  vnoremap <buffer> i$ T$ot$
  vnoremap <buffer> a$ F$of$
endfu

fu! __LATEX__()
  set tw=70
  call ChaChing()
endfu

fu! __CPP__()
  let &l:commentstring="// %s"
endfu

fu! __JSON__()
  nnoremap <leader>p :silent w<CR>:silent !prettier --write %<CR>
endfu

aug THE_BREWERY
  au!
  " make splits equally sized on window resize
  au VimResized * wincmd =

  " file extension handling
  au BufRead,BufNewFile *.mdx,*.md call __MARKDOWN__()
  au BufRead,BufNewFile *.cpp,*.h call __CPP__()
  au BufRead,BufNewFile *.tex call __LATEX__()
  au BufRead,BufNewFile *.json call __JSON__()
	au BufRead,BufNewFile *	if &ft == 'sh' | set ft=zsh | endif
aug END
