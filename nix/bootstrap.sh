#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

link_file "$DOTFILES/nix/home.nix" "$HOME/.config/nixpkgs/home.nix"
