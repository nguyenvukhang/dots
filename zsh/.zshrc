source_if_exists() {
	[ -r $1 ] && source $1 >/dev/null 2>/dev/null
}
has() {
	command -v $1 >/dev/null
}

source_if_exists $HOME/.cargo/env               # cargo (rust)
source_if_exists $HOME/.opam/opam-init/init.zsh # opam (OCaml)

# special directories
export UNI=$HOME/uni REPOS=$HOME/repos DOTS=$HOME/dots

export PYTHONPYCACHEPREFIX=/tmp/pycache        # bye __pycache__
export LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 # locale standardize
export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8   # locale standardize
export SHELL_SESSIONS_DISABLE=1                # remove ~/.zsh_sessions

export FZF_DEFAULT_OPTS="--height=7 +m --no-mouse --reverse --no-info --prompt='  ' --no-separator"

export EDITOR=nvim
[ "$EDITOR" = "nvim" ] && export MANPAGER="nvim +Man!" # use neovim as manpager

export N_PREFIX="$HOME/.local/n"

#  Setting $PATH
PATH=/usr/local/go/bin:$PATH
PATH=$HOME/.local/bin/luals/bin:$PATH
PATH=$HOME/go/bin:$PATH
PATH=$HOME/.local/bin:$PATH
[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
export PATH

unsetopt BEEP       # prevents beeps in general
setopt IGNOREEOF    # prevents <C-d> from quitting the shell
setopt GLOBDOTS     # include hidden dir tab complete
setopt PROMPT_SUBST # enable scriptig in the prompt

# ZSH shell prompt settings (+git)
prompt_git() {
	local B=$(git branch --show-current 2>/dev/null)
	[ -z $B ] && return
	local R=$(git config --get remote.origin.url 2>/dev/null)
	R=${R##*/}
	[[ $R =~ '^(.*)\.git$' ]] &&
		echo "%F{241}(%F{246}${match[1]}%F{241}/$B)" ||
		echo "%F{241}($B)"
}
PROMPT_ARROW='>'
PROMPT=$'%F{blue}%~ $(prompt_git)%f\n%(?.%F{green}${PROMPT_ARROW} %f.%F{red}${PROMPT_ARROW} %f)'

bindkey "^[[3~" delete-char
bindkey '^[[Z' reverse-menu-complete

# {{{ Git shenanigans
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
alias grs="$GIT reset --soft"
alias grpo="$GIT remote prune origin"
alias gt="$GIT tag"
alias giti="$EDITOR .gitignore"
alias gitm="$EDITOR .gitmodules"
alias gsn="$GIT show --name-status"

# to get remote branches on bare checkouts, run
# git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

gmb() {
	local PREV=$(git rev-parse HEAD)
	gco $1
	git reset --hard $PREV
}

# git preview (quickly open files by number)
gp() {
	[ $1 ] && $EDITOR $($GIT ls-files $@)
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

# git clone
#
# USAGE:
# gcl git@github.com:neovim/neovim.git
# gcl https://github.com/neovim/neovim.git
# gcl neovim/neovim
gcl() {
	local repo="$1" url
	shift
	if [[ $repo =~ '^(https://.*/.*|git@.*:.*)/' ]]; then
		url=$repo # url starts with 'https://' or 'git@' and has another '/' after.
	elif [[ $repo =~ '^(.*)/(.*)$' ]]; then
		url=git@github.com:${match[1]}/${match[2]}.git # default to github.
	fi
	[ -z $url ] && echo "Unable to parse requested repo." && return 1
	git clone $url $@
}
gcb() { # git clone --bare
	gcl $@ --bare
}

# git logs
alias gll='git log --graph --pretty=k' glal='gll --all'
gl() {
	gll -n ${1-$(($LINES * 0.6 > 10 ? $LINES * 0.6 : 10))} $@
}
gla() {
	gll --all -n ${1-$(($LINES * 0.6 > 10 ? $LINES * 0.6 : 10))} $@
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
gslf() { # git search log (with filenames) and open in editor
	git log --all --pretty=s --compact-summary | $EDITOR -
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
	a) t="$DOTS/@/alacritty/alacritty.yml" ;;
	g) t="$DOTS/@/git/config" ;;
	k) t="$DOTS/@/alatty/alatty.conf" ;;
	s) t="$HOME/.ssh/config" ;;
	t) t="$DOTS/tmux/tmux.conf" ;;
	u) t="$UNI_LAUNCH" ;;
	v) t="$DOTS/nvim/init.lua" ;;
	w) t="$DOTS/@/wezterm/wezterm.lua" ;;
	z) t="$DOTS/zsh/.zshrc" ;;
	ze) t="$ZSHENV_PATH" ;;
	esac
	[ $t ] && $EDITOR $t || echo "nothing happened."
}

alias 2A="cd /Applications"
alias 2c="cd $HOME/.config"
alias 2d="cd $DOTS"
alias 2f="cd $HOME/files"
alias 2h="cd $HOMEBREW_PREFIX"
alias 2i="cd '$HOME/Library/Mobile Documents/com~apple~CloudDocs'"
alias 2j="cd $HOME/Downloads"
alias 2k="cd $DOTS/@/kitty"
alias 2l="cd $HOME/.local"
alias 2lb="cd $HOME/.local/bin"
alias 2ls="cd $HOME/.local/src"
alias 2m="cd $REPOS/math"
alias 2mc="cd '$HOME/Library/Application Support/PrismLauncher/instances'"
alias 2n="cd $REPOS/notes"
alias 2o="cd $HOME/repos"
alias 2or="cd $HOME/other-repos"
alias 2p="cd $DOTS/personal"
alias 2s="cd $HOME/seagate"
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
	enter) [ ${match[2]} ] && cd ${match[2]} ;;
	right) [ ${match[2]} ] && cd ${match[2]} && g ;;
	esac
}

# g for jump (requires fd and fzf)
g() {
	__g -HI -d ${1-4} -t d -E '.git' -E 'node_modules' -E 'target'
}

# pdfgrep with nice setup
pd() {
	pdfgrep --with-filename --page-number $@ -- **/*.pdf
}

# run a command in a loop
mon() {
	while; do
		sleep 1 && clear && echo "-> $PWD" && $@
	done
}

if has eza; then
	EZA_OPTS=(--group-directories-first -s Name -I '.DS_Store')
	alias ls="eza -a $EZA_OPTS"
	alias lss="eza -a --tree -L 2 $EZA_OPTS"
	alias lsss="eza -a --tree -L 3 $EZA_OPTS"
	alias ll="eza -lag $EZA_OPTS"
else
	alias ls='ls -A --color=auto'
	alias ll='ls -lAg --color=auto'
fi
alias fd='fd --hidden'
alias rg='rg --hidden'
alias ct="printf '\033[2J\033[3J\033[1;1H'" # clear terminal
alias zr="exec $SHELL -l"                   # reloads shell
alias py='python3' mk='make'
alias vim="$EDITOR" vi="$EDITOR"
alias clangf="cp $DOTS/zsh/.clang-format ."
alias pulse='open "/Applications/Pulse Secure.app/Contents/Plugins/JamUI/PulseTray.app"'
alias ca='micromamba activate ml'

# t: run the obvious thing
t() {
	local DONE=0
	_() {
		[ $DONE = 0 ] && [ -r $1 ] && DONE=1 && shift && $@
	}
	_ Makefile make $@
	_ run bash run $@
	_ build.sh bash build.sh $@
	_ run.py python3 run.py $@
	_ Cargo.toml cargo run $@
	_ package.json npm run dev $@
	unset _ DONE
	return 0
}

# clears jdtls (nvim) cache
jclear() {
	rm -rf $HOME/.cache/nvim/jdtls
	mkdir -p $HOME/.cache/nvim/jdtls
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

# chinese pinyin!
chpy() {
	$HOMEBREW_PREFIX/lib/ruby/gems/3.3.0/bin/ch2py --tonemarks $@
}

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
