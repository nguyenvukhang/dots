#!/bin/zsh

# start tmux session detached (and attach if session exists)
tmux new-session -d -As "uni" -c "$START" \
  "git log --oneline --graph --all -n 10; exec zsh -i"

# switch to tmux session
tmux switch-client -t "uni"
