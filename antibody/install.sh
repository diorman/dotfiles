#!/bin/sh
if ! command -v antibody > /dev/null; then
	echo 'error: antibody plugin manager not installed'
	exit 1
fi
antibody bundle <"$DOTFILES/antibody/plugins.txt" >~/.zsh_plugins.sh
antibody update
