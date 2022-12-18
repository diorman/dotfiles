DEFAULT_GOAL := node2nix

.PHONY: node2nix
node2nix:
	node2nix \
		-i node-packages.json \
		-o node-packages.nix \
		-c composition.nix \
		--pkg-name nodejs-18_x
