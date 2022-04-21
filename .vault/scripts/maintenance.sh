#!/usr/bin/env zsh

# a simple maintenance script I use for mac

function maintain() {

update=true

function msg() {
	echo >&2 -e "${1-}"
}

if type "brew" &>/dev/null; then
	if [ "$update" = true ]; then
		msg 'Updating Homebrew Recipes...'
		brew update &>/dev/null
		msg 'Upgrading and removing outdated formulae...'
		brew upgrade &>/dev/null
	fi
	msg 'Cleaning up Homebrew Cache...'
	brew cleanup -s &>/dev/null
	rm -rfv "$(brew --cache)"
	brew tap --repair &>/dev/null
fi

msg 'Clearing System Cache Files...'
sudo rm -rfv /Library/Caches/* &>/dev/null
sudo rm -rfv /System/Library/Caches/* &>/dev/null
sudo rm -rfv ~/Library/Caches/* &>/dev/null

}

maintain
