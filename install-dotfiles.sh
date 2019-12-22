#!/bin/sh

set -e

cd "$(dirname "$0")"
DOTFILES=$(pwd -P)

source $DOTFILES/functions.sh

if test -f $HOME/.localrc; then
	source $HOME/.localrc
fi

topic="$1"

# install specific topic
if [[ -n "$topic" ]]; then
	if ! test -d "$DOTFILES/$topic"; then
		log_fail "topic $topic is not available"
		exit 1
	fi

	exports="$DOTFILES/$topic/exports.zsh"
	installer="$DOTFILES/$topic/install.sh"

	test -f "$exports" && source "$exports"

	if test -f "$installer"; then
		log_init "running $topic installer..."
		sh "$installer"
		log_success "$topic installer"
	else
		log_info "no installer found"
	fi

	exit 0
fi

# load exports
for file in $DOTFILES/*/exports.zsh; do
	source "$file"
done

# exec installers
for installer in $DOTFILES/*/install.sh; do
	dirname=$(dirname "$installer")
	topic=${dirname#"$DOTFILES/"}
	log_init "running $topic installer..."
	sh "$installer"
	log_success "$topic installer"
done

