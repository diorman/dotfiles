#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

mkdir -p "$HOME/.gnupg"
link_file "$DOTFILES/gpg/gpg.conf" "$HOME/.gnupg/gpg.conf"
link_file "$DOTFILES/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
