#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

mkdir -p "$(brew --prefix)/etc"

link_file "$DOTFILES/dnsmasq/dnsmasq.conf" "$(brew --prefix)/etc/dnsmasq.conf"

status="$(brew services list | awk '/^dnsmasq/ { printf $2 }')"

if [[ "$status" == "stopped" ]]; then
  log_info "dnsmasq is not running. Start it with \`sudo brew services start dnsmasq\`"
  exit 0
fi

log_info "dnsmasq is running. Restart it with \`sudo brew services restart dnsmasq\`"
