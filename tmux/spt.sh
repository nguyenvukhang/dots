#!/bin/zsh

# start tmux session
tmux new-session -s "spt" "ncspot"

# switch to tmux session
tmux switch-client -t "spt"
