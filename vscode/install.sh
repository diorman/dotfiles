#!/bin/bash

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

if ! command -v code > /dev/null; then
  echo 'vscode is not installed. Skipping installation of extensions'
  exit 0
fi

log_info "installing vscode extensions..."

extensions=()

# Adds syntax highlighting, commands, hover tips, and linting for Dockerfile and docker-compose files.
extensions+=(ms-azuretools.vscode-docker)

# Integrates ESLint JavaScript into VS Code.
extensions+=(dbaeumer.vscode-eslint)

# Pull Request Provider for GitHub
extensions+=(github.vscode-pull-request-github)

# Rich Go language support for Visual Studio Code
extensions+=(ms-vscode.go)

# Code formatter using prettier
extensions+=(esbenp.prettier-vscode)

# Rust language support
extensions+=(rust-lang.rust)

# Extension to use shellcheck in vscode
extensions+=(timonwong.shellcheck)

for extension in "${extensions[@]}"; do
  code --install-extension "$extension" || true
done

################################################################################
## Extra requirements
################################################################################

if command -v go > /dev/null; then
  log_info "installing golang language server (gopls)..."
  GO111MODULE=on go get golang.org/x/tools/gopls@latest
fi
