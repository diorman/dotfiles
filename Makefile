DOTFILES = $(shell git rev-parse --show-toplevel)
.DEFAULT_GOAL := setup

.PHONY: setup
setup: setup-home-manager setup-brew setup-dns setup-fish

.PHONY: setup-home-manager
setup-home-manager:
	@echo "Setting up home-manager..."
	mkdir -p $(HOME)/.config/home-manager
	@ln -sf $(DOTFILES)/home.nix $(HOME)/.config/home-manager/home.nix
	@home-manager switch
	@echo "...Completed setting up home-manager"

.PHONY: setup-dns
setup-dns:
	@echo "Setting up DNS servers..."
	@networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
	@echo "...Completed up DNS servers"

.PHONY: setup-brew
setup-brew:
	@echo "Setting up brew bundle..."
	@brew cleanup
	@brew bundle --global
	@echo "...Completed up brew bundle"

.PHONY: setup-fish
setup-fish: FiSH_PATH := $(HOME)/.nix-profile/bin/fish
setup-fish:
	@echo "Setting up fish..."
	@grep -qxF $(FiSH_PATH) /etc/shells || echo $(FiSH_PATH) | sudo tee -a /etc/shells
	@chsh -s $(HOME)/.nix-profile/bin/fish
	@echo "...Completed setting up fish"

.PHONY: update
update: update-home-manager update-vim update-brew

.PHONY: update-home-manager
update-home-manager:
	@echo "Updating home-manager..."
	@nix-channel --update
	@home-manager switch
	@echo "...Completed updating home-manager"

.PHONY: update-vim
update-vim:
	@echo "Updating vim packages..."
	@nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
	@echo "...Completed updating vim packages"

.PHONY: update-brew
update-brew:
	@echo "Updating brew packages..."
	@brew cleanup
	@brew bundle cleanup --global
	@brew cu --all --yes --quiet
	@echo "...Completed updating brew packages"
