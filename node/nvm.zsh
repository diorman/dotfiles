#!/bin/zsh

if test -d $HOME/.nvm; then
	__nvm_started=0

	__nvm_init() {
		test $__nvm_started = 0 && {
			export NVM_DIR="$HOME/.nvm"
			[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
			[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
			__nvm_started=1
		}
	}

	nvm() {
		__nvm_init
		nvm "$@"
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