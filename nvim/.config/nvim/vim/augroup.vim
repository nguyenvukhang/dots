function! __MARKDOWN__()
  set ft=markdown
  set tw=70

  " makes word surrounded in $$
  " nnoremap <buffer> <leader>m ciw$$<esc>P
  " vnoremap <buffer> <leader>m c$$<esc>P

  " letter to vector: A -> \v{A}
  nnoremap <buffer> <leader>v s\v{}<esc>P

  " letter to math'd vector: A -> $\v{A}$
  nnoremap <buffer> <leader>V s$\v{}$<esc>hP

  " use $ as bounding delimiters, kinda like () and {}
  onoremap <buffer> <silent> i$ :<c-u>normal! T$vt$<cr>
  onoremap <buffer> <silent> a$ :<c-u>normal! F$vf$<cr>
  vnoremap <buffer> i$ T$ot$
  vnoremap <buffer> a$ F$of$

  lua vim.api.nvim_buf_set_option(0, "commentstring", "{/* %s */}")
  hi link markdownError Normal
  let b:AutoPairs={'$':'$','(':')','[':']','{':'}',"'":"'",'"':'"','```':'```','"""':'"""',"'''":"'''","`":"`"}
endfunction

function! __LATEX__()
  set tw=70

  " makes word surrounded in backticks
  nnoremap <buffer> <leader>m ciw$$<esc>P
  vnoremap <buffer> <leader>m c$$<esc>P

  " makes letter become vector: A -> \v{A}
  nnoremap <buffer> <leader>v s\v{}<esc>P

  " makes letter become math'd vector: A -> `\v{A}`
  nnoremap <buffer> <leader>V s$\v{}$<esc>hP
  let b:AutoPairs={'$':'$','(':')','[':']','{':'}',"'":"'",'"':'"','```':'```','"""':'"""',"'''":"'''","`":"`"}
endfunction

function! __CPP__()
  lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
  set tw=69
endfunction

aug THE_BREWERY
  au!
  " make splits equally sized on window resize
  au VimResized * wincmd =

  " file extension handling
  au BufRead,BufNewFile *.mdx,*.md call __MARKDOWN__()
  au BufRead,BufNewFile *.tex call __LATEX__()
  au BufRead,BufNewFile *.cpp,*.h call __CPP__()
  " au BufRead,BufNewFile *.m UltiSnipsAddFiletypes markdown

  " /bin/sh files highlighted as if they were zsh files
	au BufRead,BufNewFile *	if &ft == 'sh' | set ft=zsh | endif
aug END
