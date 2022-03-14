# dots

hello from a mac.  
welcome to my dotfile repo.  
mac's mostly gui so this isn't gonna exactly be a roller coaster ride.

### general setup

clone the repo, then recursively update submodules with the
`submodule-init` script.

stow files using the `setup` script.

build the lua language server with the `lua-build` script.

### macOS Monterey Lockscreen Background

For this to work, you need FileVault to be turned off:
```
System Preferences
-> Security & Privacy
-> FileVault
-> [turn it off]
```

Get your user's UUID:
```
System Preferences
-> Users & Groups
-> [unlock the lock]
-> [right click your user]
-> Advanced Options
-> UUID
```

create a file `lockscreen.png` which has the exact same dimensions as
your device resolution (top-left apple icon > About This Mac >
Displays).

Put it at

```
/Library/Caches/Desktop Pictures/<UUID>/lockscreen.png
```

### launch terminal faster

On the first launch after startup, `xcodebuild` takes a good few
seconds to run before the interactive shell loads.

To counter this, I simply accepted the license of `xcodebuild` by
running

```
sudo xcodebuild -license
```

Press <kbd>Shift</kbd> + <kbd>g</kbd> to scroll to the bottom and
press enter. Type in `agree` and press enter to agree to the license.
