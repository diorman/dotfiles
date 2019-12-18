#!/bin/sh

if command -v go >/dev/null 2>&1; then
	export GOPATH=$HOME/Projects
	export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
	export GO111MODULE=on
fi
