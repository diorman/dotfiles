#!/bin/zsh

export CDPATH=$HOME/Code/src
export PATH="$DOTFILES/bin:$HOME/bin:$PATH"
export PJ_PATH="$HOME/Code/src"

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
