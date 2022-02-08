#!/bin/zsh

# main variables
START=$REPOS/uni

# start tmux session detached (and attach if session exists)
tmux new-session -d -As "uni" -c "$START"

# switch to tmux session
tmux switch-client -t "uni"
