#!/bin/bash

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

link_file "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
