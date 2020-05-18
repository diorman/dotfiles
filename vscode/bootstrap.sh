#!/bin/bash

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

if ! command -v code > /dev/null; then
  echo 'skipping vscode setup'
  exit 0
fi

VSCODE_HOME="$HOME/Library/Application Support/Code/User"

link_file "$DOTFILES/vscode/settings.json" "$VSCODE_HOME/settings.json"
