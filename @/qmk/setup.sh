#!/bin/sh

# go to the directory where qmk_firmware is to be installed, then run
# this script. This will install qmk, set it up, and use ssh for the
# git remote.

if ! command -v qmk >/dev/null; then
  echo "qmk binary not found. Please install qmk first."
fi

qmk setup --yes -H ./qmk_firmware nguyenvukhang/qmk_firmware
cd ./qmk_firmware
git remote set-url origin git@github.com:nguyenvukhang/qmk_firmware.git
