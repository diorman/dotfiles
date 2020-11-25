DOTFILES := $(shell git rev-parse --show-toplevel)
BREWFILE := $(DOTFILES)/brew/Brewfile
BREW := $(shell command -v brew 2>/dev/null)
.DEFAULT_GOAL := bundle

.PHONY: install
install:
ifndef BREW
	@echo "installing brew..."
	@$(shell /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)")
	@echo "...done"
endif

.PHONY: bundle
bundle: install
	@echo "installing brew bundle..."
	@brew cleanup
	@brew bundle --global
	@echo "...done"
