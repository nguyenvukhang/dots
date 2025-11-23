# Khang's zshrc
#
# zsh docs on conditionals: https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html

# Sources $1 if it exists.
source_if_exists() {
  if [ -r $1 ]; then # `-r` flag checks if file exists and is readable by current process.
    source $1 >/dev/null 2>/dev/null
  fi
}

# Checks if $1 exists as a binary, while printing nothing to stdout.
binary_exists() {
  command -v $1 >/dev/null
}

# If $1 exists as a directory, append it to $PATH (without exporting).
prepend_to_path_if_exists() {
  if [ -d "$1" ]; then
    PATH="$1":$PATH
  fi
}

source_if_exists $HOME/.cargo/env               # cargo (rust)
source_if_exists $HOME/.opam/opam-init/init.zsh # opam (OCaml)
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

#  ///////////////////////////////////////////////////////////////////
# // Shell environment variables.

# special directories
export UNI=$HOME/uni REPOS=$HOME/repos DOTS=$HOME/dots

export PYTHONPYCACHEPREFIX=/tmp/pycache        # bye __pycache__
export LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 # locale standardize
export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8   # locale standardize
export SHELL_SESSIONS_DISABLE=1                # remove ~/.zsh_sessions
export LESSCHARSET=utf-8                       # `less` to show unicode chars

export FZF_DEFAULT_OPTS="--height=7 +m --no-mouse --reverse --no-info --prompt='  ' --no-separator"

if binary_exists nvim; then
  export EDITOR=nvim
  export MANPAGER="nvim +Man!" # use neovim as manpager
else
  export MANPAGER=
fi

if [ -d "$HOME/.local/n" ]; then
  export N_PREFIX="$HOME/.local/n"
  [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

#  Setting $PATH

PATH=$HOME/.local/bin:/usr/local/bin:$PATH
prepend_to_path_if_exists /usr/lib/wsl/lib
prepend_to_path_if_exists $HOME/.local/luals/bin
prepend_to_path_if_exists /usr/local/cuda/bin
prepend_to_path_if_exists $HOME/.elan/bin
prepend_to_path_if_exists /usr/local/go/bin
prepend_to_path_if_exists $HOME/.local/go/bin
prepend_to_path_if_exists $HOME/go/bin
# prepend_to_path_if_exists $HOME/.local/alatty/bin
prepend_to_path_if_exists $HOME/.jenv/bin
prepend_to_path_if_exists $HOMEBREW_PREFIX/opt/ruby/bin
prepend_to_path_if_exists $HOMEBREW_PREFIX/opt/swift/bin
prepend_to_path_if_exists $HOMEBREW_PREFIX/bin
prepend_to_path_if_exists $HOME/.zvm/bin
prepend_to_path_if_exists $HOME/.local/zig
prepend_to_path_if_exists $HOME/.local/texlive/texdir/bin/x86_64-linux
export PATH

#  ///////////////////////////////////////////////////////////////////
# // Shell options.

unsetopt BEEP       # prevents beeps in general
setopt IGNOREEOF    # prevents <C-d> from quitting the shell
setopt GLOBDOTS     # include hidden dir tab complete
setopt PROMPT_SUBST # enable scriptig in the prompt

bindkey "^[[3~" delete-char          # binds delete to delete
bindkey '^[[Z' reverse-menu-complete # binds shift+tab to going to the previous tab-complete suggestion

#  ///////////////////////////////////////////////////////////////////
# // Shell prompt.

# Show a pretty summary of the git situation in CWD.
prompt_git() {
  local B=$(git branch --show-current 2>/dev/null)
  [ -z $B ] && return
  local R=$(git config --get remote.origin.url 2>/dev/null)
  [[ ${R##*/} =~ '^(.*)\.git$' ]] &&
    echo "%F{241}(%F{246}${match[1]}%F{241}/$B)" ||
    echo "%F{241}($B)"
}
PROMPT_ARROW='>'
PROMPT=$'%F{blue}%~ $(prompt_git)%f\n%(?.%F{green}${PROMPT_ARROW} %f.%F{red}${PROMPT_ARROW} %f)'

#  ///////////////////////////////////////////////////////////////////
# // Git aliases.

# {{{ Git shenanigans
binary_exists git-nu && GIT=git-nu || GIT=git

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
alias grs="$GIT reset --soft"
alias grpo="$GIT remote prune origin"
alias giti="$EDITOR .gitignore"
alias gitm="$EDITOR .gitmodules"
# alias gt="$GIT tag"
# alias gsn="$GIT show --name-status"

# to get remote branches on bare checkouts, run
# git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# "git move branch". Moves $1 to HEAD.
gmb() {
  local OUTPUT=$(git branch -f $1 HEAD 2>&1 >/dev/null)
  if [[ $OUTPUT == *'used by worktree'* ]]; then
    OUTPUT=$(git rev-parse HEAD)
    gco $1
    git reset --hard $OUTPUT
  else
    git checkout $1
  fi
}

# git preview (quickly open files by number)
gp() {
  [ $1 ] && $EDITOR $($GIT ls-files --deduplicate $@)
}

# if it's already checked out somewhere, go there, else:
# if there's a worktree whose directory matches the query, go there
gco() {
  # do nothing if it exits ok on default command
  X=$($GIT checkout $@ 2>&1) && echo "$X" && return

  # do nothing if it's not in a git repository
  [[ $X == 'fatal: not a git repository'* ]] && echo "$X" && return

  # do nothing if git status is unclean
  [[ $X == 'error: Your local changes t'* ]] && echo "$X" && return

  # first match: absolute path to existing worktree
  if [[ $X =~ ^fatal:.*is\ already\ checked\ out\ at\ \'(.*)\'$ ]]; then
    printf "\e[30m* \e[32m${1}\e[30m (Already checked out)\e[0m\n"
    cd ${match[1]}
    return
  elif [[ $X =~ ^fatal:.*is\ already\ used\ by\ worktree\ at\ \'(.*)\'$ ]]; then
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

# git logs
if binary_exists git-ln; then
  # unbounded lists
  alias gll='git ln' glal='git ln --all'
  alias gl='git ln --bound'
  alias gla='git ln --all --bound'
else
  local fmt='%C(yellow)%h%C(auto)%d %Creset%s %C(241)(%C(246)%ar%C(241))'
  alias gll='git log --graph --pretty=k' glal='gll --all'
  gl() {
    local n=${1-$(($LINES < 16 ? 10 : $LINES * 3 / 5))}
    [ $1 ] && shift
    git log --graph --pretty=$fmt -n $n $@
  }
  gla() {
    local n=${1-$(($LINES < 16 ? 10 : $LINES * 3 / 5))}
    [ $1 ] && shift
    git log --graph --pretty=$fmt --all -n $n $@
  }
fi

mongl() {
  for j in {1..120}; do
    clear && gla ${1-$LINES} && sleep 1
  done
}

# git search log
gsl() {
  git log --all --pretty='%C(yellow)%h %Creset%s' --color=always |
    fzf --height=${1-7} --ansi -m --bind 'enter:select-all+accept'
}

gcm() { # git commit
  if [ $1 ]; then
    git commit -m $1
  else
    git commit
  fi
}

gca() { # git commit --amend
  if [ $1 ]; then
    git commit --amend -m $1
  else
    git commit --amend
  fi
}

# git reverse-squash
# squashes all changes into the target commit
grv() {
  git reset --soft $1 && git commit --amend --no-edit
}

# git join
gj() {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ $BRANCH = 'HEAD' ]; then
    return printf "\e[33mCurrently in detached head. Aborting.\e[m\n"
  fi
  git checkout $1
  git merge --no-ff $BRANCH
  git branch -f $BRANCH HEAD
  git checkout $BRANCH
}

yeet() {
  if [ $TMUX ]; then
    echo "Using tmux to push..."
    local CMD="echo 'pushing...'; git push $@; sleep 2"
    tmux split-window -dv -l 5 "sh -c '$CMD'"
  elif [[ $1 == '-f' ]]; then
    git push --force-with-lease
  else
    git push $@
  fi
}

2r() { # go to git root
  cd $(git rev-parse --show-toplevel)
}
# }}}

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
  # a) t="$DOTS/@/alacritty/alacritty.yml" ;;
  a) t="$DOTS/@/awesome/rc.lua" ;;
  g) t="$DOTS/@/git/config" ;;
  gh) t="$DOTS/@/ghostty/config" ;;
  k) t="$DOTS/@/alatty/alatty.conf" ;;
  ki) t="$DOTS/@/kitty/kitty.conf" ;;
  s) t="$HOME/.ssh/config" ;;
  t) t="$DOTS/tmux/tmux.conf" ;;
  u) t="$UNI_LAUNCH" ;;
  v) t="$DOTS/nvim/init.lua" ;;
  w) t="$DOTS/@/wezterm/wezterm.lua" ;;
  z) t="$DOTS/zsh/.zshrc" ;;
  esac
  [ $t ] && $EDITOR $t || echo "nothing happened."
}

alias 2A="cd /Applications"
alias 2c="cd $HOME/.config"
alias 2d="cd $DOTS"
alias 2i="cd $HOME/iCloud"
alias 2j="cd $HOME/Downloads"
alias 2l="cd $HOME/.local"
alias 2lb="cd $HOME/.local/bin"
alias 2ls="cd $HOME/.local/src"
alias 2m="cd $REPOS/math"
alias 2mc="cd '$HOME/Library/Application Support/PrismLauncher/instances'"
alias 2n="cd $REPOS/notes"
alias 2o="cd $HOME/repos"
alias 2t="cd $HOME/repos/tex"
alias 2u="cd $UNI"
alias 2v="cd $DOTS/nvim"
alias 2z="cd $DOTS/zsh"

alias o="cd .." # out
alias b="cd -"  # back

# g for jump (requires fd and fzf)
__g() {
  [[ ! $(command ls -Ap) = *"/"* ]] && return # end if no child dir
  local FZF=(--height=7 +m --no-mouse --reverse --no-info
    --prompt='  ' --header=${PWD/$HOME/'~'} --expect 'esc,left,enter,right')
  [[ $(fd $@ | fzf $FZF) =~ '^(.*)'$'\n''(.*)$' ]]
  case ${match[1]} in
  left) cd .. && g ;;
  enter) [ -d ${match[2]} ] && cd "${match[2]}" ;;
  right) [ -d ${match[2]} ] && cd "${match[2]}" && g ;;
  esac
}

# g for jump (requires fd and fzf)
g() {
  __g -HI -d ${1-4} -t d -E '.git' -E 'node_modules' -E 'target'
}

if binary_exists eza; then
  X="Makefile=4;33:CMake*=4;33:*.lock=37:*ignore=37:.gitmodules=37"
  X+=":README*=33:LICENSE*=37:*.pdf=38;5;105:Cargo.toml=4;33"
  export EZA_COLORS="reset:$X"
  EZA_OPTS=(--group-directories-first -s Name -I '.DS_Store')
  alias ls="eza -a $EZA_OPTS"
  alias lss="eza -a --tree -L 2 $EZA_OPTS"
  alias lsss="eza -a --tree -L 3 $EZA_OPTS"
  alias ll="eza -lag $EZA_OPTS"
else
  alias ls='ls -A --color=auto'
  alias ll='ls -lAg --color=auto'
fi

alias ct="printf '\033[2J\033[3J\033[1;1H'" # clear terminal
alias zr="exec $SHELL -l"                   # reloads shell
alias py='python3' mk='make'
alias vim="$EDITOR" vi="$EDITOR"
alias nvimd="$EDITOR -u $DOTS/nvim/debug/init.lua"
alias nv="~/.local/memes/bin/nvim"
alias clangf="cp $DOTS/zsh/.clang-format ."
alias pulse='open "/Applications/Pulse Secure.app/Contents/Plugins/JamUI/PulseTray.app"'
alias ca='micromamba activate ml'

# Clears jdtls (nvim's Java LSP) cache.
jclear() {
  rm -rf $HOME/.cache/nvim/jdtls
  mkdir -p $HOME/.cache/nvim/jdtls
}

# List all Java installations.
jlist() {
  /usr/libexec/java_home -V
}

if [[ $(cat /etc/os-release 2>/dev/null) == *'ubuntu'* ]]; then
  open() {
    nohup xdg-open $@ 2>/dev/null 2>&1 &
  }
fi

# killing Goodnotes
kgn() {
  PID=$(ps x | grep Goodnotes | grep -v grep)
  PID="${PID#"${PID%%[![:space:]]*}"}" # remove spaces from the front
  PID=${PID%% *}                       # get contents before the first space
  if [ $PID ]; then
    echo "Killing $PID" && kill $PID
  else
    echo "No matching process found"
  fi
}
# kills notification center
knc() {
  killall NotificationCenter
}

# micromamba create --name ml python=3.10 --yes

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="$HOME/.local/bin/micromamba"
export MAMBA_ROOT_PREFIX="$HOME/.local/micromamba"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__mamba_setup"
else
  alias micromamba="$MAMBA_EXE" # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

JENV=false
if [ "$JENV" = true ] && binary_exists jenv; then
  # jenv initialize
  eval "$(jenv init -)"
  jenv enable-plugin export
fi

# RBENV=false
# if [ "$RBENV" = true ] && binary_exists rbenv; then
#   # rbenv initialize
#   eval "$(rbenv init - --no-rehash zsh)"
# fi

# Pdf search tool for linux
pdf() {
  local SEARCH_DIRS=
  local PDF_FILE=$(fd --no-ignore -e pdf . \
    $HOME/uni \
    $HOME/repos/books \
    $HOME/repos/tex |
    fzf)
  if [ -z $PDF_FILE ]; then
    return
  fi
  nohup zathura "$PDF_FILE" </dev/null >/dev/null 2>&1 &
  disown
}

obs_fix() {
  sudo modprobe -r v4l2loopback
}
