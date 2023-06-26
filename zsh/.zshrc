START_TMUX=true

# load homebrew
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Use tmux session as a shell wrapper.
# Only quitting the base session will exit the terminal emulator.
tmux_loop() {
  ([[ $START_TMUX != true ]] || [ $TMUX ] || ! command -v tmux 2>/dev/null) && return
  while; do
    [[ $(tmux new -As z -n editor) == '[detached (from session z)]' ]] && exit
    tmux has -t z && continue || exit
  done
}
export EDITOR=nvim # somehow this export is needed for tmux select to work
tmux_loop

# ////////////////////////////////////////////////////////////////////

# Starting directory (also the marked directory)
START_DIR=$HOME/repos/paper/tool

[ $PWD = $HOME ] && [ -d $START_DIR ] && cd $START_DIR
alias 2m="cd $START_DIR"

# cargo (rust)
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

has() {
  command -v $1 >/dev/null
}

# exports
export UNI=$HOME/uni
export NOTES_FILE=$HOME/repos/notes/log.yml
export SHELL_SESSIONS_DISABLE=1 # remove ~/.zsh_sessions
export LANG=en_US.UTF-8         # for manpagers
export GITNU_DEBUG=1

unsetopt BEEP    # prevents beeps in general
setopt IGNOREEOF # prevents <C-d> from quitting the shell
setopt GLOBDOTS  # include hidden dir tab complete
setopt PROMPT_SUBST

prompt_git() {
  local branch=$(git branch --show-current 2>/dev/null)
  local remote=$(git config --get remote.origin.url 2>/dev/null)
  [ -z $branch ] && return
  [[ $remote =~ '^.*\/(.*)\.git$' ]] &&
    echo " %F{241}(%F{246}${match[1]}%F{241}/$branch)" ||
    echo " %F{241}($branch)"
}

PROMPT_ARROW='>'
PROMPT=$'%F{blue}%~$(prompt_git)%f\n%(?.%F{green}${PROMPT_ARROW} %f.%F{red}${PROMPT_ARROW} %f)'

# generic fzf options
# use with fzf --color=$FZF_COLORS
FZF_COLORS='pointer:green,header:white'
FZF_OPTS=(--height=7 +m --no-mouse --reverse
  --no-info --prompt="  " --color=$FZF_COLORS)

# use neovim as manpager
[ $EDITOR = "nvim" ] && export MANPAGER="nvim +Man!"

# for my own scripts and neovim configs
export DOTS=$HOME/dots
export REPOS=$HOME/repos
BUN_INSTALL=$HOME/.bun

PATH=$HOME/.local/bin:$PATH
PATH=$BUN_INSTALL/bin:$PATH
PATH=$HOME/Qt/6.4.2/macos/bin:$PATH
PATH=$HOME/Qt/Tools/QtInstallerFramework/4.5/bin:$PATH
PATH=$HOME/.yarn/bin:$PATH
PATH=$HOMEBREW_PREFIX/opt/node@16/bin:$PATH # node@16 via brew
export PATH

has git-nu && GIT=git-nu || GIT=git

# to use with worktrees
# [remote "origin"]
# url = git@github.com:nguyenvukhang/uni.git
# fetch = +refs/heads/*:refs/remotes/origin/*

# highly used
alias gs="$GIT status" # git status
alias ga="$GIT add"
alias gaa="$GIT add --all"
alias gb="$GIT branch"
alias gc="$GIT commit"
alias gcan="$GIT commit --amend --no-edit"
alias gcn="$GIT clean -fxd --exclude=\"node_modules\""
alias gcnn="$GIT clean -fxd"
alias gd="$GIT diff"
alias gds="$GIT diff --staged"
alias gf="$GIT fetch"
alias giti="$EDITOR .gitignore"
alias gm="$GIT merge"           # squash diff into one commit
alias gmn="$GIT merge --no-ff"  # squash diff into one commit
alias gms="$GIT merge --squash" # squash diff into one commit
alias gpdo="$GIT push -d origin"
alias gr="$GIT reset"
alias grh="$GIT reset --hard"
alias grpo="$GIT remote prune origin"

# still essential
alias gcf="git config --edit"
alias gitm="$EDITOR .gitmodules"

# git preview (quickly open files by number)
gp() {
  # macOS-only
  $GIT ls-files $@ | tr \\n \\0 | xargs -0 $EDITOR

  # gnu xargs only
  # $GIT ls-files $@ | xargs -d '\n' $EDITOR
}

# git checkout, without speedbumps. just get there already.
# (source + tests at ./tests/gco-test.zsh)
gco() {
  local OUTPUT="$($GIT checkout $@ 2>&1)" # original output
  local greyed="\033[0;37m$OUTPUT\033[0m" TARGET_DIR BRANCH
  jump() {
    echo "\033[0;30m -> \033[0;32m${1}\033[0;37m ${2}\033[0m" && unset -f jump
  }
  [[ $OUTPUT =~ '^(fatal: not a git repository|Already on).*$' ]] && echo $greyed && return
  [[ $OUTPUT =~ "^fatal: .* is already checked out at '(.*)'$" ]] && jump $1 && cd ${match[1]} && return
  [[ $OUTPUT =~ 'Aborting' ]] && echo $greyed && return
  while IFS= read -r line; do
    if [[ $line =~ '^worktree (.*)$' ]]; then
      dir=${match[1]}
      [[ ${line##*/} == $1 ]] && TARGET_DIR=$dir
    elif [[ $line =~ '^branch refs/heads/(.*)$' ]]; then
      [[ ${match[1]} == $1 && -d $dir ]] && jump $1 && cd $dir && return
      [[ -z $BRANCH && $TARGET_DIR ]] && BRANCH=${match[1]}
    fi
  done < <(git worktree list --porcelain)
  [ $TARGET_DIR ] && jump "$BRANCH" "(dir: $1)" && cd $TARGET_DIR && return # jump with dir
  [ $OUTPUT ] && echo $greyed || return 0
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
gl() {
  local i=$(($LINES - 10 > 10 ? $LINES - 10 : 10))
  git log --graph --pretty=k -n ${1-$i}
}
gla() {
  local i=$(($LINES - 10 > 10 ? $LINES - 10 : 10))
  git log --graph --pretty=k -n ${1-$i} --all
}
gll() {
  git log --graph --pretty=k --all
}
mongl() {
  local i=$(($LINES - 10 > 10 ? $LINES - 10 : 10))
  for j in {1..120}; do
    clear && gla ${1-$i} && sleep 2
  done
}

# git search log
gsl() {
  git log --all --pretty=s --color=always |
    fzf $FZF_OPTS --height=${1-7} --ansi -m --bind 'enter:select-all+accept'
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

# to remove a submodule completely:
# 0. mv a/submodule a/submodule_tmp
# 1. git submodule deinit -f -- a/submodule
# 2. rm -rf .git/modules/a/submodule
# 3. git rm -f a/submodule
# Note: a/submodule (no trailing slash)

# alt way (derived):
# 1. rm -rf a/submodule
# 2. git submodule deinit -f -- a/submodule
# 3. rm -rf .git/modules/a/submodule
# 4. git rm -f a/submodule

# remove a secrets file from all git history:
# [https://stackoverflow.com/questions/43762338/how-to-remove-file-from-git-history]
# git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch path_to_file" HEAD

p() {
  # get a target gpg file
  local res=()
  while IFS= read -r i; do
    [[ $i =~ '^(.*)\.gpg$' ]] && res+=("${match[1]}")
  done < <(fd -e gpg --strip-cwd-prefix --base-directory $HOME/.password-store)
  local target=$(printf '%s\n' "${res[@]}" | fzf $FZF_OPTS)
  # guard
  [ -z $target ] && echo "nothing selected." && return
  case $1 in
  '')
    local data=$(pass $target) YELLOW="\e[1;33m" NORMAL="\e[1;0m"
    # print the second line to stdout
    [[ "$data" = *$'\n'* ]] && echo ${YELLOW}${data#*$'\n'}${NORMAL}
    read -ks "_?Press any key to continue..." && echo
    # copy the password to clipboard
    pass show --clip $target &>/dev/null
    echo 'Copied password to clipboard. Will clear after 45 seconds.'
    ;;
  '--edit' | '-e') pass edit $target ;;
  esac
}

ed() {
  local t
  case $1 in
  a) t="$DOTS/fs/src/alacritty/alacritty.yml" ;;
  g) t="$DOTS/fs/src/git/config" ;;
  c) t="$HOME/Library/Application Support/rs.canvas-sync/config.yml" ;;
  k) t="$DOTS/fs/src/kitty/kitty.conf" ;;
  s) t="$DOTS/personal/.ssh/config" ;;
  t) t="$DOTS/tmux/tmux.conf" ;;
  u) t="$UNI_LAUNCH" ;;
  v) t="$DOTS/nvim/init.lua" ;;
  w) t="$HOME/.config/wezterm/wezterm.lua" ;;
  z) t="$DOTS/zsh/.zshrc" ;;
  esac
  [ $t ] && $EDITOR $t || echo "nothing happened."
}

alias 2A="cd /Applications"
alias 2c="cd $HOME/.config"
alias 2ca="cd $HOME/.cache"
alias 2d="cd $DOTS"
alias 2f="cd $HOME/files"
alias 2h="cd $HOMEBREW_PREFIX"
alias 2j="cd $HOME/Downloads"
alias 2l="cd $HOME/.local"
alias 2lb="cd $HOME/.local/bin"
alias 2ls="cd $HOME/.local/src"
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
  EXA_OPTS=(--group-directories-first --sort=Filename --ignore-glob='.DS_Store')
  alias ls="exa -a $EXA_OPTS"
  alias lss="exa -a --tree --level=2 $EXA_OPTS"
  alias lsss="exa -a --tree --level=3 $EXA_OPTS"
  alias ll="exa -al $EXA_OPTS"
else
  alias ls="ls -A --color=auto"
  alias ll="ls -Al --color=auto"
fi

# g for jump (requires fd and fzf)
g() {
  [[ ! $(command ls -Ap) = *"/"* ]] && return # end if no child dir
  local FD=(-H -I -c never -d 4 -t d --strip-cwd-prefix -E '.git'
    -E 'node_modules')
  local FZF=(--height=7 +m --no-mouse --reverse --no-info --prompt="  "
    --color=$FZF_COLORS
    --header=${PWD/$HOME/'~'}
    --expect "esc,left,enter,right")
  [[ $(fd $FD | fzf $FZF) =~ '^(.*)'$'\n''(.*)$' ]]
  case ${match[1]} in
  'left') cd .. && g ;;
  'enter') [ -d ${match[2]} ] && cd ${match[2]} ;;
  'right') [ -d ${match[2]} ] && cd ${match[2]} && g ;;
  *) return ;; # 'esc' covered here
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
alias n="$EDITOR $NOTES_FILE"

# searches
alias fd="fd --hidden"
alias rg="rg --hidden"

# yarn
alias yb="yarn build"
alias yl="yarn lint"
alias yd="yarn dev"

# binds
bindkey "^[[3~" delete-char
bindkey '^[[Z' reverse-menu-complete

# uni
t() {
  if [ -f run ]; then
    bash run $@
  elif [ -f Makefile ]; then
    make $@
  elif [ -f Cargo.toml ]; then
    cargo test $@
  elif [ -f test ]; then
    bash test $@
  elif [ -f wrap.sh ]; then
    bash wrap.sh $@
  elif [ -f package.json ]; then
    yarn dev
  fi
}

# clears jdtls (nvim) cache
jclear() {
  rm -rf $HOME/.cache/nvim/jdtls
  mkdir -p $HOME/.cache/nvim/jdtls
}

# newer aliases
alias clangf="cp $DOTS/zsh/.clang-format ."
alias gitd="$REPOS/gitnu/target/debug/git-nu" # gitnu dev

# checks to see if required apps are installed
checkhealth() {
  local REQUIRE=(fzf nvim fd rg tmux)
  for app in ${REQUIRE[@]}; do
    has $app || echo "zshrc needs: $app"
  done
}

# file opener
v() {
  local x=$(fd -t f -e pdf | fzf ${FZF_OPTS})
  [ $x ] && open "$x"
}
