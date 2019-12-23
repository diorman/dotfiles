#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

mkdir -p $(brew --prefix)/etc

link_file "$DOTFILES/dnsmasq/dnsmasq.conf" "$(brew --prefix)/etc/dnsmasq.conf"
