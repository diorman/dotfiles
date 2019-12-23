#!/bin/zsh

if test -d $HOME/Projects/src/github.com/unbounce/eng-conversions-devtools/bin; then
	export PATH=$HOME/Projects/src/github.com/unbounce/eng-conversions-devtools/bin:$PATH
fi

if test -d $HOME/Projects/src/github.com/unbounce/dev-env/bin; then
	export PATH=$HOME/Projects/src/github.com/unbounce/dev-env/bin:$PATH
fi
