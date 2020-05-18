#!/bin/bash

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

if command -v rustup > /dev/null; then
  log_info "updating rustup..."
  rustup update
else
  log_info "installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
