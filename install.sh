#!/bin/sh

cd "$(dirname "$0")"

arg0="$1"
args="$@"
shift

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

if [[ -z "$arg0" ]]; then
	confirm "requirements and dotfiles" &&
		./scripts/dotfiles.install.sh &&
		./scripts/requirements.install.sh
elif [[ "$arg0" == "dotfiles" ]]; then
	confirm "$args" && ./scripts/dotfiles.install.sh "$@"
elif [[ "$arg0" == "requirements" ]]; then
	confirm "$args" && ./scripts/requirements.install.sh "$@"
fi
