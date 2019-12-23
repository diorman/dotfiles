#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

if ! command -v antibody > /dev/null; then
	log_fail "antibody plugin manager not installed"
	exit 1
fi

antibody bundle <"$DOTFILES/antibody/plugins.txt" >~/.zsh_plugins.sh
antibody update
