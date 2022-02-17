.DEFAULT_GOAL := icon

.PHONY: icon
icon: ICON_PATH := /Applications/kitty.app/Contents/Resources/kitty.icns
icon:
	@rm $(ICON_PATH)
	@ln -s $(HOME)/.config/kitty/icon.icns $(ICON_PATH)
	@touch /Applications/Kitty.app
	@killall Finder || true
	@killall Docker || true
