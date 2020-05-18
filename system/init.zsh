#!/bin/zsh

# reload terminal
alias reload!='exec "$SHELL" -l'

# move files or folders to the trash
if command -v trash > /dev/null; then
  alias rm='trash'
fi

# show colors by default
alias ls='ls -G'
