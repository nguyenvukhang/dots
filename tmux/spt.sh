#!/bin/zsh

# start tmux session (detached)
tmux new-session -As "spt" -d -n "spotify" "ncspot"

# switch to tmux session
tmux switch-client -t "spt"
