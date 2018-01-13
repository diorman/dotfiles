#!/bin/sh
if ! which antibody >/dev/null 2>&1; then
	echo 'error: antibody plugin manager not installed'
	exit 1
fi
antibody bundle <"$DOTFILES/antibody/plugins.txt" >~/.zsh_plugins.sh
antibody update
