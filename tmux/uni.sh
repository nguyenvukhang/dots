#!/bin/zsh

# main variables
START=$REPOS/uni

# start tmux session
tmux new-session -s "uni" -c "$START"

# switch to tmux session
tmux switch-client -t "uni"
