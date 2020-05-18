#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

NODE_VERSIONS=(10.18.0 12.14.0)
NODE_DEFAULT_VERSION=12.14.0

log_info "checking nvm installation..."

if ! test -d "$HOME/.nvm"; then
  log_info "installing nvm"
  git clone https://github.com/creationix/nvm.git "$HOME/.nvm"
fi

log_info "nvm installed"

log_info "checking nvm latest version..."
cd "$HOME/.nvm" \
  && git checkout -q master \
  && git pull -q \
  && git checkout -q "$(git describe --tags)" \
  && log_info "using nvm version $(git describe --tags)" \

# shellcheck disable=SC1090
source "$HOME/.nvm/nvm.sh"

for node_version in "${NODE_VERSIONS[@]}"; do
  log_info "checking node $node_version installation..."

  if ! nvm ls "$node_version" > /dev/null; then
    log_info "installing node $node_version..."
    nvm install "$node_version"
  fi

  nvm install-latest-npm

  log_info "node $node_version"
done

nvm alias default "$NODE_DEFAULT_VERSION"
