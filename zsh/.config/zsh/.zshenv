SHELL_SESSIONS_DISABLE=1
REPOS=$HOME/repos
ZSH_DOTS=$HOME/.config/zsh
MAPLE=192.168.1.9
BREW=brew@$MAPLE
FZF_OPTS=(--height=7 +m --no-mouse --reverse \
  --no-info --prompt="  " --color='pointer:green')

# exports
export DOTS=$HOME/dots
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export N_PREFIX=$HOME/.local/bin/n
export PREFIX=$HOME/.local/bin/n
export TERM="screen-256color"
# export VIMTEX_OUTPUT_DIRECTORY=$HOME/.local/vimtex

# editor
export EDITOR=nvim
[ $EDITOR = "nvim" ] && export MANPAGER="nvim +Man!"
