#!/bin/sh

export CDPATH=$HOME/Projects/src
export PATH="$DOTFILES/bin:$HOME/bin:$PATH"
export EDITOR='vim'
export VEDITOR='code'

# GNU utilities
for gnupath in "coreutils/libexec/gnubin" \
	"findutils/libexec/gnubin" \
	"gnu-tar/libexec/gnubin" \
	"gnu-sed/libexec/gnubin" \
  "gawk/libexec/gnubin" \
	"gnu-indent/libexec/gnubin" \
	"gnu-getopt/bin" \
	"grep/libexec/gnubin" \
	"curl/bin" \
	"make/libexec/gnubin"; do
	export PATH="/usr/local/opt/$gnupath:$PATH"
done
