#!/bin/zsh

# Use tmux session as a shell wrapper.
# Only quitting the base session will exit the terminal emulator.
tmux_loop() {
  ([ $TMUX ] || ! command -v tmux 2>/dev/null) && return
  while; do
    [[ $(tmux new -As z -n editor) == '[detached (from session z)]' ]] && exit
    tmux has -t z && continue || exit
  done
}
export EDITOR=nvim # somehow this export is needed for tmux select to work
if [[ $START_TMUX == true ]]; then
  tmux_loop
fi

# PATH=$HOME/Qt/6.4.2/macos/bin:$PATH
# PATH=$HOME/Qt/Tools/QtInstallerFramework/4.5/bin:$PATH

p() {
  # get a target gpg file
  local res=()
  while IFS= read -r i; do
    [[ $i =~ '^(.*)\.gpg$' ]] && res+=("${match[1]}")
  done < <(fd -e gpg --base-directory $HOME/.password-store)
  local target=$(printf '%s\n' "${res[@]}" | fzf $FZF_OPTS)
  # guard
  [ -z $target ] && echo "nothing selected." && return
  case $1 in
  '')
    local data=$(pass $target) YELLOW='\e[33m' NORMAL='\e[0m'
    # print the second line to stdout
    [[ "$data" = *$'\n'* ]] && echo ${YELLOW}${data#*$'\n'}${NORMAL}
    read -ks "_?Press any key to continue..." && echo
    pass show --clip $target &>/dev/null
    echo 'Copied password to clipboard.'
    ;;
  '--edit' | '-e') pass edit $target ;;
  esac
}
