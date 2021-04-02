DOTFILES := $(shell git rev-parse --show-toplevel)
BREWFILE := $(DOTFILES)/brew/Brewfile
BREW := $(shell command -v brew 2>/dev/null)
.DEFAULT_GOAL := install

.PHONY: install
install:
	@echo "installing brew bundle..."
	@brew cleanup
	@brew bundle --global
	@echo "...done"
