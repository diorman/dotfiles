DOTFILES = $(shell git rev-parse --show-toplevel)
.DEFAULT_GOAL := setup

.PHONY: setup
setup: home-manager brew dns

.PHONY: home-manager
home-manager:
	mkdir -p $(HOME)/.config/home-manager
	@ln -sf $(DOTFILES)/home.nix $(HOME)/.config/home-manager/home.nix
	@home-manager switch

.PHONY: dns
dns:
	@echo "setting up DNS servers..."
	@networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
	@echo "...done"

.PHONY: brew
brew:
	$(MAKE) -C brew
