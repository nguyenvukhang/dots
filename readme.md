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

All setup-related scripts are stored in the `assist` script. Run it without
arguments to get a short help menu.

To get started:
1. Clone the repo
2. (optional) run `./assist --sub` to download submodules
3. (optional) run `./assist --lua` to build the lua language server (required for lua LSP in neovim)
4. (optional) run `./assist --mac` to install mac preferences
5. run `./setup` to send symlinks to all across the system

To uninstall, simply run `./uninstall`. This perfectly reverses the effects of
the `setup` script. After uninstall, there are no more files changed outside of
the repository root.

## Other notes

### Neovim startuptime

Here's proof that my neovim configs don't really affect launch times.

Not a flex; this is to remind my future self that it's futile to optimize configs
to improve launch times.

![neovim startuptime](https://raw.githubusercontent.com/nguyenvukhang/dots/master/nvim/startuptimes.png)

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
