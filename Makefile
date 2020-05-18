DOTFILES = $(shell git rev-parse --show-toplevel)

LOG_INFO = (printf "\r[ \033[00;34mINFO\033[0m ] %s\n" "$(1)")
LOG_FAIL = (printf "\r\033[2K[ \033[0;31mFAIL\033[0m ] %s\n" "$(1)")

RUN_ALL = $(foreach topic, \
	$(wildcard $(DOTFILES)/**/$(1).sh), \
	@make --no-print-directory $(1)-$(subst /$(1).sh,,$(subst $(DOTFILES)/,,$(topic))))

RUN_SCRIPT = (if [ -f "$(DOTFILES)/$(2)/$(1).sh" ]; then \
		$(call LOG_INFO,running $(1) script for '$(2)'...); \
		DOTFILES=$(DOTFILES) bash "$(DOTFILES)/$(2)/$(1).sh" $(3); \
	else \
		$(call LOG_FAIL,no $(1) script available for '$(2)'); \
	fi)

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
