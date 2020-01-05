#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

mkdir -p $(brew --prefix)/etc

link_file "$DOTFILES/dnsmasq/dnsmasq.conf" "$(brew --prefix)/etc/dnsmasq.conf"

status=($(brew services list | awk '/^dnsmasq/ { printf $2 }'))


if [[ "$svcstatus" == "stopped" ]]; then
	sudo brew services start dnsmasq
	exit 0
fi

# I got some issues with the "restart" command not working properly
sudo brew services stop dnsmasq
sudo brew services start dnsmasq
