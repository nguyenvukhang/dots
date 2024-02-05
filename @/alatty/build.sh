#!/bin/bash

LDFLAGS=-L/opt/homebrew/lib \
    python3 setup.py alatty.app \
    --extra-include-dirs $HOMEBREW_PREFIX/Cellar/librsync/2.3.4/include
rm -rf /Applications/alatty.app
cp -r alatty.app /Applications/alatty.app
