function! MdxSpecific()
  set ft=markdown
  set tw=70
  function! MarkdownHeadersSetext()
    silent g/^#\s/norm! ^df yypVr=
    silent g/^##\s/norm! ^df yypVr-
  endfunction
  command! MarkdownHeadersSetext :call MarkdownHeadersSetext()
  nnoremap <buffer> <leader>p :Prettier<CR>:MarkdownHeadersSetext<CR>:echo "Prettier + MDX!"<CR>

  " makes word surrounded in backticks
  nnoremap <buffer> <leader>m ciw``<esc>P
  vnoremap <buffer> <leader>m c``<esc>P

  " makes letter become vector: A -> \v{A}
  nnoremap <buffer> <leader>v s\v{}<esc>P

  " makes letter become math'd vector: A -> `\v{A}`
  nnoremap <buffer> <leader>V s`\v{}`<esc>hP
endfunction

function! LatexSpecific()
  set tw=70

  " makes word surrounded in backticks
  nnoremap <buffer> <leader>m ciw$$<esc>P
  vnoremap <buffer> <leader>m c$$<esc>P

  " makes letter become vector: A -> \v{A}
  nnoremap <buffer> <leader>v s\v{}<esc>P

  " makes letter become math'd vector: A -> `\v{A}`
  nnoremap <buffer> <leader>V s$\v{}$<esc>hP
endfunction

aug THE_BREWERY
  au!
  " make splits equally sized on window resize
  au VimResized * wincmd =
  " markdown/mdx handling
  au BufRead,BufNewFile *.mdx call MdxSpecific()
  au BufRead,BufNewFile *.tex call LatexSpecific()
  au BufRead,BufNewFile *.m set ft=matlab
  au BufRead,BufNewFile *.m UltiSnipsAddFiletypes markdown
  " made all /bin/sh files be highlighted as if they were zsh files
	au BufRead,BufNewFile *	if &ft == 'sh' | set ft=zsh | endif
	au BufRead,BufNewFile *.md set tw=70 | set fo-=l
  " temporary clutch
  au BufRead,BufNewFile *.json set fmr={,}
aug END

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
" au VimEnter * call TeleIfEmpty()

command! StanGlyphs :silent! call StanGlyphs()
command! Date :call Date()

