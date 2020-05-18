#!/bin/bash

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

link_file "$DOTFILES/ruby/gemrc" "$HOME/.gemrc"
