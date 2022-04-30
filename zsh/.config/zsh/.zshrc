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

# auto start tmux
START_TMUX=false
if [ "$START_TMUX" = true ] && command -v tmux &>/dev/null && [ -n "$PS1" ] \
  && [[ ! "$TERM" =~ tmux ]] \
  && [ -z "$TMUX" ]; then
  exec tmux new-session -As base -n stalia
fi

tsm # tmux session manager
