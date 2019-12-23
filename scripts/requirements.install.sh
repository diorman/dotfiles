#!/bin/sh

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

RUBY_VERSIONS=(2.4.1 2.6.5)
RUBY_DEFAULT_VERSION=2.6.5

JAVA_JENV_VERSIONS=(1.8 11.0)
JAVA_SDK_PATHS=(jdk1.8.0_162.jdk openjdk-11.0.2.jdk)
JAVA_DEFAULT_VERSION=1.8

NODE_VERSIONS=(10.18.0 12.14.0)
NODE_DEFAULT_VERSION=12.14.0

source $DOTFILES/scripts/install-utils.sh

test -f $HOME/.zshrc.local && source $HOME/.zshrc.local

install_brew() {
	log_info "checking homebrew installation..."
	if ! command -v brew > /dev/null; then
		log_info "installing brew..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	log_success "homebrew"
}

install_brew_bundle() {
	log_info "running homebrew bundle..."
	brew bundle --file=$DOTFILES/Brewfile
	log_success "homebrew bundle"
}

install_ruby() {
	for ruby_version in ${RUBY_VERSIONS[@]}; do
		log_info "checking ruby $ruby_version installation..."

		if ! rbenv versions | grep $ruby_version > /dev/null; then
			log_info "installing ruby $ruby_version..."
			rbenv install $ruby_version
		fi
		log_success "ruby $ruby_version"
	done

	rbenv global $RUBY_DEFAULT_VERSION
}

install_java() {
	for index in ${!JAVA_JENV_VERSIONS[@]}; do
		local java_version="${JAVA_JENV_VERSIONS[$index]}"
		local java_path="/Library/Java/JavaVirtualMachines/${JAVA_SDK_PATHS[$index]}/Contents/Home"
		log_info "checking java $java_version installation..."

		if ! jenv versions | grep $java_version > /dev/null; then
			echo "adding $java_version to jenv..."
			jenv add /Library/Java/JavaVirtualMachines/${JAVA_SDK_PATHS[$index]}/Contents/Home
		fi

		log_success "jvm $java_version"
	done

	jenv global $JAVA_DEFAULT_VERSION
}

install_clojure_lein() {
	if ! test -f $HOME/bin/lein; then
		log_info "installing lein"
		mkdir -p $HOME/bin
		curl -sL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o $HOME/bin/lein
		chmod +x $HOME/bin/lein
	else
		log_info "upgrading lein"
		yes | lein upgrade
	fi

	log_success "lein"
}

install_node() {
	log_info "checking nvm installation..."

	if ! test -d $HOME/.nvm; then
		log_info "installing nvm"
		git clone https://github.com/creationix/nvm.git $HOME/.nvm
	fi

	log_success "nvm installed"

	log_info "checking nvm latest version..."
	cd $HOME/.nvm \
		&& git checkout -q master \
		&& git pull -q \
		&& git checkout -q $(git describe --tags) \
		&& log_success "using nvm version $(git describe --tags)" \

	. "$HOME/.nvm/nvm.sh"

	for node_version in ${NODE_VERSIONS[@]}; do
		log_info "checking node $node_version installation..."

		if ! nvm ls $node_version > /dev/null; then
			log_info "installing node $node_version..."
			nvm install $node_version
		fi

		nvm install-latest-npm

		log_success "node $node_version"
	done

	nvm alias default $NODE_DEFAULT_VERSION
}

install_vscode_extensions() {
	log_info "installing vscode extensions..."

	extensions=()

	# Adds syntax highlighting, commands, hover tips, and linting for Dockerfile and docker-compose files.
	extensions+=(ms-azuretools.vscode-docker)

	# Integrates ESLint JavaScript into VS Code.
	extensions+=(dbaeumer.vscode-eslint)

	# Pull Request Provider for GitHub
	extensions+=(github.vscode-pull-request-github)

	# Rich Go language support for Visual Studio Code
	extensions+=(ms-vscode.go)

	# Code formatter using prettier
	extensions+=(esbenp.prettier-vscode)

	for extension in ${extensions[@]}; do
		code --install-extension "$extension" || true
	done

	log_success "vscode extensions"
}

case "$1" in
	brew)
		install_brew
		;;
	brew-bundle)
		install_brew_bundle
		;;
	ruby)
		install_ruby
		;;
	java)
		install_java
		;;
	clojure)
		install_clojure_lein
		;;
	node)
		install_node
		;;
	vscode)
		install_vscode_extensions
		;;
	*)
		install_brew
		install_brew_bundle
		install_ruby
		install_java
		install_clojure_lein
		install_node
		install_vscode_extensions
esac
