#!/bin/zsh

# main variables
START=$REPOS/uni/calc/modules/MA2002/assignments/1

# files to open
open $START/questions.pdf

# start tmux session detached (and attach if session exists)
tmux new-session -d -As "uni" -c "$START" \
  "git log --oneline --graph --all -n 10; exec zsh -i"

# tmux operations
tmux send -t "uni" "vim" ENTER
tmux send -t "uni" C-f

# switch to tmux session
tmux switch-client -t "uni"
