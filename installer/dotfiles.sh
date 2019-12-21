#!/bin/sh
#
# bootstrap installs things.
cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

source $DOTFILES/installer/log.inc.sh

if test -f $HOME/.localrc; then
	source $HOME/.localrc
fi

set -e

echo ''

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
	if command -v zsh >/dev/null 2>&1 && grep "$(command -v zsh)" /etc/shells >/dev/null; then
		command -v zsh
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
	test "$(expr "$SHELL" : '.*/\(.*\)')" != "zsh" &&
		command -v chsh >/dev/null 2>&1 &&
		chsh -s "$zsh" &&
		success "set $("$zsh" --version) at $zsh as default shell"
}

install_dotfiles
run_installers
set_shell
unset DOTFILES

echo ''
echo '  All installed!'
