#!/bin/sh

if command -v brew >/dev/null 2>&1; then
	brew() {
		case "$1" in
		remove|uninstall)
			shift
			brew rmtree "$@"
			;;
		*)
			command brew "$@"
			;;
		esac
	}
fi
