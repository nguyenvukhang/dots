#!/usr/bin/env zsh

DISPLAY=$(curl https://www.nguyenvukhang.com/api/nus)
DISPLAY=${DISPLAY##*  }
if [ -z $DISPLAY ]; then
  echo '...'
else
  echo $DISPLAY
fi
