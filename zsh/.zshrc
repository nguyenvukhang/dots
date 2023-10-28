PROMPT_ARROW=${PROMPT_ARROW-[uwu] >}
START_TMUX=true

[ -z $FD_BIN ] && FD_BIN=fd
alias fd="$FD_BIN --hidden"
alias rg="rg --hidden"

# ////////////////////////////////////////////////////////////////////

# cargo (rust)
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

# opam (OCaml)
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh >/dev/null 2>/dev/null

has() {
  command -v $1 >/dev/null
}

# exports
export UNI=$HOME/uni
export SHELL_SESSIONS_DISABLE=1 # remove ~/.zsh_sessions

# locale standardize
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export EDITOR=nvim
export REPOS=$HOME/repos
export GITNU_DEBUG=1

# Use tmux session as a shell wrapper.
# Only quitting the base session will exit the terminal emulator.
tmux_loop() {
  ([[ $START_TMUX != true ]] || [ $TMUX ] || ! command -v tmux 2>/dev/null) && return
  while; do
    [[ $(tmux new -As z -n editor) == '[detached (from session z)]' ]] && exit
    tmux has -t z && continue || exit
  done
}
tmux_loop

unsetopt BEEP       # prevents beeps in general
setopt IGNOREEOF    # prevents <C-d> from quitting the shell
setopt GLOBDOTS     # include hidden dir tab complete
setopt PROMPT_SUBST # enable scriptig in the prompt

prompt_git() {
  local B=$(git branch --show-current 2>/dev/null)
  [ -z $B ] && return
  local R=$(git config --get remote.origin.url 2>/dev/null)
  R=${R#*/}
  [[ $R =~ '^(.*)\.git$' ]] &&
    echo "%F{241}(%F{246}${match[1]}%F{241}/$B)" ||
    echo "%F{241}($B)"
}

PROMPT=$'%F{blue}%~ $(prompt_git)%f\n%(?.%F{green}${PROMPT_ARROW} %f.%F{red}${PROMPT_ARROW} %f)'
PROMPT=$'%F{blue}%~ $(prompt_git)%f\n%(?.%F{green}%M > %f.%F{red}%M > %f)'
PROMPT=$'%F{blue}%~ $(prompt_git)%f\n%(?.%F{green}> %f.%F{red}> %f)'

export FZF_DEFAULT_OPTS="--height=7 +m --no-mouse --reverse --no-info --prompt='  '"

# use neovim as manpager
[ "$EDITOR" = "nvim" ] && export MANPAGER="nvim +Man!"

PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.yarn/bin:$PATH
PATH=$HOMEBREW_PREFIX/anaconda3/bin/:$PATH
PATH=$HOMEBREW_PREFIX/opt/node@16/bin:$PATH # node@16 via brew
export PATH

has git-nu && GIT=git-nu || GIT=git

alias gs="$GIT status"
alias ga="$GIT add"
alias gaa="$GIT add -A"
alias gb="$GIT branch"
alias gc="$GIT commit"
alias gcan="$GIT commit --amend --no-edit"
alias gcn="$GIT clean -fxd -e 'node_modules' -e 'target/' -e '*.env'"
alias gcnn="$GIT clean -fxd"
alias gd="$GIT diff"
alias gds="$GIT diff --staged"
alias gf="$GIT fetch"
alias gm="$GIT merge"
alias gmn="$GIT merge --no-ff"
alias gms="$GIT merge --squash"
alias gpdo="$GIT push -d origin"
alias gr="$GIT reset"
alias grh="$GIT reset --hard"
alias grpo="$GIT remote prune origin"
alias gt="$GIT tag"
alias giti="$EDITOR .gitignore"
alias gitm="$EDITOR .gitmodules"

# git preview (quickly open files by number)
gp() {
  # macOS-only
  $GIT ls-files $@ | tr \\n \\0 | xargs -0 $EDITOR

  # gnu xargs only
  # $GIT ls-files $@ | xargs -d '\n' $EDITOR
}

# if it's already checked out somewhere, go there, else:
# if there's a worktree whose directory matches the query, go there
gco() {
  # do nothing if it exits ok on default command
  X=$($GIT checkout $@ 2>&1) && echo "$X" && return

  # do nothing if it's not in a git repository
  [[ $X == 'fatal: not a git repository'* ]] && echo "$X" && return

  # first match: absolute path to existing worktree
  if [[ $X =~ ^fatal:.*is\ already\ checked\ out\ at\ \'(.*)\'$ ]]; then
    printf "\e[30m* \e[32m${1}\e[30m (Already checked out)\e[0m\n"
    cd ${match[1]}
    return
  fi

  local TARGET_DIR= TARGET_BRANCH= LINE_DIR= LINE_BRANCH=

  # Iterate over worktree directories. Only look for directory matches
  # here. If there were branch matches they would have been caught
  # earlier already.
  while IFS= read -r line; do
    if [[ $line =~ ^worktree\ (.*)$ ]]; then
      if [[ "${line##*/}" == $1 ]]; then
        printf "\e[30m* \e[32m${1}\e[30m (worktree --list)\e[0m\n"
        cd ${match[1]} && return
      fi
    fi
  done < <(git worktree list --porcelain)

  # nowhere to jump
  echo $X
}

# git worktree navigation, by directory name
gw() {
  while IFS= read -r line; do
    # if line begins with 'worktree', use it to set dir and base
    if [[ $line =~ '^worktree (.*)$' ]]; then
      dir=${match[1]}
      base=${line##*/}
      [[ $base == $1 ]] && cd $dir
    fi
  done < <(git worktree list --porcelain)
}

# git clone
#
# USAGE:
# gcl git@github.com:neovim/neovim.git
# gcl https://github.com/neovim/neovim.git
# gcl neovim/neovim
gcl() {
  local repo="${@: -1}" other_args=(${@:1:-1}) url
  if [[ $repo =~ '^(https://.*/.*|git@.*:.*)/' ]]; then
    url=$repo
  elif [[ $repo =~ '^(.*)/(.*)$' ]]; then
    url=git@github.com:${match[1]}/${match[2]}.git
  fi
  [ -z $url ] && echo "Unable to parse requested repo." && return 1
  git clone $other_args $url
}

# git clone --bare
#
# USAGE:
# see gcl() USAGE
gcb() {
  gcl --bare $1
}

# git logs
_gl() {
  local i=$(($LINES / 2 > 10 ? $LINES / 2 : 10))
  while IFS= read -r line; do
    printf "$line\e[0m\n" && let i--
    [[ $i -eq 0 ]] && break
  done < <(git -c 'color.ui=always' log --pretty=k --graph $@)
  return 0
}
gl() {
  _gl -n ${1-$LINES}
}
gla() {
  _gl --all -n ${1-$LINES}
}
gll() {
  git log --graph --pretty=k --all
}
mongl() {
  for j in {1..120}; do
    clear && gla ${1-$LINES} && sleep 1
  done
}

# git search log
gsl() {
  git log --all --pretty=s --color=always |
    fzf --height=${1-7} --ansi -m --bind 'enter:select-all+accept'
}

# git search log (with filenames) and open in editor
gslf() {
  git log --all --pretty=s --compact-summary | $EDITOR -
}

# git commit
gcm() {
  if [ $1 ]; then
    git commit -m $1
  else
    git commit
  fi
}

# git commit --amend
gca() {
  if [ $1 ]; then
    git commit --amend -m $1
  else
    git commit --amend
  fi
}

yeet() {
  if [ $TMUX ]; then
    echo "Using tmux to push..."
    local CMD="echo 'pushing...'; git push $@; sleep 2"
    tmux split-window -dv -l 5 "sh -c '$CMD'"
  else
    echo "Regular push..."
    git push $@
  fi
}

# alt way (derived):
# 1. rm -rf a/submodule
# 2. git submodule deinit -f -- a/submodule
# 3. rm -rf .git/modules/a/submodule
# 4. git rm -f a/submodule

# remove a secrets file from all git history:
# [https://stackoverflow.com/questions/43762338/how-to-remove-file-from-git-history]
# git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch path_to_file" HEAD

ed() {
  local t
  case $1 in
  a) t="$DOTS/@/alacritty/alacritty.yml" ;;
  g) t="$DOTS/@/git/config" ;;
  k) t="$DOTS/@/kitty/kitty.conf" ;;
  s) t="$HOME/.ssh/config" ;;
  t) t="$DOTS/tmux/tmux.conf" ;;
  u) t="$UNI_LAUNCH" ;;
  v) t="$DOTS/nvim/init.lua" ;;
  z) t="$DOTS/zsh/.zshrc" ;;
  ze) t="$ZSHENV_PATH" ;;
  esac
  [ $t ] && $EDITOR $t || echo "nothing happened."
}

alias 2A="cd /Applications"
alias 2c="cd $HOME/.config"
alias 2ca="cd $HOME/.cache"
alias 2d="cd $DOTS"
alias 2f="cd $HOME/files"
alias 2h="cd $HOMEBREW_PREFIX"
alias 2i="cd '$HOME/Library/Mobile Documents/com~apple~CloudDocs'"
alias 2j="cd $HOME/Downloads"
alias 2k="cd $HOME/repos/log"
alias 2l="cd $HOME/.local"
alias 2lb="cd $HOME/.local/bin"
alias 2ls="cd $HOME/.local/src"
alias 2m="cd $REPOS/math"
alias 2mc="cd '$HOME/Library/Application Support/PrismLauncher/instances'"
alias 2n="cd $REPOS/notes"
alias 2o="cd $HOME/repos"
alias 2or="cd $HOME/other-repos"
alias 2p="cd $DOTS/personal"
alias 2u="cd $UNI"
alias 2v="cd $DOTS/nvim"
alias 2z="cd $DOTS/zsh"

alias o="cd .." # out
alias b="cd -"  # back

2r() { # go to git root
  cd $(git rev-parse --show-toplevel)
}

if has exa; then
  EXA_OPTS=(--group-directories-first -s Name -I '.DS_Store')
  alias ls="exa -a $EXA_OPTS"
  alias lss="exa -a --tree -L 2 $EXA_OPTS"
  alias lsss="exa -a --tree -L 3 $EXA_OPTS"
  alias ll="exa -lag $EXA_OPTS"
else
  alias ls="ls -A --color=auto"
  alias ll="ls -lAg --color=auto"
fi

# g for jump (requires fd and fzf)
g() {
  [[ ! $(command ls -Ap) = *"/"* ]] && return # end if no child dir
  local FD_ARGS=(-HI -d ${1-4} -t d -E '.git' -E 'node_modules')
  local FZF=(--height=7 +m --no-mouse --reverse --no-info
    --prompt='  ' --header=${PWD/$HOME/'~'} --expect 'esc,left,enter,right')
  [[ $($FD_BIN $FD_ARGS | fzf $FZF) =~ '^(.*)'$'\n''(.*)$' ]]
  case ${match[1]} in
  left) cd .. && g ;;
  enter) [ ${match[2]} ] && cd ${match[2]} ;;
  right) [ ${match[2]} ] && cd ${match[2]} && g ;;
  esac
}

# pdfgrep with nice setup
pd() {
  pdfgrep --with-filename --page-number $@ -- **/*.pdf
}

# run a command in a loop
mon() {
  while; do
    clear
    echo "-> $PWD" && $@
    sleep 1
  done
}

alias ct="printf '\033[2J\033[3J\033[1;1H'" # clear terminal
alias zr="exec $SHELL -l"                   # reloads shell
alias ka="killall"
alias py=python3
alias si="$EDITOR .stow-local-ignore"
alias vim=nvim

# vim() {
#   if [ $1 ]; then
#     $EDITOR $@
#   else
#     local SELECT=$($FD_BIN -t f | fzf)
#     [ $SELECT ] && $EDITOR $SELECT
#   fi
# }

# yarn
alias yb="yarn build"
alias yl="yarn lint"
alias yd="yarn dev"
alias mk="make"
alias qmk_setup="qmk setup -H ./qmk_firmware nguyenvukhang/qmk_firmware"
alias clangf="cp $DOTS/zsh/.clang-format ."
alias jup="jupyter lab --app-dir $HOMEBREW_PREFIX/share/jupyter/lab"

# binds
bindkey "^[[3~" delete-char
bindkey '^[[Z' reverse-menu-complete

# uni
t() {
  if [ -f run ]; then
    ./run $@
  elif [ -f run.py ]; then
    python run.py $@
  elif [ -f Makefile ]; then
    make $@
  elif [ -f Cargo.toml ]; then
    cargo run $@
  elif [ -f package.json ]; then
    yarn dev
  fi
}

# clears jdtls (nvim) cache
jclear() {
  rm -rf $HOME/.cache/nvim/jdtls
  mkdir -p $HOME/.cache/nvim/jdtls
}

# file opener
view() {
  local x=$($FD_BIN -tf -tl | fzf)
  [ $x ] && open "$x"
}

tm() {
  [ $TMUX ] && local a=switch || local a=a
  case $1 in
  ls) tmux $@ ;;
  -d) tmux detach ;;
  -k)
    shift
    [ $1 ] || set -- $(tmux ls | fzf -0 $FZF_OPTS)
    [ $1 ] && tmux kill-session -t $1
    ;;
  '')
    local S=$(tmux ls 2>/dev/null)
    if [ -z $S ]; then
      tmux new -s 0
    else
      S=$(printf $S | fzf $FZF_OPTS)
      [ $S ] && tmux $a -t ${S%%:*}
    fi
    ;;
  *)
    tmux has -t $1 2>/dev/null || tmux new -ds $1
    tmux $a -t $1
    ;;
  esac
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/khang/.local/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/Users/khang/.local/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/khang/.local/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="/Users/khang/.local/miniconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<

ca() {
  case $1 in
  -d) conda deactivate ;;
  ml) conda activate $1 ;;
  *)
    echo 'Defaulting to: [ml]'
    ca ml
    ;;
  esac
}

# killing Goodnotes

kgn() {
  PS=$(ps x | grep Goodnotes | grep -v grep)
  PS=${PS%% *}
  if [ $PS ]; then
    echo "Killing $PS"
    kill $PS
  else
    echo "No matching process found"
  fi
}
