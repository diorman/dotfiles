DEFAULT_GOAL := configure

.PHONY: configure
configure: FiSH_PATH := $(HOME)/.nix-profile/bin/fish
configure:
	@grep -qxF $(FiSH_PATH) /etc/shells || echo $(FiSH_PATH) | sudo tee -a /etc/shells
	@chsh -s $(HOME)/.nix-profile/bin/fish
