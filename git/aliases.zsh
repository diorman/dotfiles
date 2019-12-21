#!/bin/sh

gi() {
	curl -s "https://www.gitignore.io/api/$*"
}

alias gcd=". $DOTFILES/bin/git-get"
