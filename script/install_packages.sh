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

. $DOTFILES/script/log.inc.sh

install_brew() {
	info "checking homebrew installation..."
	if ! command -v brew > /dev/null; then
		info "installing brew..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	success "homebrew"
}

install_brew_bundle() {
	info "running homebrew bundle..."
	brew bundle
	success "homebrew bundle"
}

install_ruby() {
	for ruby_version in ${RUBY_VERSIONS[@]}; do
		info "checking ruby $ruby_version installation..."

		if ! rbenv versions | grep $ruby_version > /dev/null; then
			info "installing ruby $ruby_version..."
			rbenv install $ruby_version
		fi
		success "ruby $ruby_version"
	done

	rbenv global $RUBY_DEFAULT_VERSION
}

install_java() {
	for index in ${!JAVA_JENV_VERSIONS[@]}; do
		local java_version="${JAVA_JENV_VERSIONS[$index]}"
		local java_path="/Library/Java/JavaVirtualMachines/${JAVA_SDK_PATHS[$index]}/Contents/Home"
		info "checking java $java_version installation..."

		if ! jenv versions | grep $java_version > /dev/null; then
			echo "adding $java_version to jenv..."
			jenv add /Library/Java/JavaVirtualMachines/${JAVA_SDK_PATHS[$index]}/Contents/Home
		fi

		success "jvm $java_version"
	done

	jenv global $JAVA_DEFAULT_VERSION
}

install_clojure() {
	if ! test -f $HOME/bin/lein; then
		info "installing lein"
		mkdir -p $HOME/bin
		curl -sL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o $HOME/bin/lein
		chmod +x $HOME/bin/lein
	else
		info "upgrading lein"
		yes | lein upgrade
	fi

	success "lein"
}

install_node() {
	info "checking nvm installation..."

	if ! test -d $HOME/.nvm; then
		info "installing nvm"
		git clone https://github.com/creationix/nvm.git $HOME/.nvm
	fi

	success "nvm installed"

	info "checking nvm latest version..."
	cd $HOME/.nvm \
		&& git checkout -q master \
		&& git pull -q \
		&& git checkout -q $(git describe --tags) \
		&& success "using nvm version $(git describe --tags)" \

	. "$HOME/.nvm/nvm.sh"

	for node_version in ${NODE_VERSIONS[@]}; do
		info "checking node $node_version installation..."

		if ! nvm ls $node_version > /dev/null; then
			info "installing node $node_version..."
			nvm install $node_version
		fi

		nvm install-latest-npm

		success "node $node_version"
	done

	nvm alias default $NODE_DEFAULT_VERSION
}

case "$1" in
	homebrew)
		install_brew
		;;
	homebrew-bundle)
		install_brew_bundle
		;;
	ruby)
		install_ruby
		;;
	java)
		install_java
		;;
	clojure)
		install_clojure
		;;
	node)
		install_node
		;;
	*)
		install_brew
		install_brew_bundle
		install_ruby
		install_java
		install_clojure
		install_node
esac
