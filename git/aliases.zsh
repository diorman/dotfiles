#!/bin/sh

gi() {
	curl -s "https://www.gitignore.io/api/$*"
}

# gcd() {
# 	disable read
# 	source $DOTFILES/git/git-get.sh
# 	trap "return 0" ERR
# 	trap "git_get_cleanup" EXIT
# 	git_get_main "$@"
# 	cd $(git_get_dest "$@")
# }

alias gcd=". $DOTFILES/bin/git-get"
