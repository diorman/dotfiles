#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

RUBY_VERSIONS=(2.4.1 2.6.5)
RUBY_DEFAULT_VERSION=2.6.5

for ruby_version in "${RUBY_VERSIONS[@]}"; do
  log_info "checking ruby $ruby_version installation..."

  if ! rbenv versions | grep "$ruby_version" > /dev/null; then
    log_info "installing ruby $ruby_version..."
    rbenv install "$ruby_version"
  fi
  log_info "ruby $ruby_version"
done

rbenv global $RUBY_DEFAULT_VERSION
