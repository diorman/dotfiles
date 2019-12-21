#!/bin/sh

git config --global include.path ~/.gitconfig.local

# The user email is set dynamically with git-get
git config --global user.name "Diorman Colmenares"

# Don't ask ssh password all the time
if [ "$(uname -s)" = "Darwin" ]; then
	git config --global credential.helper osxkeychain
fi

# better diffs
if command -v diff-so-fancy > /dev/null; then
	git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
fi

# use vscode as mergetool
if command -v code > /dev/null; then
	git config --global merge.tool vscode
	git config --global mergetool.vscode.cmd "code --wait $MERGED"
fi
