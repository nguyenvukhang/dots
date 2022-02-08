#!/bin/zsh

# main variables
START=$REPOS/uni/calc/modules/MA2002/assignments/1

# files to open
open $START/questions.pdf

# start tmux session
tmux new-session -s "uni" -c "$START"

# tmux operations
tmux send -t "uni" "vim" ENTER
tmux send -t "uni" C-f

# switch to tmux session
tmux switch-client -t "uni"
