#!/bin/zsh

if test -d $HOME/.nvm; then

	__nvm_init() {
		unset -f nvm
		unset -f node
		unset -f npm
		unset -f __nvm_init

		export NVM_DIR=$HOME/.nvm
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	}

	nvm() {
		__nvm_init
		nvm "$@"
	}

	node() {
		__nvm_init
		node "$@"
	}

	npm() {
		__nvm_init
		npm "$@"
	}
fi