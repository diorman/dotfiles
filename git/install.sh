#!/bin/sh

if [[ -z $GIT_CUSTOM_CONFIG ]]; then
	echo "GIT_CUSTOM_CONFIG is not set (eg ~/.localrc). Example:"
	echo ""
cat << EOF
export GIT_CUSTOM_CONFIG=\$(jq -n \\
	--arg home "\$HOME" \\
	'{
		"\(\$home)/.gitconfig": {
			"user.email": "email@test.com",
			"includeIf.gitdir:**/git-org/*/.git.path": "\(\$home)/.gitconfig.git-org"
		},
		"\(\$home)/.gitconfig.git-org": {
			"user.email": "email@git-org.com"
		}
	}')
EOF
	exit 1
fi

if ! jq -e . &>/dev/null <<< "$GIT_CUSTOM_CONFIG"; then
	echo "GIT_CUSTOM_CONFIG contains invalid JSON"
	exit 1
fi

git config --global user.name "Diorman Colmenares"
git config --global include.path $HOME/.gitconfig.dotfiles

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

# Parse and set $GIT_CUSTOM_CONFIG
for file in $(jq -r "keys[]" <<< "$GIT_CUSTOM_CONFIG"); do
	for key in $(jq --arg file $file -r '.[$file] | keys[]' <<< "$GIT_CUSTOM_CONFIG"); do
		value=$(jq --arg file $file --arg key $key -r '.[$file][$key]' <<< "$GIT_CUSTOM_CONFIG")

		if ! test -f "$file"; then
			touch "$file"
		fi

		git config --file "$file" $key $value
	done
done
