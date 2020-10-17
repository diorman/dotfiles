DOTFILES = $(shell git rev-parse --show-toplevel)
EXTENSIONS_FILE=$(DOTFILES)/vscode/extensions.txt
.DEFAULT_GOAL := install-extensions

.PHONY: save-extensions
save-extensions:
	@echo "saving extensions..."
	@code --list-extensions > $(EXTENSIONS_FILE)
	@echo "...done"

.PHONY: install-extensions
install-extensions:
	@echo "installing extensions..."
	@cat $(EXTENSIONS_FILE) | xargs -L1 code --install-extension
	@echo "...done"
