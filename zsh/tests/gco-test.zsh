source ./test.zsh

GIT=git
QUIET=true

# Sample output of `git worktree list --porcelain`
# ```
# worktree /home/khang/repos/wacom
# bare
#
# worktree /home/khang/repos/wacom/dev
# HEAD dd28d8878b6479e805ecfba04a09717d5197b68b
# branch refs/heads/dev
#
# worktree /home/khang/repos/wacom/main
# HEAD dd28d8878b6479e805ecfba04a09717d5197b68b
# branch refs/heads/main
# ```

# git checkout, without speedbumps. just get there already.
gco() {
  local OUTPUT="$($GIT checkout $@ 2>&1)" # original output
  local greyed="\033[0;37m$OUTPUT\033[0m" T_DIR BRANCH
  jump() {
    echo "\033[0;37m -> \033[0;32m${1}\033[0;37m ${2}\033[0m" && unset -f jump
  }
  [[ $OUTPUT =~ '^(fatal: not a git repository|Already on).*$' ]] && echo $greyed && return
  [[ $OUTPUT =~ "^fatal: .* is already checked out at '(.*)'$" ]] && jump $1 && cd ${match[1]} && return
  [[ $OUTPUT =~ 'Aborting' ]] && echo $greyed && return
  while IFS= read -r line; do
    if [[ $line =~ '^worktree (.*)$' ]]; then
      dir=${match[1]}
      [[ ${line##*/} == $1 ]] && T_DIR=$dir
    elif [[ $line =~ '^branch refs/heads/(.*)$' ]]; then
      [[ ${match[1]} == $1 && -d $dir ]] && jump $1 && cd $dir && return
      [[ -z $BRANCH && $T_DIR ]] && BRANCH=${match[1]}
    fi
  done < <(git worktree list --porcelain)
  [ $T_DIR ] && jump "$BRANCH" "(dir: $1)" && cd $T_DIR && return # jump with dir
  [ $OUTPUT ] && echo $greyed || return 0
}

commit() {
  echo "data($1)" >$1 && git add $1 && git commit -m "added: $1"
}

log() {
  git log --all --oneline --graph
}

build() {
  mkdir $TMP_DIR/init $TMP_DIR/repo
  cd $TMP_DIR/init
  git init &>$N
  git branch -m main &>$N
  commit README.md &>$N
  commit one &>$N && C1=$(git rev-parse HEAD)
  commit two &>$N && C2=$(git rev-parse HEAD)
  commit three &>$N && C3=$(git rev-parse HEAD)
  commit last &>$N

  git checkout -b B1 &>$N && git reset --hard $C1 &>$N
  git checkout -b B2 &>$N && git reset --hard $C2 &>$N
  git checkout -b B3 &>$N && git reset --hard $C3 &>$N
  git checkout main &>$N

  cd $TMP_DIR
  mv $TMP_DIR/init/.git $TMP_DIR/repo
  cd $TMP_DIR/repo/.git
  git config --bool core.bare true
  cd $TMP_DIR/repo

  git worktree add B1 &>$N
  git worktree add B2 &>$N
  git worktree add D3 &>$N && cd D3 && git checkout B3 &>$N && git branch -D D3 &>$N
}

TMP_DIR=$(mktemp -d)
cleanup() {
  rm -rf $TMP_DIR
}
trap cleanup EXIT

build

# Do nothing if not in a git repository, even if in the lift-lobby
# equivalent that is the git workspace.
line 1
cd $TMP_DIR/repo && gco B1 &>$N
assert_eq_path $PWD $TMP_DIR/repo/B1

# Go to B2
line 2
cd $TMP_DIR/repo/B1 && gco B2 &>$N
assert_eq_path $PWD $TMP_DIR/repo/B2

# Go to D3
line 3
cd $TMP_DIR/repo/B1 && gco B3 &>$N
assert_eq_path $PWD $TMP_DIR/repo/D3

# Go to D3
line 4
cd $TMP_DIR/repo/B1 && gco D3 &>$N
assert_eq_path $PWD $TMP_DIR/repo/D3

assert_eq "$T_DIR" ''
assert_eq "$BRANCH" ''
assert_eq "$OUTPUT" ''
if command -v jump; then
  echo "Should not have jump command from outside"
fi
# x=$(jump 2>&1)
# echo "$x"

echo "[gco-test.zsh] All tests passed!"
