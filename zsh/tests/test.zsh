N=/dev/null

assert_eq() {
  local RECEIVED=$1
  local EXPECTED=$2
  if [[ $RECEIVED != $EXPECTED ]]; then
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo "received: \"${RECEIVED}\""
    echo "========================================"
    echo "expected: \"${EXPECTED}\""
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    exit
  fi
}

assert_eq_path() {
  local RECEIVED=$1
  local EXPECTED=$2
  if [[ ! $RECEIVED -ef $EXPECTED ]]; then
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo "received path: \"${RECEIVED}\""
    echo "========================================"
    echo "expected path: \"${EXPECTED}\""
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    exit
  fi
}

line() {
  [[ $QUIET == true ]] && return
  [ $1 ] && TEXT=" [$1]" || TEXT=""
  echo "───────────────────────────────────────────────────────${TEXT}"
}
