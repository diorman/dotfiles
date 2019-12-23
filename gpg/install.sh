#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

link_file "$DOTFILES/gpg/gpg.conf" "$HOME/.gnupg/gpg.conf"
link_file "$DOTFILES/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
