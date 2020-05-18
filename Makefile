DOTFILES = $(shell git rev-parse --show-toplevel)

LOG_INFO = (printf "\r[ \033[00;34mINFO\033[0m ] %s\n" "$(1)")
LOG_FAIL = (printf "\r\033[2K[ \033[0;31mFAIL\033[0m ] %s\n" "$(1)")

# $1 -> [install|bootstrap]
# $2 -> topic
# $3 -> optional script flags
RUN_SCRIPT = (if [ -f "$(DOTFILES)/$(2)/$(1).sh" ]; then \
		$(call LOG_INFO,running $(1) script for '$(2)'...); \
		DOTFILES=$(DOTFILES) bash "$(DOTFILES)/$(2)/$(1).sh" $(3); \
	else \
		$(call LOG_FAIL,no $(1) script available for '$(2)'); \
	fi);

# $1 -> [install|bootstrap]
RUN_ALL = $(foreach topic, \
	$(wildcard $(DOTFILES)/**/$(1).sh), \
	$(call RUN_SCRIPT,$(1),$(subst /$(1).sh,,$(subst $(DOTFILES)/,,$(topic)))))

.PHONY: bootstrap
bootstrap:
	@$(call RUN_ALL,bootstrap)

.PHONY: bootstrap-%
bootstrap-%:
	@$(call RUN_SCRIPT,bootstrap,$*)

.PHONY: install
install:
	@$(call RUN_ALL,install)

.PHONY: install-%
install-%:
	@$(call RUN_SCRIPT,install,$*)

.PHONY: install-brew-bundle
install-brew-bundle:
	@$(call RUN_SCRIPT,install,brew,--run-bundle)

.PHONY: brew-bundle-dump
brew-bundle-dump:
	brew bundle dump --force --describe --no-restart --file "$(DOTFILES)/brew/Brewfile"

# Only checks what packages would be removed.
# To remove the packages manually run the command passing the --force flag
.PHONY: brew-bundle-cleanup
brew-bundle-cleanup:
	brew bundle cleanup --file "$(DOTFILES)/brew/Brewfile"
