#!/bin/sh

if ! command -v code > /dev/null; then
	echo 'skipping vscode setup'
	exit 0
fi

VSCODE_HOME="$HOME/Library/Application Support/Code/User"

ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_HOME/settings.json"

modules=()

# Adds syntax highlighting, commands, hover tips, and linting for Dockerfile and docker-compose files.
modules+=(ms-azuretools.vscode-docker)

# Integrates ESLint JavaScript into VS Code.
modules+=(dbaeumer.vscode-eslint)

# Pull Request Provider for GitHub
modules+=(github.vscode-pull-request-github)

# Rich Go language support for Visual Studio Code
modules+=(ms-vscode.go)

# Code formatter using prettier
modules+=(esbenp.prettier-vscode)

for module in ${modules[@]}; do
	code --install-extension "$module" || true
done
