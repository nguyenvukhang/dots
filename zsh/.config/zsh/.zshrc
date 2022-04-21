# dependencies
# git, fzf, rg, fd, nvim (placed at ~/.local/bin/nvim), git number

# reference
# https://zsh.sourceforge.io/Intro/intro_3.html

# =====================
# ENVIRONMENT VARIABLES
# =====================

# for installed software
export HISTFILE=$ZDOTDIR/.zsh_history
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export N_PREFIX=$HOME/.local/bin/n
export PYENV_ROOT=$HOME/.local/src/pyenv
export TERM="screen-256color"

export FZF_OPTS=(--height=7 +m --no-mouse --reverse \
  --no-info --prompt="  " --color='pointer:green,header:white')

# editor
export EDITOR=nvim
export LESSHISTFILE=-
[ $EDITOR = "nvim" ] && export MANPAGER="nvim +Man!"

# for my own scripts
export DOTS=$HOME/dots
export REPOS=$HOME/repos

# =============
# SHELL OPTIONS
# =============

setopt ignoreeof # prevents <C-d> from quitting the shell
unsetopt BEEP # prevents beeps in general
SHELL_SESSIONS_DISABLE=1

# =============
# BUILDING PATH
# =============
PATH=$N_PREFIX/bin:$PATH
PATH=$HOME/.jenv/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.local/bin/git:$PATH
PATH=$HOME/.yarn/bin:$PATH
PATH=$HOME/.local/src/lua-language-server/bin:$PATH
# android build tools
PATH=$HOME/Library/Android/sdk/build-tools/32.0.0:$PATH
export PATH

# ==============
# THE REAL ZSHRC
# ==============

source $ZDOTDIR/init
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
