#!/bin/sh

cd "$(dirname "$0")"

arg="$1"

confirm() {
	while true; do
		read -p "Install $1? (y/n): " yn
		case $yn in
				y) return 0;;
				n) return 1;;
				* ) echo "answer 'y' or 'n'!!!";;
		esac
done
}

if [[ -z "$arg" ]]; then
	confirm "requirements and dotfiles" &&
		./scripts/dotfiles.install.sh &&
		./scripts/requirements.install.sh
elif [[ "$arg" == "dotfiles" ]]; then
	confirm "$arg" && ./scripts/dotfiles.install.sh
elif [[ "$arg" == "requirements" ]]; then
	confirm "$arg" && ./scripts/requirements.install.sh
fi
