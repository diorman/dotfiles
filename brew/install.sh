#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

run_bundle() {
  log_info "running homebrew bundle..."
  brew bundle --file="$DOTFILES/brew/Brewfile"
}

if ! command -v brew > /dev/null; then
  log_info "installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if in_array "--run-bundle" "$@"; then
  run_bundle
  exit 0
fi

read -p "install/update bundle? " -n 1 -r
echo ""

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  run_bundle
else
  log_info "skipping running bundle"
fi
