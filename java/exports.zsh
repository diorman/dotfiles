#!/bin/sh

if command -v jenv > /dev/null; then
	export PATH="$HOME/.jenv/bin:$PATH"
fi
