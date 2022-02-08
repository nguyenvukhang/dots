# dependencies
# git, fzf, rg, fd, nvim (placed at ~/.local/bin/nvim), git number

# reference
# https://zsh.sourceforge.io/Intro/intro_3.html

source $ZSH_DOTS/init
source $ZSH_DOTS/prompt
source $ZSH_DOTS/ls
source $ZSH_DOTS/edits
source $ZSH_DOTS/git
source $ZSH_DOTS/jump
source $ZSH_DOTS/nav
source $ZSH_DOTS/one-liners
source $ZSH_DOTS/tmux
source $ZSH_DOTS/pass
source $ZSH_DOTS/sessions

# zsh stuff
export HISTFILE=$ZDOTDIR/.zsh_history

PATH=$N_PREFIX/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.local/bin/git:$PATH
PATH=$HOME/.yarn/bin:$PATH
export PATH

setopt ignoreeof

alias luamake=/Users/khang/.local/src/lua-language-server/3rd/luamake/luamake

# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#   tmux new -As base
# fi
