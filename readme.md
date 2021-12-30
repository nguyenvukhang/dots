# dots

hello from a mac.  
welcome to my dotfile repo.  
mac's mostly gui so this isn't gonna exactly be a roller coaster ride.

### general setup

clone the repo, then recursively update submodules with
```
git submodule update --init --recursive
```
if you're using nvim, then go to `nvim/.config/nvim` and run
`plug-init` first.  
then, open vim and run `:PlugInstall`.

stow files by running the setup script:
```
cd dots
./setup
```
before making changes to any submodule, remember to checkout a branch
