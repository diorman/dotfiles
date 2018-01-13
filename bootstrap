#!/bin/sh
#
# bootstrap installs things.
export DOTFILES=$(pwd -P)

set -e

echo ''

info() {
	# shellcheck disable=SC2059
	printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
	# shellcheck disable=SC2059
	printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
	# shellcheck disable=SC2059
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
	# shellcheck disable=SC2059
	printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
	echo ''
	exit
}

link_file() {
	if [ -e "$2" ]; then
		if [ "$(readlink "$2")" = "$1" ]; then
			success "skipped $1"
			return 0
		else
			mv "$2" "$2.backup"
			success "moved $2 to $2.backup"
		fi
	fi
	ln -sf "$1" "$2"
	success "linked $1 to $2"
}

install_dotfiles() {
	info 'installing dotfiles'
	find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' -not -path '*.git*' |
		while read -r src; do
			dst="$HOME/.$(basename "${src%.*}")"
			link_file "$src" "$dst"
		done
}

find_zsh() {
	if which zsh >/dev/null 2>&1 && grep "$(which zsh)" /etc/shells >/dev/null; then
		which zsh
	else
		echo "/bin/zsh"
	fi
}

run_installers() {
	# find the installers and run them iteratively
	git ls-tree --name-only -r HEAD | grep install.sh | while read -r installer; do
		info "running ${installer}..."
		sh -c "$installer"
		success $installer
	done
}

set_shell() {
	zsh="$(find_zsh)"
	which chsh >/dev/null 2>&1 &&
		chsh -s "$zsh" &&
		success "set $("$zsh" --version) at $zsh as default shell"
}

install_dotfiles
run_installers
set_shell
unset DOTFILES

echo ''
echo '  All installed!'
