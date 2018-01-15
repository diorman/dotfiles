#!/bin/sh

if command -v git-get >/dev/null 2>&1; then
	export GIT_GET_PATH="$HOME/Projects/src"
fi
