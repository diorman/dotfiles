#!/bin/sh

source $DOTFILES/scripts/install-utils.sh

pfconf="$HOME/.pf.conf"
svc_label="com.apple.pfctl-custom"
pfctl_plist="/Library/LaunchDaemons/$svc_label.plist"

cat <<EOF > "$pfconf"
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
rdr-anchor "com.apple/*"
rdr-anchor "dnsmasq.forward"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
load anchor "dnsmasq.forward" from "$DOTFILES/pfctl/dnsmasq.forward"
EOF

cat <<EOF | sudo tee $pfctl_plist > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$svc_label</string>
	<key>Program</key>
	<string>/sbin/pfctl</string>
	<key>ProgramArguments</key>
	<array>
		<string>pfctl</string>
		<string>-e</string>
		<string>-f</string>
		<string>$pfconf</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOF

sudo launchctl unload -w "$pfctl_plist" &> /dev/null

log_init "launching $svc_label"
sudo launchctl load -w "$pfctl_plist"
