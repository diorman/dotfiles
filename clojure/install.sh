#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

if ! test -f "$HOME/bin/lein"; then
  log_info "installing lein"
  mkdir -p "$HOME/bin"
  curl -sL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o "$HOME/bin/lein"
  chmod +x "$HOME/bin/lein"
else
  log_info "upgrading lein"
  yes | lein upgrade
fi
