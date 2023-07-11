#!/bin/bash

LDFLAGS=-L/opt/homebrew/lib \
    python3 setup.py kitty.app \
    --extra-include-dirs $HOMEBREW_PREFIX/Cellar/librsync/2.3.4/include
rm -rf /Applications/kitty.app
cp -r kitty.app /Applications/kitty.app
