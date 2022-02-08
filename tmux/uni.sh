#!/bin/zsh

# main variables
START=$REPOS/uni

# start tmux session (detached)
tmux new-session -As "uni" -c "$START"

# switch to tmux session
tmux switch-client -t "uni"
