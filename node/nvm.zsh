#!/bin/zsh

set -e

if test -d $HOME/.nvm; then

	__nvm_init() {
		export NVM_DIR=$HOME/.nvm
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

		unset -f nvm
		unset -f node
		unset -f npm
		unset -f __nvm_init
	}

	nvm() {
		__nvm_init
		command nvm "$@"
	}

	node() {
		__nvm_init
		command node "$@"
	}

	npm() {
		__nvm_init
		command npm "$@"
	}
fi
