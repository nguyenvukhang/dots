# dots

Hello from a mac.  
Welcome to my dotfile repo.  

Mac's mostly gui so this isn't gonna exactly be a roller coaster ride, but I do
try to make my configs [btw-able][arch-btw].

* [Getting started](#getting-started)
* [Other notes](#other-notes)
  * [Neovim startuptime](#neovim-startuptime)
  * [macOS Monterey Login Screen Background](#macos-monterey-login-screen-background)
  * [Launch terminal faster](#launch-terminal-faster)

## Getting Started

`./setup` and see what's up. Filesystem is organized in `fs/home` and
`fs/root`.

## Other notes

### macOS Monterey Login Screen Background

What this does is change your **login screen's** background. The background of
the screen you see when you boot up your mac machine. Note the difference
between this and the **lock screen**, which is the screen you see after waking
your machine from a locked state.

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

Create a file `lockscreen.png` which has the exact same dimensions as
your device resolution (top-left apple icon > About This Mac >
Displays).

Put it at
```
/Library/Caches/Desktop Pictures/<UUID>/lockscreen.png
```

[arch-btw]: https://knowyourmeme.com/memes/btw-i-use-arch
