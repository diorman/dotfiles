#!/bin/zsh

if test -d $HOME/Code/src/github.com/unbounce/eng-conversions-devtools/bin; then
	export PATH=$HOME/Code/src/github.com/unbounce/eng-conversions-devtools/bin:$PATH
fi

if test -d $HOME/Code/src/github.com/unbounce/dev-env/bin; then
	export PATH=$HOME/Code/src/github.com/unbounce/dev-env/bin:$PATH
fi
