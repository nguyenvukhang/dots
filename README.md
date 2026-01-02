# dots

Hello from a mac. Welcome to my dotfile repo.

- [Getting started](#getting-started)
- [MacOS tweaks](#macos-tweaks)
  - [Login Screen Background](#login-screen-background)
  - [Learnt spelling](#learnt-spelling)

## Getting Started

`sh setup` and see what's up. Filesystem is organized in `fs/home`.
This means that the file structure rooted at `fs/home` will be
symlinked and overlaid on the home directory upon installation.

## MacOS Tweaks

### Login screen background

> this is known to work on MacOS Monterey & Ventura

This is referring to changing your **login screen's** background. The
background of the screen you see when you boot up your mac machine.

Note the difference between this and the **lock screen**, which is the
screen you see after waking your machine from a locked state.

For this to work, you need FileVault to be turned off:

```
System Preferences
-> Security & Privacy
-> FileVault
-> [turn it off]
```

Obtain your user's UUID:

```
System Preferences
-> Users & Groups
-> [unlock the lock]
-> [right click your user]
-> Advanced Options
-> UUID
```

Create a file `lockscreen.png` <a id="create-lockscreen-png"></a>
which has the exact same dimensions as your device resolution
(top-left apple icon > About This Mac > Displays).

Save the following script as `lock.sh`, in the same directory as
`lockscreen.png` and run it with `sh lock.sh`. It copies
`lockscreen.png` to `/Library/Caches/Desktop
Pictures/<UUID>/lockscreen.png`.

```sh
#!/usr/bin/env sh

DESKTOP_PICTURES='/Library/Caches/Desktop Pictures'
UUID=$(dscl /Search -read "/Users/$USER" GeneratedUID)
UUID="${UUID#*: }"
TARGET_DIR="$DESKTOP_PICTURES/$UUID"

if [[! -d $TARGET_DIR]]; then
  echo "Target directory doesn't exist:\n$TARGET_DIR\n"
fi

cp ./lockscreen.png "$TARGET_DIR/lockscreen.png"

```

### Learnt spelling

The file `~/Library/Spelling/LocalDictionary` contains all the words
learnt by the computer with your usage. (from right-clicking badly
spelt words and clicking "Learn Spelling")
