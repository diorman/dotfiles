#!/bin/sh

if command -v rbenv > /dev/null; then
	eval "$(rbenv init -)"
fi

alias be="bundle exec"
