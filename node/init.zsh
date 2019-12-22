#!/bin/zsh

if test -d $HOME/.nvm; then

	__nvm_init() {
		local nvm_dir=$HOME/.nvm
		[ -s "$nvm_dir/nvm.sh" ] && \. "$nvm_dir/nvm.sh"  # This loads nvm
		[ -s "$nvm_dir/bash_completion" ] && \. "$nvm_dir/bash_completion"  # This loads nvm bash_completion

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
