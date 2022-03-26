function! StatuslineGit()
  let l:is_in_worktree = systemlist("git rev-parse --is-inside-work-tree")[0]
  echom l:is_in_worktree
  if l:is_in_worktree ==# "true"
    let l:branchname = systemlist("git rev-parse --abbrev-ref HEAD")[0]
    return strlen(l:branchname) > 0 ? l:branchname : '_'
  else
    return '_'
  endif
endfunction

set statusline=%t\ %m
set statusline+=\ %{StatuslineGit()}
