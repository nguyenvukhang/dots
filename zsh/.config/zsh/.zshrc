# mac problems (required for every single cli tool installed by brew)
[ -f /opt/homebrew/bin/brew ] \
  && eval "$(/opt/homebrew/bin/brew shellenv)"

# dependencies
# git, fzf, rg, fd, nvim (placed at ~/.local/bin/nvim), git number

# reference
# https://zsh.sourceforge.io/Intro/intro_3.html

# .............................................. environment variables
#
# (to only be used in $ZDOTDIR)

# for installed software
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export N_PREFIX=$HOME/.local/bin/n
export PYENV_ROOT=$HOME/.local/src/pyenv
export TERM="screen-256color"

FZF_OPTS=(--height=7 +m --no-mouse --reverse \
  --no-info --prompt="  " --color='pointer:green,header:white')

# editor
export EDITOR=nvim
export LESSHISTFILE=-
[ $EDITOR = "nvim" ] && export MANPAGER="nvim +Man!"

# for my own scripts
export DOTS=$HOME/dots
export REPOS=$HOME/repos

# ...................................................... shell options

unsetopt BEEP # prevents beeps in general
setopt ignoreeof # prevents <C-d> from quitting the shell
setopt globdots # include hidden dir tab complete
SHELL_SESSIONS_DISABLE=1
# SAVEHIST=0
# HISTSIZE=0
HISTFILE=$ZDOTDIR/.history

# ............................................................... path

GOPATH=$HOME/go/bin
PATH=$HOME/.jenv/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.local/bin/git:$PATH
PATH=$HOME/.yarn/bin:$PATH
PATH=$HOME/.local/src/lua-language-server/bin:$PATH
# android build tools
PATH=$HOME/Library/Android/sdk/build-tools/32.0.0:$PATH
PATH=$HOME/.cargo/bin:$PATH
PATH=$GOPATH:$PATH
export PATH

# .......................................................... functions

source $ZDOTDIR/prompt
source $ZDOTDIR/ls
source $ZDOTDIR/edits
source $ZDOTDIR/git
source $ZDOTDIR/uni
source $ZDOTDIR/jump
source $ZDOTDIR/nav
source $ZDOTDIR/one-liners
source $ZDOTDIR/tmux
source $ZDOTDIR/pass

# ............................................... tmux session manager

# auto start tmux
START_TMUX=false
if [ "$START_TMUX" = true ] && command -v tmux &>/dev/null && [ -n "$PS1" ] \
  && [[ ! "$TERM" =~ tmux ]] \
  && [ -z "$TMUX" ]; then
  exec tmux new-session -As base -n stalia
fi

# clear the tsm log
# tsm # tmux session manager

LOGFILE="$ZDOTDIR/tmux_session_log.txt"

tsm_log() {
  local timestamp=$(date '+%R:%S')
  echo "$timestamp: $@">>$LOGFILE
}

# tmux session manager:
# use tmux [base] session in the place of a terminal
# ──────────────────────────────────────────────────────────
# Default terminal behavior:
#   exit shell  -> close GUI window
#   exit tmux   -> go back to shell
#   detach tmux -> go back to shell, keep tmux
# ──────────────────────────────────────────────────────────
# tmux [base] as terminal:
#   exit [base]       -> close GUI window
#   exit [non-base]   -> go back to [base]
#   detach [non-base] -> go back to [base], keep [non-base]
#   *** added feature ***
#   detach [base]     -> close GUI window, keep [base]
# ──────────────────────────────────────────────────────────
# TODO: implement exit [non-base] -> go back to [base]
# current behavior: exit [non-base] -> go back to [base],
#                   but only if [base] is still running
# exiting the last remaining session in tmux enters a state
# that is not differentiable. You can't tell what was the
# previously exited session name (not from tmux exit codes)

tmux_loop() {
  ! command -v tmux &> /dev/null && return 0
  [[ $RUN_TMUX != "true" ]] && return 0
  [ $TMUX ] && return 0

  tsm_log "entering tmux loop"
  while; do
    tsm_log "open tmux"
    local EXITCODE=$(exec tmux new-session -As base -n stalia)
    tsm_log "exit tmux:\n$EXITCODE"
    [[ "$EXITCODE" == "[detached (from session base)]" ]] && exit 0
    tmux has-session -t base 2> /dev/null && continue
    exit 0
  done
}

RUN_TMUX=true
tmux_loop
