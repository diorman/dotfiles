#!/bin/sh

if ! command -v code > /dev/null; then
	echo 'skipping vscode setup'
	exit 0
fi

VSCODE_HOME="$HOME/Library/Application Support/Code/User"

ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_HOME/settings.json"

modules="
lukehoban.go
dbaeumer.vscode-eslint
avli.clojure
"

for module in $modules; do
	code --install-extension "$module" || true
done
