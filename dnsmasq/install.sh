#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

link_file "$DOTFILES/dnsmasq/dnsmasq.conf" "$(brew --prefix)/etc/dnsmasq.conf"
