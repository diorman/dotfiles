#!/bin/sh

if command -v git-get > /dev/null; then
	export GIT_GET_PATH="$HOME/Projects/src"
fi
