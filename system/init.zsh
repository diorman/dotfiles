#!/bin/sh

export PATH=$PATH:~/bin
export CDPATH=$HOME/Projects/src

# GNU utilities
for gnupath in "coreutils/libexec/gnubin" \
	"findutils/libexec/gnubin" \
	"gnu-tar/libexec/gnubin" \
	"gnu-sed/libexec/gnubin" \
  "gawk/libexec/gnubin" \
	"gnu-indent/libexec/gnubin" \
	"gnu-getopt/bin" \
	"grep/libexec/gnubin" \
  "make/libexec/gnubin"; do
	export PATH="/usr/local/opt/$gnupath:$PATH"
done
