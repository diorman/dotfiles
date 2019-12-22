#!/bin/sh

source $DOTFILES/functions.sh

link_file "$DOTFILES/dnsmasq/dnsmasq.conf" "$(brew --prefix)/etc/dnsmasq.conf"
