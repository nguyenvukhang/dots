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
  local greyed="\033[0;37m$OUTPUT\033[0m" TARGET_DIR BRANCH
  jump() { # print a message describing the jump made
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

# $1: file name
# writes some data to the file $1 and commits it
commit_file() {
  echo "data($1)" >$1 && git add $1 && git commit -m "added: $1"
}

log() {
  git log --all --oneline --graph
}

build() {
  # $TMP_DIR/base is not used in any test.
  # It just serves as a dummy git history to clone from
  mkdir $TMP_DIR/base $TMP_DIR/repo
  cd $TMP_DIR/base
  git init &>$N
  git branch -m main &>$N
  commit_file README.md &>$N
  commit_file one &>$N && C1=$(git rev-parse HEAD)
  commit_file two &>$N && C2=$(git rev-parse HEAD)
  commit_file three &>$N && C3=$(git rev-parse HEAD)
  commit_file last &>$N

  git checkout -b B1 &>$N && git reset --hard $C1 &>$N
  git checkout -b B2 &>$N && git reset --hard $C2 &>$N
  git checkout -b B3 &>$N && git reset --hard $C3 &>$N
  git checkout main &>$N

  mv $TMP_DIR/base/.git $TMP_DIR/repo
  git -C $TMP_DIR/repo/.git config --bool core.bare true
  rm -rf $TMP_DIR/base
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
# └── repo
#    ├── B1
#    │  ├── one
#    │  └── README.md
#    ├── B2
#    │  ├── one
#    │  ├── README.md
#    │  └── two
#    └── D3
#       ├── one
#       ├── README.md
#       ├── three
#       └── two

# Save environment variables to later assert that they have not changed
TEST__TARGET_DIR=$TARGET_DIR
TEST__BRANCH=$BRANCH
TEST__OUTPUT=$OUTPUT

# Jump from the lift-lobby (git workspace area, but not in any git workspace)
cd $TMP_DIR/repo && gco B1 &>$N
assert_eq_path $PWD $TMP_DIR/repo/B1

# Jump using REF
cd $TMP_DIR/repo/B1 && gco B2 &>$N
assert_eq_path $PWD $TMP_DIR/repo/B2

# Jump using REF to a different directory
cd $TMP_DIR/repo/B1 && gco B3 &>$N
assert_eq_path $PWD $TMP_DIR/repo/D3

# Jump using DIRECTORY (D3 is checked out on branch B3)
cd $TMP_DIR/repo/B1 && gco D3 &>$N
assert_eq_path $PWD $TMP_DIR/repo/D3

# Assert that variables have been cleared
assert_eq "$TARGET_DIR" "$TEST__TARGET_DIR"
assert_eq "$BRANCH" "$TEST__BRANCH"
assert_eq "$OUTPUT" "$TEST__OUTPUT"

# Assert that jump command does not leak
if command -v jump; then
  echo "Should not have jump command from outside"
fi

echo "[gco-test.zsh] All tests passed!"
