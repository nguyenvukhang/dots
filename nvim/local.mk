#!/bin/sh

# install build prerequisites:
# [https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites]

# clone the repo:
# git clone https://github.com/neovim/neovim

# symlink this script into that repo
# cd neovim
# ln -s ~/path/to/this/script .

INSTALL_DIRECTORY=/usr/local

make \
  CMAKE_BUILD_TYPE=Release \
  CMAKE_INSTALL_PREFIX=${INSTALL_DIRECTORY} \
  install
