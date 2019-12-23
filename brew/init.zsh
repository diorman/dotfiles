#!/bin/sh

brew() {
	case "$1" in
	remove|uninstall)
		shift
		command brew rmtree "$@"
		;;
	*)
		command brew "$@"
		;;
	esac
}
