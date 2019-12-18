#!/bin/sh

if command -v brew >/dev/null 2>&1; then
	export PATH="/usr/local/sbin:$PATH"
fi
