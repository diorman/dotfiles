#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

mkdir -p $(brew --prefix)/etc

link_file "$DOTFILES/dnsmasq/dnsmasq.conf" "$(brew --prefix)/etc/dnsmasq.conf"

svc=($(brew services list | awk '/^dnsmasq/ { printf "%s %s", $2, $3 }'))
svcstatus="${svc[0]}"
svcuser="${svc[1]}"


if [[ "$svcstatus" == "stopped" ]]; then
	brew services start dnsmasq
	exit 0
fi

# dnsmasq is runinng on port 5353, therefore, sudo is not required
if [[ "$svcuser" == "root" ]]; then
	sudo brew services stop dnsmasq
	brew services start dnsmasq
else
	brew services restart dnsmasq
fi
