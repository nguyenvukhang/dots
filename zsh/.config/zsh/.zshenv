# this will be ran for every instance of zsh
# particularly, every single zsh script.
# to add, interactive shell environment variables,
# head over to .zshrc

export XDG_CONFIG_HOME=$HOME/.config
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
. "$HOME/.cargo/env"

export DOTS=$HOME/dots
export REPOS=$HOME/repos
