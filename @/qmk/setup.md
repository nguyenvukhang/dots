install qmk

```
brew install qmk/qmk/qmk # for macOS
sudo pacman -S qmk       # for the best disto of all time
```

clone the qmk_firmware repository to desired location:

```
cd $REPOS
git clone https://github.com/qmk/qmk_firmware.git --origin upstream
```

run `qmk setup` from within `qmk_firmware/`

```
cd $REPOS/qmk_firmware
qmk setup
```

Make sure that `qmk setup` recognized that it is in a working directory.
It should not start cloning a new copy of `qmk/qmk_firmware`.

enjoy.
